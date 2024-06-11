import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';
import 'package:zladag_flutter_app/features/user/presentation/providers/auth_provider.dart';

class StartingFormWidget extends StatefulWidget {
  const StartingFormWidget({super.key});

  @override
  State<StartingFormWidget> createState() => _StartingFormWidgetState();
}

class _StartingFormWidgetState extends State<StartingFormWidget> {
  String userName = '';
  late String signMethod;
  String? userEmail;
  late SharedPreferences prefs;
  late String phoneNumber;

  void _submitUserData() async {
    signMethod = prefs.getString('signMethod') ?? 'no method found';
    phoneNumber = prefs.getString('phoneNumber') ?? 'no phone number found';
    userEmail = prefs.getString('userEmail');
    print('$signMethod $phoneNumber $userEmail');

    // ignore: use_build_context_synchronously
    Provider.of<AuthProvider>(context, listen: false).eitherFailureOrSignUpUser(
        signUpUserBody: SignUpUserBody(
            signMethod: signMethod,
            phoneNumber: phoneNumber,
            name: userName,
            email: userEmail),
        context: context);
  }

  void _setSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    _setSharedPrefs();
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _widget(),
        ),
      ),
    );
  }

  Widget _widget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 118,
        ),
        Image.network(
          'https://picsum.photos/500/1000',
          fit: BoxFit.cover,
          width: 173,
          height: 173,
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Selamat datang di Catnip!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.032,
            height: 1.5,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Kenalan dulu yuk',
          style: TextStyle(
            fontFamily: 'SF-Pro',
            fontSize: 16,
            color: AppColor.grey_1,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        TextField(
          autocorrect: false,
          style: AppTextStyle(color: AppColor.black_2).sfproBodyS(),
          decoration: InputDecoration(
            hintText: 'Siapa namamu?',
            hintStyle: AppTextStyle(color: AppColor.grey_1).sfproBodyS(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            isDense: true,
            fillColor: AppColor.grey_3,
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
          onChanged: (value) => setState(() {
            userName = value;
          }),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => setState(() {
            // currPageState = 2;
            _submitUserData();
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: AppColor.orange_1,
                borderRadius: BorderRadius.circular(4)),
            child: Text(
              'Lanjutkan Pesanan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Mulish',
                color: AppColor.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
