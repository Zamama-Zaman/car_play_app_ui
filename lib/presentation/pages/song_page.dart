// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, prefer_if_null_operators

import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:car_play_app/data/ads/ad_helper.dart';
import 'package:car_play_app/data/store/store_favourites_song.dart';
import 'package:car_play_app/presentation/pages/audio_music_page.dart';
import 'package:car_play_app/presentation/pages/audio_music_page_test.dart';
import 'package:car_play_app/presentation/state_management/show_search_bar_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// const int maxFailedLoadAttempts = 3;

class SongPage extends StatefulWidget {
  const SongPage({Key? key}) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  List<SongModel> listOfSong = [];

  List<Audio> listAudio = [];

  List<Audio> _listAudioSearch = [];

  TextEditingController searchController = TextEditingController();

  ValueChanged<String>? onChanged;
  String? text;

  final _inlineAdIndex = 4;

  // int _interstitialLoadAttempts = 0;

  late BannerAd _bottomBannerAd;
  late BannerAd _inlineBannerAd;
  // InterstitialAd? _interstitialAd;

  bool _isBottomBannerAdLoaded = false;
  bool _isInlineBannerAdLoaded = false;

  int _getListViewItemIndex(int index) {
    if (index >= _inlineAdIndex && _isInlineBannerAdLoaded) {
      return index - 1;
    }
    return index;
  }

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

  void _createInlineBannerAd() {
    _inlineBannerAd = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isInlineBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _inlineBannerAd.load();
  }

  // void _createInterstitailAd() {
  //   InterstitialAd.load(
  //     adUnitId: AdHelper.interstitialAdUnitID,
  //     request: AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         _interstitialAd = ad;
  //         _interstitialLoadAttempts = 0;
  //       },
  //       onAdFailedToLoad: (error) {
  //         _interstitialLoadAttempts += 1;
  //         _interstitialAd = null;
  //         if (_interstitialLoadAttempts >= maxFailedLoadAttempts) {
  //           _createInterstitailAd();
  //         }
  //       },
  //     ),
  //   );
  // }

  // void showInterstitialAd() {
  //   if (_interstitialAd != null) {
  //     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //       onAdDismissedFullScreenContent: (ad) {
  //         ad.dispose();
  //         _createInterstitailAd();
  //       },
  //       onAdFailedToShowFullScreenContent: (ad, error) {
  //         ad.dispose();
  //         _createInterstitailAd();
  //       },
  //     );
  //     _interstitialAd!.show();
  //   }
  // }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    _bottomBannerAd.dispose();
    _inlineBannerAd.dispose();
    // _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // requestStoragePermission();
    getAllSong();
    _createBottomBannerAd();
    _createInlineBannerAd();
    // _createInterstitailAd();
    super.initState();
  }

  requestStoragePermission() async {
    // only if the platform is not web, coz web have no permission
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  getAllSong() async {
    listOfSong = await _audioQuery.querySongs();
    createPlaylist(listOfSong);
    setState(() {});
  }

  void searchQuery(String query) {
    List<Audio> name = _listAudioSearch.where((name) {
      final titleLower = name.metas.title!.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      listAudio = name;
      assetsAudioPlayer.open(
        Playlist(
          audios: listAudio,
        ),
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        showNotification: true,
        autoStart: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: _isBottomBannerAdLoaded
              ? SizedBox(
                  height: _bottomBannerAd.size.height.toDouble(),
                  width: _bottomBannerAd.size.width.toDouble(),
                  child: AdWidget(ad: _bottomBannerAd),
                )
              : null,
          appBar: context.watch<ShowSearchBarProvider>().isShow
              ? PreferredSize(
                  preferredSize: Size(double.infinity, 50),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      border: Border.all(color: Colors.black, width: .5),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel_rounded),
                          onPressed: () {
                            searchController.clear();
                            listAudio = _listAudioSearch;
                            assetsAudioPlayer.open(
                              Playlist(
                                audios: listAudio,
                              ),
                              headPhoneStrategy:
                                  HeadPhoneStrategy.pauseOnUnplug,
                              showNotification: true,
                              autoStart: false,
                            );
                            context
                                .read<ShowSearchBarProvider>()
                                .showSearchBar(false);
                          },
                        ),
                      ),
                      onChanged: searchQuery,
                    ),
                  ),
                )
              : null,
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     print(listOfSong.length);
          //   },
          // ),
          body: listAudio.isEmpty
              ? Center(child: Text("No Song Found"))
              : ListView.builder(
                  itemCount: listAudio.length +
                      (_isInlineBannerAdLoaded &&
                              !context.watch<ShowSearchBarProvider>().isShow
                          ? 1
                          : 0),
                  itemBuilder: (context, index) {
                    if (_isInlineBannerAdLoaded &&
                        index == _inlineAdIndex &&
                        !context.watch<ShowSearchBarProvider>().isShow) {
                      // if (false) {
                      return Container(
                        padding: EdgeInsets.only(bottom: 10),
                        width: _inlineBannerAd.size.width.toDouble(),
                        height: _inlineBannerAd.size.height.toDouble(),
                        child: AdWidget(
                          ad: _inlineBannerAd,
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AudioMusicPage(
                                player: assetsAudioPlayer,
                                audio: listAudio,
                                index: _getListViewItemIndex(index),
                                // index: index,
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
                                  artworkWidth:
                                      MediaQuery.of(context).size.width / 15,
                                  id: int.parse(
                                      listAudio[_getListViewItemIndex(index)]
                                          .metas
                                          .id!),
                                  type: ArtworkType.AUDIO,
                                ),
                                //     Container(
                                //   height: MediaQuery.of(context).size.height / 10,
                                //   width: MediaQuery.of(context).size.width / 13,
                                //   color: Colors.amber,
                                // ),
                                title: Text(
                                  listAudio[_getListViewItemIndex(index)]
                                      .metas
                                      .title!,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  listAudio[_getListViewItemIndex(index)]
                                              .metas
                                              .extra!["displayName"] ==
                                          null
                                      ? ""
                                      : listAudio[_getListViewItemIndex(index)]
                                          .metas
                                          .extra!["displayName"],
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  icon: isFavourite(listAudio[
                                              _getListViewItemIndex(index)]
                                          .metas
                                          .extra!["uri"])
                                      ? Icon(
                                          Icons.favorite_outlined,
                                          color: Colors.red,
                                        )
                                      : Icon(Icons.favorite_outline),
                                  onPressed: () async {
                                    if (isFavourite(
                                        listAudio[_getListViewItemIndex(index)]
                                            .metas
                                            .extra!["uri"])) {
                                      setState(() {
                                        removeAFavouritSong(
                                          listAudio[
                                                  _getListViewItemIndex(index)]
                                              .metas
                                              .extra!["uri"],
                                        );
                                      });
                                    } else {
                                      setState(() {
                                        addFavouriteList(
                                          listAudio[
                                                  _getListViewItemIndex(index)]
                                              .metas
                                              .extra!["displayName"],
                                          listAudio[
                                                  _getListViewItemIndex(index)]
                                              .metas
                                              .extra!["uri"],
                                          listAudio[
                                                  _getListViewItemIndex(index)]
                                              .metas
                                              .title!,
                                          listAudio[
                                                  _getListViewItemIndex(index)]
                                              .metas
                                              .extra!["data"],
                                          listAudio[
                                                  _getListViewItemIndex(index)]
                                              .metas
                                              .id!,
                                        );
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                )),
    );
  }

  createPlaylist(List<SongModel> songs) {
    listOfSong = songs;

    for (int i = 0; i < listOfSong.length; i++) {
      listAudio.add(
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
      _listAudioSearch.add(
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
        audios: listAudio,
      ),
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      showNotification: true,
      autoStart: false,
    );
  }
}
