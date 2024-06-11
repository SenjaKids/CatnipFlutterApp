import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_button.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/user_entity.dart';
import 'package:zladag_flutter_app/features/user/presentation/providers/auth_provider.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  // bool _isLogIn = false;
  String? accessToken;
  Widget? view;
  UserDataEntity? userData;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    accessToken ??=
        Provider.of<AuthProvider>(context, listen: true).accessToken;
    // accessToken ??=
    //     Provider.of<AuthProvider>(context, listen: true).accessToken;
    userData ??= Provider.of<AuthProvider>(context, listen: true).userData;
    // if (accessToken == null) {}
    // Provider.of(context, listen: false).

//TODO: GANTI PAGENYA BELOM MULUS
    if (accessToken == null) {
      view = _petPageState1();
    } else if (userData == null) {
      view = _petPageState1();
      // print(accessToken);
    } else {
      view = _petPageState2();
      // print(accessToken);
    }

    if (view == null) {
      return const CircularProgressIndicator();
    } else {
      return view!;
    }
  }

  Widget _petPageState1() {
    // _getSavedAccessToken(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColor.white,
      ),
      child: Center(
        child: Column(
          children: [
            const Spacer(),
            SvgPicture.asset(
              'assets/images/il-empty-state.svg',
              width: 173,
              height: 173,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              'Kamu belum log in',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.24,
                color: AppColor.black_2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Yuk log in untuk akses fitur lengkap catnip',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColor.grey_1,
              ),
            ),
            const SizedBox(height: 62),
            CatnipButton(
              label: 'Masuk',
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Belum punya akun?',
                  style: AppTextStyle(color: AppColor.black_2).mulishBodyS(),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: Text(
                    'Buat akun',
                    style: AppTextStyle(color: AppColor.orange_1).mulishBodyS(),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _petPageState2() {
    if (userData == null) {
      return const CircularProgressIndicator();
    } else {
      return Container(
        decoration: BoxDecoration(color: AppColor.white),
        child: SafeArea(
          child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColor.grey_3,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColor.white),
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            'https://picsum.photos/500/600',
                            fit: BoxFit.cover,
                            height: 48,
                            width: 48,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          userData!.userEntity.name!,
                          style: AppTextStyle(color: AppColor.black_2)
                              .mulishTitleM(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: AppColor.white),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic-paw.svg',
                          colorFilter: ColorFilter.mode(
                              AppColor.black_2, BlendMode.srcIn),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Anabul ku',
                          style: AppTextStyle(color: AppColor.black_2)
                              .mulishTitleM(),
                        )
                      ],
                    ),
                  ),
                  _petList(),
                  Container(
                    decoration: BoxDecoration(color: AppColor.white),
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: CatnipButton(
                      onTap: () =>
                          Navigator.pushNamed(context, '/tambah_anabul'),
                      color: AppColor.orange_2,
                      label: 'Tambah Anabul',
                      labelStyle: TextStyle(
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: -0.3,
                        color: AppColor.orange_1,
                      ),
                      icon: SvgPicture.asset(
                        'assets/icons/ic-add.svg',
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          AppColor.orange_1,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, '/profile_setting'),
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(color: AppColor.white),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      child: IntrinsicWidth(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic-setting.svg',
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Profile Settings',
                                style: AppTextStyle(color: AppColor.black_2)
                                    .mulishTitleM(),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/icons/ic-chev-right.svg',
                              height: 24,
                              width: 24,
                              colorFilter: ColorFilter.mode(
                                  AppColor.grey_1, BlendMode.srcIn),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Log Out',
                    style: AppTextStyle(color: AppColor.red).mulishBodyM(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _petList() {
    return Container(
      decoration: BoxDecoration(color: AppColor.white),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shrinkWrap: true,
        itemCount: userData!.petEntities.length,
        itemBuilder: (context, index) {
          if (index < userData!.petEntities.length - 1) {
            return Column(
              children: [
                _petListItem(index),
                _petDivider(),
              ],
            );
          } else {
            return _petListItem(index);
          }
        },
        // children: [_petListItem()],
      ),
    );
  }

  Widget _petListItem(int position) {
    PetEntity currPetEntity = userData!.petEntities[position];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Provider.of<AuthProvider>(context, listen: false)
            .eitherFailureOrPetDetails(
                accessToken: accessToken!,
                context: context,
                petId: currPetEntity.id!);
        Navigator.pushNamed(
          context,
          "/pet_details",
          arguments: currPetEntity,
        );
      },
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: IntrinsicWidth(
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                'https://picsum.photos/530/600',
                fit: BoxFit.cover,
                height: 48,
                width: 48,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currPetEntity.name ?? "",
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        color: AppColor.black_2,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${currPetEntity.petBreed} · ${currPetEntity.age! < 12 ? "${currPetEntity.age} bulan" : "${currPetEntity.age! ~/ 12} tahun"}',
                    // '${currPetEntity.petBreed} · ${currPetEntity.age} tahun',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(color: AppColor.grey_1).mulishBodyS(),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/ic-chev-right.svg',
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(AppColor.grey_1, BlendMode.srcIn),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _petDivider() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Divider(
          color: AppColor.grey_3,
          thickness: 1,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
