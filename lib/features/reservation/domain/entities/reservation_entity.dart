import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';

class OrderEntity {
  String? id;
  String? checkInDate;
  String? checkOutDate;
  String? status;
  BoardingEntity? boardingEntity;
  PetEntity? petEntity;
  CageEntity? cageEntity;
  List<BoardingServiceEntity>? boardingServices;
  String? note;
  int? totalLodgingPrice;
  int? totalAddOnPrice;
  int? serviceFee;
  int? totalAllPrice;

  OrderEntity({
    required this.id,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.boardingEntity,
    required this.petEntity,
    required this.cageEntity,
    required this.boardingServices,
    required this.note,
    required this.totalLodgingPrice,
    required this.totalAddOnPrice,
    required this.serviceFee,
    required this.totalAllPrice,
  });
}
