import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

// ignore: must_be_immutable
class InputSeperatedCheckboxWidget extends StatefulWidget {
  final String text;
  final String value;
  List<String> checkboxGroupValue;
  final Function setGroupValueFunction;

  InputSeperatedCheckboxWidget(
      {super.key,
      required this.text,
      required this.value,
      required this.checkboxGroupValue,
      required this.setGroupValueFunction});

  @override
  State<InputSeperatedCheckboxWidget> createState() =>
      _InputSeperatedCheckboxWidgetState();
}

class _InputSeperatedCheckboxWidgetState
    extends State<InputSeperatedCheckboxWidget> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    if (widget.checkboxGroupValue.contains(widget.value)) {
      setState(() {
        isActive = true;
      });
    } else {
      setState(() {
        isActive = false;
      });
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() {
        widget.setGroupValueFunction(widget.value);
      }),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.text,
            style: AppTextStyle(color: AppColor.black_2).mulishBodyS(),
          ),
          SvgPicture.asset(
            isActive
                ? 'assets/icons/ic-checkbox-1.svg'
                : 'assets/icons/ic-checkbox-0.svg',
            width: 16,
            height: 16,
          ),
        ],
      ),
    );
  }
}
