import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

// ignore: must_be_immutable
class InputRadioSquareWidget extends StatefulWidget {
  final String text;
  final String value;
  String? radioGroupValue;
  final Function? setGroupValueFunction;
  InputRadioSquareWidget({
    super.key,
    required this.text,
    required this.value,
    required this.radioGroupValue,
    required this.setGroupValueFunction,
  });

  @override
  State<InputRadioSquareWidget> createState() => _InputRadioSquareWidgetState();
}

class _InputRadioSquareWidgetState extends State<InputRadioSquareWidget> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    if (widget.radioGroupValue == widget.value) {
      setState(() {
        isActive = true;
        // debugPrint('fasdfa');
      });
    } else {
      setState(() {
        isActive = false;
      });
    }
    return GestureDetector(
      onTap: () => setState(() {
        widget.setGroupValueFunction!(widget.value);
        widget.radioGroupValue = widget.value;
      }),
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        // BoxDecoration(
        //     color: isActive
        //         ? const Color.fromRGBO(239, 133, 71, 0.1)
        //         : Colors.transparent,
        //     border: Border.all(
        //       color: isActive ? AppColor.orange_1 : AppColor.grey_2,
        //       width: 1,
        //     ),
        //     borderRadius: BorderRadius.circular(100))
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromRGBO(239, 133, 71, 0.1)
              : AppColor.grey_3,

          border: Border.all(
            color: isActive ? AppColor.orange_1 : AppColor.grey_3,
            width: 1,
          ),
          // color: isActive ? AppColor.orange_1 : AppColor.grey_3,
          // border: Border.all(
          //   color: isActive ? AppColor.orange_1 : AppColor.grey_2,
          //   width: 1,
          // ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/icons/ic-${widget.value}.svg',
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                  isActive ? AppColor.orange_1 : AppColor.grey_1,
                  BlendMode.srcIn),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.text,
              style: AppTextStyle(
                      color: isActive ? AppColor.orange_1 : AppColor.grey_1)
                  .mulishBodyM(),
            ),
          ],
        ),
      ),
    );
  }
}
