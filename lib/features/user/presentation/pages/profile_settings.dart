import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_switch.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_textfield.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/user_entity.dart';
import 'package:zladag_flutter_app/features/user/presentation/providers/auth_provider.dart';

class ProfileSettingsWidget extends StatefulWidget {
  const ProfileSettingsWidget({super.key});

  @override
  State<ProfileSettingsWidget> createState() => _ProfileSettingsWidgetState();
}

class _ProfileSettingsWidgetState extends State<ProfileSettingsWidget> {
  bool isReadOnly = true;
  File? userPhoto;
  String userName = '';
  UserDataEntity? userData;
  String? accessToken;

  void _getSavedAccessToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    const cachedAccessToken = 'CACHED_ACCESS_TOKEN';
    setState(() {
      accessToken = prefs.getString(cachedAccessToken);
    });

    if (accessToken != null) {
      // ignore: use_build_context_synchronously
      Provider.of<AuthProvider>(context, listen: false)
          .eitherFailureOrUserData(accessToken: accessToken!, context: context);
    }

    // print("token saved $accessToken");
  }

  @override
  void initState() {
    // TODO: implement initState
    _getSavedAccessToken(context);
    userData = Provider.of<AuthProvider>(context, listen: false).userData;
    userName = userData!.userEntity.name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: _appBar(context),
      body: _body(),
    );
  }

  Future pickImage() async {
    try {
      print('picking image');
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      print('image');
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => userPhoto = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 17),
          Center(
            child: GestureDetector(
              onTap: () {
                if (!isReadOnly) {
                  pickImage();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColor.grey_3,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: userPhoto != null
                      ? Image.file(
                          userPhoto!,
                          fit: BoxFit.cover,
                          height: 60,
                          width: 60,
                        )
                      : Image.network(
                          'https://picsum.photos/500/600',
                          fit: BoxFit.cover,
                          height: 60,
                          width: 60,
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 39),
          CatnipTextfield(
            onChanged: (value) => setState(() {
              userName = value;
              print(value);
              print(userName);
            }),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 13.5,
              horizontal: 16,
            ),
            readOnly: isReadOnly,
            value: userData!.userEntity.name,
          ),
          const SizedBox(height: 63),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hubungkan akun',
                style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/ic-google.svg'),
                    const SizedBox(width: 16),
                    Text(
                      'Google',
                      style:
                          AppTextStyle(color: AppColor.black_2).mulishTitleM(),
                    ),
                    const Spacer(),
                    const CatnipSwitch(),
                    // ToggleButtons(children: children, isSelected: isSelected)
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/ic-google.svg'),
                    const SizedBox(width: 16),
                    Text(
                      'Apple',
                      style:
                          AppTextStyle(color: AppColor.black_2).mulishTitleM(),
                    ),
                    const Spacer(),
                    const CatnipSwitch(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/ic-chev-left.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(AppColor.black_2, BlendMode.srcIn),
          ),
        ),
      ),
      title: Text(
        'Profile Setting',
        style: AppTextStyle(color: AppColor.black_2).mulishTitleL(),
      ),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: GestureDetector(
              onTap: () => setState(() {
                if (!isReadOnly) {
                  Provider.of<AuthProvider>(context, listen: false)
                      .eitherFailureOrUpdateUserProfileSuccess(
                          accessToken: accessToken!,
                          updateUserProfileBody: UpdateUserProfileBody(
                              image: userPhoto, name: userName),
                          context: context);
                }
                isReadOnly = !isReadOnly;
              }),
              child: Text(
                isReadOnly ? 'Edit' : 'Save',
                style: AppTextStyle(color: AppColor.black_2).mulishBodyS(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
