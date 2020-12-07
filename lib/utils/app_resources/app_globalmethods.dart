import 'package:flutter/material.dart';

class AppMethods {
  AppMethods._();

  static fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static String validatePhone(String value) {
    if (value.isEmpty) {
      return ' Please enter your Mobile Number';
    }

    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return ' Please enter a valid  Mobile number';
    else
      return null;
  }

  static String validatecode(String value) {
    if (value.isEmpty) {
      return 'empty code!';
    }

    if (value.length < 3 ||
        value.length > 3 ||
        !value.contains('+') ||
        value.contains(" ") ||
        value.contains(".") ||
        value.contains("#") ||
        value.contains(",") ||
        value.contains("*") ||
        value.contains("(") ||
        value.contains(")") ||
        value.contains("/") ||
        value.contains("-") ||
        value.contains(";") ||
        value.contains("N")) {
      return 'Invalid Code!';
    }
  }

  static String validatePassword(String value) {
    if (value.isEmpty) {
      return ' Please enter Password';
    }

    if (value.length < 6)
      return 'Please enter a password of length greater than 5';
    else
      return null;
  }

  static String validateemail(String value) {
    if (value.isEmpty) {
      return ' Please enter your Email Address';
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a valid email address';
    else
      return null;
  }

  static String validatename(String value) {
    if (value.isEmpty) {
      return ' Please enter your name';
    }
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid username';
    else
      return null;
  }

  static String validatetext(String value) {
    if (value.isEmpty) {
      return ' Please enter something..';
    }
  }

  static String validatedateofbirth(String value) {
    if (value.isEmpty) {
      return 'Please enter ';
    }
  }

  static String validateAddress(String value) {
    if (value.isEmpty) {
      return 'Please enter Address!';
    }
    if (value.length < 3) {
      return 'Address must contains atleast 3 characters!';
    }
  }
}
