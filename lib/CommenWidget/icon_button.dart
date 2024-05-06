import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconButtons extends StatelessWidget {
  final String icon;

  const IconButtons({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      // color: Colors.red,
      width: size.width * 0.18,
      height: size.height * 0.07,
      child: Card(
        color: Colors.white,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: SvgPicture.asset(
            icon,
            width: size.width * 0.04,
            height: size.width * 0.04,
          ),
        ),
      ),
    );
  }
}
