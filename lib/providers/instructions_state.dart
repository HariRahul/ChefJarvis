// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class InstructionState with ChangeNotifier {
  int _step = 0;
  int _maxSteps = 0;

  getStep() => _step;
  setStep(int steps) => _step = steps;
  setmaxSteps(int steps) => _maxSteps = steps;

  void incrementStep() {
    if (_step < _maxSteps) {
      _step++;
      notifyListeners();
    }
  }

  void decrementStep() {
    if (_step > 0) {
      _step--;
      notifyListeners();
    }
  }
}
