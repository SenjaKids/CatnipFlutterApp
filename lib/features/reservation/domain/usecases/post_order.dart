import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/reservation/domain/repositories/reservation_repository.dart';

class PostOrder {
  final ReservationRepository reservationRepository;

  PostOrder(this.reservationRepository);

  Future<Either<Failure, bool>> call(
      {required String accessToken,
      required PostOrderBody postOrderBody}) async {
    return await reservationRepository.postOrder(
        accessToken: accessToken, postOrderBody: postOrderBody);
  }
}
