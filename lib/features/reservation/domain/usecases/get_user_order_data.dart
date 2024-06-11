import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/reservation_entity.dart';
import 'package:zladag_flutter_app/features/reservation/domain/repositories/reservation_repository.dart';

class GetUserOrderData {
  final ReservationRepository reservationRepository;

  GetUserOrderData(this.reservationRepository);

  Future<Either<Failure, List<OrderEntity>>> call(
      {required String accessToken, required bool active}) async {
    return await reservationRepository.getUserOrderData(
        accessToken: accessToken, active: active);
  }
}
