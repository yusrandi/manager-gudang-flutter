import 'package:flutter/material.dart';

//* Constant Color
Color primaryColor = Color(0xffFF8554);
Color redColor = Color(0xffad3100);
Color blueColor = Color(0xff0036ff);
Color purpleColor = Color(0xff452590);

//* Device size
double deviceWith(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}