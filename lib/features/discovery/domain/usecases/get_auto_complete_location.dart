import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/features/discovery/domain/repositories/boarding_repository.dart';

class GetAutoCompleteLocation {
  final BoardingRepository boardingRepository;

  GetAutoCompleteLocation(this.boardingRepository);

  Future<Either<Failure, LatLng>> call({required String locationID}) async {
    return await boardingRepository.getAutocompleteLocation(
        locationID: locationID);
  }
}
