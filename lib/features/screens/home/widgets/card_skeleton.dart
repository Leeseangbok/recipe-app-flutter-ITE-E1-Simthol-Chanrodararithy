import 'package:flutter/material.dart';

Widget buildSkeletonCard({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: Icon(Icons.image, color: Colors.white)),
    );
  }