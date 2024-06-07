import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/text_styles.dart';

import '../theme/color_constants.dart';

class BorderButton extends StatelessWidget {
  final Widget? suffixImage;
  final String title;
  final VoidCallback? onTap;
  final Decoration? decoration;
  final double spacingHorizontal;
  final double spacingVertical;
  final bool isDisabled;
  final double height;

  const BorderButton({
    super.key,
    required this.onTap,
    this.suffixImage,
    required this.title,
    this.spacingVertical = 9,
    this.spacingHorizontal = 19,
    this.decoration,
    this.isDisabled = false,
    this.height = 36,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(
              horizontal: spacingHorizontal, vertical: spacingVertical),
          decoration: decoration ??
              BoxDecoration(
                  color: ColorConstants.darkGrey,
                  border: Border.all(
                      color: disabledStateColor(isDisabled: isDisabled)),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 2,
                        offset: const Offset(0, 2)),
                  ]),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              suffixImage ?? const SizedBox.shrink(),
              suffixImage != null ? 0.hs : 0.hs,
              Text(
                title,
                style: TextStyles.medium(),
              ),
            ],
          ),
        ));
  }

  Color disabledStateColor({required bool isDisabled}) {
    return isDisabled ? ColorConstants.lightGrey : Colors.white;
  }
}
