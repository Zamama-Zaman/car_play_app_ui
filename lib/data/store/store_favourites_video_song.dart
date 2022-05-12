import 'dart:io';

import 'package:car_play_app/data/models/favourites_video_songs_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<FavouritesVideoSongsModel> favouriteVideoSongList = [];
String favouriteVideoKey = "favourite_video_key";

Future<List<FavouritesVideoSongsModel>> getAllFavouritesVideoSong() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? favouriteVideoSong = pref.getString(favouriteVideoKey);

  if (favouriteVideoSong != null) {
    favouriteVideoSongList =
        FavouritesVideoSongsModel.decode(favouriteVideoSong);
  } else {
    return favouriteVideoSongList;
  }
  return favouriteVideoSongList;
}

addFavouriteVideoList(String _file) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  favouriteVideoSongList.add(FavouritesVideoSongsModel(
    file: _file,
  ));
  String encodeData = FavouritesVideoSongsModel.encode(favouriteVideoSongList);
  pref.setString(favouriteVideoKey, encodeData);
}

removeWholeFavouriteVideoList() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.remove(favouriteVideoKey);
  favouriteVideoSongList.clear();
}

Future<bool> removeAFavouritVideoSong(String file) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  for (int i = 0; i < favouriteVideoSongList.length; i++) {
    if (favouriteVideoSongList[i].file == file) {
      favouriteVideoSongList.removeAt(i);
      String encodeData =
          FavouritesVideoSongsModel.encode(favouriteVideoSongList);
      pref.setString(favouriteVideoKey, encodeData);
      return true;
    }
  }
  return false;
}

bool isFavouriteVideo(String file) {
  for (int i = 0; i < favouriteVideoSongList.length; i++) {
    if (favouriteVideoSongList[i].file == file) {
      return true;
    }
  }
  return false;
}
