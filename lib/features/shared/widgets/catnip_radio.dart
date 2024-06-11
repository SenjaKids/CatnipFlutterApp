import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CatnipRadio extends StatefulWidget {
  final String primaryLabel;
  final String? secondaryLabel;
  final CatnipRadioType? catnipRadioType;
  final double? radioIconSize;
  final Function? onTap;
  final bool? isActive;
  const CatnipRadio({
    super.key,
    required this.primaryLabel,
    this.secondaryLabel,
    this.catnipRadioType,
    this.radioIconSize,
    this.onTap,
    this.isActive,
  });

  @override
  State<CatnipRadio> createState() => _CatnipRadioState();
}

class _CatnipRadioState extends State<CatnipRadio> {
  // late Widget widget;

  bool isActive = false;

  // widget = _seperatedKeyValueRadio();

  @override
  Widget build(BuildContext context) {
    if (widget.isActive != null) {
      setState(() {
        isActive = widget.isActive!;
      });
    }

    Widget radioSelected;
    if (widget.catnipRadioType == CatnipRadioType.regular) {
      radioSelected = _regularRadio();
    } else if (widget.catnipRadioType == CatnipRadioType.seperated) {
      radioSelected = _seperatedRadio();
    } else {
      radioSelected = _regularRadio();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(
        () {
          //TODO: ONTAP GESTURE LOGIC
          if (widget.onTap != null) {
            widget.onTap!();
          }
          isActive = !isActive;
          // if (widget.onClick != null) {
          //   widget.onClick!();
          // }
        },
      ),
      child: radioSelected,
    );
    // return _seperatedKeyValueRadio();
  }

  Widget _radioIcon() {
    return (isActive
        ? SvgPicture.asset(
            'assets/icons/ic-radio-1.svg',
            width: widget.radioIconSize ?? 24,
            height: widget.radioIconSize ?? 24,
          )
        : SvgPicture.asset(
            'assets/icons/ic-radio-0.svg',
            width: widget.radioIconSize ?? 24,
            height: widget.radioIconSize ?? 24,
          ));
  }

  Widget _seperatedRadio() {
    List<Widget> listWidget = [
      Text(
        widget.primaryLabel,
        // style: widget.primaryLabelTextStyle ??
        //     AppTextStyle(color: AppColor.black_2).mulishBodyS(),
      ),
      const Spacer(),
      _radioIcon(),
    ];
    return Row(
      children: [for (Widget i in listWidget) i],
    );
  }

  Widget _regularRadio() {
    return Row(
      children: [
        _radioIcon(),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Text(
            widget.primaryLabel,
            overflow: TextOverflow.ellipsis,
            // style: widget.primaryLabelTextStyle ??
            //     AppTextStyle(color: AppColor.black_2).mulishBodyS(),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Text(
          widget.secondaryLabel ?? '',
          // style: widget.secondaryLabelTextStyle ??
          //     AppTextStyle(color: AppColor.black_2).mulishBodyS(),
        ),
      ],
    );
  }
}

enum CatnipRadioType {
  regular,
  seperated,
}
