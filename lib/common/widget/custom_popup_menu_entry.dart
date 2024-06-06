import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';

import '../theme/color_constants.dart';
import '../theme/text_styles.dart';

class CustomPopupMenuEntry extends StatelessWidget {
  final String title;
  final String? iconName;
  final IconData? assetIcon;
  final bool isSelected;

  const CustomPopupMenuEntry({
    super.key,
    required this.title,
    this.iconName,
    this.isSelected = false,
    this.assetIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          /*borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConstans.lightGrey, width: 1),*/
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          assetIcon == null
              ? SvgPicture.asset(iconName!,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : Colors.white,
                    BlendMode.srcIn,
                  ))
              : Icon(assetIcon),
          10.hs,
          Text(title,
              style: TextStyles.medium().copyWith(
                color: isSelected ? Colors.black : ColorConstants.lightGrey,
              )),
        ],
      ),
    );
  }
}
