// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:car_play_app/data/ads/ad_helper.dart';
import 'package:car_play_app/data/models/favourites_audio_songs_model.dart';
import 'package:car_play_app/data/store/store_favourites_song.dart';
import 'package:car_play_app/presentation/pages/audio_music_page.dart';
import 'package:car_play_app/presentation/pages/favorite_video_page.dart';
import 'package:car_play_app/presentation/state_management/show_search_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/src/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late BannerAd _bottomBannerAd;

  bool _isBottomBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ShowSearchBarProvider>().showSearchBar(false);
    return Scaffold(
      bottomNavigationBar: _isBottomBannerAdLoaded
          ? SizedBox(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
          : null,
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavirouteAudioPage(),
                ),
              );
            },
            child: Card(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: Center(
                  child: ListTile(
                    leading: Container(
                      height: MediaQuery.of(context).size.height / 10,
                      width: MediaQuery.of(context).size.width / 15,
                      color: Colors.transparent,
                      child: Icon(
                        Icons.video_collection,
                        size: 45,
                      ),
                    ),

                    // QueryArtworkWidget(
                    //   artworkHeight: MediaQuery.of(context).size.height / 10,
                    //   artworkWidth: MediaQuery.of(context).size.width / 15,
                    //   id: int.parse("8888888"),
                    //   type: ArtworkType.AUDIO,
                    // ),
                    title: Text("Audio Favourite Songs"),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteVideoPage(),
                ),
              );
            },
            child: Card(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: Center(
                  child: ListTile(
                    leading: Container(
                      height: MediaQuery.of(context).size.height / 10,
                      width: MediaQuery.of(context).size.width / 15,
                      color: Colors.transparent,
                      child: Icon(
                        Icons.image,
                        size: 45,
                      ),
                    ),
                    title: Text("Video Favourite Songs"),
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

class FavirouteAudioPage extends StatefulWidget {
  const FavirouteAudioPage({Key? key}) : super(key: key);

  @override
  State<FavirouteAudioPage> createState() => _FavirouteAudioPageState();
}

class _FavirouteAudioPageState extends State<FavirouteAudioPage> {
  late List<FavouriteAudioSongs> favouriteSongListPage = [];

  final assetsAudioPlayer = AssetsAudioPlayer();

  List<SongModel> listOfSong = [];

  final List<Audio> _listAudio = [];

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  Future<List<FavouriteAudioSongs>> function() async {
    return favouriteSongListPage = await getAllFavouritesSong();
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
      body: FutureBuilder<Object>(
          future: creatPlaylist(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (favouriteSongListPage.isEmpty) {
              return Center(
                child: Text("No Favourite Audio Song"),
              );
            }
            return ListView.builder(
              itemCount: favouriteSongListPage.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
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
                          artworkHeight:
                              MediaQuery.of(context).size.height / 10,
                          artworkWidth: MediaQuery.of(context).size.width / 15,
                          id: int.parse(_listAudio[index].metas.id!),
                          type: ArtworkType.AUDIO,
                        ),

                        title: Text(_listAudio[index].metas.title ?? ""),
                        // subtitle: Text(_listAudio[index].metas.extra!["name"]),
                        // subtitle: Text(
                        //     _listAudio[index].metas.extra!["displayName"] ??
                        //         ""),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              removeAFavouritSong(
                                  favouriteSongListPage[index].uri);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<List<Audio>> creatPlaylist() async {
    function().then((_favouriteSongListPage) {
      if (_favouriteSongListPage.isNotEmpty) {
        for (int i = 0; i < _favouriteSongListPage.length; i++) {
          // print(_favouriteSongListPage[i].data.toString());
          _listAudio.add(
            Audio.file(
              _favouriteSongListPage[i].data.toString(),
              metas: Metas(
                title: _favouriteSongListPage[i].title,
                id: _favouriteSongListPage[i].id,
                extra: {
                  "uri": _favouriteSongListPage[i].uri,
                  "name": _favouriteSongListPage[i].name,
                  "data": _favouriteSongListPage[i].data,
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
        return _listAudio;
      }
    });
    return _listAudio;
  }
}
