// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:car_play_app/data/ads/ad_helper.dart';
import 'package:car_play_app/data/store/store_favourites_song.dart';
import 'package:car_play_app/data/store/store_favourites_video_song.dart';
import 'package:car_play_app/presentation/pages/albums_page.dart';
import 'package:car_play_app/presentation/pages/artist_page.dart';
import 'package:car_play_app/presentation/pages/audio_music_page.dart';
import 'package:car_play_app/presentation/pages/favorite_page.dart';
import 'package:car_play_app/presentation/pages/genres_page.dart';
import 'package:car_play_app/presentation/pages/library_page.dart';
import 'package:car_play_app/presentation/pages/song_page.dart';
import 'package:car_play_app/presentation/pages/play_list_page.dart';
import 'package:car_play_app/presentation/pages/setting_page.dart';
import 'package:car_play_app/presentation/pages/video_player_page.dart';
import 'package:car_play_app/presentation/state_management/show_search_bar_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/src/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int _selectedIndex = 0;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool permissionStatus = false;
  bool permissionGranted = false;

//Files for Videos
  List<File> files = [];
  List<File> files2 = [];

  List<Widget> list = [
    Tab(text: "SONGS"),
    Tab(text: "PLAYLIST"),
    Tab(text: "FAVORITE"),
    Tab(text: "ALBUMS"),
    Tab(text: "ARTISTS"),
    Tab(text: "GENRES"),
    Tab(text: "VIDEOS"),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      // print("Selected Index: " + _controller.index.toString());
    });

    getAllFavouritesSong();
    getAllFavouritesVideoSong();
    // requestStoragePermission();
    _getStoragePermission();
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
        getAllVideos();
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }

// Get All the Videos from mobile
  void getAllVideos() async {
    print(getTemporaryDirectory());
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0].rootDir;
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(
      excludedPaths: ["/storage/emulated/0/Android/"],
      extensions: ["mp4"],
    );

    var root2 = storageInfo[1].rootDir;
    var fm2 = FileManager(root: Directory(root2)); //
    files2 = await fm2.filesTree(excludedPaths: [
      // "/storage/180C-3B03/Android/data"
      "/storage/emulated/0/Android"
    ], extensions: [
      "mp4",
    ]);
    // Adding internal Storage and SD card Storage Video Song File
    files.addAll(files2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !context.watch<ShowSearchBarProvider>().isShow
          ? AppBar(
              leading: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  context.read<ShowSearchBarProvider>().showSearchBar(true);
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
              bottom: TabBar(
                onTap: (index) {
                  // Should not used it as it only called when tab options are clicked,
                  // not when user swapped
                },
                controller: _controller,
                tabs: list,
              ),
              title: Image(
                image: AssetImage(
                    "assets/images/app_title_image-removebg-preview.png"),
                width: 200,
                height: 200,
              ),
              centerTitle: true,
            )
          : null,
      body: !permissionGranted
          ? Center(
              child: CircularProgressIndicator(),
            )
          // : Center(
          //     child: Text(permissionGranted.toString()),
          //   )
          : TabBarView(
              controller: _controller,
              children: [
                SongPage(),
                PlaylistPage(),
                FavoritePage(),
                AlbumsPage(),
                ArtistPage(),
                GenresPage(),
                VideoPlayerPage(videoFile: files),
              ],
            ),
    );
  }
}
