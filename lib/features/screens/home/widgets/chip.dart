import 'package:flutter/material.dart';

Widget buildChip({
  required String label,
  required Color bgColor,
  required Color textColor,
  String? imageUrl,
  Color? borderColor,
  bool isCircleImage = true,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          if (imageUrl != null) ...[
            isCircleImage
                ? ClipOval(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.public, size: 28, color: textColor);
                        },
                      ),
                    ),
                  )
                : SizedBox(
                    width: 32,
                    height: 32,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.category, size: 24, color: textColor);
                      },
                    ),
                  ),
            const SizedBox(width: 10),
          ],
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}