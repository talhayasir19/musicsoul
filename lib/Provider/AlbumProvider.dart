import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumProvider extends ChangeNotifier {
  late List<AlbumModel> listAlbums;
  bool isLoad = false;
  AlbumProvider() {
    getAlbums();
  }
  void getAlbums() async {
    listAlbums = await OnAudioQuery().queryAlbums();
    isLoad = true;
    notifyListeners();
  }
}
