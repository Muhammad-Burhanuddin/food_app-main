import 'package:flutter/material.dart';
import 'app_text.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final Color? borderColor;
  final String? Function(String?)? validator; // Added validator parameter

  const CustomTextFormField({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
    this.width,
    this.height,
    this.borderColor,
    this.validator, // Updated constructor to accept validator
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) // Conditionally include label
          AppText(
            text: label!,
            textColor: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        if (label != null) // Conditionally include SizedBox for spacing
          SizedBox(height: 5),
        SizedBox(
          height: height ?? 55,
          width: width ?? double.infinity,
          child: TextFormField(
            controller: controller, // Pass controller to TextFormField
            cursorColor: Colors.grey,
            validator: validator, // Pass validator to TextFormField
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: borderColor ?? Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: borderColor ?? Colors.red, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: borderColor ?? Colors.red, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: borderColor ?? Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
