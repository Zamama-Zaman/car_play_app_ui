import 'dart:convert';

class Song {
  Song({
    required this.uri,
    required this.name,
    required this.title,
    required this.data,
    required this.id,
  });

  String? uri;
  String? name;
  String? title;
  String? data;
  String? id;

  factory Song.fromJson(String str) => Song.fromMap(json.decode(str));

  String toJson() => json.encode(toMaps());

  factory Song.fromMap(Map<String, dynamic> json) => Song(
        uri: json["uri"],
        name: json["name"],
        title: json["title"],
        data: json["data"],
        id: json["id"],
      );

  Map<String, dynamic> toMaps() => {
        "uri": uri,
        "name": name,
        "title": title,
        "data": data,
        "id": id,
      };

  static Map<String, dynamic> toMap(Song songs) => {
        'uri': songs.uri,
        "name": songs.name,
        "title": songs.title,
        "data": songs.data,
        "id": songs.id,
      };

  static String encode(List<Song> songs) => json.encode(
        songs.map<Map<String, dynamic>>((songs) => Song.toMap(songs)).toList(),
      );

  static List<Song> decode(String songs) =>
      (json.decode(songs) as List<dynamic>)
          .map<Song>((item) => Song.fromJson(item))
          .toList();
}
