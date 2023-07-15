import 'package:flutter/material.dart';
import 'package:musicsoul/Components/Local%20Database/LocalDb.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:string_validator/string_validator.dart';

class PlayListSongsProvider extends ChangeNotifier {
  String playListName;
  bool isLoad = false;
  Set<SongModel> playListSongList = {};
  Set<SongModel> playListRemainingSongs = {};
  PlayListSongsProvider(this.playListName) {
    getPlaylistSongs();
  }

  void getPlaylistSongs() async {
    LocalDb dB = LocalDb.createInstance();
    //toremove spaces from string as table name donot contains spaces
    String pl = playListName.replaceAll(" ", "");
    List<SongModel> allInAllSongs = await OnAudioQuery().querySongs();
    Set<SongModel> allSongs = {};
    for (SongModel song in allInAllSongs) {
      allSongs.add(song);
    }

    playListSongList.clear();
    playListRemainingSongs.clear();

    List<String> x = await dB.fetchPlaylist(playListName);
    for (int i = 0; i < allSongs.length; i++) {
      SongModel targetSongModel = allSongs.elementAt(i);
      String targetSong = allSongs.elementAt(i).id.toString();
      bool present = false;
      for (int j = 0; j < x.length; j++) {
        String song = x[j];

        if (targetSong == song) {
          present = true;
          playListSongList.add(targetSongModel);
        }
      }
      if (present == false) {
        print(targetSongModel.displayName);
        playListRemainingSongs.add(targetSongModel);
      }
    }
    print("Now showing actual");
    for (SongModel song in playListRemainingSongs) {
      print(song.displayName);
    }

    isLoad = true;
    notifyListeners();
  }
}
