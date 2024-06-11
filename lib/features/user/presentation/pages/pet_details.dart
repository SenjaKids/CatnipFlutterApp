import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_shadow.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_loading_state.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/user/presentation/providers/auth_provider.dart';

class PetDetailsWidget extends StatefulWidget {
  const PetDetailsWidget({super.key});

  @override
  State<PetDetailsWidget> createState() => _PetDetailsWidgetState();
}

class _PetDetailsWidgetState extends State<PetDetailsWidget> {
  late PetEntity? petEntity;
  @override
  Widget build(BuildContext context) {
    petEntity = Provider.of<AuthProvider>(context, listen: true).petDetails;
    return Scaffold(
      backgroundColor: AppColor.grey_3,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    if (petEntity == null) {
      return const CatnipLoadingState();
    } else {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _topDetails(),
                const SizedBox(height: 8),
                _bottomDetails(),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/edit_anabul'),
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
                              'Edit Profile',
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
              ],
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [AppShadow.boxShadow]),
                      child: SvgPicture.asset(
                        'assets/icons/ic-chev-left.svg',
                        height: 16,
                        width: 16,
                        colorFilter:
                            ColorFilter.mode(AppColor.black_2, BlendMode.srcIn),
                      )),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _topDetails() {
    return Stack(
      children: [
        Column(
          children: [
            Image.network(
              'https://picsum.photos/1200/1600',
              fit: BoxFit.cover,
              height: 272,
              width: double.maxFinite,
            ),
            Container(
              height: 249,
              decoration: BoxDecoration(color: AppColor.white),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 232),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  boxShadow: [AppShadow.boxShadow],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          petEntity!.name ?? "",
                          style: AppTextStyle(color: AppColor.black_2)
                              .mulishTitleL(),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          petEntity!.petBreed ?? "",
                          style: AppTextStyle(color: AppColor.black_2)
                              .mulishBodyS(),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (petEntity!.petGender == "Male"
                            ? const Color.fromRGBO(222, 239, 255, 1)
                            : const Color.fromRGBO(255, 207, 207, 1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/ic-gender-${petEntity!.petGender == "Male" ? "male" : "female"}.svg',
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                            (petEntity!.petGender == "Male"
                                ? const Color.fromRGBO(121, 159, 255, 1)
                                : const Color.fromRGBO(255, 121, 121, 1)),
                            BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  (petEntity!.hasBeenVaccinatedRoutinely ?? false
                      ? Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColor.blue_1,
                            ),
                            child: Center(
                              child: Text(
                                'Sudah Vaksin',
                                style: AppTextStyle(color: AppColor.white)
                                    .mulishBodyXS(),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()),
                  (petEntity!.hasBeenSterilized! &&
                          petEntity!.hasBeenVaccinatedRoutinely!
                      ? const SizedBox(width: 8)
                      : const SizedBox()),
                  (petEntity!.hasBeenSterilized ?? false
                      ? Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColor.blue_1,
                            ),
                            child: Center(
                              child: Text(
                                'Sudah Steril',
                                style: AppTextStyle(color: AppColor.white)
                                    .mulishBodyXS(),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()),
                  (petEntity!.hasBeenSterilized! &&
                          petEntity!.hasBeenFleaFreeRegularly!
                      ? const SizedBox(width: 8)
                      : const SizedBox()),
                  (petEntity!.hasBeenFleaFreeRegularly ?? false
                      ? Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColor.blue_1,
                            ),
                            child: Center(
                              child: Text(
                                'Bebas Kutu',
                                style: AppTextStyle(color: AppColor.white)
                                    .mulishBodyXS(),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic-paw.svg',
                    width: 24,
                    height: 24,
                    colorFilter:
                        ColorFilter.mode(AppColor.black_2, BlendMode.srcIn),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Tentang',
                    style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.grey_2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Umur:',
                            style: AppTextStyle(color: AppColor.grey_1)
                                .sfproBodyS(),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            petEntity!.age! < 12
                                ? "${petEntity!.age} Bulan"
                                : "${petEntity!.age! ~/ 12} Tahun",
                            style: AppTextStyle(color: AppColor.black_2)
                                .mulishTitleM(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.grey_2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Berat:',
                            style: AppTextStyle(color: AppColor.grey_1)
                                .sfproBodyS(),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${petEntity!.bodyMass} kg',
                            style: AppTextStyle(color: AppColor.black_2)
                                .mulishTitleM(),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomDetails() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColor.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/facilities/ic-f-Grooming.svg',
                width: 24,
                height: 24,
                colorFilter:
                    ColorFilter.mode(AppColor.black_2, BlendMode.srcIn),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Preferensi Fasilitas',
                style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          (petEntity!.boardingFacilities!.isEmpty
              ? Text(
                  'Tidak ada',
                  style: AppTextStyle(color: AppColor.grey_1).mulishBodyS(),
                )
              : Wrap(
                  spacing: 11,
                  runSpacing: 11,
                  children: [
                    for (var i in petEntity!.boardingFacilities!)
                      //TODO: ICONNYA BELOM DIGANTI
                      _facilityCapsule(
                        i,
                      ),
                  ],
                )),
          const SizedBox(height: 32),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/ic-kebiasaan.svg',
                width: 24,
                height: 24,
                colorFilter:
                    ColorFilter.mode(AppColor.black_2, BlendMode.srcIn),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Kebiasaan',
                style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          (petEntity!.petHabits!.isEmpty
              ? Text(
                  'Tidak ada',
                  style: AppTextStyle(color: AppColor.grey_1).mulishBodyS(),
                )
              : Wrap(
                  spacing: 11,
                  runSpacing: 11,
                  children: [
                    for (var i in petEntity!.petHabits!)
                      //TODO: ICONNYA BELOM DIGANTI
                      _kebiasaanCapsule(
                        i,
                      ),
                  ],
                )),
          const SizedBox(height: 32),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/ic-riwayat-penyakit.svg',
                width: 24,
                height: 24,
                colorFilter:
                    ColorFilter.mode(AppColor.black_2, BlendMode.srcIn),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Riwayat Penyakit',
                style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          (petEntity!.historyOfIllness == null
              ? Text(
                  'Tidak ada',
                  style: AppTextStyle(color: AppColor.grey_1).mulishBodyS(),
                )
              : Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.grey_3,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: IntrinsicWidth(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            petEntity!.historyOfIllness!,
                            style: AppTextStyle(color: AppColor.black_2)
                                .mulishBodyS(),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _facilityCapsule(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColor.grey_3,
        borderRadius: BorderRadius.circular(4),
      ),
      child: IntrinsicWidth(
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/facilities/ic-f-AC.svg',
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(AppColor.black_2, BlendMode.srcIn),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: AppTextStyle(color: AppColor.black_2).mulishBodyS(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kebiasaanCapsule(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColor.grey_3,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTextStyle(color: AppColor.black_2).mulishBodyS(),
      ),
    );
  }
}
