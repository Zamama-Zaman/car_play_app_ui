import 'package:car_play_app/data/models/playlist_video_single_song_model.dart';
import 'package:car_play_app/data/models/playlist_video_songs_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<PlaylistVideoSongsModel> playlistVideoSongList = [];
String playlistVideoSongKey = "playlist_video_key";

Future<List<PlaylistVideoSongsModel>> getAllPlaylistVideoSong() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? playlistAudioSong = pref.getString(playlistVideoSongKey);

  if (playlistAudioSong != null) {
    playlistVideoSongList = PlaylistVideoSongsModel.decode(playlistAudioSong);
  } else {
    return playlistVideoSongList;
  }
  return playlistVideoSongList;
}

Future<String> addPlalistVideoList(String _file) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (!await checkVideoFolderExist(_file)) {
    playlistVideoSongList.add(PlaylistVideoSongsModel(
      folderName: _file,
      singleVideoSong: [],
    ));
    String encodeData = PlaylistVideoSongsModel.encode(playlistVideoSongList);
    pref.setString(playlistVideoSongKey, encodeData);
    return "Successfully Created Playlist";
  } else {
    return "Folder Already Exist";
  }
}

Future<String> addSinglSongPlaylistVideoList(
  String folderName,
  String file,
) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  PlaylistVideoSingleSongModel song = PlaylistVideoSingleSongModel(
    file: file,
  );
  int search = await searchVideoPlaylist(folderName);
  int searchSingleSong = await searchVideoSong(folderName, song);

  if (search != -1) {
    if (searchSingleSong == -1) {
      playlistVideoSongList[search].singleVideoSong!.add(song);
      String encodeData = PlaylistVideoSongsModel.encode(playlistVideoSongList);
      pref.setString(playlistVideoSongKey, encodeData);
      return "Successfully added current song in $folderName";
    }
    return "Current song already exist in $folderName";
  }
  return "Could't add in $folderName";
}

// Remove A song from Playlist
removeSingleSongPlaylistVideolist(String folderName, int index) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  int search = await searchVideoPlaylist(folderName);
  if (search != -1) {
    playlistVideoSongList[search].singleVideoSong!.removeAt(index);
  }
  String encodeData = PlaylistVideoSongsModel.encode(playlistVideoSongList);
  pref.setString(playlistVideoSongKey, encodeData);
}

removeAVideoPlaylist(String folderName) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  int search = await searchVideoPlaylist(folderName);
  if (search != -1) {
    playlistVideoSongList.removeAt(search);
  }
  String encodeData = PlaylistVideoSongsModel.encode(playlistVideoSongList);
  pref.setString(playlistVideoSongKey, encodeData);
}

Future<List<PlaylistVideoSingleSongModel>?> getAllVideoSongInAFolder(
    String folderName) async {
  List<PlaylistVideoSingleSongModel> allSongListInFolder = [];
  int search = await searchVideoPlaylist(folderName);
  if (search != -1) {
    return playlistVideoSongList[search].singleVideoSong;
  }
  return allSongListInFolder;
}

// Search A Folder
Future<int> searchVideoPlaylist(String folderName) async {
  for (int i = 0; i < playlistVideoSongList.length; i++) {
    if (playlistVideoSongList[i].folderName == folderName) {
      return i;
    }
  }
  return -1;
}

Future<int> searchVideoSong(
    String folderName, PlaylistVideoSingleSongModel song) async {
  int search = await searchVideoPlaylist(folderName);
  if (search != -1 && playlistVideoSongList[search].singleVideoSong != null) {
    for (int i = 0;
        i < playlistVideoSongList[search].singleVideoSong!.length;
        i++) {
      if (playlistVideoSongList[search].singleVideoSong![i].file == song.file) {
        return i;
      }
    }
  }
  return -1;
}

Future<bool> checkVideoFolderExist(String folderName) async {
  for (int i = 0; i < playlistVideoSongList.length; i++) {
    if (playlistVideoSongList[i].folderName == folderName) {
      return true;
    }
  }
  return false;
}
