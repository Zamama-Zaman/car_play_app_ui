// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:car_play_app/data/models/favourites_video_songs_model.dart';
import 'package:car_play_app/data/store/store_favourites_video_song.dart';
import 'package:car_play_app/presentation/pages/video_music_page.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteVideoPage extends StatefulWidget {
  const FavoriteVideoPage({Key? key}) : super(key: key);

  @override
  State<FavoriteVideoPage> createState() => _FavoriteVideoPageState();
}

class _FavoriteVideoPageState extends State<FavoriteVideoPage> {
  List<FavouritesVideoSongsModel> videoSongList = [];
  List<File> files = [];

  @override
  void initState() {
    super.initState();
    createVideoPlaylist();
  }

  Future<List<FavouritesVideoSongsModel>>
      getAllVideoSongsFromSharedPrefferences() async {
    videoSongList = await getAllFavouritesVideoSong();
    setState(() {});
    return videoSongList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image(
          image:
              AssetImage("assets/images/app_title_image-removebg-preview.png"),
          width: 200,
          height: 200,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<File>>(
        future: createVideoPlaylist(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (videoSongList.isEmpty) {
            return Center(
              child: Text("No Favourite Video Song"),
            );
          }
          return ListView.builder(
            itemCount: videoSongList.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageNextPreviousVideo(
                      file: files,
                      index: index,
                    ),
                  ),
                );
              },
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                  child: Center(
                    child: ListTile(
                      leading: QueryArtworkWidget(
                        artworkHeight: MediaQuery.of(context).size.height / 10,
                        artworkWidth: MediaQuery.of(context).size.width / 15,
                        id: int.parse("88888"),
                        type: ArtworkType.AUDIO,
                      ),
                      // Container(
                      //   height: MediaQuery.of(context).size.height / 10,
                      //   width: MediaQuery.of(context).size.width / 13,
                      //   color: Colors.transparent,
                      //   child: Icon(
                      //     Icons.image_not_supported_sharp,
                      //     size: 45,
                      //   ),
                      // ),
                      title: Text(videoSongList[index]
                          .file
                          .split("/")
                          .last
                          .split(".")
                          .first),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            removeAFavouritVideoSong(videoSongList[index].file);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<File>> createVideoPlaylist() async {
    getAllVideoSongsFromSharedPrefferences().then((video) {
      for (int i = 0; i < video.length; i++) {
        files.add(File(video[i].file));
      }
      return files;
    });
    return files;
  }
}
