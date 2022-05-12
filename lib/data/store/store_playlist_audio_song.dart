import 'package:car_play_app/data/models/playlist_audio_single_song_model.dart';
import 'package:car_play_app/data/models/playlist_audio_songs_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<PlaylistAudioSongModel> playlistAudioSongList = [];
String favouriteVideoKey = "playlist_audio_key";

Future<List<PlaylistAudioSongModel>> getAllPlaylistAudioSong() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? playlistAudioSong = pref.getString(favouriteVideoKey);

  if (playlistAudioSong != null) {
    playlistAudioSongList = PlaylistAudioSongModel.decode(playlistAudioSong);
  } else {
    return playlistAudioSongList;
  }
  return playlistAudioSongList;
}

Future<String> addPlalistAudioList(String _file) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (!await checkFolderExist(_file)) {
    playlistAudioSongList.add(PlaylistAudioSongModel(
      folderName: _file,
      song: [],
    ));
    String encodeData = PlaylistAudioSongModel.encode(playlistAudioSongList);
    pref.setString(favouriteVideoKey, encodeData);
    return "Successfully Created Playlist";
  } else {
    return "Folder Already Exist";
  }
}

Future<String> addSinglSongPlaylistAudioList(
  String folderName,
  String uri,
  String name,
  String title,
  String data,
  String id,
) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  Song song = Song(
    uri: uri,
    name: name,
    title: title,
    data: data,
    id: id,
  );
  int search = await searchPlaylist(folderName);
  int searchSingleSong = await searchSong(folderName, song);

  if (search != -1) {
    if (searchSingleSong == -1) {
      playlistAudioSongList[search].song!.add(song);
      String encodeData = PlaylistAudioSongModel.encode(playlistAudioSongList);
      pref.setString(favouriteVideoKey, encodeData);
      return "Successfully added song in $folderName";
    }
    return "Song Already exist in $folderName";
  }
  return "Could't add in $folderName";
}

// Remove A song from Playlist
removeSingleSongPlaylistAudiolist(String folderName, int index) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  int search = await searchPlaylist(folderName);
  if (search != -1) {
    playlistAudioSongList[search].song!.removeAt(index);
  }
  String encodeData = PlaylistAudioSongModel.encode(playlistAudioSongList);
  pref.setString(favouriteVideoKey, encodeData);
}

removeAPlaylist(String folderName) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  int search = await searchPlaylist(folderName);
  if (search != -1) {
    playlistAudioSongList.removeAt(search);
  }
  String encodeData = PlaylistAudioSongModel.encode(playlistAudioSongList);
  pref.setString(favouriteVideoKey, encodeData);
}

Future<List<Song>?> getAllSongInAFolder(String folderName) async {
  List<Song> allSongListInFolder = [];
  int search = await searchPlaylist(folderName);
  if (search != -1) {
    return playlistAudioSongList[search].song;
  }
  return allSongListInFolder;
}

// Search A Folder
Future<int> searchPlaylist(String folderName) async {
  for (int i = 0; i < playlistAudioSongList.length; i++) {
    if (playlistAudioSongList[i].folderName == folderName) {
      return i;
    }
  }
  return -1;
}

Future<int> searchSong(String folderName, Song song) async {
  int search = await searchPlaylist(folderName);
  if (search != -1) {
    for (int i = 0; i < playlistAudioSongList[search].song!.length; i++) {
      if (playlistAudioSongList[search].song![i].uri == song.uri) {
        return i;
      }
    }
  }
  return -1;
}

Future<bool> checkFolderExist(String folderName) async {
  for (int i = 0; i < playlistAudioSongList.length; i++) {
    if (playlistAudioSongList[i].folderName == folderName) {
      return true;
    }
  }
  return false;
}
