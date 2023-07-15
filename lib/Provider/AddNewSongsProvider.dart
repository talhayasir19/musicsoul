import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AddNewSongsProvider extends ChangeNotifier {
  int noOfChecked = 0;

  List<bool> listCheckBox = [];
  OnAudioQuery onAudioQuery = OnAudioQuery();
  bool load = false;
  AddNewSongsProvider(int index) {
    getCheckBox(index);
  }
  void increment() {
    noOfChecked++;
  }

  void decrement() {
    noOfChecked--;
  }

  void setChecked(int index) {
    listCheckBox[index] = true;
    notifyListeners();
  }

  void setUnChecked(int index) {
    listCheckBox[index] = false;
    notifyListeners();
  }
  //Function to get songs

  void getCheckBox(int index) async {
    for (int i = 0; i < index; i++) {
      listCheckBox.add(false);
    }
    load = true;
    notifyListeners();
  }
}
