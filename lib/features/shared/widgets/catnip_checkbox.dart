import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

class CatnipCheckbox extends StatefulWidget {
  final String primaryLabel;
  final String? secondaryLabel;
  final CatnipCheckboxType? catnipCheckboxType;
  final double? checkboxIconSize;
  final TextStyle? primaryLabelTextStyle;
  final TextStyle? secondaryLabelTextStyle;
  final Function? onClick;
  final bool? isActive;
  const CatnipCheckbox({
    super.key,
    required this.primaryLabel,
    this.secondaryLabel,
    this.catnipCheckboxType,
    this.checkboxIconSize,
    this.primaryLabelTextStyle,
    this.secondaryLabelTextStyle,
    this.onClick,
    this.isActive,
  });

  @override
  State<CatnipCheckbox> createState() => _CatnipCheckboxState();
}

class _CatnipCheckboxState extends State<CatnipCheckbox> {
  bool isActive = false;

  late Widget checkbox;

  @override
  Widget build(BuildContext context) {
    isActive = widget.isActive ?? isActive;
    if (widget.catnipCheckboxType == CatnipCheckboxType.regular) {
      checkbox = _regularCheckbox();
    } else if (widget.catnipCheckboxType == CatnipCheckboxType.seperated) {
      checkbox = _seperatedCheckbox();
    } else if (widget.catnipCheckboxType ==
        CatnipCheckboxType.seperatedKeyValue) {
      checkbox = _seperatedKeyValueCheckbox();
    } else {
      checkbox = _regularCheckbox();
    }

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() {
              isActive = !isActive;
              if (widget.onClick != null) {
                widget.onClick!();
              }
            }),
        child: checkbox);
  }

  Widget _checkboxIcon() {
    return (isActive
        ? SvgPicture.asset(
            'assets/icons/ic-checkbox-1.svg',
            width: widget.checkboxIconSize ?? 24,
            height: widget.checkboxIconSize ?? 24,
          )
        : SvgPicture.asset(
            'assets/icons/ic-checkbox-0.svg',
            width: widget.checkboxIconSize ?? 24,
            height: widget.checkboxIconSize ?? 24,
          ));
  }

  Widget _regularCheckbox() {
    return Row(
      children: [
        _checkboxIcon(),
        const SizedBox(width: 10),
        Text(
          widget.primaryLabel,
          style: widget.primaryLabelTextStyle ??
              AppTextStyle(color: AppColor.black_2).sfproBodyS(),
        ),
      ],
    );
  }

  Widget _seperatedCheckbox() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.primaryLabel,
            style: widget.primaryLabelTextStyle ??
                AppTextStyle(color: AppColor.black_2).sfproBodyS(),
          ),
        ),
        _checkboxIcon(),
      ],
    );
  }

  Widget _seperatedKeyValueCheckbox() {
    return Row(
      children: [
        _checkboxIcon(),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Text(
            widget.primaryLabel,
            overflow: TextOverflow.ellipsis,
            style: widget.primaryLabelTextStyle ??
                AppTextStyle(color: AppColor.black_2).mulishBodyS(),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Text(
          widget.secondaryLabel ?? '',
          style: widget.secondaryLabelTextStyle ??
              AppTextStyle(color: AppColor.black_2).mulishBodyS(),
        ),
      ],
    );
  }
}

enum CatnipCheckboxType {
  regular,
  seperated,
  seperatedKeyValue,
}
