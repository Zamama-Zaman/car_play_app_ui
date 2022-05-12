// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, prefer_if_null_operators

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:car_play_app/data/ads/ad_helper.dart';
import 'package:car_play_app/data/models/playlist_audio_songs_model.dart';
import 'package:car_play_app/data/store/store_favourites_song.dart';
import 'package:car_play_app/data/store/store_playlist_audio_song.dart';
import 'package:car_play_app/presentation/pages/favorite_page.dart';
import 'package:car_play_app/presentation/pages/library_detail_list_page.dart';
import 'package:car_play_app/presentation/pages/song_page.dart';
// import 'package:car_play/presentation/state_management/audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class AudioMusicPage extends StatefulWidget {
  final AssetsAudioPlayer player;
  final List<Audio> audio;
  final int index;
  const AudioMusicPage(
      {Key? key,
      required this.player,
      required this.audio,
      required this.index})
      : super(key: key);

  @override
  State<AudioMusicPage> createState() => _AudioMusicPageState();
}

class _AudioMusicPageState extends State<AudioMusicPage> {
  bool isFavirout = false;
  double sliderValue = 2.0;

  int myIndex = 1;

  late PageController _pageController;

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
  void dispose() {
    super.dispose();
    _sideBannerAd.dispose();
    widget.player.pause();
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.index);
    widget.player.playlistPlayAtIndex(widget.index);

    // widget.player

    function();
    super.initState();
  }

  function() {
    widget.audio;
    widget.index;
    widget.player;
  }

  //duration state stream
  // Stream<DurationState> get _durationStateStream =>
  //     Rx.combineLatest2<Duration, Duration?, DurationState>(
  //         widget.player.positionStream,
  //         widget.player.durationStream,
  //         (position, duration) => DurationState(
  //             position: position, total: duration ?? Duration.zero));

  playListFinished() {
    widget.player.current.listen((event) {
      _pageController.jumpToPage(event!.index);
      print(event.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // playListFinished();
    Size size = MediaQuery.of(context).size;
    return PageView.builder(
      onPageChanged: (_index) {
        if (_pageController.position.userScrollDirection.toString() ==
            "ScrollDirection.forward") {
          widget.player.previous();
        } else {
          widget.player.next();
        }
      },
      controller: _pageController,
      itemCount: widget.audio.length,
      itemBuilder: (context, index) {
        _createSideBannerAd();
        return Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     print(widget.player.current.value!.index);
          //   },
          // ),
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
                // crossAxisAlignment: CrossAxisAlignment.end,
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
                            // print(widget.audio[index].metas.id);
                            if (isFavourite(
                                widget.audio[index].metas.extra!["uri"])) {
                              setState(() {
                                removeAFavouritSong(
                                  widget.audio[index].metas.extra!["uri"],
                                );
                              });
                            } else {
                              setState(() {
                                addFavouriteList(
                                  widget
                                      .audio[index].metas.extra!["displayName"],
                                  widget.audio[index].metas.extra!["uri"],
                                  widget.audio[index].metas.title!,
                                  widget.audio[index].metas.extra!["data"],
                                  widget.audio[index].metas.id!,
                                );
                              });
                            }
                            setState(() {
                              isFavirout = !isFavirout;
                            });
                          },
                          child: isFavourite(
                                  widget.audio[index].metas.extra!["uri"])
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
                              widget.player.builderCurrent(
                                builder: (context, playing) => Text(
                                  playing.audio.audio.metas.title!,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Text(
                              //   // "Song name here...",
                              //   widget.player.current.value!.audio.audio.metas
                              //       .title!,

                              //   // widget.audio[index].metas.extra!['displayName'],
                              //   overflow: TextOverflow.ellipsis,
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 20,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              SizedBox(height: 5),
                              widget.player.builderCurrent(
                                builder: (context, playing) => Text(
                                  playing.audio.audio.metas
                                              .extra!['displayName'] ==
                                          null
                                      ? ""
                                      : playing.audio.audio.metas
                                          .extra!['displayName'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                              // Text(
                              //   widget.player.current.value!.audio.audio.metas
                              //               .extra!['displayName'] ==
                              //           null
                              //       ? ""
                              //       : widget.player.current.value!.audio.audio
                              //           .metas.extra!['displayName'],
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 14,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            myBottomSheet(context, index);
                            // await addPlaylist();
                            // print("I Will Rule The World!");
                            // addPlalistAudioList("Something");
                            // getAllPlaylistAudioSong()
                            //     .then((value) => print(value[0].song!.length));

                            // Add Single Song
                            // addSinglSongPlaylistAudioList("Something", "Song1");

                            // Remove Single Song
                            // removeSingleSongPlaylistAudiolist("Something", 0);
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
                        StreamBuilder<Duration>(
                            stream: widget.player.currentPosition,
                            builder: (context, snapshot) {
                              final Duration? duration = snapshot.data;
                              return Text(
                                // "00:00",
                                duration.toString().split(".").first,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            }),
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 3,
                              inactiveTrackColor: Colors.grey,
                              thumbShape:
                                  RoundSliderThumbShape(enabledThumbRadius: 8),
                            ),
                            child: StreamBuilder<Duration>(
                              stream: widget.player.currentPosition,
                              builder: (context, snapshot) {
                                final Duration? durationState = snapshot.data;

                                currentValue =
                                    durationState?.inSeconds.toDouble() ?? 0.0;

                                // widget.player.current.listen((event) {});

                                final total =
                                    widget.player.current.value?.audio.duration;
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                return Slider(
                                    value: currentValue,
                                    max: total?.inSeconds.toDouble() ?? 0.0,
                                    min: 0,
                                    onChanged: (val) {
                                      widget.player
                                          .seek(Duration(seconds: val.toInt()));
                                    });
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.symmetric(horizontal: 10),
                                //   child: ProgressBar(
                                //     progress: durationState ?? Duration.zero,
                                //     total: total ?? Duration.zero,
                                //     barHeight: 5,
                                //     baseBarColor: const Color(0xEE9E9E9E),
                                //     progressBarColor: Colors.red,
                                //     thumbColor: Colors.red,
                                //     timeLabelTextStyle: const TextStyle(
                                //       fontSize: 0,
                                //     ),
                                //     onSeek: (duration) {
                                //       widget.player.seek(duration);
                                //     },
                                //   ),
                                // );
                              },
                            ),
                          ),
                        ),
                        widget.player.builderCurrent(
                          builder: (context, playing) => Text(
                            widget.player.current.value!.audio.duration
                                .toString()
                                .split(".")
                                .first,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Text(
                        //   widget.player.current.value!.audio.duration
                        //       .toString()
                        //       .split(".")
                        //       .first,
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  PlayerControls(
                    player: widget.player,
                  ),
                ],
              ),
              // SafeArea(
              //   child: Align(
              //     alignment: Alignment.topRight,
              //     child: Container(
              //       width: 50,
              //       height: 50,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
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
                  ),
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
      },
    );
  }

  Future<dynamic> myBottomSheet(BuildContext context, int currentIndex) {
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
                        String message = await addPlalistAudioList(
                            _controller.text.toString());
                        Fluttertoast.showToast(
                            msg: message,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
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
            child: FutureBuilder<List<PlaylistAudioSongModel>>(
                future: getAllPlaylistAudioSong(),
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
                        String message = await addSinglSongPlaylistAudioList(
                          snapshot.data![index].folderName!,
                          widget.audio[currentIndex].metas.extra!["uri"],
                          widget
                              .audio[currentIndex].metas.extra!["displayName"],
                          widget.audio[currentIndex].metas.title!,
                          widget.audio[currentIndex].metas.extra!["data"],
                          widget.audio[currentIndex].metas.id!,
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
}

class PlayerControls extends StatefulWidget {
  final AssetsAudioPlayer player;
  const PlayerControls({Key? key, required this.player}) : super(key: key);

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  bool isLoop = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            setState(() {
              isLoop = !isLoop;
            });
            if (isLoop) {
              await widget.player.setLoopMode(LoopMode.single);
            } else {
              await widget.player.setLoopMode(LoopMode.none);
            }
          },
          child: Controls(
            icon: isLoop ? Icons.repeat_one : Icons.repeat,
            iconColor: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            // widget.player.pause();
            // widget.player.forwardOrRewind(-100);
            widget.player.seek(
                widget.player.currentPosition.value + Duration(seconds: -30));
          },
          child: Controls(
            icon: Icons.fast_rewind,
            iconColor: Colors.white,
          ),
        ),
        PlayControl(
          player: widget.player,
        ),
        GestureDetector(
          onTap: () {
            // widget.player.pause();
            // widget.player.forwardOrRewind(100);
            widget.player.seek(
                widget.player.currentPosition.value + Duration(seconds: 30));
          },
          child: Controls(
            icon: Icons.fast_forward,
            iconColor: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => SongPage(),
            //   ),
            // );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LibraryDetailListPage(),
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
  final AssetsAudioPlayer player;
  const PlayControl({Key? key, required this.player}) : super(key: key);

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
                widget.player.playOrPause();
              });
            },
            child: Center(
              child: Container(
                margin: EdgeInsets.all(12),
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Center(
                  child: StreamBuilder<bool>(
                      stream: widget.player.isPlaying,
                      builder: (context, snapshot) {
                        bool? isPlaying = snapshot.data;
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Icon(
                          isPlaying! ? Icons.pause : Icons.play_arrow,
                          size: 60,
                          color: Colors.white,
                        );
                      }),
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

// Future<void> addPlaylist() async {
//   List<PlaylistAudioSongModel> playlistSongs = await getAllPlaylistAudioSong();

//   print(playlistSongs.length);

//   for (int i = 0; i < playlistSongs.length; i++) {
//     playList.add(MyPlaylist(
//         text: playlistSongs[i].folderName!,
//         icon: Icons.snowshoeing,
//         func: (context) {
//           print(i);
//         }));
//   }
//   playList.toSet();
// }

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavirouteAudioPage(),
          ),
        );
      }),
];

//duration class
class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
