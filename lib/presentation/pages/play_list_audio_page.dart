// ignore_for_file: prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:car_play_app/data/models/playlist_audio_single_song_model.dart';
import 'package:car_play_app/data/models/playlist_audio_songs_model.dart';
import 'package:car_play_app/data/store/store_playlist_audio_song.dart';
import 'package:car_play_app/presentation/pages/audio_music_page.dart';
import 'package:car_play_app/presentation/pages/audio_music_page_test.dart';
import 'package:car_play_app/presentation/state_management/asset_audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlayListAudioPage extends StatefulWidget {
  const PlayListAudioPage({Key? key}) : super(key: key);

  @override
  State<PlayListAudioPage> createState() => _PlayListAudioPageState();
}

class _PlayListAudioPageState extends State<PlayListAudioPage> {
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
        elevation: 0,
      ),
      body: FutureBuilder<List<PlaylistAudioSongModel>>(
        future: getAllPlaylistAudioSong(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.data!.isNotEmpty) {
            return Center(
              child: Text("No audio playlist song"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowPlaylistSongs(
                      folderName: snapshot.data![index].folderName!,
                    ),
                  ),
                );
              },
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                  child: Center(
                    child: ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        color: Colors.red,
                        child: Icon(
                          Icons.music_note_sharp,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(snapshot.data![index].folderName!),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            removeAPlaylist(snapshot.data![index].folderName!);
                          });
                        },
                        icon: Icon(Icons.delete),
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
}

class ShowPlaylistSongs extends StatefulWidget {
  final String folderName;
  const ShowPlaylistSongs({
    Key? key,
    required this.folderName,
  }) : super(key: key);

  @override
  State<ShowPlaylistSongs> createState() => _ShowPlaylistSongsState();
}

class _ShowPlaylistSongsState extends State<ShowPlaylistSongs> {
  late List<Song>? playlsitSongListPage = [];
  final assetsAudioPlayer = AssetsAudioPlayer();

  List<SongModel> listOfSong = [];

  final List<Audio> _listAudio = [];

  @override
  void initState() {
    function().then((value) {
      creatPlaylist();
    });
    super.initState();
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    // Provider.of<AssetAudioPlayerProvider>(context, listen: false).dispose();
    super.dispose();
  }

  Future<List<Song>?> function() async {
    return playlsitSongListPage = await getAllSongInAFolder(widget.folderName);
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
        elevation: 0,
      ),
      body: FutureBuilder<List<Song>?>(
        future: getAllSongInAFolder(widget.folderName),
        // future: creatPlaylist(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.data!.isNotEmpty) {
            return Center(
              child: Text("No audio playlist song"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioMusicPage(
                      player: assetsAudioPlayer,
                      audio: _listAudio,
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
                        id: int.parse(snapshot.data![index].id!),
                        type: ArtworkType.AUDIO,
                      ),
                      title: Text(snapshot.data![index].name!),
                      // title: Text(snapshot.data![index].metas.extra!["name"]),
                      subtitle: Text(snapshot.data![index].title!),
                      // subtitle: Text(snapshot.data![index].metas.title!),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            removeSingleSongPlaylistAudiolist(
                              widget.folderName,
                              index,
                            );
                          });
                        },
                        icon: Icon(Icons.delete),
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

  Future<List<Audio>> creatPlaylist() async {
    function().then((_playlistSongListPage) {
      if (_playlistSongListPage!.isNotEmpty) {
        for (int i = 0; i < _playlistSongListPage.length; i++) {
          // print(_favouriteSongListPage[i].data.toString());
          _listAudio.add(
            Audio.file(
              _playlistSongListPage[i].data.toString(),
              metas: Metas(
                title: _playlistSongListPage[i].title,
                id: _playlistSongListPage[i].id,
                extra: {
                  "uri": _playlistSongListPage[i].uri,
                  "name": _playlistSongListPage[i].name,
                  "data": _playlistSongListPage[i].data,
                },
              ),
            ),
          );
        }
        assetsAudioPlayer.open(
          Playlist(
            audios: _listAudio,
          ),
          headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
          showNotification: true,
          autoStart: false,
        );
        // Provider.of<AssetAudioPlayerProvider>(context, listen: false)
        //     .creatPlaylistAssetAudioPlayer(_listAudio);
        return _listAudio;
      }
    });
    return _listAudio;
  }
}
