import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/theme/color_constants.dart';
import 'package:stockbuddy_flutter_app/common/theme/text_styles.dart';

// ignore: must_be_immutable
class AppTextFormFields extends StatefulWidget {
  AppTextFormFields({
    this.leftborder = false,
    this.isBorderProvided,
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.textStyle,
    this.textInputType,
    this.textInputAction,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.minLines,
    this.maxLines = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.focusNode,
    this.readOnly = false,
    this.prefixIcon,
    this.showError = true,
    this.onChanged,
  });

  AppTextFormFields.prefix({
    this.leftborder = false,
    this.isBorderProvided,
    super.key,
    this.controller,
    required this.label,
    required this.prefixIcon,
    this.hint,
    this.textStyle,
    this.textInputType,
    this.textInputAction,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.minLines,
    this.maxLines = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.focusNode,
    this.readOnly = false,
    this.showError = true,
    this.onChanged,
  });

  AppTextFormFields.multiline({
    this.leftborder = false,
    this.isBorderProvided,
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.textStyle,
    this.textInputType,
    this.textInputAction,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.minLines = 4,
    this.maxLines = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.focusNode,
    this.readOnly = false,
    this.showError = true,
    this.prefixIcon,
    this.onChanged,
  });

  AppTextFormFields.intOnly({
    this.leftborder = false,
    this.isBorderProvided,
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.textStyle,
    this.textInputAction,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.minLines,
    this.maxLines,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.focusNode,
    this.readOnly = false,
    this.showError = true,
    this.prefixIcon,
    this.onChanged,
  }) : textInputType = const TextInputType.numberWithOptions(
            decimal: false, signed: false);

  final TextEditingController? controller;
  TextInputType? textInputType;
  TextInputAction? textInputAction;
  FormFieldValidator<String>? validator;
  TextStyle? textStyle;
  final String? label;
  final String? hint;
  final bool obscureText;
  final bool? isBorderProvided;
  final Widget? suffixIcon;
  final String? prefixIcon;
  int? minLines;
  int? maxLines;
  EdgeInsetsGeometry padding;
  FocusNode? focusNode;
  final bool readOnly;
  final bool showError;
  ValueChanged<String>? onChanged;
  final bool leftborder;

  @override
  State<AppTextFormFields> createState() => _AppTextFormFieldsState();
}

class _AppTextFormFieldsState extends State<AppTextFormFields> {
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: ColorConstants.lightGrey,
        width: 1,
      ),
    );
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      focusNode: focusNode,
      readOnly: widget.readOnly,
      style: widget.textStyle ??
          TextStyles.regular(
            fontSize: 16,
            color: Colors.black,
          ),
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      obscureText: widget.obscureText,
      minLines: widget.minLines,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFFFFF),
        isDense: true,
        errorMaxLines: 2,
        errorStyle: widget.showError
            ? (widget.textStyle ??
                    TextStyles.regular(
                      fontSize: 14,
                    ))
                .copyWith(color: Colors.red)
            : const TextStyle(fontSize: 0),
        label: widget.label != null ? Text(widget.label!) : null,
        alignLabelWithHint: true,
        hintText: widget.hint,
        hintStyle: TextStyles.regular(
          fontSize: 14,
          color: ColorConstants.lightGrey,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        disabledBorder: border,
        focusedErrorBorder: border,
        suffixIconColor: ColorConstants.lightGrey,
        suffixIcon: widget.suffixIcon,
        prefixIcon: ((widget.prefixIcon) != null)
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: SizedBox(
                  height: 30,
                  width: 24,
                  child: Center(
                    child: ImageIcon(
                      AssetImage(widget.prefixIcon!),
                      color: ColorConstants.black,
                      size: 24,
                    ),
                  ),
                ),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(
          maxWidth: 48,
          minWidth: 48,
          minHeight: 24,
          maxHeight: 24,
        ),
        contentPadding: widget.padding,
      ),
    );
  }
}
