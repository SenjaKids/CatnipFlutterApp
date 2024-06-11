import 'package:flutter/material.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';

class CatnipLoadingState extends StatelessWidget {
  const CatnipLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColor.white),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColor.orange_1,
        ),
      ),
    );
  }
}
