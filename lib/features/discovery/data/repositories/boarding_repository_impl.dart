import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:zladag_flutter_app/core/connection/network_info.dart';
import 'package:zladag_flutter_app/core/errors/exceptions.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/discovery/data/datasources/boarding_remote_data_source.dart';
import 'package:zladag_flutter_app/features/discovery/data/models/sub_models.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';
import 'package:zladag_flutter_app/features/discovery/domain/repositories/boarding_repository.dart';

class BoardingRepositoryImpl implements BoardingRepository {
  final BoardingRemoteDataSource remoteDataSource;

  // final PokemonLocalDataSource localDataSource;

  final NetworkInfo networkInfo;

  BoardingRepositoryImpl({
    required this.remoteDataSource,
    // required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<BoardingEntity>>> getSearchedBoarding(
      {required BoardingSearchParams params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteBoardings =
            await remoteDataSource.getSearchedBoarding(params: params);
        // localDataSource.cacheBoardings(remoteBoardings);

        return Right(remoteBoardings);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      return Left(CacheFailure(errorMessage: 'No local data found'));

      // try {
      //   final localBoarding = await localDataSource.getLastBoarding();
      //   return Right(localBoarding);
      // } on CacheException {
      //   return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }

  @override
  Future<Either<Failure, List<BoardingEntity>>> getHomeFilteredBoarding(
      {required String boardingFilter,
      required HomeFilteredBoardingParams params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteBoardings = await remoteDataSource.getHomeFilteredBoarding(
            boardingFilter: boardingFilter,
            params: HomeFilteredBoardingParams(
              params.longitude,
              params.latitude,
            ));
        // localDataSource.cacheBoardings(remoteBoardings);

        return Right(remoteBoardings);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      return Left(CacheFailure(errorMessage: 'No local data found'));

      // try {
      //   final localBoarding = await localDataSource.getLastBoarding();
      //   return Right(localBoarding);
      // } on CacheException {
      //   return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }

  @override
  Future<Either<Failure, BoardingEntity>> getBoardingDetails(
      {required BoardingDetailsParams params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteBoarding =
            await remoteDataSource.getBoardingDetails(params: params);
        // localDataSource.cacheBoardings(remoteBoardings);
        debugPrint(
            'DEBUG [BoardingRepositoruImpl]: ${remoteBoarding.toString()}');

        return Right(remoteBoarding);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      return Left(CacheFailure(errorMessage: 'No local data found'));

      // try {
      //   final localBoarding = await localDataSource.getLastBoarding();
      //   return Right(localBoarding);
      // } on CacheException {
      //   return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }

  @override
  Future<Either<Failure, List<AutocompletePrediction>>> getAutocomplete(
      {required AutoCompleteParams params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final autoCompleteResult =
            await remoteDataSource.getAutocomplete(params: params);
        // localDataSource.cacheBoardings(remoteBoardings);

        print('6 ${autoCompleteResult}');
        return Right(autoCompleteResult);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      return Left(CacheFailure(errorMessage: 'No local data found'));

      // try {
      //   final localBoarding = await localDataSource.getLastBoarding();
      //   return Right(localBoarding);
      // } on CacheException {
      //   return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }

  @override
  Future<Either<Failure, LatLng>> getAutocompleteLocation(
      {required String locationID}) async {
    if (await networkInfo.isConnected!) {
      try {
        final latLng = await remoteDataSource.getAutocompleteLocation(
            locationID: locationID);
        // localDataSource.cacheBoardings(remoteBoardings);
        return Right(latLng);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      return Left(CacheFailure(errorMessage: 'No local data found'));
      // try {
      //   final localBoarding = await localDataSource.getLastBoarding();
      //   return Right(localBoarding);
      // } on CacheException {
      //   return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }
}
