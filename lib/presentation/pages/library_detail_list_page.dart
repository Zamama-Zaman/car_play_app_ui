// ignore_for_file: prefer_const_constructors

import 'package:car_play_app/presentation/pages/audio_music_page.dart';
import 'package:car_play_app/presentation/pages/song_page.dart';
import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';

class LibraryDetailListPage extends StatelessWidget {
  const LibraryDetailListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AsyncSnapshot<List<SongModel>> item;
    return Scaffold(
        appBar: AppBar(
          title: Image(
            image: AssetImage(
                "assets/images/app_title_image-removebg-preview.png"),
            width: 200,
            height: 200,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SongPage()
        // ListView.builder(
        //   itemBuilder: (context, index) => GestureDetector(
        //     onTap: () {
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(
        //       //     builder: (context) => AudioMusicPage(
        //       //       player: AudioPlayer(),
        //       //       item:item,
        //       //     ),
        //       //   ),
        //       // );
        //     },
        //     child: Card(
        //       child: SizedBox(
        //         height: MediaQuery.of(context).size.height / 6,
        //         child: Center(
        //           child: ListTile(
        //             leading: Container(
        //               height: 50,
        //               width: 50,
        //               color: Colors.amber,
        //             ),
        //             title: Text("Song name here"),
        //             subtitle: Text("author name"),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        );
  }
}
