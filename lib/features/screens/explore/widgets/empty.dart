import 'package:flutter/material.dart';

Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text("No meals found", style: TextStyle(color: Colors.grey, fontSize: 18)),
          const Text("Try changing your filters", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }