// ignore_for_file: prefer_const_constructors

import 'package:car_play_app/data/ads/ad_helper.dart';
import 'package:car_play_app/presentation/pages/play_list_audio_page.dart';
import 'package:car_play_app/presentation/pages/play_list_video_page.dart';
import 'package:car_play_app/presentation/state_management/show_search_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/src/provider.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
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
                  builder: (context) => PlayListAudioPage(),
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
                    title: Text("Audio Playlist Songs"),
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
                  builder: (context) => PlaylistVideoPage(),
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
                    title: Text("Video Playlist Songs"),
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
