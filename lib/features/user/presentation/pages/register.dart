import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/user/presentation/providers/auth_provider.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  String? lanjutValidationText;
  String userPhoneNumber = '';
  bool isDisabled = true;
  bool? isHasAccount;

  void setPhoneNumber(String phoneNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phoneNumber', phoneNumber);
    if (prefs.getString('signMethod') == null) {
      prefs.setString('signMethod', 'phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    isHasAccount =
        Provider.of<AuthProvider>(context, listen: true).boolHasAccount;

    // if (isHasAccount != null) {
    //   if (!isHasAccount!) {
    //     Navigator.pushNamed(context, '/verifikasi_otp');
    //   }
    // }

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
                  'Buat Akun',
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
                  'Masukan nomor ponselmu untuk memulai',
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppColor.white,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 40,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.grey_3,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Text(
                          '+62',
                          style:
                              AppTextStyle(color: AppColor.blue_1).sfproBodyS(),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: AppColor.grey_2,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: TextField(
                            // keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: AppTextStyle(color: AppColor.black_2)
                                .sfproBodyS(),
                            autocorrect: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintText: '123 4567 8900',
                              hintStyle: AppTextStyle(color: AppColor.grey_1)
                                  .sfproBodyS(),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) => setState(() {
                              userPhoneNumber = '62$value';

                              if (userPhoneNumber.length < 12 ||
                                  userPhoneNumber.length > 15) {
                                isDisabled = true;
                              } else {
                                isDisabled = false;
                              }
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                (isHasAccount != null
                    ? (isHasAccount!
                        ? Text(
                            'Nomor ini telah terdaftar. Gunakan nomor lain atau login dengan akun yang ada.',
                            style:
                                AppTextStyle(color: AppColor.red).mulishBodyS(),
                          )
                        : const SizedBox())
                    : const SizedBox()),
                const SizedBox(
                  height: 28,
                ),
                GestureDetector(
                  onTap: () async {
                    if (!isDisabled) {
                      setPhoneNumber(userPhoneNumber);
                      Provider.of<AuthProvider>(context, listen: false)
                          .eitherFailureOrCheckHasAnAccount(
                        params:
                            CheckHasAccountParams(phoneNumber: userPhoneNumber),
                        context: context,
                        phoneNumber: userPhoneNumber,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isDisabled
                          ? AppColor.orange_1.withOpacity(0.4)
                          : AppColor.orange_1,
                    ),
                    child: Text(
                      'Lanjut',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: AppColor.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: AppTextStyle(color: AppColor.black_2).sfproBodyS(),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.orange_1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
