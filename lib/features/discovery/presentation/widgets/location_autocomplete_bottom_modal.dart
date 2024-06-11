import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zladag_flutter_app/core/constants/constants.dart';
import 'package:zladag_flutter_app/features/discovery/data/models/sub_models.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/providers/boarding_provider.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';

class LocationAutoCompleteBottomModalWidget extends StatefulWidget {
  final Function getCurrentPosition, setSelectedLocation;
  const LocationAutoCompleteBottomModalWidget(
      {super.key,
      required this.getCurrentPosition,
      required this.setSelectedLocation});

  @override
  State<LocationAutoCompleteBottomModalWidget> createState() =>
      _LocationAutoCompleteBottomModalWidgetState();
}

class _LocationAutoCompleteBottomModalWidgetState
    extends State<LocationAutoCompleteBottomModalWidget> {
  Widget _locationListTile(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      width: double.maxFinite,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColor.black_2,
          fontFamily: 'Mulish',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 14 * -(4 / 100),
        ),
      ),
    );
  }

  List<AutocompletePrediction>? autocompletePrediction;
  LatLng? currLatLng;

  String currSearchValue = '';
  @override
  Widget build(BuildContext context) {
    // print("DEBUG: ${autocompletePrediction}");
    currLatLng = Provider.of<BoardingProvider>(context, listen: true).latLng;

    autocompletePrediction =
        Provider.of<BoardingProvider>(context, listen: true).autoComplete;

    return StatefulBuilder(
      builder: (context, setState) => Container(
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
                    'Pilih Lokasi',
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: TextField(
                autocorrect: false,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black_2,
                  letterSpacing: -0.3,
                ),
                onChanged: (value) => setState(
                  () {
                    currSearchValue = value;
                    debugPrint(currSearchValue);
                    //TODO: AUTOCOMPLETE
                    Provider.of<BoardingProvider>(context, listen: false)
                        .eitherFailureOrAutocomplete(
                            key: googleApikey, query: currSearchValue);
                  },
                ),
                decoration: InputDecoration(
                  prefixIconConstraints: const BoxConstraints(
                    minHeight: 16,
                    minWidth: 16,
                  ),
                  prefixIcon: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 2, left: 8, right: 4),
                    child: SvgPicture.asset(
                      'assets/icons/ic-location.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        currSearchValue == ''
                            ? AppColor.grey_1
                            : AppColor.black_2,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  hintStyle: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.grey_1,
                    letterSpacing: -0.3,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: AppColor.orange_1,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: AppColor.grey_2,
                      width: 1,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: AppColor.grey_2,
                      width: 1,
                    ),
                  ),
                  hintText: 'Cari nama akomodasi, area, dll',
                ),
              ),
            ),

            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                (currSearchValue == ''
                    ? GestureDetector(
                        onTap: () async {
                          widget.getCurrentPosition();
                          Navigator.of(context).pop();
                        },
                        // decoration: BoxDecoration(color: Colors.amberAccent),
                        child: ListTile(
                          horizontalTitleGap: 0,
                          contentPadding: const EdgeInsets.all(0),
                          leading: SvgPicture.asset(
                            'assets/icons/ic-current-location.svg',
                            width: 24,
                            height: 24,
                          ),
                          dense: true,
                          title: Text(
                            'Dekat Saya',
                            style: TextStyle(
                              color: AppColor.black_2,
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 16 * -(4 / 100),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox())
              ],
            ),
            // TODO: AUTO COMPLETE LOCATION
            (currSearchValue == ''
                ? const SizedBox()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: autocompletePrediction != null
                        ? autocompletePrediction!.length
                        : 0,
                    itemBuilder: (context, index) {
                      print('di ${autocompletePrediction!.length}');
                      return GestureDetector(
                        onTap: () async {
                          Provider.of<BoardingProvider>(context, listen: false)
                              .eitherFailureOrLatlng(
                                  locationID:
                                      autocompletePrediction![index].placeId!);
                          print(autocompletePrediction![index].placeId!);
                          widget.setSelectedLocation(
                            locationID: autocompletePrediction![index].placeId!,
                            newLocation:
                                autocompletePrediction![index].description!,
                            // longitude: currLatLng!.longitude,
                            // latitude: currLatLng!.latitude,
                            // required double latitude,
                          );
                          Navigator.pop(context);
                        },
                        child: _locationListTile(autocompletePrediction != null
                            ? autocompletePrediction![index].description!
                            : ''),
                      );
                    },
                  )),

            Spacer(),
          ],
        ),
      ),
    );
  }
}
