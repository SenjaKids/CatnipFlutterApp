import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/providers/boarding_provider.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/widgets/search_form.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/widgets/small_boarding_card.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
  });

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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
    getUserPosition();
    if (userPosition == null) {
      Provider.of<BoardingProvider>(context, listen: false)
          .eitherFailureOrHomeBoardingsWithFood(
              params: HomeFilteredBoardingParams(null, null));
      Provider.of<BoardingProvider>(context, listen: false)
          .eitherFailureOrHomeBoardingsWithPlayground(
        params: HomeFilteredBoardingParams(null, null),
      );
    } else {
      Provider.of<BoardingProvider>(context, listen: false)
          .eitherFailureOrHomeBoardingsWithFood(
        params: HomeFilteredBoardingParams(
          userPosition!.latitude.toString(),
          userPosition!.longitude.toString(),
        ),
      );
      Provider.of<BoardingProvider>(context, listen: false)
          .eitherFailureOrHomeBoardingsWithPlayground(
        params: HomeFilteredBoardingParams(userPosition!.latitude.toString(),
            userPosition!.longitude.toString()),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration:
            const BoxDecoration(color: Color.fromRGBO(246, 246, 246, 1)),
        child: Column(
          children: [
            _searchContainer(context),
            _contentContainer(context),
          ],
        ),
      ),
    );
  }

  Widget _searchContainer(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.orange_1,
                    shape: BoxShape.rectangle,
                  ),
                  child: SizedBox(
                    height: 235,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Transform.translate(
                offset: const Offset(100, -45),
                child: SvgPicture.asset('assets/images/dog-palm.svg'),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 71),
          child: Column(
            children: [
              Text(
                'Cari penginapan yang cocok untuk anabul kamu!',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColor.white,
                ),
              ),
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(146, 111, 91, 0.098),
                      spreadRadius: 0,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SearchFormWidget(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _contentContainer(BuildContext context) {
    List<BoardingEntity>? boardingsWithFood =
        Provider.of<BoardingProvider>(context).homeBoardingsWithFood;
    List<BoardingEntity>? boardingsWithPlayground =
        Provider.of<BoardingProvider>(context).homeBoardingsWithPlayground;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          _promotionList(context),
          const SizedBox(
            height: 40,
          ),
          _filteredBoardingsList(
            context,
            boardingsWithFood,
            'Termasuk Makanan',
            'Gak mau ribet siapin makanan anabul? Disini aja!',
            'food',
          ),
          const SizedBox(
            height: 32,
          ),
          _filteredBoardingsList(
            context,
            boardingsWithPlayground,
            'Tersedia Tempat Bermain',
            'Cari Pet Hotel dengan tempat bermain yang bagus.',
            'playground',
          ),
        ],
      ),
    );
  }

  Widget _promotionList(BuildContext context) {
    Widget widget;

    widget = Column(
      children: [
        SizedBox(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Promo Untukmu!',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColor.black_1,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        if (i == 2) {
                          return Container(
                            height: 160,
                            width: 320,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Image.network(
                              'https://picsum.photos/500/500',
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Container(
                              height: 160,
                              width: 320,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Image.network(
                                'https://picsum.photos/500/1000',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return widget;
  }

  Widget _filteredBoardingsList(
      BuildContext context,
      List<BoardingEntity>? boardingsList,
      String title,
      String desc,
      String value) {
    late Widget widget;

    if (boardingsList != null) {
      widget = Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColor.black_1,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  desc,
                  style: TextStyle(
                    color: AppColor.grey_1,
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 280,
            child: ListView.builder(
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: boardingsList.length + 1,
              itemBuilder: (context, index) {
                if (index != boardingsList.length) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SmallBoardingCardWidget(
                      boardingEntity: boardingsList[index],
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      //TODO: PASS LOCATION IN HOME
                      Navigator.pushNamed(
                        context,
                        '/search',
                        arguments: {
                          'boardingSearchParams': BoardingSearchParams(
                            boardingFacilities: [value],
                            latitude: userPosition == null
                                ? null
                                : userPosition!.latitude.toString(),
                            longitude: userPosition == null
                                ? null
                                : userPosition!.longitude.toString(),
                          ),
                          'dogQty': 0,
                          'catQty': 0,
                          'location': 'Dekat Saya',
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(146, 111, 91, 0.1),
                            spreadRadius: 0,
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      height: 280,
                      width: 196,
                      child: Column(
                        children: [
                          const Spacer(),
                          Text(
                            'Lihat Pet Hotel Lainnya',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              color: AppColor.black_1,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SvgPicture.asset('assets/icons/ic-arrow-right.svg'),
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      );
    } else {
      widget = const SizedBox.shrink();
    }

    return widget;
  }
}
