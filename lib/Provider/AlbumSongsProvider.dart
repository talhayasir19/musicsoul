import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../Screens/Home Screen/home.dart';

class AlbumSongsProvider extends ChangeNotifier {
  List<SongModel> listAlbumSongs = [];
  bool isLoad = false;
  AlbumSongsProvider(String album) {
    print(listSongs.length);
    for (int i = 0; i < listSongs.length; i++) {
      if (listSongs[i].album == album) {
        print("helo");
        listAlbumSongs.add(listSongs[i]);
      }
    }
    isLoad = true;
    notifyListeners();
  }
}
