import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/providers/boarding_provider.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_shadow.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';
import 'package:zladag_flutter_app/features/shared/formatter/app_formatter.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_button.dart';

class BoardingDetailsWidget extends StatefulWidget {
  final String slug;
  final String? longitude;
  final String? latitude;
  const BoardingDetailsWidget({
    super.key,
    required this.slug,
    required this.longitude,
    required this.latitude,
  });
  bool get isIos => defaultTargetPlatform == TargetPlatform.iOS;

  @override
  State<BoardingDetailsWidget> createState() => _BoardingDetailsWidgetState();
}

class _BoardingDetailsWidgetState extends State<BoardingDetailsWidget> {
  @override
  void initState() {
    _getSavedAccessToken(context);
    Provider.of<BoardingProvider>(context, listen: false)
        .eitherFailureOrBoardingDetails(
      slug: widget.slug,
      latitude: widget.latitude,
      longitude: widget.longitude,
    );
    super.initState();
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();
  GoogleMapController? googleMapController;

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  String? accessToken;

  void _getSavedAccessToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    const cachedAccessToken = 'CACHED_ACCESS_TOKEN';
    setState(() {
      accessToken = prefs.getString(cachedAccessToken);
    });

    // print("token saved $accessToken");
  }

  @override
  Widget build(BuildContext context) {
    late Widget view;
    BoardingEntity? boarding = Provider.of<BoardingProvider>(context).boarding;

    debugPrint(boarding.toString());

    if (boarding == null) {
      view = Container(
        decoration: BoxDecoration(color: AppColor.white),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColor.orange_1,
          ),
        ),
      );
    } else {
      view = Container(
        decoration: BoxDecoration(color: AppColor.white),
        child: SafeArea(
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: AppColor.white,
              body: Stack(
                children: [
                  NestedScrollView(
                    headerSliverBuilder: (context, value) {
                      return [
                        SliverToBoxAdapter(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                        height: 280.0,
                                        initialPage: 0,
                                        enableInfiniteScroll: false,
                                        viewportFraction: 1,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        }),
                                    carouselController: _controller,
                                    items: boarding.imagesPath!.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Image.network(
                                            // 'https://picsum.photos/200/300',
                                            'https://zladag-catnip-services.as.r.appspot.com/api/images?path=$i',
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 265),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: boarding.imagesPath!
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        return GestureDetector(
                                          onTap: () => _controller
                                              .animateToPage(entry.key),
                                          child: Container(
                                            width: 6.0,
                                            height: 6.0,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 3.0),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: (Colors.white)
                                                    .withOpacity(
                                                        _current == entry.key
                                                            ? 1
                                                            : 0.6)),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.grey_3,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        boarding.boardingCategory ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'SF-Pro',
                                          color: AppColor.black_2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      boarding.name ?? '',
                                      style:
                                          AppTextStyle(color: AppColor.black_2)
                                              .mulishTitleL(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      '${boarding.distance! >= 0 ? (boarding.distance! > 999 ? double.parse((boarding.distance! / 1000).toStringAsFixed(2)) : double.parse(boarding.distance!.toStringAsFixed(2))) : ""}${boarding.distance! >= 0 ? (boarding.distance! > 999 ? " km " : " m ") : ""}${boarding.distance! >= 0 ? "dari lokasi ・ " : ""}${boarding.subdistrict}, ${boarding.province}',
                                      // '${boarding.distance} km dari lokasi ・ ${boarding.subdistrict}, ${boarding.province}',
                                      style:
                                          AppTextStyle(color: AppColor.grey_1)
                                              .mulishBodyXS(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/ic-star.svg',
                                          width: 16,
                                          height: 16,
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          '4.5',
                                          style: TextStyle(
                                            color: AppColor.orange_1,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            fontFamily: 'SF-Pro',
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            '(99 review)',
                                            style: TextStyle(
                                              color: AppColor.grey_1,
                                              fontSize: 12,
                                              fontFamily: 'SF-Pro',
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColor.grey_3,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: const SizedBox(),
                                  ),
                                ],
                              ),
                              TabBar(
                                indicatorColor: AppColor.orange_1,
                                indicatorWeight: 2,
                                unselectedLabelColor: AppColor.grey_1,
                                labelColor: AppColor.black_1,
                                unselectedLabelStyle:
                                    AppTextStyle(color: AppColor.grey_1)
                                        .mulishBodyM(),
                                labelStyle:
                                    AppTextStyle(color: AppColor.black_2)
                                        .mulishTitleM(),
                                tabs: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Info',
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Review',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    body: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              // mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                const SizedBox(
                                  height: 32,
                                ),
                                Text(
                                  'Fasilitas & Layanan',
                                  style: AppTextStyle(color: AppColor.black_2)
                                      .mulishTitleM(),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  child: GridView.count(
                                    childAspectRatio: 9 / 1,
                                    // crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    padding: EdgeInsets.zero,
                                    children: List.generate(
                                      boarding.boardingFacilities!.length,
                                      (index) {
                                        return Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/facilities/ic-f-${boarding.boardingFacilities![index]}.svg',
                                              width: 16,
                                              height: 16,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              boarding.boardingFacilities![
                                                      index] ??
                                                  '',
                                              style: AppTextStyle(
                                                      color: AppColor.black_2)
                                                  .mulishBodyS(),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                Text(
                                  'Ukuran Kandang',
                                  style: AppTextStyle(color: AppColor.black_2)
                                      .mulishTitleM(),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: boarding.boardingCages?.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, cageIndex) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          child: Text(boarding
                                                  .boardingCages?[cageIndex]
                                                  .cage
                                                  ?.name ??
                                              ''),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                          child: Text('='),
                                        ),
                                        Text(
                                          '${boarding.boardingCages?[cageIndex].cage?.width.toString()}cm x ${boarding.boardingCages?[cageIndex].cage?.length.toString()}cm  ${() {
                                            if (boarding
                                                    .boardingCages?[cageIndex]
                                                    .cage
                                                    ?.height !=
                                                null) {
                                              // ignore: prefer_interpolation_to_compose_strings
                                              return boarding
                                                      .boardingCages![cageIndex]
                                                      .cage!
                                                      .height
                                                      .toString() +
                                                  "cm";
                                            } else {
                                              return "";
                                            }
                                          }()}',
                                          style: AppTextStyle(
                                                  color: AppColor.black_2)
                                              .mulishBodyS(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Text(
                                  'Kebijakan Pet Hotel',
                                  style: AppTextStyle(color: AppColor.black_2)
                                      .mulishTitleM(),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  // mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/policy/ic-checkin.svg',
                                      width: 16,
                                      height: 16,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Waktu Check In',
                                            style: AppTextStyle(
                                                    color: AppColor.black_2)
                                                .mulishBodyS(),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Check In',
                                                      style: AppTextStyle(
                                                              color: AppColor
                                                                  .black_2)
                                                          .mulishBodyS(),
                                                    ),
                                                    Text(
                                                      // ignore: prefer_interpolation_to_compose_strings
                                                      boarding.boardingPolicyEntity!
                                                              .startCheckInTime!
                                                              .substring(0, 5) +
                                                          (boarding.boardingPolicyEntity!
                                                                      .endCheckInTime ==
                                                                  null
                                                              ? ''
                                                              : ' - ${boarding.boardingPolicyEntity!.endCheckInTime!.substring(0, 5)}'),
                                                      style: AppTextStyle(
                                                              color: AppColor
                                                                  .black_2)
                                                          .mulishBodyS(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Check Out',
                                                      style: AppTextStyle(
                                                              color: AppColor
                                                                  .black_2)
                                                          .mulishBodyS(),
                                                    ),
                                                    Text(
                                                      boarding.boardingPolicyEntity!
                                                              .startCheckOutTime!
                                                              .substring(0, 5) +
                                                          (boarding.boardingPolicyEntity!
                                                                      .endCheckOutTime ==
                                                                  null
                                                              ? ''
                                                              : ' - ${boarding.boardingPolicyEntity!.endCheckOutTime!.substring(0, 5)}'),
                                                      style: AppTextStyle(
                                                              color: AppColor
                                                                  .black_2)
                                                          .mulishBodyS(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                boarding.boardingPolicyEntity!.vaccinated!
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/policy/ic-vacinated.svg',
                                              width: 16,
                                              height: 16,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Sudah Vaksin',
                                                    style: AppTextStyle(
                                                            color: AppColor
                                                                .black_2)
                                                        .mulishBodyS(),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    'Anabul melakukan vaksin tahunan',
                                                    style: AppTextStyle(
                                                            color: AppColor
                                                                .black_2)
                                                        .mulishBodyS(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                boarding.boardingPolicyEntity!.minAge != null &&
                                        boarding.boardingPolicyEntity!.maxAge !=
                                            null
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/policy/ic-age.svg',
                                              width: 16,
                                              height: 16,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Usia Anabul',
                                                    style: AppTextStyle(
                                                            color: AppColor
                                                                .black_2)
                                                        .mulishBodyS(),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    boarding.boardingPolicyEntity!
                                                                .maxAge !=
                                                            null
                                                        ? 'Menerima anabul usia ${AppFormatter().formatMonthToYear(boarding.boardingPolicyEntity!.minAge ?? 0)} - ${AppFormatter().formatMonthToYear(boarding.boardingPolicyEntity!.maxAge ?? 0)}'
                                                        : 'Menerima anabul dengan usia minimal ${AppFormatter().formatMonthToYear(boarding.boardingPolicyEntity!.minAge ?? 0)}',
                                                    style: AppTextStyle(
                                                            color: AppColor
                                                                .black_2)
                                                        .mulishBodyS(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                boarding.boardingPolicyEntity!.fleaFree!
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/policy/ic-fleafree.svg',
                                              width: 16,
                                              height: 16,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Bebas Kutu',
                                                    style: AppTextStyle(
                                                            color: AppColor
                                                                .black_2)
                                                        .mulishBodyS(),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    'Anabul bebas dari kutu yang dapat menular',
                                                    style: AppTextStyle(
                                                            color: AppColor
                                                                .black_2)
                                                        .mulishBodyS(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 32,
                                ),
                                Text(
                                  'Tentang',
                                  style: AppTextStyle(color: AppColor.black_2)
                                      .mulishTitleM(),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  boarding.description.toString(),
                                  style: AppTextStyle(color: AppColor.black_2)
                                      .mulishBodyS(),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                Text(
                                  'Lokasi',
                                  style: AppTextStyle(color: AppColor.black_2)
                                      .mulishTitleM(),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  width: double.maxFinite,
                                  height: 140,
                                  child: GoogleMap(
                                    onMapCreated: _onMapCreated,
                                    markers: {
                                      const Marker(
                                        markerId: MarkerId('Marker'),
                                        position: LatLng(-6.301869622151328,
                                            106.65243525280933),
                                      )
                                    },
                                    myLocationButtonEnabled: false,
                                    zoomControlsEnabled: false,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                          double.parse(boarding.latitude ?? ''),
                                          double.parse(
                                              boarding.longitude ?? '')),
                                      zoom: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  boarding.boardingLocationEntity!.address
                                      .toString(),
                                  style: AppTextStyle(color: AppColor.grey_2)
                                      .sfproBodyS(),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: const [
                                Center(
                                  child: Text('Review'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
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
                                    colorFilter: ColorFilter.mode(
                                        AppColor.black_2, BlendMode.srcIn),
                                  )),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          decoration:
                              BoxDecoration(color: AppColor.white, boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, -4),
                              color: AppColor.black_1.withOpacity(0.05),
                              blurRadius: 8,
                            )
                          ]),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mulai dari',
                                          style: TextStyle(
                                            fontFamily: 'SF-Pro',
                                            color: AppColor.grey_2,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        Text(
                                          'Rp ${AppFormatter().formatNumberToCurrency(boarding.cheapestLodgingPrice ?? 0)}',
                                          style: TextStyle(
                                            color: AppColor.black_2,
                                            fontFamily: 'SF-Pro',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        Text(
                                          'per ekor per malam',
                                          style: TextStyle(
                                            fontFamily: 'SF-Pro',
                                            color: AppColor.grey_2,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        print(accessToken != null);
                                        if (accessToken != null) {
                                          Navigator.pushNamed(
                                              context, '/reservasi',
                                              arguments: widget.slug);
                                        } else {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) =>
                                                _loginBottomModal(),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: 163,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColor.orange_1,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Pilih Layanan',
                                            style: TextStyle(
                                              fontFamily: 'SF-Pro',
                                              color: AppColor.white,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: -0.3,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return view;
  }

  Widget _loginBottomModal() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      height: 200,
      child: Column(
        children: [
          const SizedBox(
            height: 6,
          ),
          SvgPicture.asset('assets/icons/ic-drag-indicator.svg'),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deskripsi Anabul',
                  style: TextStyle(
                    color: AppColor.black_1,
                    fontFamily: 'Mulish',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(221, 221, 221, 1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 21,
                      color: Color.fromARGB(255, 133, 133, 133),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CatnipButton(
              onTap: () => Navigator.pushNamed(context, '/login'),
              label: 'Masuk',
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Belum punya akun?',
                style: AppTextStyle(color: AppColor.black_2).sfproBodyS(),
              ),
              const SizedBox(
                width: 4,
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/register'),
                child: Text(
                  'Buat Akun',
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
    );
  }
}
