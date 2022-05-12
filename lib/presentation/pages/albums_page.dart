// ignore_for_file: prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:car_play_app/data/ads/ad_helper.dart';
import 'package:car_play_app/presentation/pages/audio_music_page.dart';
import 'package:car_play_app/presentation/state_management/show_search_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/src/provider.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({Key? key}) : super(key: key);

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
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
      body: FutureBuilder<List<AlbumModel>>(
        future: _audioQuery.queryAlbums(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (item.data!.isEmpty) {
            return Center(
              child: Text("No Songs Found"),
            );
          }
          return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () async {
                print(item.data![index].getMap);
                final map = item.data![index].getMap;
                print(map['_id']);
                // int.parse(map['album_id'])
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowAlbumSongs(
                      aId: map['_id'],
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
                        id: item.data![index].id,
                        type: ArtworkType.AUDIO,
                      ),
                      title: Text(item.data![index].album),
                      subtitle: Text(item.data![index].artist!),
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

class ShowAlbumSongs extends StatefulWidget {
  final int aId;
  const ShowAlbumSongs({Key? key, required this.aId}) : super(key: key);

  @override
  State<ShowAlbumSongs> createState() => _ShowAlbumSongsState();
}

class _ShowAlbumSongsState extends State<ShowAlbumSongs> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final assetsAudioPlayer = AssetsAudioPlayer();

  List<SongModel> listOfSong = [];

  final List<Audio> _listAudio = [];

  getAllSong() async {
    listOfSong = await _audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM_ID,
      widget.aId,
      sortType: SongSortType.TITLE, // Default
      orderType: OrderType.ASC_OR_SMALLER, // Default
    );
    createPlaylist(listOfSong);
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getAllSong();
    super.initState();
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
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.queryAudiosFrom(
          AudiosFromType.ALBUM_ID,
          widget.aId,
          sortType: SongSortType.TITLE, // Default
          orderType: OrderType.ASC_OR_SMALLER, // Default
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (item.data!.isEmpty) {
            return Center(
              child: Text("No Songs Found"),
            );
          }
          return ListView.builder(
            itemCount: _listAudio.length,
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
                        id: item.data![index].id,
                        type: ArtworkType.AUDIO,
                      ),
                      title:
                          Text(_listAudio[index].metas.extra!["displayName"]),
                      subtitle: Text(_listAudio[index].metas.title!),
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

  createPlaylist(List<SongModel> songs) {
    listOfSong = songs;

    for (int i = 0; i < listOfSong.length; i++) {
      _listAudio.add(
        Audio.file(
          listOfSong[i].data,
          metas: Metas(
            album: listOfSong[i].album,
            artist: listOfSong[i].artist,
            title: listOfSong[i].title,
            id: listOfSong[i].id.toString(),
            extra: {
              "data": listOfSong[i].data,
              "displayName": listOfSong[i].displayName,
              "uri": listOfSong[i].uri,
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
  }
}
