import 'package:flutter/material.dart';

Widget buildMiniChip(String label, Color bg, Color text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: text,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}