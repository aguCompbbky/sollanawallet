import 'package:flutter/material.dart';

class TextUtilities {

  //Texts
  static const String singUp = "Sign Up";//start page
  static const String logIn = "Log In";//start page
  static const String solidium = "Solidium";//login page
  static const String welcomeBack = "Welcome Back";//login page
  static const String welcome = "Welcome";//register page


  static const mediumTitleSize = 20.0;
  
}

class TitleMediumWigdet extends StatelessWidget {
  const TitleMediumWigdet({
    super.key, required this.text,required this.color,
  });
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text, //text
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: color
      )
      
    );
  }
}




class TitleLargeWigdet extends StatelessWidget {
  const TitleLargeWigdet({
    super.key, required this.text,required this.color,
  });
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text, //text
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        color: color
      )
      
    );
  }
}



class TextSmallWigdet extends StatelessWidget {
  const TextSmallWigdet({
    super.key, required this.text,required this.color,
  });
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text, //text
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: color
      )
      
    );
  }
}


class TextDrawerWigdet extends StatelessWidget {
  const TextDrawerWigdet({
    super.key, required this.text,required this.color,
  });
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text, //text
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontSize: 14,
        color: color
      )
      
    );
  }
}