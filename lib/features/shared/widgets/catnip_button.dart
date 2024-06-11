import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';

class CatnipButton extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final double? borderRadius;
  final Color? color;
  final Function? onTap;
  final SvgPicture? icon;
  const CatnipButton({
    super.key,
    required this.label,
    this.labelStyle,
    this.color,
    this.borderRadius,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color ?? AppColor.orange_1,
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (icon ?? const SizedBox()),
            (icon != null ? const SizedBox(width: 8) : const SizedBox()),
            Text(
              label,
              textAlign: TextAlign.center,
              style: labelStyle ??
                  TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: AppColor.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
