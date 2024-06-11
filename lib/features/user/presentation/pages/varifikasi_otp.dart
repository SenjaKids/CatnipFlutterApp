import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/user/presentation/providers/auth_provider.dart';
import 'package:zladag_flutter_app/features/shared/formatter/app_formatter.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

class VerifikasiOTPWidget extends StatefulWidget {
  final String phoneNumber;
  const VerifikasiOTPWidget({super.key, required this.phoneNumber});

  @override
  State<VerifikasiOTPWidget> createState() => _VerifikasiOTPWidgetState();
}

class _VerifikasiOTPWidgetState extends State<VerifikasiOTPWidget> {
  String? lanjutValidationText;
  // String userPhoneNumber = '';
  bool isDisabled = true;
  String currPin = '';
  bool? isPinCorrect;

  Timer? _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OtpFieldController otpController = OtpFieldController();
    isPinCorrect =
        Provider.of<AuthProvider>(context, listen: true).otpValidationResult;
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
                  'Verifikasi OTP',
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
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColor.white,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Masukan OTP yang telah kami kirimkan ke ',
                      ),
                      TextSpan(
                          text: '+62 ${widget.phoneNumber.substring(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const TextSpan(
                        text: ' via Whatsapp',
                      ),
                    ],
                  ),
                ),
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
                const SizedBox(
                  height: 40,
                ),
                OTPTextField(
                  controller: otpController,
                  width: double.maxFinite,
                  contentPadding: const EdgeInsets.all(20),
                  keyboardType: TextInputType.number,
                  // spaceBetween: 24,
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  style: AppTextStyle(color: AppColor.black_2).mulishTitleL(),
                  length: 4,
                  fieldStyle: FieldStyle.box,
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: AppColor.grey_3,
                    enabledBorderColor: AppColor.grey_3,
                    focusBorderColor: AppColor.orange_1,
                    borderColor: AppColor.grey_3,
                  ),
                  outlineBorderRadius: 8,
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldWidth: 56,
                  isDense: true,
                  onChanged: (pin) {
                    print("Pin Changed: " + pin);
                  },
                  onCompleted: (pin) {
                    print("Completed: " + pin);
                    Provider.of<AuthProvider>(context, listen: false)
                        .eitherFailureOrOTPValidationResult(
                      validateOTPBody: ValidateOTPBody(
                        phoneNumber: widget.phoneNumber,
                        otp: pin,
                      ),
                      context: context,
                    );
                    startTimer();
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                (isPinCorrect != null && isPinCorrect == false
                    ? Text(
                        'Ups! OTP salah. Cek ulang dan coba lagi.',
                        style: AppTextStyle(color: AppColor.red).mulishBodyS(),
                      )
                    : const SizedBox()),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum terima OTP?',
                      style: AppTextStyle(color: AppColor.black_2).sfproBodyS(),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    // GestureDetector(
                    //   onTap: () => Navigator.pushNamed(context, '/register'),
                    //   child: Text(
                    //     'Kirim ulang ${_timer != null ? "di ${AppFormatter().formatTimer(_start)}" : ""}',
                    //     style: TextStyle(
                    //       fontFamily: 'SF-Pro',
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w500,
                    //       color: AppColor.orange_1,
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        _start = 60;
                        startTimer();
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (_start == 0) {
                            Provider.of<AuthProvider>(context, listen: false)
                                .eitherFailureOrOTP(
                              getOTPBody:
                                  GetOTPBody(phoneNumber: widget.phoneNumber),
                            );
                          }
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: _timer != null && _start > 0
                                  ? AppColor.grey_2
                                  : AppColor.orange_1,
                              fontFamily: 'Mulish',
                              fontSize: 14,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Kirim ulang',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: _timer != null && _start > 0
                                    ? " di ${AppFormatter().formatTimer(_start)}"
                                    : "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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
