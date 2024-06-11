import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:http_parser/http_parser.dart';
import 'package:zladag_flutter_app/core/errors/exceptions.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/user/data/models/sub_models.dart';
import 'package:zladag_flutter_app/features/user/data/models/user_model.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/user_entity.dart';
// import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<bool> checkHasAccount({required CheckHasAccountParams params});
  Future<String> getOTP({required GetOTPBody getOTPBody});
  Future<String> validateOTP({required ValidateOTPBody validateOTPBody});
  Future<bool> signUpUser({required SignUpUserBody signUpUserBody});
  Future<String> signInUser({required SignInUserBody signInUserBody});
  Future<UserDataEntity> getUserProfile({required String accessToken});
  Future<PetBreedsAndHabitsEntities> getPetBreedsandHabits(
      {required String accessToken, required String petCategory});
  Future<bool> postPetData(
      {required String accessToken, required PostPetDataBody postPetDataBody});
  Future<bool> updatePetData(
      {required String accessToken,
      required PostPetDataBody postPetDataBody,
      required String petId});
  Future<PetEntity> getPetDetails(
      {required String accessToken, required String petId});
  Future<bool> updateUserProfile(
      {required String accessToken,
      required UpdateUserProfileBody updateUserProfileBody});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  const AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<bool> checkHasAccount({required CheckHasAccountParams params}) async {
    final response = await dio.get(
      'https://zladag-catnip-services.as.r.appspot.com/api/search-for-account-by-phone-number',
      queryParameters: {
        'phoneNumber': params.phoneNumber,
      },
    );

    if (response.statusCode == 200) {
      print('hasilnya ' + response.data['hasAnAccount'].toString());
      return response.data['hasAnAccount'];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> getOTP({required GetOTPBody getOTPBody}) async {
    var body = {
      'phoneNumber': getOTPBody.phoneNumber,
    };

    final response = await dio.post(
      'https://zladag-catnip-services.as.r.appspot.com/api/send-whatsapp-verification-code',
      data: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('hasilnya ' + response.data['verificationCode'].toString());
      return response.data['verificationCode'].toString();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> validateOTP({required ValidateOTPBody validateOTPBody}) async {
    var body = {
      'phoneNumber': validateOTPBody.phoneNumber,
      'verificationCode': validateOTPBody.otp,
    };

    final response = await dio.post(
      'https://zladag-catnip-services.as.r.appspot.com/api/validate-whatsapp-verification-code',
      data: jsonEncode(body),
      options: Options(
          headers: {
            'Accept': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );

    if (response.statusCode == 200) {
      print('hasilnya ' + response.data['success'].toString());
      return response.data['success'].toString();
    } else if (response.statusCode == 422) {
      print(response.data.toString());
      // throw ServerException();
      return 'false';
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> signUpUser({required SignUpUserBody signUpUserBody}) async {
    var body = {
      'signMethod': signUpUserBody.signMethod,
      'name': signUpUserBody.name,
      'phoneNumber': signUpUserBody.phoneNumber,
      'email': signUpUserBody.email,
    };

    final response = await dio.post(
      'https://zladag-catnip-services.as.r.appspot.com/api/sign-up',
      data: jsonEncode(body),
      options: Options(
          headers: {
            'Accept': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );

    if (response.statusCode == 200) {
      print('hasilnya ' + response.data['success'].toString());
      return response.data['success'];
    } else if (response.statusCode == 422) {
      print(response.data.toString());
      // throw ServerException();
      return false;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> signInUser({required SignInUserBody signInUserBody}) async {
    Map body;
    if (signInUserBody.signMethod == 'phoneNumber') {
      body = {
        'signMethod': signInUserBody.signMethod,
        'phoneNumber': signInUserBody.phoneNumber,
      };
    } else if (signInUserBody.signMethod == 'google' ||
        signInUserBody.signMethod == 'apple') {
      body = {
        'signMethod': signInUserBody.signMethod,
        'email': signInUserBody.email,
      };
    } else {
      body = {};
    }

    final response = await dio.post(
      'https://zladag-catnip-services.as.r.appspot.com/api/sign-in',
      data: jsonEncode(body),
      options: Options(
          headers: {
            'Accept': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );

    if (response.statusCode == 200) {
      print('hasilnya ${response.data['personalAccessToken']}');
      return response.data['personalAccessToken'];
    } else if (response.statusCode == 422) {
      print(response.data.toString());
      // throw ServerException();
      return response.data['message'];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserDataEntity> getUserProfile({required String accessToken}) async {
    final response = await dio.get(
      'https://zladag-catnip-services.as.r.appspot.com/api/profile',
      options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
    if (response.statusCode == 200) {
      print('hasilnya ${response.data}');

      var userJson = response.data['data']['user'];
      var petsJson = response.data['data']['pets'];

      List<PetModel> petModels = [];

      for (var petJson in petsJson) {
        petModels.add(PetModel.fromJson(petJson));
      }

      UserModel userModel = UserModel.fromJson(userJson);

      return UserDataEntity(userEntity: userModel, petEntities: petModels);
    } else if (response.statusCode == 422) {
      print(response.data.toString());
      // throw ServerException();
      return response.data['message'];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PetBreedsAndHabitsEntities> getPetBreedsandHabits(
      {required String accessToken, required String petCategory}) async {
    final response = await dio.get(
      'https://zladag-catnip-services.as.r.appspot.com/api/pet-categories/$petCategory/breeds-and-habits',
      options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
    if (response.statusCode == 200) {
      print('hasilnya ${response.data}');

      var petBreedsJson = response.data['data']['petBreeds'];
      var petHabitsJson = response.data['data']['petHabits'];

      List<PetBreedEntity> petBreedEntities = [];
      List<PetHabitEntity> petHabitEntities = [];

      for (var petBreedJson in petBreedsJson) {
        petBreedEntities.add(PetBreedModel.fromJson(petBreedJson));
      }

      for (var petHabitJson in petHabitsJson) {
        petHabitEntities.add(PetHabitModel.fromJson(petHabitJson));
      }
      // UserModel userModel = UserModel.fromJson(userJson);

      return PetBreedsAndHabitsEntities(
          petBreedEntities: petBreedEntities,
          petHabitEntities: petHabitEntities);
    } else if (response.statusCode == 422) {
      print(response.data.toString());
      // throw ServerException();
      return response.data['message'];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> postPetData(
      {required String accessToken,
      required PostPetDataBody postPetDataBody}) async {
    Map body;
    // final imageFile = await MultipartFile.fromFile(
    //   postPetDataBody.image?.path ?? "",
    //   filename:
    //       '${postPetDataBody.name}-${postPetDataBody.petBreedId}-$accessToken',
    // );
    body = {
      'petBreedId': postPetDataBody.petBreedId,
      'petGender': postPetDataBody.petGender,
      'name': postPetDataBody.name,
      'age': postPetDataBody.age,
      'bodyMass': postPetDataBody.bodyMass,
      'hasBeenSterilized': postPetDataBody.hasBeenSterilized,
      'hasBeenVaccinatedRoutinely': postPetDataBody.hasBeenVaccinatedRoutinely,
      'hasBeenFleaFreeRegularly': postPetDataBody.hasBeenFleaFreeRegularly,
      'historyOfIllness': postPetDataBody.historyOfIllness,
      'boardingFacilities': postPetDataBody.boardingFacilities,
      'petHabitIds': postPetDataBody.petHabitIds,
      'image': postPetDataBody.image,
      // 'image': imageFile,
      // 'image': await MultipartFile.fromFile(postPetDataBody.image!.path,
      //     filename:
      //         '${postPetDataBody.name}-${postPetDataBody.petBreedId}-$accessToken'),
    };

    print('test brodi');
    final response = await dio.post(
      'https://zladag-catnip-services.as.r.appspot.com/api/profile/pets/store',
      data: jsonEncode(body),
      options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );

    if (response.statusCode == 200) {
      print('hasilnya save data ${response.data['success']}');
      return response.data['success'];
    } else if (response.statusCode == 422) {
      print(response.data.toString());
      // throw ServerException();
      return false;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PetEntity> getPetDetails(
      {required String accessToken, required String petId}) async {
    final response = await dio.get(
      'https://zladag-catnip-services.as.r.appspot.com/api/profile/pets/$petId',
      options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
    if (response.statusCode == 200) {
      print('hasilnya ${response.data}');

      var petDetailsJson = response.data['data'];
      PetEntity petEntity = PetModel.fromJson(petDetailsJson);

      return petEntity;
    } else if (response.statusCode == 422) {
      print(response.data.toString());
      // throw ServerException();
      return response.data['message'];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> updateUserProfile(
      {required String accessToken,
      required UpdateUserProfileBody updateUserProfileBody}) async {
    Map body;
    // var request = http.MultipartRequest("POST", Uri());
    // request.fields['user'] = 'someone@somewhere.com';
    // request.files.add(http.MultipartFile.fromPath(
    //   'package',
    //   'build/package.tar.gz',
    //   contentType: MediaType('application', 'x-tar'),
    // ));
    // request.send().then((response) {
    //   if (response.statusCode == 200) print("Uploaded!");
    // });

    // var uri = Uri.https(
    //     'zladag-catnip-services.as.r.appspot.com', '/api/profile/update');
    // var request = http.MultipartRequest('POST', uri)
    //   ..headers['Accept'] = 'application/json'
    //   ..headers['Authorization'] = 'Bearer $accessToken'
    //   ..fields['name'] = updateUserProfileBody.name
    //   ..files.add(http.MultipartFile.fromBytes(
    //       'image',
    //       await
    //       //  updateUserProfileBody.image != null ?
    //       updateUserProfileBody.image!.readAsBytes(),
    //       // : ,
    //       contentType: MediaType('image', 'jpeg')));
    // var streamedResponse = await request.send();
    // var response = await http.Response.fromStream(streamedResponse);
    // if (response.statusCode == 200) print('Uploaded!');

    // if (updateUserProfileBody.image != null) {
    //   var bytes = await rootBundle.load(updateUserProfileBody.image!.path);
    //   var buffer = bytes.buffer;
    //   var imageBytes =
    //       buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

    //   // Encode the bytes
    //   var base64Image = base64Encode(imageBytes);
    //   body = {
    //     'name': updateUserProfileBody.name,
    //     'image': base64Image,
    //   };
    // } else {

    // FormData formData = FormData();
    // formData = FormData.fromMap({
    //   'name': updateUserProfileBody.name,
    //   'image': updateUserProfileBody.image != null
    //       // ? ToImageData.imagetoData(updateUserProfileBody.image!.path)
    //       ? updateUserProfileBody.image!
    //       : null,
    // });
    body = {
      'name': updateUserProfileBody.name,
      'image': updateUserProfileBody.image != null
          ? updateUserProfileBody.image!
          // ? ToImageData.imagetoData(updateUserProfileBody.image!.path)
          // ? await MultipartFile.fromFile(updateUserProfileBody.image!.path,
          //     filename: updateUserProfileBody.name)
          : null,
    };
    // }
    // Uri uri = Uri(
    //   scheme: 'https',
    //   host: 'zladag-catnip-services.as.r.appspot.com',
    //   path: '/api/profile/update',

    // );

    // print(accessToken);
    // print('test ${updateUserProfileBody.name}');
    final response = await dio.post(
      'https://zladag-catnip-services.as.r.appspot.com/api/profile/update',
      data: body,
      options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            // 'content-type': 'multipart/form-data',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );

    if (response.statusCode == 200) {
      print('hasilnya save data $response');
      return true;
    } else if (response.statusCode == 422) {
      print('hasilnya save data $response');
      // print(response.data.toString());
      // throw ServerException();
      return false;
    } else {
      print('hasilnya save data ${response.data}');
      throw ServerException();
    }
  }

  @override
  Future<bool> updatePetData(
      {required String accessToken,
      required PostPetDataBody postPetDataBody,
      required String petId}) async {
    Map body;
    // final imageFile = await MultipartFile.fromFile(
    //   postPetDataBody.image?.path ?? "",
    //   filename:
    //       '${postPetDataBody.name}-${postPetDataBody.petBreedId}-$accessToken',
    // );
    body = {
      'petBreedId': postPetDataBody.petBreedId,
      'petGender': postPetDataBody.petGender,
      'name': postPetDataBody.name,
      'age': postPetDataBody.age,
      'bodyMass': postPetDataBody.bodyMass,
      'hasBeenSterilized': postPetDataBody.hasBeenSterilized,
      'hasBeenVaccinatedRoutinely': postPetDataBody.hasBeenVaccinatedRoutinely,
      'hasBeenFleaFreeRegularly': postPetDataBody.hasBeenFleaFreeRegularly,
      'historyOfIllness': postPetDataBody.historyOfIllness,
      'boardingFacilities': postPetDataBody.boardingFacilities,
      'petHabitIds': postPetDataBody.petHabitIds,
      'image': postPetDataBody.image,
      // 'image': imageFile,
      // 'image': await MultipartFile.fromFile(postPetDataBody.image!.path,
      //     filename:
      //         '${postPetDataBody.name}-${postPetDataBody.petBreedId}-$accessToken'),
    };

    print('test brodi');
    final response = await dio.post(
      'https://zladag-catnip-services.as.r.appspot.com/api/profile/pets/$petId/update',
      data: jsonEncode(body),
      options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );

    if (response.statusCode == 200) {
      print('hasilnya update pet data ${response.data['success']}');
      return response.data['success'];
    } else if (response.statusCode == 422) {
      print(response.data.toString());
      // throw ServerException();
      return false;
    } else {
      throw ServerException();
    }
  }
}

class ToImageData {
  static String imagetoData(String? imagepath) {
    final extension =
        // path.extension(
        imagepath!.substring(imagepath.lastIndexOf("/")).replaceAll("/", "");
    // );
    final bytes = File(imagepath).readAsBytesSync();
    String base64 =
        "data:image/${extension.replaceAll(".", "")};base64,${base64Encode(bytes)}";
    return base64;
  }
}
