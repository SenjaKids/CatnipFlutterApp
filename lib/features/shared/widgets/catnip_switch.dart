import 'package:flutter/material.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';

class CatnipSwitch extends StatefulWidget {
  final bool? isActive;
  final Color? foregroundColor, activeBackgroundColor, inactiveBackgroundColor;
  const CatnipSwitch(
      {super.key,
      this.isActive,
      this.foregroundColor,
      this.activeBackgroundColor,
      this.inactiveBackgroundColor});

  @override
  State<CatnipSwitch> createState() => _CatnipSwitchState();
}

class _CatnipSwitchState extends State<CatnipSwitch> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    isActive = widget.isActive ?? isActive;
    return GestureDetector(
      onTap: () => setState(() {
        isActive = !isActive;
      }),
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(vertical: 2),
        duration: const Duration(milliseconds: 500),
        height: 31,
        width: 51,
        decoration: BoxDecoration(
          color: isActive
              ? widget.activeBackgroundColor ??
                  const Color.fromRGBO(52, 199, 89, 1)
              : widget.inactiveBackgroundColor ??
                  const Color.fromRGBO(120, 120, 128, 0.16),
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
                  color: widget.foregroundColor ?? AppColor.white,
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
      ),
    );
  }
}
