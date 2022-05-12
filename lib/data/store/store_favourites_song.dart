import 'package:car_play_app/data/models/favourites_audio_songs_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<FavouriteAudioSongs> favouriteSongList = [];
String favouriteKey = "favourite_key";

Future<List<FavouriteAudioSongs>> getAllFavouritesSong() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? favouriteSong = pref.getString(favouriteKey);

  if (favouriteSong != null) {
    favouriteSongList = FavouriteAudioSongs.decode(favouriteSong);
  } else {
    return favouriteSongList;
  }
  return favouriteSongList;
}

addFavouriteList(
    String name, String uri, String title, String data, String id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  favouriteSongList.add(FavouriteAudioSongs(
    name: name,
    uri: uri,
    title: title,
    data: data,
    id: id,
  ));
  String encodeData = FavouriteAudioSongs.encode(favouriteSongList);
  pref.setString(favouriteKey, encodeData);
}

removeWholeFavouriteList() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.remove(favouriteKey);
  favouriteSongList.clear();
}

Future<bool> removeAFavouritSong(String uri) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  for (int i = 0; i < favouriteSongList.length; i++) {
    if (favouriteSongList[i].uri == uri) {
      favouriteSongList.removeAt(i);
      String encodeData = FavouriteAudioSongs.encode(favouriteSongList);
      pref.setString(favouriteKey, encodeData);
      return true;
    }
  }
  return false;
}

bool isFavourite(String uri) {
  for (int i = 0; i < favouriteSongList.length; i++) {
    if (favouriteSongList[i].uri == uri) {
      return true;
    }
  }
  return false;
}
