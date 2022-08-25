import 'package:flutter/material.dart';

class ColorItem extends StatelessWidget {
  const ColorItem({
    Key? key,
    required this.isColorSelected,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  final bool isColorSelected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(right: 12),
        // color: Colors.red,
        child: Stack(
          children: [
            Container(
              // margin: const EdgeInsets.only(right: 12),
              height: 36,
              width: 36,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Visibility(
                visible: isColorSelected,
                child: const Center(
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
