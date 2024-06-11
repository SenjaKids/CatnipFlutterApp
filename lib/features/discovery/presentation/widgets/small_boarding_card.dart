import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';
import 'package:zladag_flutter_app/features/shared/formatter/app_formatter.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_shadow.dart';

class SmallBoardingCardWidget extends StatefulWidget {
  final BoardingEntity boardingEntity;
  const SmallBoardingCardWidget({super.key, required this.boardingEntity});

  @override
  State<SmallBoardingCardWidget> createState() =>
      _SmallBoardingCardWidgetState();
}

class _SmallBoardingCardWidgetState extends State<SmallBoardingCardWidget> {
  LatLng? userPosition;

  void getUserPosition() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double? longitude = prefs.getDouble('userLongitude');
    double? latitude = prefs.getDouble('userLatitude');

    if (longitude != null && latitude != null) {
      setState(() {
        userPosition = LatLng(
          latitude,
          longitude,
        );
      });
    } else {
      setState(() {
        userPosition = null;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/boarding_details',
        arguments: BoardingDetailsParams(
          slug: widget.boardingEntity.slug!,
          latitude:
              userPosition == null ? null : userPosition!.latitude.toString(),
          longitude:
              userPosition == null ? null : userPosition!.longitude.toString(),
        ),
      ),
      child: Container(
        width: 196,
        height: 280,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [AppShadow.boxShadow],
        ),
        child: Column(
          children: [
            Image.network(
                height: 124,
                width: double.maxFinite,
                fit: BoxFit.cover,
                // 'https://picsum.photos/200/300'),
                'https://zladag-catnip-services.as.r.appspot.com/api/images?path=${widget.boardingEntity.imagesPath![0]}'),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.boardingEntity.name ?? '',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: AppColor.black_1,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic-star.svg',
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                            AppColor.orange_1, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        '4.5',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          color: AppColor.grey_1,
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
                          letterSpacing: -0.3,
                          color: AppColor.grey_1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic-location-filled.svg',
                        width: 16,
                        height: 16,
                        colorFilter:
                            ColorFilter.mode(AppColor.grey_1, BlendMode.srcIn),
                      ),
                      // TODO: ICON LOCATION DI SMALL CARD PAKE YANG MANA
                      // SvgPicture.asset(
                      //   'assets/icons/ic-location.svg',
                      //   width: 16,
                      //   height: 16,
                      //   colorFilter: ColorFilter.mode(
                      //       AppColor.grey_1, BlendMode.srcIn),
                      // ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          '${widget.boardingEntity.subdistrict}, ${widget.boardingEntity.province}',
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            letterSpacing: -0.3,
                            color: AppColor.grey_1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 39,
                  ),
                  Text(
                    'Rp ${AppFormatter().formatNumberToCurrency(widget.boardingEntity.cheapestLodgingPrice ?? 0)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.black_1,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Mulish',
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'per ekor per malam',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColor.grey_1,
                      fontFamily: 'Mulish',
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
