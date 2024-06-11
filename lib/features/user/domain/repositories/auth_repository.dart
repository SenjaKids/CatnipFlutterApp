import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/user_entity.dart';
import '../../../../core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> checkHasAccount(
      {required CheckHasAccountParams params});
  Future<Either<Failure, String>> getOTP({required GetOTPBody getOTPBody});
  Future<Either<Failure, bool>> validateOTP(
      {required ValidateOTPBody validateOTPBody});
  Future<Either<Failure, bool>> signUpUser(
      {required SignUpUserBody signUpUserBody});
  Future<Either<Failure, String>> signInUser(
      {required SignInUserBody signInUserBody});
  Future<Either<Failure, UserDataEntity>> getUserProfile(
      {required String accessToken});
  Future<Either<Failure, PetBreedsAndHabitsEntities>> getPetBreedsandHabits(
      {required String accessToken, required String petCategory});
  Future<Either<Failure, bool>> postPetData(
      {required String accessToken, required PostPetDataBody postPetDataBody});
  Future<Either<Failure, PetEntity>> getPetDetails(
      {required String accessToken, required String petId});
  Future<Either<Failure, bool>> updateUserProfile(
      {required String accessToken,
      required UpdateUserProfileBody updateUserProfileBody});
  Future<Either<Failure, bool>> updatePetData(
      {required String accessToken,
      required PostPetDataBody postPetDataBody,
      required String petId});
}
