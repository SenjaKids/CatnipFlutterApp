import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/reservation_entity.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/sub_entity.dart';
import 'package:zladag_flutter_app/features/reservation/presentation/provider/reservation_provider.dart';
import 'package:zladag_flutter_app/features/shared/formatter/app_formatter.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_button.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_checkbox.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_loading_state.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_radio.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_textfield.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';

class ReservasiWidget extends StatefulWidget {
  final String slug;
  const ReservasiWidget({super.key, required this.slug});

  @override
  State<ReservasiWidget> createState() => _ReservasiWidgetState();
}

class _ReservasiWidgetState extends State<ReservasiWidget> {
  String? accessToken;
  int savedCatCount = 0;
  int savedDogCount = 0;
  int dogCount = 0;
  int catCount = 0;
  DateTime? startDate;
  DateTime? endDate;
  ReservationBoardingDetail? reservationBoardingDetail;

  List<OrderEntity> orders = [];
  DateTime savedStartDate = DateTime.now();
  DateTime savedEndDate = DateTime.now().add(const Duration(days: 1));
  List<String> selectedServicesId = [];
  String selectedCageId = "";
  String selectedPetId = "";
  int totalHotelPrice = 0;
  int totalAddOnPrice = 0;
  int totalPrice = 0;
  bool resetOrder = false;

  void _getSavedAccessToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    const cachedAccessToken = 'CACHED_ACCESS_TOKEN';
    setState(() {
      accessToken = prefs.getString(cachedAccessToken);
      Provider.of<ReservationProvider>(context, listen: false)
          .eitherFailureOrReservationBoardingDetail(
              accessToken: accessToken!, slug: widget.slug, context: context);
      print(accessToken);
    });

    // if (accessToken != null) {
    //   // ignore: use_build_context_synchronously
    //   Provider.of<Reser>(context, listen: false)
    //       .eitherFailureOrUserData(accessToken: accessToken!, context: context);
    // }

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
    reservationBoardingDetail =
        Provider.of<ReservationProvider>(context, listen: true)
            .reservationBoardingDetail;

    totalAddOnPrice = 0;
    print(orders);
    setState(() {
      for (OrderEntity order in orders) {
        if (order.cageEntity!.price != null) {
          totalHotelPrice = order.cageEntity!.price!;
        }
        if (order.boardingServices != null) {
          print('a');
          for (BoardingServiceEntity service in order.boardingServices!) {
            print('b');
            if (service.price != null) {
              print('c');
              totalAddOnPrice = totalAddOnPrice + service.price!;
            }
          }
        }
      }
      totalPrice = totalAddOnPrice + totalHotelPrice;
    });

    if (reservationBoardingDetail == null) {
      return const CatnipLoadingState();
    } else {
      return Scaffold(
        appBar: _appBar(),
        body: _body(),
      );
    }
  }

  AppBar _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/ic-chev-left.svg',
            height: 28,
            width: 28,
            colorFilter: ColorFilter.mode(AppColor.black_2, BlendMode.srcIn),
          ),
        ),
      ),
      title: Text(
        reservationBoardingDetail!.boardingName ?? '',
        style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
      ),
      backgroundColor: AppColor.white,
      elevation: 0,
    );
  }

  Widget _body() {
    return Container(
      decoration: BoxDecoration(color: AppColor.grey_3),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return _bottomSheetModalCalendar();
                          }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tanggal',
                                  style: TextStyle(
                                    fontFamily: 'SF-Pro',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColor.grey_1,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${DateFormat.MMMd('id_ID').format(savedStartDate)} - ${DateFormat.MMMd('id_ID').format(savedEndDate)}',
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    letterSpacing: 0.12,
                                    color: AppColor.black_2,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/icons/ic-add.svg',
                              width: 16,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                AppColor.orange_1,
                                BlendMode.srcIn,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          dogCount = savedDogCount;
                          catCount = savedCatCount;
                        });
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => bottomSheetModalPetCount());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Anabul',
                                  style: TextStyle(
                                    fontFamily: 'SF-Pro',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColor.grey_1,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$savedCatCount Kucing $savedDogCount Anjing',
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    letterSpacing: 0.12,
                                    color: AppColor.black_2,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/icons/ic-add.svg',
                              width: 16,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                AppColor.orange_1,
                                BlendMode.srcIn,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
                padding: const EdgeInsets.only(bottom: 12),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index < savedCatCount) {
                    return _petOrderFormContainer('Kucing', index + 1, index);
                  } else {
                    return _petOrderFormContainer(
                        'Anjing', index + 1 - savedCatCount, index);
                  }
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: savedCatCount + savedDogCount),
            _orderSummaryContainer(),
          ],
        ),
      ),
    );
  }

  Widget _petOrderFormContainer(
      String petCategory, int petCategoryCount, int position) {
    if (resetOrder) {
      orders = [];
      orders.add(OrderEntity(
          id: null,
          checkInDate: null,
          checkOutDate: null,
          status: null,
          boardingEntity: null,
          petEntity: null,
          cageEntity: CageEntity("", null, null, null, null, null),
          boardingServices: [],
          note: "",
          totalLodgingPrice: null,
          totalAddOnPrice: null,
          serviceFee: null,
          totalAllPrice: null));
      resetOrder = false;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: AppColor.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$petCategory $petCategoryCount',
            style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Pilih Profil',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.14,
                  color: AppColor.black_2,
                  height: 1.5,
                ),
              ),
              const SizedBox(width: 4),
              const Text('*'),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return _bottomSheetPilihAnabul(petCategory, position);
                }),
            child: (orders[position].petEntity == null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(
                        color: AppColor.grey_3,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pilih Profil Anabul',
                          style: TextStyle(
                            color: AppColor.black_2,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          'assets/icons/ic-add.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            AppColor.black_2,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  )
                : _petContainer(
                    petCategory, orders[position].petEntity, position)),
          ),
          const SizedBox(height: 16),
          Divider(
            color: AppColor.grey_3,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          Text(
            'Kandang',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.14,
              color: AppColor.black_2,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 7),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => CatnipRadio(
                    onTap: () => setState(() {
                      selectedCageId =
                          reservationBoardingDetail!.cageEntities![index].id!;
                      orders[position].cageEntity =
                          reservationBoardingDetail!.cageEntities![index];
                      print(
                          reservationBoardingDetail!.cageEntities![index].id!);
                      print(orders[position].cageEntity!.id);
                    }),
                    isActive: selectedCageId ==
                        reservationBoardingDetail!.cageEntities![index].id!
                            .toString(),
                    primaryLabel: reservationBoardingDetail!
                        .cageEntities![index].name
                        .toString(),
                    secondaryLabel:
                        'Rp${AppFormatter().formatNumberToCurrency(reservationBoardingDetail!.cageEntities![index].price!)}',
                    radioIconSize: 20,
                  ),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 16,
                  ),
              itemCount: reservationBoardingDetail!.cageEntities!.length),
          const SizedBox(height: 16),
          Divider(
            color: AppColor.grey_3,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          Text(
            'Add-on Service',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.14,
              color: AppColor.black_2,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 7),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => CatnipCheckbox(
                    onClick: () {
                      // if (orders[position].boardingServices)
                      setState(() {
                        if (selectedServicesId.contains(
                            reservationBoardingDetail!
                                .boardingServices![index].id)) {
                          selectedServicesId.remove(reservationBoardingDetail!
                              .boardingServices![index].id!);
                          orders[position].boardingServices!.remove(
                              reservationBoardingDetail!
                                  .boardingServices![index]);
                          print(selectedServicesId);
                          print(orders[position].boardingServices!);
                        } else {
                          selectedServicesId.add(reservationBoardingDetail!
                              .boardingServices![index].id!);
                          orders[position].boardingServices!.add(
                              reservationBoardingDetail!
                                  .boardingServices![index]);
                          print(selectedServicesId);
                          print(orders[position].boardingServices!);
                        }
                      });
                    },
                    primaryLabel: reservationBoardingDetail!
                        .boardingServices![index].name
                        .toString(),
                    secondaryLabel:
                        'Rp${AppFormatter().formatNumberToCurrency(reservationBoardingDetail!.boardingServices![index].price!)}',
                    checkboxIconSize: 20,
                    catnipCheckboxType: CatnipCheckboxType.seperatedKeyValue,
                  ),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 16,
                  ),
              itemCount: reservationBoardingDetail!.boardingServices!.length),
          const SizedBox(height: 16),
          Divider(
            color: AppColor.grey_3,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 16),
          Text(
            'Tulis Pesan',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.14,
              color: AppColor.black_2,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 7),
          CatnipTextfield(
            onChanged: (value) => setState(() {
              orders[position].note = value;
              print(orders[position].note);
            }),
            hint: 'What do you like us to know?',
            maxLines: 3,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 13.5, horizontal: 16),
          ),
        ],
      ),
    );
  }

  Widget _orderSummaryContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      decoration: BoxDecoration(color: AppColor.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Total Harga Penginapan (${savedCatCount + savedDogCount} anabul)',
                style: AppTextStyle(color: AppColor.grey_1).mulishBodyS(),
              ),
              const Spacer(),
              Text(
                'Rp${AppFormatter().formatNumberToCurrency(totalHotelPrice)}',
                style: AppTextStyle(color: AppColor.black_2).mulishBodyS(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Total Add-on Service',
                style: AppTextStyle(color: AppColor.grey_1).mulishBodyS(),
              ),
              const Spacer(),
              Text(
                'Rp${AppFormatter().formatNumberToCurrency(totalAddOnPrice)}',
                style: AppTextStyle(color: AppColor.black_2).mulishBodyS(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: AppColor.grey_3,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Total Pemesanan',
                style: AppTextStyle(color: AppColor.black_2).mulishBodyS(),
              ),
              const Spacer(),
              Text(
                'Rp${AppFormatter().formatNumberToCurrency(totalPrice)}',
                style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: AppColor.grey_3,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 12),
          CatnipButton(
            label: 'Pesan Sekarang',
            onTap: () {
              print(orders);
              Provider.of<ReservationProvider>(context, listen: false)
                  .eitherFailureOrPostOrderSuccess(
                      accessToken: accessToken!,
                      postOrderBody: PostOrderBody(
                          slug: widget.slug,
                          checkInDate: savedStartDate.toString().substring(
                              0, savedStartDate.toString().indexOf(' ')),
                          checkOutDate: savedEndDate.toString().substring(
                              0, savedEndDate.toString().indexOf(' ')),
                          orders: orders),
                      context: context);
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

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
                        resetOrder = true;
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

  StatefulBuilder _bottomSheetModalCalendar() {
    void onSubmitCalendar() {
      debugPrint(savedStartDate.toString());
      debugPrint(savedStartDate
          .toString()
          .substring(0, savedStartDate.toString().indexOf(' ')));
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

  StatefulBuilder _bottomSheetPilihAnabul(String petCategory, int position) {
    return StatefulBuilder(
      builder: (context, setState) {
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
                      'Pilih Profil Anabul',
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/tambah_anabul'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          border: Border.all(
                            color: AppColor.grey_3,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic-add.svg',
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                AppColor.black_2,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Tambah Anabul Baru',
                              style: TextStyle(
                                color: AppColor.black_2,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    reservationBoardingDetail!.catPetEntities!.length +
                                reservationBoardingDetail!
                                    .dogPetEntities!.length >
                            0
                        ? Column(
                            children: [
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'atau pilih anabul yang sudah ada',
                                  style: AppTextStyle(color: AppColor.grey_1)
                                      .mulishBodyS(),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          )
                        : const SizedBox(),
                    ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          dogCount = -1;
                          dogCount++;
                          return _petContainer(
                              null,
                              //TODO: ATUR BIAR YANG KELUAR ANJING DOANK ATO KUCING DOANK SAMA KASI LIAT DISABLED
                              index < savedCatCount && petCategory == 'Kucing'
                                  ? (reservationBoardingDetail!
                                          .catPetEntities!.isNotEmpty
                                      ? reservationBoardingDetail!
                                          .catPetEntities![index]
                                      : null)
                                  : (reservationBoardingDetail!
                                          .dogPetEntities!.isNotEmpty
                                      ? reservationBoardingDetail!
                                          .dogPetEntities![dogCount]
                                      : null),
                              position);
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 8,
                            ),
                        itemCount: reservationBoardingDetail!
                                .catPetEntities!.length +
                            reservationBoardingDetail!.dogPetEntities!.length),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? _petContainer(
      String? petCategory, PetEntity? petEntity, int position) {
    if (petEntity == null) {
      return null;
    }
    return GestureDetector(
      onTap: () {
        if (petCategory == null) {
          setState(() {
            selectedPetId = petEntity.id!;
            orders[position].petEntity = petEntity;
          });
          print(orders[position].petEntity!.id);
          print(orders[position]);

          Navigator.pop(context);
        } else {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return _bottomSheetPilihAnabul(petCategory, position);
              });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: AppColor.grey_3,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                'https://picsum.photos/200/300',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  petEntity.name.toString(),
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    height: 1.5,
                    letterSpacing: 0.16,
                    color: AppColor.black_2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${petEntity.petBreed} · ${petEntity.age! < 12 ? "${petEntity.age} Bulan" : "${petEntity.age! ~/ 12} Tahun"}',
                  style: AppTextStyle(color: AppColor.grey_1).mulishBodyS(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
