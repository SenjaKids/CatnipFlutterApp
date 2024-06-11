import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/connection/network_info.dart';
import 'package:zladag_flutter_app/core/errors/exceptions.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/user/data/datasources/auth_local_data_source.dart';
import 'package:zladag_flutter_app/features/user/data/datasources/auth_remote_data_source.dart';
import 'package:zladag_flutter_app/features/user/data/models/user_model.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/user_entity.dart';
import 'package:zladag_flutter_app/features/user/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> checkHasAccount(
      {required CheckHasAccountParams params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final hasAccount =
            await remoteDataSource.checkHasAccount(params: params);
        // localDataSource.cacheAccessToken();
        return Right(hasAccount);
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
  Future<Either<Failure, String>> getOTP(
      {required GetOTPBody getOTPBody}) async {
    if (await networkInfo.isConnected!) {
      try {
        final otp = await remoteDataSource.getOTP(getOTPBody: getOTPBody);
        // localDataSource.cacheBoardings(remoteBoardings);
        return Right(otp);
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
  Future<Either<Failure, bool>> validateOTP(
      {required ValidateOTPBody validateOTPBody}) async {
    if (await networkInfo.isConnected!) {
      try {
        final validationResult = await remoteDataSource.validateOTP(
            validateOTPBody: validateOTPBody);
        // localDataSource.cacheBoardings(remoteBoardings);
        return Right(bool.parse(validationResult));
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
  Future<Either<Failure, bool>> signUpUser(
      {required SignUpUserBody signUpUserBody}) async {
    if (await networkInfo.isConnected!) {
      try {
        final validationResult =
            await remoteDataSource.signUpUser(signUpUserBody: signUpUserBody);
        // localDataSource.cacheBoardings(remoteBoardings);
        return Right(validationResult);
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
  Future<Either<Failure, String>> signInUser(
      {required SignInUserBody signInUserBody}) async {
    if (await networkInfo.isConnected!) {
      try {
        final accessToken =
            await remoteDataSource.signInUser(signInUserBody: signInUserBody);
        localDataSource.cacheAccessToken(accessToken);
        return Right(accessToken);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      return Left(CacheFailure(errorMessage: 'No local data found'));

      // try {
      //   final accessToken = await localDataSource.getLastBoarding();
      //   return Right(localBoarding);
      // } on CacheException {
      //   return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }

  @override
  Future<Either<Failure, UserDataEntity>> getUserProfile(
      {required String accessToken}) async {
    if (await networkInfo.isConnected!) {
      print('either');
      try {
        print('inside');
        // print('$accessToken');
        final userData =
            await remoteDataSource.getUserProfile(accessToken: accessToken);
        print("auth repo impl $userData");
        localDataSource.cacheUser(userData.userEntity as UserModel);
        localDataSource.cachePets(userData.petEntities);
        return Right(userData);
      } on ServerException {
        print('exception');
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      print("auth repo impl no internet");
      return Left(CacheFailure(errorMessage: 'No local data found'));

      // try {
      //   final accessToken = await localDataSource.getLastBoarding();
      //   return Right(localBoarding);
      // } on CacheException {
      //   return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }

  @override
  Future<Either<Failure, PetBreedsAndHabitsEntities>> getPetBreedsandHabits(
      {required String accessToken, required String petCategory}) async {
    if (await networkInfo.isConnected!) {
      try {
        final breedsAndHabits = await remoteDataSource.getPetBreedsandHabits(
            accessToken: accessToken, petCategory: petCategory);
        print("auth repo impl $breedsAndHabits");
        // localDataSource.cacheUser(userData.userEntity as UserModel);
        // localDataSource.cachePets(userData.petEntities);
        return Right(breedsAndHabits);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      print("auth repo impl no internet");
      return Left(CacheFailure(errorMessage: 'No local data found'));

      // try {
      //   final accessToken = await localDataSource.getLastBoarding();
      //   return Right(localBoarding);
      // } on CacheException {
      //   return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }

  @override
  Future<Either<Failure, bool>> postPetData(
      {required String accessToken,
      required PostPetDataBody postPetDataBody}) async {
    if (await networkInfo.isConnected!) {
      try {
        final breedsAndHabits = await remoteDataSource.postPetData(
            accessToken: accessToken, postPetDataBody: postPetDataBody);
        // print("auth repo impl $breedsAndHabits");
        // localDataSource.cacheUser(userData.userEntity as UserModel);
        // localDataSource.cachePets(userData.petEntities);
        return Right(breedsAndHabits);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      print("auth repo impl no internet");
      return Left(CacheFailure(errorMessage: 'No local data found'));

      // try {
      //   final accessToken = await localDataSource.getLastBoarding();
      //   return Right(localBoarding);
      // } on CacheException {
      //   return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }

  @override
  Future<Either<Failure, PetEntity>> getPetDetails(
      {required String accessToken, required String petId}) async {
    if (await networkInfo.isConnected!) {
      try {
        final petEntity = await remoteDataSource.getPetDetails(
            accessToken: accessToken, petId: petId);
        // print("auth repo impl $breedsAndHabits");
        // localDataSource.cacheUser(userData.userEntity as UserModel);
        // localDataSource.cachePets(userData.petEntities);
        return Right(petEntity);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      print("auth repo impl no internet");
      return Left(CacheFailure(errorMessage: 'No local data found'));

      // try {
      //   final accessToken = await localDataSource.getLastBoarding();
      //   return Right(localBoarding);
      // } on CacheException {
      //   return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserProfile(
      {required String accessToken,
      required UpdateUserProfileBody updateUserProfileBody}) async {
    if (await networkInfo.isConnected!) {
      try {
        final successUpdateUserProfile =
            await remoteDataSource.updateUserProfile(
                accessToken: accessToken,
                updateUserProfileBody: updateUserProfileBody);
        // print("auth repo impl $breedsAndHabits");
        // localDataSource.cacheUser(userData.userEntity as UserModel);
        // localDataSource.cachePets(userData.petEntities);
        return Right(successUpdateUserProfile);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      print("auth repo impl no internet");
      return Left(CacheFailure(errorMessage: 'No local data found'));

      // try {
      //   final accessToken = await localDataSource.getLastBoarding();
      //   return Right(localBoarding);
      // } on CacheException {
      //   return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }

  @override
  Future<Either<Failure, bool>> updatePetData(
      {required String accessToken,
      required PostPetDataBody postPetDataBody,
      required String petId}) async {
    if (await networkInfo.isConnected!) {
      try {
        final success = await remoteDataSource.updatePetData(
            accessToken: accessToken,
            postPetDataBody: postPetDataBody,
            petId: petId);
        // print("auth repo impl $breedsAndHabits");
        // localDataSource.cacheUser(userData.userEntity as UserModel);
        // localDataSource.cachePets(userData.petEntities);
        return Right(success);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      print("auth repo impl no internet");
      return Left(CacheFailure(errorMessage: 'No local data found'));

      // try {
      //   final accessToken = await localDataSource.getLastBoarding();
      //   return Right(localBoarding);
      // } on CacheException {
      //   return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }

  //TODO: LOGOUT (REMOVE ACCESS TOKEN)
}
