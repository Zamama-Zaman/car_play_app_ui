import 'dart:convert';

class PlaylistVideoSingleSongModel {
  String? file;

  PlaylistVideoSingleSongModel({
    required this.file,
  });

  factory PlaylistVideoSingleSongModel.fromJson(String str) =>
      PlaylistVideoSingleSongModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMaps());

  factory PlaylistVideoSingleSongModel.fromMap(Map<String, dynamic> json) =>
      PlaylistVideoSingleSongModel(
        file: json["file"],
      );

  Map<String, dynamic> toMaps() => {
        "file": file,
      };

  static Map<String, dynamic> toMap(PlaylistVideoSingleSongModel songs) => {
        'file': songs.file,
      };

  static String encode(List<PlaylistVideoSingleSongModel> songs) => json.encode(
        songs
            .map<Map<String, dynamic>>(
                (songs) => PlaylistVideoSingleSongModel.toMap(songs))
            .toList(),
      );

  static List<PlaylistVideoSingleSongModel> decode(String songs) =>
      (json.decode(songs) as List<dynamic>)
          .map<PlaylistVideoSingleSongModel>(
              (item) => PlaylistVideoSingleSongModel.fromJson(item))
          .toList();
}
