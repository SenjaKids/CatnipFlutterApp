import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:zladag_flutter_app/core/connection/location_info.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/providers/boarding_provider.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/widgets/location_autocomplete_bottom_modal.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class SearchFormWidget extends StatefulWidget {
  // final BuildContext context;
  final Function? alternativeSearchFunction;
  int? catCount, dogCount;

  SearchFormWidget({
    super.key,
    this.alternativeSearchFunction,
    this.catCount,
    this.dogCount,
  });

  @override
  State<SearchFormWidget> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchFormWidget> {
  int savedCatCount = 0;
  int savedDogCount = 0;
  int catCount = 0;
  int dogCount = 0;
  String location = '';
  List<String> petCategories = [];
  LatLng? currLatLng;
  // Position? selectedPosition;
  DateTime savedStartDate = DateTime.now();
  DateTime savedEndDate = DateTime.now().add(const Duration(days: 1));
  DateTime? startDate;
  DateTime? endDate;

  Future<void> getCurrentPosition() async {
    final hasPermission =
        await LocationInfoImpl().handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(
          () => currLatLng = LatLng(position.latitude, position.longitude));
      location = 'Dekat Saya';
      print(currLatLng);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> setSelectedLocation({
    required String locationID,
    required String newLocation,
  }) async {
    setState(() {
      location = newLocation;
      currLatLng = Provider.of<BoardingProvider>(context, listen: false).latLng;
      print(currLatLng);
      print(newLocation);
    });
  }
  // }

  @override
  void initState() {
    getCurrentPosition();
    setState(() {
      savedCatCount = widget.catCount ?? 0;
      savedDogCount = widget.dogCount ?? 0;
      startDate = savedStartDate;
      endDate = savedEndDate;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(context.toString());
    // autocompletePrediction =
    //     Provider.of<BoardingProvider>(context, listen: true).autoComplete;

    return Column(
      children: [
        GestureDetector(
          onTap: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                // return _bottomSheetModalLocation();
                return LocationAutoCompleteBottomModalWidget(
                  getCurrentPosition: getCurrentPosition,
                  setSelectedLocation: setSelectedLocation,
                );
              }),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColor.grey_3,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/ic-location.svg',
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    AppColor.grey_1,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    currLatLng != null ? location : 'Pilih Lokasi',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: currLatLng != null
                          ? AppColor.black_2
                          : AppColor.grey_1,
                      fontFamily: 'Mulish',
                      letterSpacing: -0.3,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                (location == 'Dekat Saya'
                    ? SvgPicture.asset(
                        'assets/icons/ic-current-location.svg',
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                            AppColor.orange_1, BlendMode.srcIn),
                      )
                    : const SizedBox()),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColor.grey_3,
            borderRadius: BorderRadius.circular(4),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return _bottomSheetModalCalendar();
                        }),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic-calendar.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(
                              AppColor.grey_1, BlendMode.srcIn),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            '${DateFormat.MMMd('id_ID').format(savedStartDate)} - ${DateFormat.MMMd('id_ID').format(savedEndDate)}',
                            style: TextStyle(
                              color: AppColor.black_2,
                              fontFamily: 'Mulish',
                              letterSpacing: -0.3,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  thickness: 1,
                  color: AppColor.grey_1,
                ),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      dogCount = savedDogCount;
                      catCount = savedCatCount;
                    });
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => bottomSheetModalPetCount());
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic-dog.svg',
                        width: 16,
                        height: 16,
                        colorFilter:
                            ColorFilter.mode(AppColor.grey_1, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        savedDogCount.toString(),
                        style: TextStyle(
                          color: AppColor.black_2,
                          fontFamily: 'Mulish',
                          letterSpacing: -0.3,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SvgPicture.asset(
                        'assets/icons/ic-cat.svg',
                        width: 16,
                        height: 16,
                        colorFilter:
                            ColorFilter.mode(AppColor.grey_1, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        savedCatCount.toString(),
                        style: TextStyle(
                          color: AppColor.black_2,
                          fontFamily: 'Mulish',
                          letterSpacing: -0.3,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: () {
            if (currLatLng != null) {
              if (widget.alternativeSearchFunction == null) {
                if (dogCount > 0) {
                  petCategories.add('dog');
                }
                if (catCount > 0) {
                  petCategories.add('cat');
                }

                print(currLatLng!.latitude.toString());
                print(currLatLng!.longitude.toString());
                Navigator.pushNamed(
                  context,
                  '/search',
                  arguments: {
                    'boardingSearchParams': BoardingSearchParams(
                      latitude: currLatLng!.latitude.toString(),
                      longitude: currLatLng!.longitude.toString(),
                    ),
                    'dogQty': dogCount,
                    'catQty': catCount,
                    'startDate': savedStartDate,
                    'endDate': savedEndDate,
                    'location': location,
                  },
                );
              } else {
                widget.alternativeSearchFunction!(
                  newCatCount: catCount,
                  newDogCount: dogCount,
                  newLocation: location,
                  newStartDate: savedStartDate,
                  newEndDate: savedEndDate,
                );
              }
            } else {
              // TODO: PROMPT CANNOT SEARCH WITHOUT LOCATION
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColor.orange_1,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/ic-search.svg'),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Cari Pet Hotel',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    letterSpacing: -0.3,
                    fontWeight: FontWeight.w700,
                    color: AppColor.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  StatefulBuilder _bottomSheetModalCalendar() {
    void onSubmitCalendar() {
      debugPrint(savedStartDate.toString());
      setState(() {
        savedStartDate = startDate!;
        savedEndDate = endDate!;
      });
    }

    return StatefulBuilder(
      builder: (context, setState) {
        void onDataChangeCalendar(DateRangePickerSelectionChangedArgs args) {
          SchedulerBinding.instance.addPostFrameCallback((duration) {
            setState(() {
              startDate = args.value.startDate;
              endDate = args.value.endDate;
            });
          });
        }

        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
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
                      'Tanggal Penitipan',
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
              //TODO: CALENDAR
              Container(
                height: 400,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SfDateRangePicker(
                  headerHeight: 50,
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    disabledDatesTextStyle: TextStyle(
                      fontFamily: 'Mulish',
                      color: AppColor.grey_1,
                    ),
                    todayTextStyle: TextStyle(
                      fontFamily: 'Mulish',
                      color: AppColor.black_2,
                    ),
                    textStyle: TextStyle(
                      fontFamily: 'Mulish',
                      color: AppColor.black_2,
                    ),
                  ),
                  headerStyle: DateRangePickerHeaderStyle(
                    textStyle: TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w600,
                      color: AppColor.black_2,
                    ),
                  ),
                  selectionTextStyle: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w600,
                    color: AppColor.white,
                  ),
                  rangeTextStyle: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w600,
                    color: AppColor.black_2,
                  ),
                  minDate: DateTime.now(),
                  todayHighlightColor: AppColor.orange_1,
                  selectionColor: AppColor.orange_1,
                  rangeSelectionColor: AppColor.orange_2,
                  startRangeSelectionColor: AppColor.orange_1,
                  endRangeSelectionColor: AppColor.orange_1,
                  // onViewChanged: onDataChangeCalendar,
                  onSelectionChanged: onDataChangeCalendar,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange:
                      PickerDateRange(savedStartDate, savedEndDate),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (startDate != null && endDate != null) {
                      onSubmitCalendar();
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: startDate != null && endDate != null
                          ? AppColor.orange_1
                          : AppColor.grey_2,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'Simpan',
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 16,
                          letterSpacing: -0.3,
                          fontWeight: FontWeight.w600,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

//TODO: INI JADIIN WIDGET SENDIRI AJA NANTI (ADA DIPAKE DIHAL RESERVASI JUGA)
  StatefulBuilder bottomSheetModalPetCount() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setStateModal) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        height: 265,
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Anjing',
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            color: AppColor.black_1,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setStateModal(() {
                          if (dogCount != 0) {
                            dogCount--;
                          }
                        }),
                        child:
                            SvgPicture.asset('assets/icons/ic-decrement.svg'),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      SizedBox(
                        width: 32,
                        child: Center(
                          child: Text(
                            dogCount.toString(),
                            style: TextStyle(
                              fontFamily: 'SF-Pro',
                              color: AppColor.black_1,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () => setStateModal(() {
                          if (dogCount != 99) {
                            dogCount++;
                          }
                        }),
                        child:
                            SvgPicture.asset('assets/icons/ic-increment.svg'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Kucing',
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          color: AppColor.black_1,
                          fontSize: 16,
                        ),
                      )),
                      GestureDetector(
                        onTap: () => setStateModal(() {
                          if (catCount != 0) {
                            catCount--;
                          }
                        }),
                        child:
                            SvgPicture.asset('assets/icons/ic-decrement.svg'),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      SizedBox(
                        width: 32,
                        child: Center(
                          child: Text(
                            catCount.toString(),
                            style: TextStyle(
                              fontFamily: 'SF-Pro',
                              color: AppColor.black_1,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () => setStateModal(() {
                          if (catCount != 99) {
                            catCount++;
                          }
                        }),
                        child:
                            SvgPicture.asset('assets/icons/ic-increment.svg'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        savedCatCount = catCount;
                        savedDogCount = dogCount;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: AppColor.orange_1,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontSize: 16,
                            letterSpacing: -0.3,
                            fontWeight: FontWeight.w600,
                            color: AppColor.white,
                          ),
                        ),
                      ),
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
