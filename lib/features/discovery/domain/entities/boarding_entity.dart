import 'sub_entities.dart';

class BoardingEntity {
  final String? name;
  final String? slug;
  final double? distance; // distance from current longitude latitude on km
  final String? subdistrict;
  final String? province;
  final String? boardingCategory;
  final String? longitude;
  final String? latitude;
  final List<dynamic>? boardingFacilities;
  final List<CagesEntity>? boardingCages;
  final BoardingPolicyEntity? boardingPolicyEntity;
  final BoardingLocationEntity? boardingLocationEntity;
  final String? description;
  final int? cheapestLodgingPrice;
  final List<dynamic>? imagesPath; // image path from API

  BoardingEntity({
    this.name,
    this.slug,
    this.distance,
    this.subdistrict,
    this.province,
    this.longitude,
    this.latitude,
    this.boardingCategory,
    this.boardingFacilities,
    this.boardingCages,
    this.boardingPolicyEntity,
    this.boardingLocationEntity,
    this.description,
    this.cheapestLodgingPrice,
    this.imagesPath,
  });
}
