import 'package:flutter/material.dart';

typedef DisplayConverter<T> = String Function(T);

class AppDropdownTextFormField<T> extends StatefulWidget {
  final String? label;
  final List<T> items;
  final T? selectedValue;
  final ValueChanged<T?>? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final bool filled = false;
  final Color? filledColor;
  final InputBorder? border;
  final String? hintText;
  final DisplayConverter<dynamic>? displayConverter;
  final EdgeInsetsGeometry padding;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final FormFieldValidator<T>? validator;

  const AppDropdownTextFormField({
    super.key,
    required this.items,
    this.label,
    this.hintText,
    this.onChanged,
    this.displayConverter,
    this.selectedValue,
    this.suffixIcon,
    this.validator,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.contentPadding,
    this.filledColor,
    this.border,
    this.focusNode,
  });

  @override
  State<AppDropdownTextFormField<T>> createState() =>
      _AppDropdownTextFormFieldState<T>();
}

class _AppDropdownTextFormFieldState<T>
    extends State<AppDropdownTextFormField<T>> {
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        width: 1,
      ),
    );
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<T>(
        dropdownColor: Colors.white,
        items: widget.items
            .map((e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(widget.displayConverter != null
                      ? widget.displayConverter!(e)
                      : e.toString()),
                ))
            .toList(),
        value: widget.selectedValue,
        onChanged: widget.onChanged,
        validator: widget.validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          errorStyle: const TextStyle(fontSize: 0),
          label: widget.label != null ? Text(widget.label!) : null,
          alignLabelWithHint: true,
          hintText: widget.hintText,
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border,
          disabledBorder: border,
          focusedErrorBorder: border,
          suffixIcon: widget.suffixIcon,
          contentPadding: widget.padding,
        ),
      ),
    );
  }
}
