import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

// ignore: must_be_immutable
class InputSquareWidget extends StatefulWidget {
  final String text;
  final String iconName;
  final String value;
  List<String> checkboxGroupValue;
  final Function setGroupValueFunction;
  InputSquareWidget({
    super.key,
    required this.text,
    required this.value,
    required this.checkboxGroupValue,
    required this.setGroupValueFunction,
    required this.iconName,
  });

  @override
  State<InputSquareWidget> createState() => _InputSquareWidgetState();
}

class _InputSquareWidgetState extends State<InputSquareWidget> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    if (widget.checkboxGroupValue.contains(widget.value)) {
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
        widget.setGroupValueFunction(widget.value);
        // if (isActive) {
        //   widget.checkboxGroupValue.remove(widget.value);
        // } else {
        //   widget.checkboxGroupValue.add(widget.value);
        // }
      }),
      child: Container(
        width: 108,
        height: 108,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromRGBO(239, 133, 71, 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isActive ? AppColor.orange_1 : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Expanded(
                child: SvgPicture.asset(
                    'assets/icons/facilities/ic-f-${widget.iconName}.svg')),
            Expanded(
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: AppTextStyle(color: AppColor.black_2).mulishBodyS(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
