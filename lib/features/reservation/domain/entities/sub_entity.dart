import 'package:zladag_flutter_app/features/discovery/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';

class ReservationBoardingDetail {
  final String? boardingName;
  final String? boardingSlug;
  final List<PetEntity>? catPetEntities;
  final List<PetEntity>? dogPetEntities;
  final List<CageEntity>? cageEntities;
  final List<BoardingServiceEntity>? boardingServices;

  ReservationBoardingDetail(
      {required this.boardingName,
      required this.boardingSlug,
      required this.catPetEntities,
      required this.dogPetEntities,
      required this.cageEntities,
      required this.boardingServices});
}
