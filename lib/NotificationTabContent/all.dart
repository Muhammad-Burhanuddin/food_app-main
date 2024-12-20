import 'package:flutter/material.dart';
import 'package:recipe_food/CommenWidget/notificationContainer.dart';

import '../CommenWidget/app_text.dart';

class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          AppText(
            text: 'Today',
            fontSize: 11,
            textColor: Colors.black,
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 0,
              itemBuilder: (index, context) {
                return NotificationContainer();
              }),
        ],
      ),
    );
  }
}
