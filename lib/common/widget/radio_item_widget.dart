import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';

import '../theme/color_constants.dart';
import '../theme/text_styles.dart';

class RadioItemWidget extends StatelessWidget {
  final int id;
  final String text;
  final int selectedValue;

  RadioItemWidget(
      {required this.id, required this.text, required this.selectedValue});

  @override
  Widget build(BuildContext context) {
    bool isSelected = id == selectedValue;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: isSelected ? Color(0xffFF9501) : ColorConstants.lightGrey,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: Colors.black)
                : Border.all(color: Colors.transparent),
          ),
        ),
        4.hs,
        Text(
          text,
          style: isSelected
              ? TextStyles.bold(color: Colors.black, fontSize: 10)
              : TextStyles.regular(fontSize: 10),
        ),
      ],
    );
  }
}
