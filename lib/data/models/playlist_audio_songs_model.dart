import 'dart:convert';

import 'package:car_play_app/data/models/playlist_audio_single_song_model.dart';

class PlaylistAudioSongModel {
  PlaylistAudioSongModel({
    required this.folderName,
    required this.song,
  });

  String? folderName;
  List<Song>? song;

  factory PlaylistAudioSongModel.fromJson(String str) =>
      PlaylistAudioSongModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMaps());

  factory PlaylistAudioSongModel.fromMap(Map<String, dynamic> json) =>
      PlaylistAudioSongModel(
        folderName: json["folderName"],
        song: json["song"] == null
            ? null
            : List<Song>.from(json["song"].map((x) => Song.fromMap(x))),
      );

  Map<String, dynamic> toMaps() => {
        "folderName": folderName,
        "song": song == null
            ? null
            : List<dynamic>.from(song!.map((x) => x.toMaps())),
      };

  static Map<String, dynamic> toMap(PlaylistAudioSongModel songs) => {
        'folderName': songs.folderName,
        'song': songs.song == null
            ? null
            : List<dynamic>.from(songs.song!.map((x) => x.toMaps())),
      };

  static String encode(List<PlaylistAudioSongModel> songs) => json.encode(
        songs
            .map<Map<String, dynamic>>(
                (songs) => PlaylistAudioSongModel.toMap(songs))
            .toList(),
      );

  static List<PlaylistAudioSongModel> decode(String songs) =>
      (json.decode(songs) as List<dynamic>)
          .map<PlaylistAudioSongModel>(
              (item) => PlaylistAudioSongModel.fromMap(item))
          .toList();
}
