import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  const AppText(
      {super.key, required this.text, this.fontSize, this.fontWeight, this.textColor, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: fontSize ,
        color: textColor ?? Colors.white,
      ),
    );
  }
}
