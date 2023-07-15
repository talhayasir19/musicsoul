// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PLSongModel {
  String name;
  int nosongs;
  PLSongModel({
    required this.name,
    required this.nosongs,
  });

  PLSongModel copyWith({
    String? name,
    int? nosongs,
  }) {
    return PLSongModel(
      name: name ?? this.name,
      nosongs: nosongs ?? this.nosongs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'nosongs': nosongs,
    };
  }

  factory PLSongModel.fromMap(Map<String, dynamic> map) {
    return PLSongModel(
      name: map['name'] as String,
      nosongs: map['nosongs'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PLSongModel.fromJson(String source) =>
      PLSongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PLSongModel(name: $name, nosongs: $nosongs)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PLSongModel &&
        other.name == name &&
        other.nosongs == nosongs;
  }

  @override
  int get hashCode => name.hashCode ^ nosongs.hashCode;
}
