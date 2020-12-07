import 'package:flutter/material.dart';

class Flatbutton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor, textcolor;
  final VoidCallback onPressed;
  final double size;

  const Flatbutton(
      {Key key,
      this.buttonText,
      this.textcolor,
      this.buttonColor,
      this.onPressed,
      this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: buttonColor,
      onPressed: () {},
      child: Text(buttonText,
          style: TextStyle(
            color: textcolor,
            fontSize: size,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
