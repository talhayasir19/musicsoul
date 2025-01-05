import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class AlbumProvider extends ChangeNotifier {
  late List<AlbumModel> listAlbums;
  bool isLoad = false;
  AlbumProvider() {
    getAlbums();
  }
  void getAlbums() async {
    PermissionStatus status = await Permission.audio.request();
    if (status.isPermanentlyDenied) {
      await Permission.audio.request();
    }
    if (status.isGranted) {
      listAlbums = await OnAudioQuery().queryAlbums();
    }
    isLoad = true;
    notifyListeners();
  }
}
