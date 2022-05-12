// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:car_play_app/data/ads/ad_helper.dart';
import 'package:car_play_app/data/store/store_favourites_video_song.dart';
import 'package:car_play_app/presentation/pages/video_music_page.dart';
import 'package:car_play_app/presentation/state_management/show_search_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/src/provider.dart';

class VideoPlayerPage extends StatefulWidget {
  final List<File> videoFile;
  const VideoPlayerPage({
    Key? key,
    required this.videoFile,
  }) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  List<File> files = [];
  List<File> files2 = [];

  Future<List<File>> getAllVideos() async {
    Permission.storage.request();
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0].rootDir;
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(excludedPaths: [
      "/storage/emulated/0/Android"
    ], extensions: [
      "mp4",
    ]);

    // var root2 = storageInfo[1].rootDir;
    // var fm2 = FileManager(root: Directory(root)); //
    // files2 = await fm.filesTree(excludedPaths: [
    //   "/storage/emulated/0/Android"
    // ], extensions: [
    //   "mp4",
    // ]);
    // print(files2[0].toString() + " I am called");

    return files;
  }

  final _inlineAdIndex = 4;

  late BannerAd _bottomBannerAd;
  late BannerAd _inlineBannerAd;

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
      size: AdSize.largeBanner,
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

  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
    _createInlineBannerAd();
    getAllVideos();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
    _inlineBannerAd.dispose();
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
      body:
          // FutureBuilder<List<File>>(
          //     future: getAllVideos(),
          //     builder: (context, snapshot) {
          //       if (files.isEmpty) {
          //         return Center(
          //           child: Text("No Vidoes"),
          //         );
          //       }
          //       if (!snapshot.hasData) {
          //         return Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       }
          //       return
          widget.videoFile.isEmpty
              ? Center(
                  child: Text("No Vidoes"),
                )
              : ListView.builder(
                  itemCount: widget.videoFile.length,
                  itemBuilder: (context, index) {
                    if (_isInlineBannerAdLoaded && index == _inlineAdIndex) {
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
                              builder: (context) => PageNextPreviousVideo(
                                file: widget.videoFile,
                                index: _getListViewItemIndex(index),
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
                                  id: int.parse("8888888"),
                                  type: ArtworkType.AUDIO,
                                ),
                                title: Text(
                                  widget.videoFile[_getListViewItemIndex(index)]
                                      .path
                                      .split('/')
                                      .last
                                      .toString()
                                      .split(".")
                                      .first,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  icon: isFavouriteVideo(widget
                                          .videoFile[
                                              _getListViewItemIndex(index)]
                                          .path)
                                      ? Icon(
                                          Icons.favorite_outlined,
                                          color: Colors.red,
                                        )
                                      : Icon(Icons.favorite_outline),
                                  onPressed: () async {
                                    if (isFavouriteVideo(widget
                                        .videoFile[_getListViewItemIndex(index)]
                                        .path)) {
                                      setState(() {
                                        removeAFavouritVideoSong(widget
                                            .videoFile[
                                                _getListViewItemIndex(index)]
                                            .path);
                                      });
                                    } else {
                                      setState(() {
                                        addFavouriteVideoList(widget
                                            .videoFile[
                                                _getListViewItemIndex(index)]
                                            .path);
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
                ),
      // }),
    );
  }
}
