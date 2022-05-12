import 'dart:convert';

class FavouritesVideoSongsModel {
  final String file;

  FavouritesVideoSongsModel({
    required this.file,
  });

  FavouritesVideoSongsModel.fromJson(Map<String, dynamic> json)
      : file = json["file"];

  static Map<String, dynamic> toMap(FavouritesVideoSongsModel songs) => {
        'file': songs.file,
      };

  static String encode(List<FavouritesVideoSongsModel> songs) => json.encode(
        songs
            .map<Map<String, dynamic>>(
                (songs) => FavouritesVideoSongsModel.toMap(songs))
            .toList(),
      );

  static List<FavouritesVideoSongsModel> decode(String songs) =>
      (json.decode(songs) as List<dynamic>)
          .map<FavouritesVideoSongsModel>(
              (item) => FavouritesVideoSongsModel.fromJson(item))
          .toList();
}
