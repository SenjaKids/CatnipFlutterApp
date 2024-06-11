import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';
import 'package:zladag_flutter_app/features/discovery/domain/repositories/boarding_repository.dart';

class GetBoardingDetails {
  final BoardingRepository boardingRepository;

  GetBoardingDetails(this.boardingRepository);

  Future<Either<Failure, BoardingEntity>> call(
      {required BoardingDetailsParams boardingDetailsParams}) async {
    return await boardingRepository.getBoardingDetails(
        params: boardingDetailsParams);
  }
}
