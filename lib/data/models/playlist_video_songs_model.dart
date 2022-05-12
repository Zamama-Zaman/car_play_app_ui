import 'dart:convert';

import 'package:car_play_app/data/models/playlist_video_single_song_model.dart';

class PlaylistVideoSongsModel {
  PlaylistVideoSongsModel({
    required this.folderName,
    required this.singleVideoSong,
  });

  String? folderName;
  List<PlaylistVideoSingleSongModel>? singleVideoSong;

  factory PlaylistVideoSongsModel.fromJson(String str) =>
      PlaylistVideoSongsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMaps());

  factory PlaylistVideoSongsModel.fromMap(Map<String, dynamic> json) =>
      PlaylistVideoSongsModel(
        folderName: json["folderName"],
        singleVideoSong: json["singleVideoSong"] == null
            ? null
            : List<PlaylistVideoSingleSongModel>.from(json["singleVideoSong"]
                .map((x) => PlaylistVideoSingleSongModel.fromMap(x))),
      );

  Map<String, dynamic> toMaps() => {
        "folderName": folderName,
        "singleVideoSong": singleVideoSong == null
            ? null
            : List<dynamic>.from(singleVideoSong!.map((x) => x.toMaps())),
      };

  static Map<String, dynamic> toMap(PlaylistVideoSongsModel songs) => {
        'folderName': songs.folderName,
        'singleVideoSong': songs.singleVideoSong == null
            ? null
            : List<dynamic>.from(songs.singleVideoSong!.map((x) => x.toMaps())),
      };

  static String encode(List<PlaylistVideoSongsModel> songs) => json.encode(
        songs
            .map<Map<String, dynamic>>(
                (songs) => PlaylistVideoSongsModel.toMap(songs))
            .toList(),
      );

  static List<PlaylistVideoSongsModel> decode(String songs) =>
      (json.decode(songs) as List<dynamic>)
          .map<PlaylistVideoSongsModel>(
              (item) => PlaylistVideoSongsModel.fromMap(item))
          .toList();
}
