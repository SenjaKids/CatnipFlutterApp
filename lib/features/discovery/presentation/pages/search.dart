import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/providers/boarding_provider.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/widgets/filter_form.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/widgets/medium_boarding_card.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/widgets/search_form.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';

// ignore: must_be_immutable
class SearchWidget extends StatefulWidget {
  final BoardingSearchParams boardingSearchParams;
  final int dogQty;
  final int catQty;
  DateTime? startDate;
  DateTime? endDate;
  final String location;
  // final String longitude;
  // final String latitude;
  SearchWidget({
    super.key,
    required this.boardingSearchParams,
    required this.dogQty,
    required this.catQty,
    required this.location,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late BoardingSearchParams boardingSearchParams;
  late int dogQty;
  late int catQty;
  late String location;
  // late BoardingProvider provider;
  late List<BoardingEntity>? boardings;
  String sortByValue = '';
  String bottomPriceRange = 'Rp0';
  String topPriceRange = 'Rp900.000';
  List<String> boardingCategories = [];
  List<String> facilities = [];
  List<String> petCategories = [];

  late DateTime startDate;
  late DateTime endDate;
  @override
  void initState() {
    // provider = Provider.of<BoardingProvider>(context, listen: false);

    // provider.eitherFailureOrSearchedBoardings(
    if (widget.catQty > 0) {
      petCategories.add('cat');
    }
    if (widget.dogQty > 0) {
      petCategories.add('dog');
    }
    Provider.of<BoardingProvider>(context, listen: false)
        .eitherFailureOrSearchedBoardings(
      // latitude: '-82.5866176',
      // longitude: '-103.9723351',
      // latitude: '4.6786904',
      // longitude: '92.6318706',
      latitude: widget.boardingSearchParams.latitude,
      longitude: widget.boardingSearchParams.longitude,
      facilities: widget.boardingSearchParams.boardingFacilities,
      petCategories: petCategories,
    );

    facilities = widget.boardingSearchParams.boardingFacilities ?? [];
    boardingSearchParams = widget.boardingSearchParams;
    dogQty = widget.dogQty;
    catQty = widget.catQty;
    location = widget.location;
    startDate = widget.startDate ?? DateTime.now();
    endDate = widget.endDate ?? DateTime.now().add(const Duration(days: 1));

    super.initState();
  }

  void _reloadProvider() {
    Provider.of<BoardingProvider>(context, listen: false)
        .eitherFailureOrSearchedBoardings(
      // TODO: BALIKIN PARAMETER LATITUDE LONGITUDENYA
      latitude: widget.boardingSearchParams.latitude,
      longitude: widget.boardingSearchParams.longitude,
      sortBy: sortByValue,
      boardingCategories: boardingCategories,
      facilities: facilities,
      petCategories: petCategories,
      bottomPriceRange: bottomPriceRange,
      topPriceRange: topPriceRange,
    );

    debugPrint(
        'reload provider value: $sortByValue $boardingCategories $facilities $bottomPriceRange $topPriceRange $petCategories');
  }

  void setNewFilterValue({
    required String newSortByValue,
    required String newBottomPriceRange,
    required String newTopPriceRange,
    required List<String> newBoardingCategories,
    required List<String> newFacilities,
    required List<String> newPetCategories,
  }) {
    setState(() {
      sortByValue = newSortByValue;
      bottomPriceRange = newBottomPriceRange;
      topPriceRange = newTopPriceRange;
      boardingCategories = newBoardingCategories;
      facilities = newFacilities;
      petCategories = newPetCategories;
    });
    _reloadProvider();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {

    boardings = Provider.of<BoardingProvider>(context, listen: true).boardings;
    debugPrint(boardings.toString());
    // });

    late Widget searchWidget;

    if (boardings != null) {
      if (boardings!.isEmpty) {
        //EMPTY STATE
        searchWidget = Scaffold(
          backgroundColor: const Color.fromARGB(255, 244, 244, 244),
          appBar: _appBarView(context),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.9,
                          minChildSize: 0.4,
                          maxChildSize: 0.9,
                          expand: false,
                          builder: (_, controller) =>
                              _bottomSheetModalFilter(controller),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              width: 1,
                              // color: AppColor.grey_2,
                              color: const Color(0xFFDADADA),
                            )),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic-sort.svg',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Filter',
                              style: TextStyle(
                                color: AppColor.black_2,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                letterSpacing: -0.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        sortByValue = 'nearestLocation';
                        _reloadProvider();
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                            color: sortByValue == 'nearestLocation'
                                ? const Color.fromRGBO(239, 133, 71, 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              width: 1,
                              // color: AppColor.grey_2,
                              color: sortByValue == 'nearestLocation'
                                  ? AppColor.orange_1
                                  : const Color(0xFFDADADA),
                            )),
                        child: Text(
                          'Lokasi Terdekat',
                          style: TextStyle(
                            color: AppColor.black_2,
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            letterSpacing: -0.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        sortByValue = 'lowestPrice';
                        _reloadProvider();
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                            color: sortByValue == 'lowestPrice'
                                ? const Color.fromRGBO(239, 133, 71, 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              width: 1,
                              // color: AppColor.grey_2,
                              color: sortByValue == 'lowestPrice'
                                  ? AppColor.orange_1
                                  : const Color(0xFFDADADA),
                            )),
                        child: Text(
                          'Harga Terendah',
                          style: TextStyle(
                            color: AppColor.black_2,
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            letterSpacing: -0.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Center(
                child: Text('No Data'),
              ),
            ],
          ),
        );
      } else {
        // DATA FOUNDED
        searchWidget = Scaffold(
          backgroundColor: const Color.fromARGB(255, 244, 244, 244),
          appBar: _appBarView(context),
          body: _bodyView(context, boardings),
        );
      }
    } else {
      debugPrint('else');
      searchWidget = Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 244, 244, 244),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColor.orange_1,
          ),
        ),
      );
    }
    return searchWidget;
  }

  AppBar _appBarView(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 82,
      centerTitle: false,
      leadingWidth: 50,
      titleSpacing: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/ic-chev-left.svg',
            height: 28,
            width: 28,
          ),
        ),
      ),
      backgroundColor: AppColor.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Mulish',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColor.black_2,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            // ignore: prefer_interpolation_to_compose_strings
            DateFormat.yMMMd('id_ID').format(startDate) +
                ', ' +
                endDate.difference(startDate).inDays.toString() +
                ' Malam' +
                (dogQty > 0 ? ', ${dogQty.toString()} Anjing' : '') +
                (catQty > 0 ? ', ${catQty.toString()} Kucing' : ''),
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Mulish',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColor.black_2,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
          child: GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (context) => _bottomSheetModalSearch(context),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: AppColor.orange_2,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  'Ubah',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    color: AppColor.orange_1,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _bottomSheetModalFilter(ScrollController controller) {
    return Container(
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
                  'Filter',
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
            height: 14,
          ),
          FilterFormWidget(
            saveValueFunction: setNewFilterValue,
            boardingCategoriesFilterActive: boardingCategories,
            facilitiesFilterActive: facilities,
            petCategoriesFilterActive: petCategories,
            priceTopRange: topPriceRange,
            priceBottomRange: bottomPriceRange,
            sortValue: sortByValue,
          ),
        ],
      ),
    );
  }

  StatefulBuilder _bottomSheetModalSearch(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setStateModal) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        height: 255,
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
                    'Ubah Pencarian',
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
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SearchFormWidget(
                alternativeSearchFunction: searchAndFilterFunction,
                catCount: catQty,
                dogCount: dogQty,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyView(BuildContext context, List<BoardingEntity>? boardings) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.9,
                    minChildSize: 0.4,
                    maxChildSize: 0.9,
                    expand: false,
                    builder: (_, controller) =>
                        _bottomSheetModalFilter(controller),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 1,
                        // color: AppColor.grey_2,
                        color: const Color(0xFFDADADA),
                      )),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic-sort.svg',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: AppColor.black_2,
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          letterSpacing: -0.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                onTap: () => setState(() {
                  sortByValue = 'nearestLocation';
                  _reloadProvider();
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                      color: sortByValue == 'nearestLocation'
                          ? const Color.fromRGBO(239, 133, 71, 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 1,
                        // color: AppColor.grey_2,
                        color: sortByValue == 'nearestLocation'
                            ? AppColor.orange_1
                            : const Color(0xFFDADADA),
                      )),
                  child: Text(
                    'Lokasi Terdekat',
                    style: TextStyle(
                      color: AppColor.black_2,
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      letterSpacing: -0.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                onTap: () => setState(() {
                  sortByValue = 'lowestPrice';
                  _reloadProvider();
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                      color: sortByValue == 'lowestPrice'
                          ? const Color.fromRGBO(239, 133, 71, 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 1,
                        // color: AppColor.grey_2,
                        color: sortByValue == 'lowestPrice'
                            ? AppColor.orange_1
                            : const Color(0xFFDADADA),
                      )),
                  child: Text(
                    'Harga Terendah',
                    style: TextStyle(
                      color: AppColor.black_2,
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      letterSpacing: -0.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: boardings?.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return MediumBoardingCardWidget(
              boardingEntity: boardings![index],
            );
          },
        ),
      ],
    );
  }

  void searchAndFilterFunction({
    required int newCatCount,
    required int newDogCount,
    required String newLocation,
    required DateTime newStartDate,
    required DateTime newEndDate,
  }) {
    setState(() {
      // boardings =
      //     Provider.of<BoardingProvider>(context, listen: true).boardings;

      petCategories = [];
      if (newCatCount > 0) {
        petCategories.add('cat');
      }
      if (newDogCount > 0) {
        petCategories.add('dog');
      }
      location = newLocation;
      catQty = newCatCount;
      dogQty = newDogCount;
      startDate = newStartDate;
      endDate = newEndDate;

      _reloadProvider();
    });
    Navigator.of(context).pop();
  }
}
