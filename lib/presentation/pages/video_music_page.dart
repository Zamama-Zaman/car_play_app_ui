// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:car_play_app/data/ads/ad_helper.dart';
import 'package:car_play_app/data/models/playlist_video_songs_model.dart';
import 'package:car_play_app/data/store/store_favourites_video_song.dart';
import 'package:car_play_app/data/store/store_playlist_video_song.dart';
import 'package:car_play_app/presentation/pages/video_music_library_page.dart';
import 'package:car_play_app/presentation/pages/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_player/video_player.dart';

class PageNextPreviousVideo extends StatefulWidget {
  final List<File> file;
  final int index;
  const PageNextPreviousVideo({
    Key? key,
    required this.file,
    required this.index,
  }) : super(key: key);

  @override
  State<PageNextPreviousVideo> createState() => _PageNextPreviousVideoState();
}

class _PageNextPreviousVideoState extends State<PageNextPreviousVideo> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.file.length,
      itemBuilder: (context, index) => VideoMusicPage(
        file: widget.file[index],
        videoFile: widget.file,
      ),
    );
  }
}

class VideoMusicPage extends StatefulWidget {
  final File file;
  final List<File> videoFile;
  const VideoMusicPage({
    Key? key,
    required this.file,
    required this.videoFile,
  }) : super(key: key);

  @override
  State<VideoMusicPage> createState() => _VideoMusicPageState();
}

class _VideoMusicPageState extends State<VideoMusicPage> {
  late VideoPlayerController _controller;

  bool isFavirout = false;
  double sliderValue = 2.0;

  int myIndex = 1;

  Duration currentPositionDuration = Duration.zero;

  double currentValue = 5.0;

  late BannerAd _sideBannerAd;

  bool _isSideBannerAdLoaded = false;

  void _createSideBannerAd() {
    _sideBannerAd = BannerAd(
      size: AdSize(width: 250, height: 100),
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isSideBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _sideBannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    initilizatingVideoController();
  }

  initilizatingVideoController() async {
    //'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
    _controller = VideoPlayerController.file(widget.file)
      ..play()
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      setState(() {
        currentPositionDuration = _controller.value.position;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _sideBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _createSideBannerAd();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetImage(
                "assets/images/dids.jpg",
              ),
              fit: BoxFit.fill,
              color: Colors.black.withOpacity(.6),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: size.height / 2.6,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/ice_and_fire.jpg"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isFavouriteVideo(widget.file.path)) {
                          setState(() {
                            removeAFavouritVideoSong(widget.file.path);
                          });
                        } else {
                          setState(() {
                            addFavouriteVideoList(widget.file.path);
                          });
                        }
                        setState(() {
                          isFavirout = !isFavirout;
                        });
                      },
                      child: isFavouriteVideo(widget.file.path)
                          ? Controls(
                              icon: Icons.favorite,
                              iconColor: Colors.yellow,
                            )
                          : Controls(
                              icon: Icons.favorite,
                              iconColor: Colors.white,
                            ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            _controller.dataSource
                                .split("/")
                                .last
                                .split(".")
                                .first,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        myBottomSheet(context, widget.file.path);
                      },
                      child: Controls(
                        icon: Icons.playlist_add,
                        iconColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text(
                      // "00:00",
                      currentPositionDuration.toString().split(".").first,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 3,
                          inactiveTrackColor: Colors.grey,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 8),
                        ),
                        child: Slider(
                            value: currentPositionDuration.inSeconds.toDouble(),
                            max:
                                _controller.value.duration.inSeconds.toDouble(),
                            min: 0,
                            onChanged: (val) {
                              _controller
                                  .seekTo(Duration(seconds: val.toInt()));
                            }),
                      ),
                    ),
                    Text(
                      _controller.value.duration.toString().split(".").first,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              PlayerControls(
                controller: _controller,
                videoFile: widget.videoFile,
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(right: size.width / 80),
              child: Align(
                alignment: Alignment.topRight,
                child: _isSideBannerAdLoaded
                    ? SizedBox(
                        height: _sideBannerAd.size.height.toDouble(),
                        width: _sideBannerAd.size.width.toDouble(),
                        child: AdWidget(ad: _sideBannerAd),
                      )
                    : SizedBox(),
              ),
            ),
          ),
          SafeArea(
            child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                )
                // PopupMenuButton<String>(
                //   icon: Icon(
                //     Icons.more_vert,
                //     color: Colors.white,
                //   ),
                //   itemBuilder: (context) => [
                //     PopupMenuItem(
                //       child: Text("Something"),
                //       onTap: () {},
                //     ),
                //     PopupMenuItem(
                //       child: Text("Something here"),
                //       onTap: () {},
                //     ),
                //   ],
                // ),
                ),
          ),
        ],
      ),
    );
  }
}

Future<dynamic> myBottomSheet(BuildContext context, String path) {
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 80,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Enter playlist name",
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("CANCLE"),
                  ),
                  TextButton(
                    onPressed: () async {
                      String message = await addPlalistVideoList(
                          _controller.text.toString());
                      Fluttertoast.showToast(
                          msg: message,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      _controller.text = "";
                    },
                    child: Text("CREATE"),
                  ),
                ],
              ),
            );
          },
          child: Card(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: Center(
                child: ListTile(
                  leading: Container(
                    height: 30,
                    width: 30,
                    color: Colors.red,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  title: Text("Create new playlist"),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 80),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text("Add to existing playlist"),
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 80),
        Expanded(
          child: FutureBuilder<List<PlaylistVideoSongsModel>>(
              future: getAllPlaylistVideoSong(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () async {
                      String message = await addSinglSongPlaylistVideoList(
                        snapshot.data![index].folderName!,
                        path,
                      );
                      Fluttertoast.showToast(
                          msg: message,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pop(context);
                    },
                    child: Card(
                      elevation: 0.1,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 8,
                        child: Center(
                          child: ListTile(
                            leading: Container(
                              height: 30,
                              width: 30,
                              color: Colors.red,
                              child: Icon(
                                Icons.music_note_sharp,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(snapshot.data![index].folderName!),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    ),
    // ListView.builder(
    //   itemCount: playList.length,
    //   itemBuilder: (context, index) => Card(
    //     child: SizedBox(
    //       height: MediaQuery.of(context).size.height / 6,
    //       child: Center(
    //         child: GestureDetector(
    //           onTap: () => playList[index].func(context),
    //           child: ListTile(
    //             leading: Container(
    //               height: 50,
    //               width: 50,
    //               color: Colors.red,
    //               child: Icon(
    //                 playList[index].icon,
    //                 color: Colors.white,
    //               ),
    //             ),
    //             title: Text(playList[index].text),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
  );
}

class PlayerControls extends StatefulWidget {
  final VideoPlayerController controller;
  final List<File> videoFile;
  const PlayerControls({
    Key? key,
    required this.controller,
    required this.videoFile,
  }) : super(key: key);

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  bool isLoop = false;

  Duration currentPositionDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      currentPositionDuration = widget.controller.value.position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            setState(() {
              isLoop = !isLoop;
              widget.controller.setLooping(isLoop);
            });
          },
          child: Controls(
            icon: isLoop ? Icons.repeat_one : Icons.repeat,
            iconColor: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.controller
                .seekTo(currentPositionDuration + Duration(seconds: -30));
          },
          child: Controls(
            icon: Icons.fast_rewind,
            iconColor: Colors.white,
          ),
        ),
        PlayControl(
          controller: widget.controller,
        ),
        GestureDetector(
          onTap: () {
            widget.controller
                .seekTo(currentPositionDuration + Duration(seconds: 30));
          },
          child: Controls(
            icon: Icons.fast_forward,
            iconColor: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoLibraryPage(
                  videoFile: widget.videoFile,
                ),
              ),
            );
          },
          child: Controls(
            // icon: Icons.shuffle,
            icon: Icons.library_music,
            iconColor: Colors.white,
          ),
        ),
        // Controls(
        //   icon: Icons.favorite,
        // ),
      ],
    );
  }
}

class PlayControl extends StatefulWidget {
  final VideoPlayerController controller;
  const PlayControl({Key? key, required this.controller}) : super(key: key);

  @override
  State<PlayControl> createState() => _PlayControlState();
}

class _PlayControlState extends State<PlayControl> {
  bool isPause = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.red.withOpacity(0.1),
                      offset: Offset(5, 10),
                      spreadRadius: 3,
                      blurRadius: 10),
                  BoxShadow(
                      color: Colors.white70,
                      offset: Offset(-3, -4),
                      spreadRadius: -2,
                      blurRadius: 10)
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                if (widget.controller.value.isPlaying) {
                  widget.controller.pause();
                } else {
                  widget.controller.play();
                }
              });
            },
            child: Center(
              child: Container(
                margin: EdgeInsets.all(12),
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Center(
                  child: Icon(
                    widget.controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Controls extends StatelessWidget {
  final IconData icon;
  final Color iconColor;

  const Controls({
    Key? key,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.red.withOpacity(0.1),
                      offset: Offset(5, 10),
                      spreadRadius: 3,
                      blurRadius: 10),
                  BoxShadow(
                      color: Colors.white70,
                      offset: Offset(-3, -4),
                      spreadRadius: -2,
                      blurRadius: 10)
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Center(
                  child: Icon(
                icon,
                size: 30,
                color: iconColor,
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class MyPlaylist {
  final String text;
  final IconData icon;
  final Function func;

  MyPlaylist({
    required this.text,
    required this.icon,
    required this.func,
  });
}

TextEditingController _controller = TextEditingController();

List<MyPlaylist> playList = [
  MyPlaylist(
    text: "Create new playlist",
    icon: Icons.add,
    func: (context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Enter playlist name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("CANCLE"),
            ),
            TextButton(
              onPressed: () {},
              child: Text("CREATE"),
            ),
          ],
        ),
      );
    },
  ),
  MyPlaylist(
      text: "My Favourite",
      icon: Icons.favorite,
      func: (context) {
        print("I Will Rule The World! 2");
      }),
];

//duration class
class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
