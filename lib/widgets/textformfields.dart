import 'package:flutter/material.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';

class AppTextFromField extends StatelessWidget {
  final FlatButton suffixIcon;
  final FlatButton prefixicon;
  final int maxlines;
  final int minlines;
  final Color iconColor;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged onFieldSubmitted;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final bool autofocus;
  final TextInputAction inputAction;

  const AppTextFromField({
    Key key,
    this.suffixIcon,
    this.prefixicon,
    this.iconColor = Colors.grey,
    this.hintText,
    this.minlines,
    this.maxlines,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.focusNode,
    this.onFieldSubmitted,
    this.validator,
    this.onSaved,
    this.autofocus = false,
    this.inputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxlines,
      minLines: minlines,
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      autofocus: autofocus,
      textInputAction: inputAction,
      obscureText: this.obscureText,
      style: TextStyle(color: Colors.black, fontSize: 20),
      keyboardType: this.keyboardType,
      decoration: InputDecoration(
        hasFloatingPlaceholder: true,
        fillColor: Colors.grey.shade100,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: new BorderSide(color: Colors.white),
          borderRadius: new BorderRadius.circular(40),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(30)),
        hintText: this.hintText,
        labelText: this.labelText,
        suffixIcon: this.suffixIcon,
        prefixIcon: this.prefixicon,
        labelStyle: TextStyle(
          color: AppColor.textscolorgrey,
        ),
        hintStyle: TextStyle(
          color: AppColor.textscolorgrey,
        ),
      ),
    );
  }
}
