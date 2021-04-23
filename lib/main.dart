//import 'dart:async';
//import 'package:bergedil_lovers/loginscreen.dart';
import 'package:bergedil_lovers/splashscreen.dart';
import 'package:flutter/material.dart';
 
 void main(){
  
    runApp(new MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: SplashScreen());}
}





