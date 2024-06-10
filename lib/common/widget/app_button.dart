import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/theme/text_styles.dart';
import 'package:stockbuddy_flutter_app/common/widget/rounded_loading_button.dart';
import '../theme/color_constants.dart';

class AppButton extends StatelessWidget {
  final String labelText;
  final TextStyle? labelStyle;
  final Function() onTap;
  final String? suffixIcon;
  final double? buttonWidth;
  final double buttonHeight;
  final Widget? prefixIcon;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? borderColor;
  final RoundedLoadingButtonController? controller;
  final bool animateOnTap;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.labelText,
    this.labelStyle,
    required this.onTap,
    this.suffixIcon,
    this.buttonHeight = 48,
    this.buttonWidth,
    this.prefixIcon,
    this.borderRadius,
    this.color = ColorConstants.darkGrey,
    this.borderColor,
    this.controller,
    this.animateOnTap = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      controller: controller,
      onPressed: onTap,
      height: buttonHeight,
      width: buttonWidth ?? MediaQuery.of(context).size.width,
      borderRadius: 10,
      color: color,
      elevation: 0,
      borderColor: borderColor,
      animateOnTap: animateOnTap,
      isLoading: isLoading,
      child: Text(
        labelText,
        style: labelStyle ?? TextStyles.button,
      ),
    );
  }
}
