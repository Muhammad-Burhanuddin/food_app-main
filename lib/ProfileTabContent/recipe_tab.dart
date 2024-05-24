import 'package:flutter/material.dart';

import '../CommenWidget/saved_container.dart';

class RecipeTab extends StatefulWidget {
  const RecipeTab({super.key});

  @override
  State<RecipeTab> createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 7,
        itemBuilder: (index, context) {
          return SavedContainer();
        });
  }
}
