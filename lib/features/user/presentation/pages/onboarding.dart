import 'package:flutter/material.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              'https://picsum.photos/500/1000',
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),
          ),
          Container(
            height: 380,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(217, 217, 217, 0),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColor.black_2,
                    ),
                    children: [
                      const TextSpan(text: 'Temukan penginapan '),
                      TextSpan(
                          text: 'terbaik',
                          style: TextStyle(color: AppColor.blue_1)),
                      const TextSpan(text: ' untuk anabul kamu!'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Corem ipsum dolor sit amet, consectetur adipiscing',
                  style: AppTextStyle(color: AppColor.grey_1).sfproBodyS(),
                ),
                const SizedBox(
                  height: 68,
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.orange_1,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: double.maxFinite,
                    child: Text(
                      'Buat Akun',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColor.white,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: -0.3),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: AppTextStyle(color: AppColor.grey_1).sfproBodyS(),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Masuk',
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.orange_1,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
