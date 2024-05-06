
import 'package:flutter/material.dart';
import '../Helpers/colors.dart';
import 'app_text.dart';


class CustomButton extends StatelessWidget {
  final double? height, width, borderRadius, fontSize;
  final Color? backgroundColor, textColor,borderColor;
  final String? label;
  final FontWeight? fontWeight;
  final void Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final IconData? icon;
  final double? iconSize,spacing,borderWidth;
  final Color? iconColor;


  const CustomButton(
      {super.key,
        this.height,
        this.width,
        this.borderRadius,
        this.backgroundColor,
        this.label,
        this.fontSize,
        this.fontWeight,
        this.textColor,
        this.onTap, this.borderColor, this.margin, this.icon, this.iconSize, this.iconColor, this.spacing, this.borderWidth,
      });

  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        height: height ?? Size.height * .055,
        width: width ?? Size.width * 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          color: backgroundColor ?? AppColors.primaryColor,
          border: Border.all(color: borderColor?? Colors.transparent,width: borderWidth??2),
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                text: label ?? "",
                textColor: textColor ??  Colors.white,
                fontWeight: fontWeight ?? FontWeight.w600,
                fontSize: fontSize ?? 16,
              ),
              if (icon != null) // Conditionally include the icon
                SizedBox(width: spacing??20),
              Visibility(
                visible: icon != null, // Show the icon only if it's provided
                child: Icon(
                  icon,
                  color: iconColor??Colors.white,
                  size: iconSize ?? 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
