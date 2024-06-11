import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';
import 'package:zladag_flutter_app/features/discovery/domain/repositories/boarding_repository.dart';

class GetSearchedBoarding {
  final BoardingRepository boardingRepository;

  GetSearchedBoarding(this.boardingRepository);

  Future<Either<Failure, List<BoardingEntity>>> call(
      {required BoardingSearchParams params}) async {
    return await boardingRepository.getSearchedBoarding(params: params);
  }
}
