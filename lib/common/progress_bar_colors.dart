

import 'package:flutter/material.dart';

class ProgressBarColors {
  static Color getColorByValue(double value) {
    if(value < 0.33)
      return Colors.red;
    else if(value >= 0.33 && value < 0.66) 
      return Colors.orange;
    else if(value >= 0.66 && value < 0.99) 
      return Colors.orangeAccent;
    else 
      return Colors.green;
  }
}