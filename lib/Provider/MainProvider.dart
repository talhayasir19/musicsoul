import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

class MainProvider extends ChangeNotifier {
  int indexSelected = 0;
  List<bool> isSelected = [true, false, false, false];
  void setSelected(int index) {
    isSelected.setAll(0, [false, false, false, false]);
    isSelected[index] = true;
    indexSelected = index;
    notifyListeners();
  }
}
