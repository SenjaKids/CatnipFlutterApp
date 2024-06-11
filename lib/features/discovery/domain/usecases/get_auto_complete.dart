import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/discovery/data/models/sub_models.dart';
import 'package:zladag_flutter_app/features/discovery/domain/repositories/boarding_repository.dart';

class GetAutoComplete {
  final BoardingRepository boardingRepository;

  GetAutoComplete(this.boardingRepository);

  Future<Either<Failure, List<AutocompletePrediction>>> call(
      {required AutoCompleteParams autoCompleteParams}) async {
    return await boardingRepository.getAutocomplete(params: autoCompleteParams);
  }
}
