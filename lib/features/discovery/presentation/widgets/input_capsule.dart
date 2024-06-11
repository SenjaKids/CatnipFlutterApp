import 'package:flutter/material.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

// ignore: must_be_immutable
class InputCapsuleWidget extends StatefulWidget {
  final String text;
  final String value;
  String? radioGroupValue;
  final Function? setGroupValueFunction;
  InputCapsuleWidget({
    super.key,
    required this.text,
    required this.value,
    required this.radioGroupValue,
    required this.setGroupValueFunction,
  });

  @override
  State<InputCapsuleWidget> createState() => _InputCapsuleWidgetState();
}

class _InputCapsuleWidgetState extends State<InputCapsuleWidget> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    if (widget.radioGroupValue == widget.value) {
      setState(() {
        isActive = true;
        debugPrint('fasdfa');
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
        decoration: BoxDecoration(
            color: isActive
                ? const Color.fromRGBO(239, 133, 71, 0.1)
                : Colors.transparent,
            border: Border.all(
              color: isActive ? AppColor.orange_1 : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(100)),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          widget.text,
          style: AppTextStyle(color: AppColor.black_2).mulishBodyS(),
        ),
      ),
    );
  }
}
