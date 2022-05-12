// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:car_play_app/presentation/state_management/asset_audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioMusicPageTest extends StatefulWidget {
  final int index;
  final AssetsAudioPlayer player;
  final List<Audio> audio;
  const AudioMusicPageTest({
    Key? key,
    required this.index,
    required this.player,
    required this.audio,
  }) : super(key: key);

  @override
  State<AudioMusicPageTest> createState() => _AudioMusicPageTestState();
}

class _AudioMusicPageTestState extends State<AudioMusicPageTest> {
  PageController controller = PageController(
    initialPage: 1,
  );

  @override
  void initState() {
    // if (controller.position.jumpTo(value)) {
    //   controller.jumpToPage(1);
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // controller.jumpToPage(1);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print("I Will Rule The World!");
          Provider.of<AssetAudioPlayerProvider>(context, listen: false)
              .playPauseAssetAudioPlayer();
        },
      ),
      body: Center(
        child: Text("I Will Rule The World!"),
      ),
    );
  }
}
