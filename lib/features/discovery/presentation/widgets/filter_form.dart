import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/widgets/input_capsule.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/widgets/input_seperated_checkbox.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/widgets/input_seperated_togle.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/widgets/input_square.dart';
import 'package:zladag_flutter_app/features/shared/formatter/price_input_formatter.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

// ignore: must_be_immutable
class FilterFormWidget extends StatefulWidget {
  String sortValue = '';
  String priceBottomRange = '';
  String priceTopRange = '';
  List<String> facilitiesFilterActive = [];
  List<String> boardingCategoriesFilterActive = [];
  List<String> petCategoriesFilterActive = [];
  final Function saveValueFunction;
  FilterFormWidget({
    super.key,
    required this.saveValueFunction,
    required this.sortValue,
    required this.boardingCategoriesFilterActive,
    required this.facilitiesFilterActive,
    required this.petCategoriesFilterActive,
    required this.priceBottomRange,
    required this.priceTopRange,
  });

  // const FilterFormWidget({super.key});
  @override
  State<FilterFormWidget> createState() => _FilterFormWidgetState();
}

class _FilterFormWidgetState extends State<FilterFormWidget> {
  final TextEditingController _topRangeController = TextEditingController();
  final TextEditingController _bottomRangeController = TextEditingController();

  @override
  void initState() {
    _topRangeController.text = widget.priceTopRange;
    _bottomRangeController.text = widget.priceBottomRange;
    super.initState();
  }
  // String sortValue = '';
  // String priceBottomRange = '';
  // String priceTopRange = '';
  // List<String> facilitiesFilterActive = [];
  // List<String> boardingCategoriesFilterActive = [];
  // List<String> petCategoriesFilterActive = [];

  void setFacilitiesValue(String value) {
    setState(() {
      if (widget.facilitiesFilterActive.contains(value)) {
        widget.facilitiesFilterActive.remove(value);
      } else {
        widget.facilitiesFilterActive.add(value);
      }

      debugPrint(widget.facilitiesFilterActive.toString());
    });
  }

  void setBoardingCategoriesValue(String value) {
    setState(() {
      if (widget.boardingCategoriesFilterActive.contains(value)) {
        widget.boardingCategoriesFilterActive.remove(value);
      } else {
        widget.boardingCategoriesFilterActive.add(value);
      }

      debugPrint(widget.boardingCategoriesFilterActive.toString());
    });
  }

  void setPetCategoriesValue(String value) {
    setState(() {
      if (widget.petCategoriesFilterActive.contains(value)) {
        widget.petCategoriesFilterActive.remove(value);
      } else {
        widget.petCategoriesFilterActive.add(value);
      }

      debugPrint(widget.petCategoriesFilterActive.toString());
    });
  }

  void setSortValue(String value) {
    setState(() {
      widget.sortValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _sortContainerView(),
                    _dividerView(color: null),
                    _priceRangeContainerView(),
                    _dividerView(color: null),
                    _categoryContainerView(),
                    _dividerView(color: null),
                    _facilityContainerView(),
                    _dividerView(color: AppColor.grey_2),
                    _petCategoryContainerView(),
                    const SizedBox(
                      height: 104,
                    ),
                  ],
                ),
              ),
            ],
          ),
          widget.sortValue != '' ||
                  widget.facilitiesFilterActive.isNotEmpty ||
                  widget.boardingCategoriesFilterActive.isNotEmpty ||
                  widget.petCategoriesFilterActive.isNotEmpty ||
                  (widget.priceBottomRange != '' && widget.priceTopRange != '')
              ? Column(
                  children: [
                    const Spacer(),
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          widget.saveValueFunction(
                            newSortByValue: widget.sortValue,
                            newBottomPriceRange: widget.priceBottomRange,
                            newTopPriceRange: widget.priceTopRange,
                            newBoardingCategories:
                                widget.boardingCategoriesFilterActive,
                            newFacilities: widget.facilitiesFilterActive,
                            newPetCategories: widget.petCategoriesFilterActive,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColor.orange_1,
                          ),
                          child: Text(
                            'Simpan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.3,
                              fontFamily: 'SF-Pro',
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _petCategoryContainerView() {
    return Column(
      children: [
        InputSeperatedTogleWidget(
          text: 'Khusus Anjing',
          value: 'dog',
          checkboxGroupValue: widget.petCategoriesFilterActive,
          setGroupValueFunction: setPetCategoriesValue,
        ),
        const SizedBox(
          height: 24,
        ),
        InputSeperatedTogleWidget(
          text: 'Khusus Kucing',
          value: 'cat',
          checkboxGroupValue: widget.petCategoriesFilterActive,
          setGroupValueFunction: setPetCategoriesValue,
        ),
      ],
    );
  }

  Widget _facilityContainerView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fasilitas',
          style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            Expanded(
              child: InputSquareWidget(
                  text: 'Tempat Bermain',
                  iconName: 'Playground',
                  value: 'playground',
                  checkboxGroupValue: widget.facilitiesFilterActive,
                  setGroupValueFunction: setFacilitiesValue),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: InputSquareWidget(
                  text: 'Ruangan Ber-AC',
                  iconName: 'AC',
                  value: 'ac',
                  checkboxGroupValue: widget.facilitiesFilterActive,
                  setGroupValueFunction: setFacilitiesValue),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: InputSquareWidget(
                  text: 'CCTV',
                  value: 'cctv',
                  iconName: 'CCTV',
                  checkboxGroupValue: widget.facilitiesFilterActive,
                  setGroupValueFunction: setFacilitiesValue),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: InputSquareWidget(
                  text: 'Termasuk Makanan',
                  iconName: 'Food',
                  value: 'food',
                  checkboxGroupValue: widget.facilitiesFilterActive,
                  setGroupValueFunction: setFacilitiesValue),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: InputSquareWidget(
                  text: 'Antar\nJemput',
                  iconName: 'Delivery',
                  value: 'delivery',
                  checkboxGroupValue: widget.facilitiesFilterActive,
                  setGroupValueFunction: setFacilitiesValue),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: InputSquareWidget(
                  text: 'Grooming',
                  value: 'grooming',
                  iconName: 'Grooming',
                  checkboxGroupValue: widget.facilitiesFilterActive,
                  setGroupValueFunction: setFacilitiesValue),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: InputSquareWidget(
                  text: 'Dokter Hewan',
                  iconName: 'Veterinary',
                  value: 'veterinary',
                  checkboxGroupValue: widget.facilitiesFilterActive,
                  setGroupValueFunction: setFacilitiesValue),
            ),
            const SizedBox(
              width: 8,
            ),
            const Expanded(
              child: SizedBox(),
            ),
            const SizedBox(
              width: 8,
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _categoryContainerView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori',
          style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
        ),
        const SizedBox(
          height: 24,
        ),
        Column(
          children: [
            InputSeperatedCheckboxWidget(
              text: 'Pet Hotel',
              value: 'petHotel',
              setGroupValueFunction: setBoardingCategoriesValue,
              checkboxGroupValue: widget.boardingCategoriesFilterActive,
            ),
            const SizedBox(
              height: 24,
            ),
            InputSeperatedCheckboxWidget(
              text: 'Pet Shop',
              value: 'petShop',
              checkboxGroupValue: widget.boardingCategoriesFilterActive,
              setGroupValueFunction: setBoardingCategoriesValue,
            ),
            const SizedBox(
              height: 24,
            ),
            InputSeperatedCheckboxWidget(
              text: 'Rumah Sakit Hewan',
              value: 'petHospital',
              checkboxGroupValue: widget.boardingCategoriesFilterActive,
              setGroupValueFunction: setBoardingCategoriesValue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _dividerView({Color? color}) {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Divider(
          thickness: 1,
          height: 1,
          color: color ?? const Color.fromARGB(255, 235, 235, 235),
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }

  Widget _priceRangeContainerView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rentang Harga',
          style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _bottomRangeController,
                style: AppTextStyle(color: AppColor.black_2).mulishBodyS(),
                autocorrect: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PriceInputFormatter(),
                  LengthLimitingTextInputFormatter(12),
                ],
                onChanged: (value) => setState(() {
                  widget.priceBottomRange = value;
                }),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Rp0',
                  hintStyle: AppTextStyle(color: AppColor.grey_1).mulishBodyS(),
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.orange_1,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.grey_2,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.grey_2,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 16,
              child: Divider(
                thickness: 1,
                height: 1,
                color: AppColor.grey_2,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _topRangeController,
                autocorrect: false,
                style: AppTextStyle(color: AppColor.black_2).mulishBodyS(),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PriceInputFormatter(),
                  LengthLimitingTextInputFormatter(12),
                ],
                onChanged: (value) => setState(() {
                  widget.priceTopRange = value;
                }),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Rp0',
                  hintStyle: AppTextStyle(color: AppColor.grey_1).mulishBodyS(),
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.orange_1,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.grey_2,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.grey_2,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sortContainerView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Urutkan',
          style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            Expanded(
              child: InputCapsuleWidget(
                text: 'Lokasi Terdekat',
                value: 'nearestLocation',
                radioGroupValue: widget.sortValue,
                setGroupValueFunction: setSortValue,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => widget.sortValue = 'lowestPrice',
                child: InputCapsuleWidget(
                  text: 'Harga Terendah',
                  value: 'lowestPrice',
                  radioGroupValue: widget.sortValue,
                  setGroupValueFunction: setSortValue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => widget.sortValue = 'highestPrice',
                child: InputCapsuleWidget(
                  text: 'Harga Tertinggi',
                  value: 'highestPrice',
                  radioGroupValue: widget.sortValue,
                  setGroupValueFunction: setSortValue,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ],
    );
  }
}
