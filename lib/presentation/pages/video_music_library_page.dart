// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:car_play_app/presentation/pages/video_player_page.dart';
import 'package:flutter/material.dart';

class VideoLibraryPage extends StatefulWidget {
  final List<File> videoFile;
  const VideoLibraryPage({Key? key, required this.videoFile}) : super(key: key);

  @override
  State<VideoLibraryPage> createState() => _VideoLibraryPageState();
}

class _VideoLibraryPageState extends State<VideoLibraryPage> {
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
      body: VideoPlayerPage(
        videoFile: widget.videoFile,
      ),
    );
  }
}
