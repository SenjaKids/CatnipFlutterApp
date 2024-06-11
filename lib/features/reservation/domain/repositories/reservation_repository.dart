import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/reservation_entity.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/sub_entity.dart';
import '../../../../core/errors/failure.dart';

abstract class ReservationRepository {
  Future<Either<Failure, ReservationBoardingDetail>> getBoardingReservationData(
      {required String accessToken, required String slug});
  Future<Either<Failure, bool>> postOrder(
      {required String accessToken, required PostOrderBody postOrderBody});
  Future<Either<Failure, List<OrderEntity>>> getUserOrderData(
      {required String accessToken, required bool active});
}
