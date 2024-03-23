import 'package:flutter/material.dart';

class DialogProvider with ChangeNotifier {
  int submitted = 0;
  void submit(int num){
    submitted = num;
    notifyListeners();
  }
  void reset(){
    submitted = 0;
  }
}