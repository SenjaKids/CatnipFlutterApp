import 'package:zladag_flutter_app/features/discovery/data/models/boarding_model.dart';
import 'package:zladag_flutter_app/features/discovery/data/models/sub_models.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/reservation_entity.dart';
import 'package:zladag_flutter_app/features/user/data/models/sub_models.dart';

class OrderModel extends OrderEntity {
  OrderModel(
      {super.id,
      super.checkInDate,
      super.checkOutDate,
      super.status,
      super.boardingEntity,
      super.petEntity,
      super.cageEntity,
      super.boardingServices,
      super.note,
      super.totalLodgingPrice,
      super.totalAddOnPrice,
      super.serviceFee,
      super.totalAllPrice});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    print(json['boarding'.toString()]);
    return OrderModel(
      id: json['id'],
      checkInDate: json['checkInDate'],
      checkOutDate: json['checkOutDate'],
      status: json['status'],
      //TODO: CARA NGAMBIL DATANYA MASIH GA EFEKTIF DAN GA AMAN
      boardingEntity: (json['boarding'].toString().contains(':')
          ? BoardingModel.fromJson(json['boarding'])
          : BoardingEntity(name: json['boarding'].toString())),
      petEntity: (json['pet'].toString().contains(':')
          ? PetModel.fromJson(json['pet'])
          : PetModel(name: json['pet'].toString())),
      //  PetModel.fromJson(json['pet']),
      cageEntity: json['boardingCage'] != null
          ? CageModel.fromJson(json['boardingCage'])
          : null,
      // boardingServices: BoardingServiceModel.fromJson(json['boardingService'])
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     baCageName: name,
  //     baCageLength: length,
  //     baCageWidth: width,
  //     baCageHeight: height,
  //     'price': price,
  //   };
  // }
}
