import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zladag_flutter_app/core/connection/network_info.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/user/data/datasources/auth_local_data_source.dart';
import 'package:zladag_flutter_app/features/user/data/datasources/auth_remote_data_source.dart';
import 'package:zladag_flutter_app/features/user/data/repositories/auth_repository_impl.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/user_entity.dart';
import 'package:zladag_flutter_app/features/user/domain/usecases/check_has_account.dart';
import 'package:zladag_flutter_app/features/user/domain/usecases/get_otp.dart';
import 'package:zladag_flutter_app/features/user/domain/usecases/get_pet_breeds_and_habits.dart';
import 'package:zladag_flutter_app/features/user/domain/usecases/get_pet_details.dart';
import 'package:zladag_flutter_app/features/user/domain/usecases/get_user_profile.dart';
import 'package:zladag_flutter_app/features/user/domain/usecases/post_pet_data.dart';
import 'package:zladag_flutter_app/features/user/domain/usecases/sign_in_user.dart';
import 'package:zladag_flutter_app/features/user/domain/usecases/sign_up_user.dart';
import 'package:zladag_flutter_app/features/user/domain/usecases/update_pet_data.dart';
import 'package:zladag_flutter_app/features/user/domain/usecases/update_user_profile.dart';
import 'package:zladag_flutter_app/features/user/domain/usecases/validate_otp.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/register.dart';

class AuthProvider extends ChangeNotifier {
  bool? boolHasAccount;
  String? otp;
  bool? otpValidationResult;
  String? userPhoneNumber;
  String? accessToken;
  UserDataEntity? userData;
  PetBreedsAndHabitsEntities? catBreedsAndHabits;
  PetBreedsAndHabitsEntities? dogBreedsAndHabits;
  List<String>? catHabits, dogHabits;
  PetEntity? petDetails;
  Failure? failure;

  void eitherFailureOrOTPValidationResult(
      {required ValidateOTPBody validateOTPBody,
      required BuildContext context}) async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(dio: Dio()),
      localDataSource: AuthLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrHomeFilteredBoardings =
        await ValidateOTP(repository).call(validateOTPBody: validateOTPBody);

    failureOrHomeFilteredBoardings.fold(
      (newFailure) {
        otpValidationResult = null;
        failure = newFailure;
        notifyListeners();
      },
      (newOTPStatus) {
        otpValidationResult = newOTPStatus;
        if (newOTPStatus) {
          if (boolHasAccount!) {
            eitherFailureOrAccessToken(
                signInUserBody: SignInUserBody(
                  signMethod: 'phoneNumber',
                  phoneNumber: userPhoneNumber,
                ),
                context: context);
          } else {
            Navigator.pushNamed(
              context,
              '/starting_form',
            );
          }
        }
        print(otpValidationResult);
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrOTP({required GetOTPBody getOTPBody}) async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(dio: Dio()),
      localDataSource: AuthLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrHomeFilteredBoardings =
        await GetOTP(repository).call(getOTPBody: getOTPBody);

    failureOrHomeFilteredBoardings.fold(
      (newFailure) {
        otp = null;
        failure = newFailure;
        notifyListeners();
      },
      (newOTP) {
        otp = newOTP;
        print(otp);
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrCheckHasAnAccount({
    required CheckHasAccountParams params,
    required BuildContext context,
    required String phoneNumber,
  }) async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(dio: Dio()),
      localDataSource: AuthLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrHomeFilteredBoardings =
        await CheckHasAccount(repository).call(params: params);

    failureOrHomeFilteredBoardings.fold(
      (newFailure) {
        boolHasAccount = null;
        failure = newFailure;
        notifyListeners();
      },
      (newHasAccount) {
        boolHasAccount = newHasAccount;
        failure = null;

        if (context.widget.toString() == const RegisterWidget().toString()) {
          if (!newHasAccount) {
            eitherFailureOrOTP(
                getOTPBody: GetOTPBody(phoneNumber: phoneNumber));
            Navigator.pushNamed(
              context,
              '/verifikasi_otp',
              arguments: phoneNumber,
            );
          }
        } else {
          if (newHasAccount) {
            userPhoneNumber = phoneNumber;
            eitherFailureOrOTP(
                getOTPBody: GetOTPBody(phoneNumber: phoneNumber));
            Navigator.pushNamed(
              context,
              '/verifikasi_otp',
              arguments: phoneNumber,
            );
          }
        }
        notifyListeners();
      },
    );
  }

  void eitherFailureOrSignUpUser(
      {required SignUpUserBody signUpUserBody,
      required BuildContext context}) async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(dio: Dio()),
      localDataSource: AuthLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrSignUpUser =
        await SignUpUser(repository).call(signUpUserBody: signUpUserBody);

    failureOrSignUpUser.fold(
      (newFailure) {
        // signUpSuccess = null;
        failure = newFailure;
        notifyListeners();
      },
      (newSignUpStatus) {
        // signUpSuccess = newSignUpStatus;
        if (newSignUpStatus) {
          print('success? $newSignUpStatus');
          eitherFailureOrAccessToken(
              signInUserBody: SignInUserBody(
                signMethod: signUpUserBody.signMethod,
                email: signUpUserBody.email,
                phoneNumber: signUpUserBody.phoneNumber,
              ),
              context: context);
        }
        print(newSignUpStatus);
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrAccessToken(
      {required SignInUserBody signInUserBody,
      required BuildContext context}) async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(dio: Dio()),
      localDataSource: AuthLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrAccessToken =
        await SignInUser(repository).call(signInUserBody: signInUserBody);

    print('accesstoken func');
    failureOrAccessToken.fold(
      (newFailure) {
        accessToken = null;
        failure = newFailure;
        notifyListeners();
      },
      (newAccessToken) {
        eitherFailureOrUserData(accessToken: newAccessToken, context: context);
        print('access token $newAccessToken');
        accessToken = newAccessToken;
        failure = null;
        notifyListeners();
        Navigator.pushNamed(
          context,
          '/main_activity',
        );
      },
    );
  }

  void eitherFailureOrUserData(
      {required String accessToken, required BuildContext context}) async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(dio: Dio()),
      localDataSource: AuthLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );
    print('user data');

    final failureOrUserData =
        await GetUserProfile(repository).call(accessToken: accessToken);

    failureOrUserData.fold(
      (newFailure) {
        print('user data fail');
        userData = null;
        failure = newFailure;
        notifyListeners();
      },
      (newUserData) {
        print('user data: $newUserData');
        userData = newUserData;
        // print(newAccessToken);
        failure = null;
        notifyListeners();
        // Navigator.pushNamed(
        //   context,
        //   '/main_activity',
        // );
      },
    );
  }

  void eitherFailureOrBreedsAndHabits(
      {required String accessToken,
      required String petCategory,
      required BuildContext context}) async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(dio: Dio()),
      localDataSource: AuthLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );
    // print('user data');

    final failureOrBreedsAndHabits =
        await GetPetBreedsAndHabits(repository).call(
      accessToken: accessToken,
      petCategory: petCategory,
    );

    failureOrBreedsAndHabits.fold(
      (newFailure) {
        print('user data fail');
        userData = null;
        failure = newFailure;
        notifyListeners();
      },
      (newBreedsAndHabits) {
        print('breeds and habits: $newBreedsAndHabits');
        if (petCategory == 'cat') {
          catHabits = [];
          catBreedsAndHabits = newBreedsAndHabits;
          for (PetHabitEntity habit in catBreedsAndHabits!.petHabitEntities) {
            catHabits!.add(habit.name);
          }
        } else if (petCategory == 'dog') {
          dogHabits = [];
          dogBreedsAndHabits = newBreedsAndHabits;
          for (PetHabitEntity habit in dogBreedsAndHabits!.petHabitEntities) {
            dogHabits!.add(habit.name);
          }
        }
        // print(newAccessToken);
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrSavePetDataSuccess(
      {required String accessToken,
      required PostPetDataBody postPetDataBody,
      required BuildContext context}) async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(dio: Dio()),
      localDataSource: AuthLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );
    // print('user data');

    final failureOrSavePetDataSuccess = await PostPetData(repository).call(
      accessToken: accessToken,
      postPetDataBody: postPetDataBody,
    );

    failureOrSavePetDataSuccess.fold(
      (newFailure) {
        print('save pet data failed');
        // userData = null;
        failure = newFailure;
        notifyListeners();
      },
      (isSuccess) {
        print('save pet data: $isSuccess');
        if (isSuccess) {
          Navigator.pushNamed(context, "/main_activity");
        } else {
          //TODO: HANDLE IF FAILED SAVE DATA
        }
        // print(newAccessToken);
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrPetDetails(
      {required String accessToken,
      required String petId,
      required BuildContext context}) async {
    petDetails = null;
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(dio: Dio()),
      localDataSource: AuthLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrPetDetails = await GetPetDetails(repository).call(
      accessToken: accessToken,
      petId: petId,
    );

    failureOrPetDetails.fold(
      (newFailure) {
        print('get pet details failed');
        petDetails = null;
        failure = newFailure;
        notifyListeners();
      },
      (newPetDetails) {
        print('petDetails data: $newPetDetails');
        // if (isSuccess) {
        //   Navigator.pushNamed(context, "/main_activity");
        // } else {
        //   //TODO: HANDLE IF FAILED SAVE DATA
        // }
        petDetails = newPetDetails;
        // print(newAccessToken);
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrUpdateUserProfileSuccess(
      {required String accessToken,
      required UpdateUserProfileBody updateUserProfileBody,
      required BuildContext context}) async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(dio: Dio()),
      localDataSource: AuthLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );
    // print('user data');

    final failureOrSavePetDataSuccess =
        await UpdateUserProfile(repository).call(
      accessToken: accessToken,
      updateUserProfileBody: updateUserProfileBody,
    );

    failureOrSavePetDataSuccess.fold(
      (newFailure) {
        print('update user profile failed');
        // userData = null;
        failure = newFailure;
        notifyListeners();
      },
      (isSuccess) {
        print('save user profile data: $isSuccess');
        if (isSuccess) {
          eitherFailureOrUserData(accessToken: accessToken, context: context);
          // Navigator.pushNamed(context, "/main_activity");
        } else {
          //TODO: HANDLE IF FAILED SAVE DATA
        }
        // print(newAccessToken);
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrUpdatePetDataSuccess(
      {required String accessToken,
      required PostPetDataBody postPetDataBody,
      required String petId,
      required BuildContext context}) async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(dio: Dio()),
      localDataSource: AuthLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );
    // print('user data');

    final failureOrSavePetDataSuccess = await UpdatePetData(repository).call(
        accessToken: accessToken,
        postPetDataBody: postPetDataBody,
        petId: petId);

    failureOrSavePetDataSuccess.fold(
      (newFailure) {
        print('save pet data failed');
        // userData = null;
        failure = newFailure;
        notifyListeners();
      },
      (isSuccess) {
        print('update pet data: $isSuccess');
        if (isSuccess) {
          Navigator.pushNamed(context, "/main_activity");
        } else {
          //TODO: HANDLE IF FAILED SAVE DATA
        }
        // print(newAccessToken);
        failure = null;
        notifyListeners();
      },
    );
  }
}
