import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecentSearchContainer extends StatelessWidget {
  final String searchQuery;
  final Function(String) onSearchSelected;

  RecentSearchContainer(
      {required this.searchQuery, required this.onSearchSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(searchQuery),
      onTap: () {
        onSearchSelected(searchQuery);
      },
    );
  }
}
