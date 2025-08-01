import 'package:flutter/material.dart';

class PaddingUtilities {

  static const double _padding = 24.0;

  static const EdgeInsets paddingRight = EdgeInsets.only(right: _padding);
  static const EdgeInsets paddingRightLeft = EdgeInsets.symmetric(horizontal: _padding);
  static const EdgeInsets paddingLeft = EdgeInsets.only(left: _padding);
  static const EdgeInsets paddingTop = EdgeInsets.only(top: _padding*2);
  static const EdgeInsets paddingTopBottom = EdgeInsets.symmetric(vertical: _padding);
  static const EdgeInsets paddingAll20 =  EdgeInsets.all(20.0);
}