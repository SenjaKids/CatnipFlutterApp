import 'package:flutter/material.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

// ignore: must_be_immutable
class InputSeperatedTogleWidget extends StatefulWidget {
  final String text;
  final String value;
  List<String> checkboxGroupValue;
  final Function setGroupValueFunction;

  InputSeperatedTogleWidget(
      {super.key,
      required this.text,
      required this.value,
      required this.checkboxGroupValue,
      required this.setGroupValueFunction});

  @override
  State<InputSeperatedTogleWidget> createState() =>
      _InputSeperatedTogleWidgetState();
}

class _InputSeperatedTogleWidgetState extends State<InputSeperatedTogleWidget> {
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
            style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
          ),
          // SvgPicture.asset(
          //   isActive
          //       ? 'assets/icons/ic-checkbox-1.svg'
          //       : 'assets/icons/ic-checkbox-0.svg',
          //   width: 16,
          //   height: 16,
          // ),
          togleSwitch(),
        ],
      ),
    );
  }

  Widget togleSwitch() {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(vertical: 2),
      duration: const Duration(milliseconds: 500),
      height: 31,
      width: 51,
      decoration: BoxDecoration(
        color: isActive
            ? const Color.fromRGBO(52, 199, 89, 1)
            : const Color.fromRGBO(120, 120, 128, 0.16),
        borderRadius: BorderRadius.circular(200),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            curve: Curves.decelerate,
            duration: const Duration(milliseconds: 500),
            left: isActive ? 22 : 2,
            child: Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                color: AppColor.white,
                boxShadow: [
                  // BoxShadow(
                  //   blurRadius: 0,
                  //   offset: const Offset(0, 0),
                  //   spreadRadius: 1,
                  //   color: Colors.black.withOpacity(0.04),
                  // ),
                  BoxShadow(
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                    color: Colors.black.withOpacity(0.15),
                  ),
                  // BoxShadow(
                  //   blurRadius: 1,
                  //   offset: const Offset(0, 3),
                  //   spreadRadius: 0,
                  //   color: Colors.black.withOpacity(0.06),
                  // ),
                ],
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
