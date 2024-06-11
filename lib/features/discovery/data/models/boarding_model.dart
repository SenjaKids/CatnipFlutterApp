import 'package:zladag_flutter_app/core/constants/constants.dart';
import 'package:zladag_flutter_app/features/discovery/data/models/sub_models.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';

class BoardingModel extends BoardingEntity {
  BoardingModel({
    super.name,
    super.slug,
    super.distance,
    super.subdistrict,
    super.province,
    super.latitude,
    super.longitude,
    super.boardingCategory,
    super.boardingFacilities,
    super.boardingCages,
    super.boardingPolicyEntity,
    super.boardingLocationEntity,
    super.description,
    super.cheapestLodgingPrice,
    super.imagesPath,
  });

  factory BoardingModel.fromJson(Map<String, dynamic> json) {
    print(json[baBoardingCages]);
    return BoardingModel(
      name: json[baName],
      slug: json[baSlug],
      latitude: json[baLatitude],
      longitude: json[baLongitude],
      distance:
          json[baDistance] != null ? json[baDistance] + 0.0 : json[baDistance],
      subdistrict: json[baSubdistrict],
      province: json[baProvince],
      boardingCategory: json[baBoardingCategory],
      boardingFacilities: json[baBoardingFacilities],
      boardingCages: CagesModel.fromJson(json[baBoardingCages]),
      boardingPolicyEntity: BoardingPolicyModel.fromJson(json),
      boardingLocationEntity: BoardingLocationModel.fromJson(json),
      description: json[baDescription],
      cheapestLodgingPrice: json[baCheapestLodgingPrice],
      imagesPath: json[baImages],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      baName: name,
      baSlug: slug,
      baDistance: distance,
      baSubdistrict: subdistrict,
      baProvince: province,
      baBoardingCategory: boardingCategory,
      baBoardingFacilities: boardingFacilities,
      baBoardingCages: boardingCages,
      baStartCheckIn: boardingPolicyEntity?.startCheckInTime,
      baEndCheckIn: boardingPolicyEntity?.endCheckInTime,
      baStartCheckOut: boardingPolicyEntity?.startCheckOutTime,
      baEndCheckOut: boardingPolicyEntity?.endCheckOutTime,
      baAddress: boardingLocationEntity?.address,
      baMapLink: boardingLocationEntity?.mapLink,
      baDescription: description,
      baCheapestLodgingPrice: cheapestLodgingPrice,
      baImages: imagesPath,
    };
  }
}
