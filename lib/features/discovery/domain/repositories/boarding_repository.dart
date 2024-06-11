import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/discovery/data/models/sub_models.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';
import '../../../../core/errors/failure.dart';

abstract class BoardingRepository {
  Future<Either<Failure, List<BoardingEntity>>> getSearchedBoarding(
      {required BoardingSearchParams params});
  Future<Either<Failure, List<BoardingEntity>>> getHomeFilteredBoarding(
      {required String boardingFilter,
      required HomeFilteredBoardingParams params});
  Future<Either<Failure, BoardingEntity>> getBoardingDetails(
      {required BoardingDetailsParams params});
  Future<Either<Failure, List<AutocompletePrediction>>> getAutocomplete(
      {required AutoCompleteParams params});
  Future<Either<Failure, LatLng>> getAutocompleteLocation(
      {required String locationID});
}
