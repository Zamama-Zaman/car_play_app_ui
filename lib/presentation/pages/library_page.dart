// ignore_for_file: prefer_const_constructors

import 'package:car_play_app/presentation/pages/library_detail_list_page.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Car Player"),
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: ListView.builder(
        itemCount: libraryList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LibraryDetailListPage(),
              ),
            );
          },
          child: Card(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Center(
                child: ListTile(
                  leading: Text(
                    libraryList[index],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.navigate_next,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<String> libraryList = [
  "Songs",
  "Artists",
  "Albums",
  "Genres",
];
