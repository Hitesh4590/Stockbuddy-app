import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';

import '../theme/text_styles.dart';

class GridviewTileWidget extends StatelessWidget {
  final String iconPath;
  final String value;
  final String labelText;
  final Color color1;
  final Color color2;
  final Color borderColor;

  GridviewTileWidget(
      {required this.iconPath,
      required this.value,
      required this.labelText,
      required this.color1,
      required this.color2,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          color1,
          color2,
        ]),
        border: Border.all(width: 2, color: borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Image.asset(iconPath).allp(5),
              ),
              10.hs,
              Text(
                'INR ',
                style: TextStyles.bold(color: Colors.black, fontSize: 20),
              ),
              5.hs,
              Text(
                value,
                style: TextStyles.bold(color: Colors.black, fontSize: 20),
              ),
            ],
          ),
          Spacer(),
          Text(
            labelText,
            style: TextStyles.regular(color: Colors.black, fontSize: 10),
          ),
        ],
      ).allp(5),
    );
  }
}
