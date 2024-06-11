import 'package:flutter/material.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

// ignore: must_be_immutable
class CatnipTextfield extends StatefulWidget {
  final String? hint;
  String? value;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final double? borderRadius;
  final int? maxLines;
  final Function? onChanged;
  final Color? borderColor;
  bool? readOnly;
  CatnipTextfield({
    super.key,
    this.hint,
    this.backgroundColor,
    this.contentPadding,
    this.hintTextStyle,
    this.textStyle,
    this.borderRadius,
    this.value,
    this.readOnly,
    this.maxLines,
    this.onChanged,
    this.borderColor,
  });

  @override
  State<CatnipTextfield> createState() => _CatnipTextfieldState();
}

class _CatnipTextfieldState extends State<CatnipTextfield> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) =>
          widget.onChanged != null ? widget.onChanged!(value) : null,
      readOnly: widget.readOnly ?? false,
      autocorrect: false,
      controller: _controller,
      maxLines: widget.maxLines ?? 1,
      style: widget.textStyle ??
          AppTextStyle(color: AppColor.black_2).sfproBodyS(),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: widget.contentPadding ?? const EdgeInsets.all(0),
        hintText: widget.hint ?? '',
        hintStyle: widget.hintTextStyle ??
            AppTextStyle(color: AppColor.grey_1).sfproBodyS(),
        filled: true,
        fillColor: widget.backgroundColor ?? AppColor.grey_3,
        border: OutlineInputBorder(
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
        ),
      ),
    );
  }
}
