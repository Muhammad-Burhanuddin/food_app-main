import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const AppText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.textAlign,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow:
          overflow ?? TextOverflow.clip, // Default to ellipsis if not provided
      style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: fontSize,
        color: textColor ?? Colors.white,
      ),
    );
  }
}
