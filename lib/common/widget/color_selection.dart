import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import '../theme/text_styles.dart';

class ColorSelection extends StatelessWidget {
  final int id;
  final Color color;
  final int selectedColor;

  ColorSelection(
      {required this.id, required this.color, required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    bool isSelected = id == selectedColor;
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Container(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ).allp(5),
      ),
    );
  }
}
