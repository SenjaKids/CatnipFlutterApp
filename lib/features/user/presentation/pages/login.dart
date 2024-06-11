import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 54, 24, 24),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColor.orange_1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: SvgPicture.asset(
                    'assets/icons/ic-chev-left.svg',
                    height: 28,
                    width: 28,
                    colorFilter:
                        ColorFilter.mode(AppColor.white, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Masuk',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    letterSpacing: 0.32,
                    color: AppColor.white,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Selamat datang kembali! Yuk masuk lagi',
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppColor.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 53,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 235, 235, 235)),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/ic-google.svg',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                'Masuk dengan Google',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  color: AppColor.black_2,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.14,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 48,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                color: AppColor.grey_1,
                              )),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Atau',
                                style: AppTextStyle(color: AppColor.grey_1)
                                    .mulishBodyS(),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: Divider(
                                color: AppColor.grey_1,
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 48,
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/login_whatsapp'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 235, 235, 235)),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/ic-google.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'Masuk dengan Nomor Whatsapp',
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    color: AppColor.black_2,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.14,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun?',
                          style: AppTextStyle(color: AppColor.black_2)
                              .sfproBodyS(),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: Text(
                            'Buat akun',
                            style: TextStyle(
                              fontFamily: 'SF-Pro',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.orange_1,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
