import 'package:flutter/material.dart';

import '../Components/Local Database/LocalDb.dart';
import '../Components/Local Database/PLSongModel.dart';

class PlaylistProvider extends ChangeNotifier {
  bool isLoad = false;
  List<PLSongModel> listPlaylist = [];
  PlaylistProvider() {
    getlist();
  }
  Future<void> getlist() async {
    LocalDb db = LocalDb.createInstance();
    listPlaylist = await db.getData();

    isLoad = true;
    notifyListeners();
  }

  Future<void> addPlaylist() async {
    LocalDb db = LocalDb.createInstance();
    listPlaylist = await db.getData();

    notifyListeners();
  }
}
