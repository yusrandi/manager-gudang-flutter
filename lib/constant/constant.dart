import 'package:flutter/material.dart';

//* Constant Color
Color primaryColor = Color(0xffFF8554);
Color redColor = Color(0xffad3100);
Color blueColor = Color(0xff0036ff);
Color purpleColor = Color(0xff452590);

Color unSelectedTabBackgroundColor = Color(0xFFFFFFFC);
Color subTitleTextColor = Color(0xFF9F988F);
Color hintTextColor = Color(0xFFB9B9B9);
const Color kHintTextColor = Color(0xFFBB9B9B9);

//* Device size
double deviceWith(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

InputDecoration buildInputDecoration(IconData icons, String hinttext) {
  return InputDecoration(
      hintText: hinttext,
      prefixIcon: Icon(icons),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.green, width: 1),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: redColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: hintTextColor,
          width: 1,
        ),
      ),
      labelText: hinttext,
      labelStyle: const TextStyle(color: Colors.black));
}
