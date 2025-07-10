import 'package:flutter/material.dart';
import 'package:walletsolana/utilities/color_utilities.dart';
import 'package:walletsolana/utilities/text_utilities.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key, required this.buttonBackgroundColor, required this.text, required this.onpressed});
  final Color buttonBackgroundColor;
  final String text;
  final void Function()? onpressed;

  @override
  Widget build(BuildContext context) {
    return 
      Card( 
      shape: StadiumBorder(side: BorderSide(width: 2, color: Colors.black)),
      
    
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonBackgroundColor,
          ),
          onPressed: onpressed,
          child: TitleMediumWigdet(text:text,
          color: ColorUtilities.reverseColor(buttonBackgroundColor)),
        ),
      
    );
  }
}