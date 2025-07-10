import 'package:flutter/material.dart';

class ColorUtilities {
  static Color buttonBackgroundColor = Colors.white;


  static Color reverseColor(Color color) {
  if (color == Colors.black) {
    return Colors.white;
  } 
  else if(color == Colors.white){
    return Colors.black;
  }
  else {
    return color;
  }

  
}
static Color selectColor(Color color){
  return color;
}


  static Color buttonTextColor(){
    return reverseColor(buttonBackgroundColor);
  }
  
}