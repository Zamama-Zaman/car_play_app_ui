import 'dart:convert';

class FavouriteAudioSongs {
  final String name;
  final String uri;
  final String title;
  final String data;
  final String id;

  FavouriteAudioSongs({
    required this.name,
    required this.uri,
    required this.title,
    required this.data,
    required this.id,
  });

  FavouriteAudioSongs.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        uri = json['uri'],
        title = json['title'],
        data = json['data'],
        id = json['id'];

  static Map<String, dynamic> toMap(FavouriteAudioSongs songs) => {
        'name': songs.name,
        'uri': songs.uri,
        'title': songs.title,
        'data': songs.data,
        'id': songs.id,
      };

  static String encode(List<FavouriteAudioSongs> songs) => json.encode(
        songs
            .map<Map<String, dynamic>>(
                (songs) => FavouriteAudioSongs.toMap(songs))
            .toList(),
      );

  static List<FavouriteAudioSongs> decode(String songs) => (json.decode(songs)
          as List<dynamic>)
      .map<FavouriteAudioSongs>((item) => FavouriteAudioSongs.fromJson(item))
      .toList();
}
