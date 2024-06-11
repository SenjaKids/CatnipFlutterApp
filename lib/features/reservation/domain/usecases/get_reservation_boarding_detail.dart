import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/sub_entity.dart';
import 'package:zladag_flutter_app/features/reservation/domain/repositories/reservation_repository.dart';

class GetReservationBoardingDetail {
  final ReservationRepository reservationRepository;

  GetReservationBoardingDetail(this.reservationRepository);

  Future<Either<Failure, ReservationBoardingDetail>> call(
      {required String accessToken, required String slug}) async {
    return await reservationRepository.getBoardingReservationData(
        accessToken: accessToken, slug: slug);
  }
}
