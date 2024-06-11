import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// import 'package:row_overflow_count/row_overflow_count.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_button.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_checkbox.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_radio.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_textfield.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/user/presentation/providers/auth_provider.dart';
import 'package:zladag_flutter_app/features/user/presentation/widgets/input_dropdown_checkbox.dart';
import 'package:zladag_flutter_app/features/user/presentation/widgets/input_radio_square.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/widgets/input_square.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

class TambahAnabulWidget extends StatefulWidget {
  const TambahAnabulWidget({super.key});

  @override
  State<TambahAnabulWidget> createState() => _TambahAnabulWidgetState();
}

class _TambahAnabulWidgetState extends State<TambahAnabulWidget> {
  // int currPageState = 3;
  File? petImage;
  String petNameValue = "";
  String spesiesValue = "";
  String jenisKelaminValue = "";
  String petBreedId = "";
  String petBreedName = "";
  int petAgeValue = 0;
  double petBodyMassValue = 0;
  bool isSteril = false;
  bool isObatKutu = false;
  bool isVaksin = false;
  String historyOfIllness = '';
  PetBreedsAndHabitsEntities? catBreedsAndHabits;
  PetBreedsAndHabitsEntities? dogBreedsAndHabits;
  List<String> selectedHabitsName = [];
  List<String> selectedHabitsId = [];
  // List<String>? catHabits, dogHabits;
  List<String> facilitiesFilterActive = [];
  String? accessToken;

  bool canSaveData = true;
  String? nameFieldError,
      spesiesFieldError,
      jenisKelaminFieldError,
      beratFieldError,
      umurFieldError,
      rasFieldError;

  Future pickImage() async {
    try {
      print('picking image');
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      print('image');
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => petImage = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _setPetBreed({required String id, required String name}) {
    setState(() {
      petBreedId = id;
      petBreedName = name;
    });
  }

  void _checkDataField() {
    nameFieldError = null;
    spesiesFieldError = null;
    jenisKelaminFieldError = null;
    beratFieldError = null;
    umurFieldError = null;
    rasFieldError = null;

    if (petNameValue.isEmpty) {
      setState(() {
        canSaveData = false;
        nameFieldError = "Nama harus diisi";
      });
    } else if (petNameValue.length > 20) {
      setState(() {
        canSaveData = false;
        nameFieldError = "Nama maksimal 20 karakter";
      });
    }

    if (spesiesValue.isEmpty) {
      setState(() {
        canSaveData = false;
        spesiesFieldError = "Pilih spesies anabul";
      });
    }
    if (jenisKelaminValue.isEmpty) {
      setState(() {
        canSaveData = false;
        jenisKelaminFieldError = "Pilih jenis kelamin anabul";
      });
    }
    if (petBodyMassValue == 0) {
      setState(() {
        canSaveData = false;
        beratFieldError = "Berat harus diisi";
      });
    }
    if (petAgeValue == 0) {
      setState(() {
        canSaveData = false;
        umurFieldError = "Umur harus diisi";
      });
    }

    if (petBreedId.isEmpty) {
      setState(() {
        canSaveData = false;
        rasFieldError = "Pilih ras anabul";
      });
    }
  }

  void setFacilitiesValue(String value) {
    setState(() {
      if (facilitiesFilterActive.contains(value)) {
        facilitiesFilterActive.remove(value);
      } else {
        facilitiesFilterActive.add(value);
      }
      debugPrint(facilitiesFilterActive.toString());
    });
  }

  void setSpesiesGroupValue(String value) {
    setState(() {
      spesiesValue = value;
    });
  }

  void setJenisKelaminGroupValue(String value) {
    setState(() {
      jenisKelaminValue = value;
    });
  }

  void _getSavedAccessToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    const cachedAccessToken = 'CACHED_ACCESS_TOKEN';
    setState(() {
      accessToken = prefs.getString(cachedAccessToken);
    });
    // ignore: use_build_context_synchronously
    Provider.of<AuthProvider>(context, listen: false)
        .eitherFailureOrBreedsAndHabits(
            accessToken: accessToken!, context: context, petCategory: 'cat');
    // ignore: use_build_context_synchronously
    Provider.of<AuthProvider>(context, listen: false)
        .eitherFailureOrBreedsAndHabits(
            accessToken: accessToken!, context: context, petCategory: 'dog');

    // print("token saved $accessToken");
  }

  void savePetData() {
    canSaveData = true;
    print(
        '$petBreedId $petNameValue $spesiesValue $jenisKelaminValue $petBodyMassValue $petAgeValue $isSteril $isObatKutu $isVaksin $facilitiesFilterActive $selectedHabitsId $historyOfIllness');
    _checkDataField();

    if (canSaveData) {
      print('lewat');
      Provider.of<AuthProvider>(context, listen: false)
          .eitherFailureOrSavePetDataSuccess(
              accessToken: accessToken!,
              postPetDataBody: PostPetDataBody(
                //TODO: PETBREED BELON
                petBreedId: petBreedId,
                petGender: jenisKelaminValue,
                name: petNameValue,
                age: petAgeValue,
                bodyMass: petBodyMassValue,
                hasBeenSterilized: isSteril,
                hasBeenVaccinatedRoutinely: isVaksin,
                hasBeenFleaFreeRegularly: isObatKutu,
                historyOfIllness: historyOfIllness,
                boardingFacilities: facilitiesFilterActive,
                petHabitIds: selectedHabitsId,
                //TODO: IMAGE MASIH NULL
                image: petImage,
              ),
              context: context);
    }
  }

  @override
  void initState() {
    _getSavedAccessToken(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    catBreedsAndHabits =
        Provider.of<AuthProvider>(context, listen: true).catBreedsAndHabits;
    dogBreedsAndHabits =
        Provider.of<AuthProvider>(context, listen: true).dogBreedsAndHabits;
    // print(ca);
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 24,
              ),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: () => pickImage(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(48),
                      child: petImage != null
                          ? Image.file(
                              petImage!,
                              fit: BoxFit.cover,
                              width: 96,
                              height: 96,
                            )
                          : Image.asset(
                              'assets/images/default-pet-profile.png',
                              fit: BoxFit.cover,
                              width: 96,
                              height: 96,
                            ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48),
                      color: AppColor.orange_1,
                    ),
                    //TODO: ICON BELOM FIX DARI DESIGN
                    child: SvgPicture.asset(
                      "assets/icons/ic-location.svg",
                      width: 16,
                      height: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  Text(
                    "Informasi Pet",
                    style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    "Nama",
                    style: AppTextStyle(color: AppColor.black_2).mulishBodyM(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "*",
                    style: AppTextStyle(color: AppColor.red).mulishBodyM(),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              CatnipTextfield(
                hint: 'Nama anabul mu?',
                hintTextStyle:
                    AppTextStyle(color: AppColor.grey_1).sfproBodyS(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13.5),
                onChanged: (value) => setState(
                  () {
                    petNameValue = value;
                  },
                ),
                borderColor:
                    nameFieldError != null ? AppColor.red : Colors.transparent,
              ),
              (nameFieldError != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            nameFieldError!,
                            style:
                                AppTextStyle(color: AppColor.red).mulishBodyS(),
                          )
                        ],
                      ),
                    )
                  : const SizedBox()),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    "Spesies",
                    style: AppTextStyle(color: AppColor.black_2).mulishBodyM(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "*",
                    style: AppTextStyle(color: AppColor.red).mulishBodyM(),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputRadioSquareWidget(
                      text: "Anjing",
                      value: "dog",
                      radioGroupValue: spesiesValue,
                      setGroupValueFunction: setSpesiesGroupValue,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: InputRadioSquareWidget(
                      text: "Kucing",
                      value: "cat",
                      radioGroupValue: spesiesValue,
                      setGroupValueFunction: setSpesiesGroupValue,
                    ),
                  ),
                ],
              ),
              (spesiesFieldError != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            spesiesFieldError!,
                            style:
                                AppTextStyle(color: AppColor.red).mulishBodyS(),
                          )
                        ],
                      ),
                    )
                  : const SizedBox()),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    "Ras",
                    style: AppTextStyle(color: AppColor.black_2).mulishBodyM(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "*",
                    style: AppTextStyle(color: AppColor.red).mulishBodyM(),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.grey_3,
                  border: rasFieldError != null
                      ? Border.all(color: AppColor.red)
                      : null,
                ),
                child: GestureDetector(
                  onTap: () => showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => _rasBottomModal(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            petBreedId.isEmpty ? 'Pilih Ras' : petBreedName,
                            style: AppTextStyle(
                                    color: petBreedId.isEmpty
                                        ? AppColor.grey_1
                                        : AppColor.black_2)
                                .sfproBodyS(),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/icons/ic-chev-bottom.svg',
                          colorFilter: ColorFilter.mode(
                              AppColor.grey_1, BlendMode.srcIn),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              (rasFieldError != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            rasFieldError!,
                            style:
                                AppTextStyle(color: AppColor.red).mulishBodyS(),
                          )
                        ],
                      ),
                    )
                  : const SizedBox()),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    "Jenis Kelamin",
                    style: AppTextStyle(color: AppColor.black_2).mulishBodyM(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "*",
                    style: AppTextStyle(color: AppColor.red).mulishBodyM(),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputRadioSquareWidget(
                      text: "Betina",
                      value: "female",
                      radioGroupValue: jenisKelaminValue,
                      setGroupValueFunction: setJenisKelaminGroupValue,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: InputRadioSquareWidget(
                      text: "Jantan",
                      value: "male",
                      radioGroupValue: jenisKelaminValue,
                      setGroupValueFunction: setJenisKelaminGroupValue,
                    ),
                  ),
                ],
              ),
              (jenisKelaminFieldError != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            jenisKelaminFieldError!,
                            style:
                                AppTextStyle(color: AppColor.red).mulishBodyS(),
                          )
                        ],
                      ),
                    )
                  : const SizedBox()),
              const SizedBox(
                height: 24,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Umur",
                              style: AppTextStyle(color: AppColor.black_2)
                                  .mulishBodyM(),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "*",
                              style: AppTextStyle(color: AppColor.red)
                                  .mulishBodyM(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                              color: AppColor.grey_3,
                              borderRadius: BorderRadius.circular(8),
                              border: umurFieldError != null
                                  ? Border.all(color: AppColor.red)
                                  : null),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) => setState(() {
                                    if (value.isEmpty) {
                                      petAgeValue = 0;
                                    } else {
                                      petAgeValue = int.parse(value);
                                    }
                                  }),
                                  style: AppTextStyle(color: AppColor.black_2)
                                      .sfproBodyS(),
                                  decoration: InputDecoration(
                                    hintText: '0',
                                    hintStyle:
                                        AppTextStyle(color: AppColor.grey_1)
                                            .sfproBodyS(),
                                    contentPadding: const EdgeInsets.all(0),
                                    filled: true,
                                    isDense: true,
                                    fillColor: Colors.transparent,
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                              Text(
                                'Bulan',
                                style: AppTextStyle(color: AppColor.blue_1)
                                    .sfproBodyS(),
                              ),
                            ],
                          ),
                        ),
                        (umurFieldError != null
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      umurFieldError!,
                                      style: AppTextStyle(color: AppColor.red)
                                          .mulishBodyS(),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox()),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Berat",
                              style: AppTextStyle(color: AppColor.black_2)
                                  .mulishBodyM(),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "*",
                              style: AppTextStyle(color: AppColor.red)
                                  .mulishBodyM(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                              color: AppColor.grey_3,
                              borderRadius: BorderRadius.circular(8),
                              border: beratFieldError != null
                                  ? Border.all(color: AppColor.red)
                                  : null),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  inputFormatters: [
                                    // FilteringTextInputFormatter.digitsOnly,
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,1}')),
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      final text = newValue.text;
                                      return text.isEmpty
                                          ? newValue
                                          : double.tryParse(text) == null
                                              ? oldValue
                                              : newValue;
                                    }),
                                  ],
                                  onChanged: (value) => setState(() {
                                    if (value.isEmpty) {
                                      petBodyMassValue = 0;
                                    } else {
                                      petBodyMassValue = double.parse(value);
                                    }
                                  }),
                                  style: AppTextStyle(color: AppColor.black_2)
                                      .sfproBodyS(),
                                  decoration: InputDecoration(
                                    hintText: '0.0',
                                    hintStyle:
                                        AppTextStyle(color: AppColor.grey_1)
                                            .sfproBodyS(),
                                    contentPadding: const EdgeInsets.all(0),
                                    filled: true,
                                    isDense: true,
                                    fillColor: Colors.transparent,
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                              Text(
                                'Kg',
                                style: AppTextStyle(color: AppColor.blue_1)
                                    .sfproBodyS(),
                              ),
                            ],
                          ),
                        ),
                        (beratFieldError != null
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      beratFieldError!,
                                      style: AppTextStyle(color: AppColor.red)
                                          .mulishBodyS(),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox()),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CatnipCheckbox(
                primaryLabel: 'Sudah steril',
                primaryLabelTextStyle:
                    AppTextStyle(color: AppColor.black_2).mulishBodyM(),
                catnipCheckboxType: CatnipCheckboxType.seperated,
                checkboxIconSize: 20,
                onClick: () => setState(() {
                  isSteril = !isSteril;
                }),
              ),
              const SizedBox(height: 24),
              CatnipCheckbox(
                primaryLabel: 'Rutin menggunakan obat kutu',
                primaryLabelTextStyle:
                    AppTextStyle(color: AppColor.black_2).mulishBodyM(),
                catnipCheckboxType: CatnipCheckboxType.seperated,
                checkboxIconSize: 20,
                onClick: () => setState(() {
                  isObatKutu = !isObatKutu;
                }),
              ),
              const SizedBox(height: 24),
              CatnipCheckbox(
                primaryLabel: 'Rutin vaksinasi',
                primaryLabelTextStyle:
                    AppTextStyle(color: AppColor.black_2).mulishBodyM(),
                catnipCheckboxType: CatnipCheckboxType.seperated,
                checkboxIconSize: 20,
                onClick: () => setState(() {
                  isVaksin = !isVaksin;
                }),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Text(
                    "Preferensi Pet",
                    style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _facilityContainerView(),
              const SizedBox(height: 40),
              Row(
                children: [
                  Text(
                    "Kebiasaan Pet",
                    style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              //TODO: CAPSULE SELECTED LIST
              // RowOverflowCount(
              //   labels: selectedHabitsName,
              //   labelTextStyle:
              //       AppTextStyle(color: AppColor.white).mulishBodyXS(),
              //   labelPadding:
              //       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   labelMargin: const EdgeInsets.only(right: 4),
              //   labelDecoration: BoxDecoration(
              //     color: AppColor.blue_1,
              //     borderRadius: BorderRadius.circular(4),
              //   ),
              //   overflowMargin: const EdgeInsets.only(left: 4),
              //   overflowTextBuilder: (int count) => "+ $count lainnya",
              //   overflowPadding:
              //       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   overflowDecoration: BoxDecoration(
              //     color: AppColor.blue_1,
              //     borderRadius: BorderRadius.circular(4),
              //   ),
              //   overflowTextStyle:
              //       AppTextStyle(color: AppColor.white).mulishBodyXS(),
              // ),
              // const SizedBox(height: 10),
              InputDropdownCheckbox(
                habits: spesiesValue == 'dog'
                    ? (dogBreedsAndHabits != null
                        ? dogBreedsAndHabits!.petHabitEntities
                        : [])
                    : (catBreedsAndHabits != null
                        ? catBreedsAndHabits!.petHabitEntities
                        : []),
                onTap: (String selectedId, String selectedName) => setState(() {
                  if (selectedHabitsId.contains(selectedId)) {
                    selectedHabitsId.remove(selectedId);
                  } else {
                    selectedHabitsId.add(selectedId);
                  }
                  if (selectedHabitsName.contains(selectedName)) {
                    selectedHabitsName.remove(selectedName);
                  } else {
                    selectedHabitsName.add(selectedName);
                  }
                  print(selectedHabitsName);
                }),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Text(
                    "Riwayat Penyakit",
                    style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => setState(() {
                  historyOfIllness = value;
                }),
                autocorrect: false,
                maxLines: 5,
                style: AppTextStyle(color: AppColor.black_2).sfproBodyS(),
                decoration: InputDecoration(
                  hintText: 'Siapa nama anabul mu?',
                  hintStyle: AppTextStyle(color: AppColor.grey_1).sfproBodyS(),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 13.5),
                  filled: true,
                  isDense: true,
                  fillColor: AppColor.grey_3,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(
                height: 49,
              ),
              CatnipButton(
                label: 'Simpan',
                onTap: () => savePetData(),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     vertical: 10,
              //   ),
              //   width: double.maxFinite,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(4),
              //     color: AppColor.orange_1,
              //   ),
              //   child: Center(
              //     child: Text(
              //       'Simpan',
              //       style: TextStyle(
              //         fontFamily: 'Mulish',
              //         fontSize: 16,
              //         fontWeight: FontWeight.w700,
              //         letterSpacing: -0.3,
              //         color: AppColor.white,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0,
      leading: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset(
            'assets/icons/ic-chev-left.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(AppColor.black_2, BlendMode.srcIn),
          ),
        ),
      ),
      title: Text(
        'Tambah Pet',
        style: AppTextStyle(color: AppColor.black_2).mulishTitleL(),
      ),
    );
  }

  // Widget _body() {
  //   return
  // }

  Widget _facilityContainerView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fasilitas',
          style: AppTextStyle(color: AppColor.black_2).mulishBodyM(),
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
                  checkboxGroupValue: facilitiesFilterActive,
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
                  checkboxGroupValue: facilitiesFilterActive,
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
                  checkboxGroupValue: facilitiesFilterActive,
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
                  checkboxGroupValue: facilitiesFilterActive,
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
                  checkboxGroupValue: facilitiesFilterActive,
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
                  checkboxGroupValue: facilitiesFilterActive,
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
                  checkboxGroupValue: facilitiesFilterActive,
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

  StatefulBuilder _rasBottomModal() {
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
                    'Ras Anabul',
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
            ListView.separated(
              separatorBuilder: (context, index) => Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Divider(
                    color: AppColor.grey_3,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              shrinkWrap: true,
              //TODO: BELOM DI HANDLE KALO GA PILIH DOG DAN CAT
              itemCount: spesiesValue == 'dog'
                  ? dogBreedsAndHabits!.petBreedEntities.length
                  : catBreedsAndHabits!.petBreedEntities.length,
              itemBuilder: (context, index) => CatnipRadio(
                onTap: () {
                  _setPetBreed(
                    id: (spesiesValue == 'dog'
                        ? dogBreedsAndHabits!.petBreedEntities[index].id
                        : catBreedsAndHabits!.petBreedEntities[index].id),
                    name: (spesiesValue == 'dog'
                        ? dogBreedsAndHabits!.petBreedEntities[index].name
                        : catBreedsAndHabits!.petBreedEntities[index].name),
                  );

                  setState(() {
                    petBreedId = (spesiesValue == 'dog'
                        ? dogBreedsAndHabits!.petBreedEntities[index].id
                        : catBreedsAndHabits!.petBreedEntities[index].id);
                    petBreedName = (spesiesValue == 'dog'
                        ? dogBreedsAndHabits!.petBreedEntities[index].name
                        : catBreedsAndHabits!.petBreedEntities[index].name);
                  });
                  // print(petBreedId);
                },
                isActive: petBreedId ==
                    (spesiesValue == 'dog'
                        ? dogBreedsAndHabits!.petBreedEntities[index].id
                        : catBreedsAndHabits!.petBreedEntities[index].id),
                primaryLabel: spesiesValue == 'dog'
                    ? dogBreedsAndHabits!.petBreedEntities[index].name
                    : catBreedsAndHabits!.petBreedEntities[index].name,
                catnipRadioType: CatnipRadioType.seperated,
              ),
            )
          ],
        ),
      ),
    );
  }
}
