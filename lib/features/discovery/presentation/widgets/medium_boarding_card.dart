import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';
import 'package:zladag_flutter_app/features/shared/formatter/app_formatter.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_shadow.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

class MediumBoardingCardWidget extends StatelessWidget {
  final BoardingEntity boardingEntity;
  const MediumBoardingCardWidget({super.key, required this.boardingEntity});

  @override
  Widget build(BuildContext context) {
    // final facilityListViewKey = GlobalKey();
    // bool isStillFitFacility = true;
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/boarding_details', arguments: {
        'slug': boardingEntity.slug,
      }),
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 24,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [AppShadow.boxShadow],
        ),
        width: double.maxFinite,
        child: Column(
          children: [
            SizedBox(
              height: 124,
              child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: boardingEntity.imagesPath!.length,
                  itemBuilder: (context, index) {
                    int maxPhotos = 8;
                    if (index < maxPhotos - 1 &&
                        index != boardingEntity.imagesPath!.length - 1) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Image.network(
                            height: 124,
                            width: 240,
                            fit: BoxFit.cover,
                            // 'https://picsum.photos/200/300'),
                            'https://zladag-catnip-services.as.r.appspot.com/api/images?path=${boardingEntity.imagesPath![index]}'),
                      );
                    } else if (index > maxPhotos - 1) {
                      return const SizedBox();
                    } else if (index == boardingEntity.imagesPath!.length - 1 ||
                        index == maxPhotos - 1) {
                      return Image.network(
                          height: 124,
                          width: 240,
                          fit: BoxFit.cover,
                          // 'https://picsum.photos/200/300');
                          'https://zladag-catnip-services.as.r.appspot.com/api/images?path=${boardingEntity.imagesPath![index]}');
                    } else {
                      return const SizedBox();
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 24,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: boardingEntity.boardingFacilities?.length,
                        itemBuilder: (context, index) {
                          if (index < 4) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.blue_1,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                boardingEntity.boardingFacilities?[index],
                                style: AppTextStyle(color: AppColor.white)
                                    .mulishBodyXS(),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          boardingEntity.name ?? '',
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: AppColor.black_2,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic-star.svg',
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '4.5',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              color: AppColor.orange_1,
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            '(99)',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.3,
                              color: AppColor.grey_1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic-location.svg',
                        width: 16,
                        height: 16,
                        colorFilter:
                            ColorFilter.mode(AppColor.grey_1, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          '${boardingEntity.distance! >= 0 ? (boardingEntity.distance! > 999 ? double.parse((boardingEntity.distance! / 1000).toStringAsFixed(2)) : double.parse(boardingEntity.distance!.toStringAsFixed(2))) : ""}${boardingEntity.distance! >= 0 ? (boardingEntity.distance! > 999 ? " km " : " m ") : ""}${boardingEntity.distance! >= 0 ? "dari lokasi ・ " : ""}${boardingEntity.subdistrict}, ${boardingEntity.province}',
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColor.grey_1,
                            letterSpacing: -0.3,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Rp ${AppFormatter().formatNumberToCurrency(boardingEntity.cheapestLodgingPrice ?? 0)}',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.black_2,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'per ekor per malam',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColor.grey_1,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
