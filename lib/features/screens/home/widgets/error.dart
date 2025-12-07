import 'package:flutter/material.dart';

Widget buildErrorWidget(Object error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(15)),
      child: Row(children: [
        const Icon(Icons.error, color: Colors.red),
        const SizedBox(width: 10),
        Expanded(child: Text('Error loading data', style: TextStyle(color: Colors.red[800])))
      ]),
    );
  }