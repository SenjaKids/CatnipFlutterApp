import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/connection/network_info.dart';
import 'package:zladag_flutter_app/core/errors/exceptions.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/reservation/data/datasources/reservation_remote_data_source.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/reservation_entity.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/sub_entity.dart';
import 'package:zladag_flutter_app/features/reservation/domain/repositories/reservation_repository.dart';

class ReservationRepositoryImpl extends ReservationRepository {
  final ReservationRemoteDataSource remoteDataSource;
  // final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ReservationRepositoryImpl({
    required this.remoteDataSource,
    // required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ReservationBoardingDetail>> getBoardingReservationData(
      {required String accessToken, required String slug}) async {
    if (await networkInfo.isConnected!) {
      try {
        final reservationBoardingDetail = await remoteDataSource
            .getBoardingReservationData(accessToken: accessToken, slug: slug);
        // localDataSource.cacheAccessToken();
        return Right(reservationBoardingDetail);
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
  Future<Either<Failure, bool>> postOrder(
      {required String accessToken,
      required PostOrderBody postOrderBody}) async {
    if (await networkInfo.isConnected!) {
      try {
        final postOrderSuccess = await remoteDataSource.postOrder(
            accessToken: accessToken, postOrderBody: postOrderBody);
        // localDataSource.cacheAccessToken();
        return Right(postOrderSuccess);
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
  Future<Either<Failure, List<OrderEntity>>> getUserOrderData(
      {required String accessToken, required bool active}) async {
    if (await networkInfo.isConnected!) {
      try {
        final reservationBoardingDetail = await remoteDataSource
            .getUserOrderData(accessToken: accessToken, active: active);
        // localDataSource.cacheAccessToken();
        return Right(reservationBoardingDetail);
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
