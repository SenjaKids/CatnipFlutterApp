// import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zladag_flutter_app/core/errors/exceptions.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/discovery/data/models/sub_models.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/reservation/data/model/reservation_model.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/reservation_entity.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/sub_entity.dart';
import 'package:zladag_flutter_app/features/user/data/models/sub_models.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';

abstract class ReservationRemoteDataSource {
  Future<ReservationBoardingDetail> getBoardingReservationData(
      {required String accessToken, required String slug});
  Future<bool> postOrder(
      {required String accessToken, required PostOrderBody postOrderBody});
  Future<List<OrderEntity>> getUserOrderData(
      {required String accessToken, required bool active});
}

class ReservationRemoteDataSourceImpl implements ReservationRemoteDataSource {
  final Dio dio;

  const ReservationRemoteDataSourceImpl({required this.dio});

  @override
  Future<ReservationBoardingDetail> getBoardingReservationData(
      {required String accessToken, required String slug}) async {
    print('before reserve');
    print(slug);
    print(accessToken);
    final response = await dio.get(
      'https://zladag-catnip-services.as.r.appspot.com/api/boardings/$slug/pets-cages-and-services',
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

    print(response);
    if (response.statusCode == 200) {
      print('hasilnya ${response.data}');

      var dogJson = response.data['data']['pets']['dogs'];
      var catJson = response.data['data']['pets']['cats'];
      var cagesJson = response.data['data']['boardingCages'];
      var servicesJson = response.data['data']['boardingServices'];

      // List<PetBreedEntity> petBreedEntities = [];
      List<PetEntity> dogPetEntities = [];
      List<PetEntity> catPetEntities = [];
      List<CageEntity> cageEntities = [];
      List<BoardingServiceEntity> boardingServices = [];

      for (var petJson in dogJson) {
        dogPetEntities.add(PetModel.fromJson(petJson));
      }

      for (var petJson in catJson) {
        catPetEntities.add(PetModel.fromJson(petJson));
      }

      for (var cageJson in cagesJson) {
        cageEntities.add(CageModel.fromJson(cageJson));
      }

      for (var serviceJson in servicesJson) {
        boardingServices.add(BoardingServiceModel.fromJson(serviceJson));
      }

      // for (var petHabitJson in petHabitsJson) {
      //   petHabitEntities.add(PetHabitModel.fromJson(petHabitJson));
      // }
      // UserModel userModel = UserModel.fromJson(userJson);

      return ReservationBoardingDetail(
          boardingName: response.data['data']['boarding']['name'],
          boardingSlug: response.data['data']['boarding']['slug'],
          catPetEntities: catPetEntities,
          dogPetEntities: dogPetEntities,
          cageEntities: cageEntities,
          boardingServices: boardingServices);
    } else if (response.statusCode == 422) {
      print(response.data.toString());
      // throw ServerException();
      return response.data['message'];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> postOrder(
      {required String accessToken,
      required PostOrderBody postOrderBody}) async {
    Map body;
    List<dynamic> orders = [];
    for (OrderEntity o in postOrderBody.orders) {
      List<String> servicesId = [];
      for (BoardingServiceEntity i in o.boardingServices!) {
        servicesId.add(i.id!);
      }
      orders.add({
        'petId': o.petEntity!.id,
        'note': o.note,
        'boardingCageId': o.cageEntity!.id,
        'boardingServiceIds': servicesId,
      });
    }
    body = {
      'boarding': postOrderBody.slug,
      'checkInDate': postOrderBody.checkInDate,
      'checkOutDate': postOrderBody.checkOutDate,
      'orders': orders,
    };

    final response = await dio.post(
      'https://zladag-catnip-services.as.r.appspot.com/api/profile/orders/store',
      data: body,
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
      print('hasilnya save data order ${response.data['success']}');
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
  Future<List<OrderEntity>> getUserOrderData(
      {required String accessToken, required bool active}) async {
    final response = await dio.get(
      'https://zladag-catnip-services.as.r.appspot.com/api/profile/orders',
      queryParameters: {
        'active': active,
      },
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

    print(response);
    if (response.statusCode == 200) {
      print('hasilnya ${response.data}');

      var jsonData = response.data['data'];

      // List<PetBreedEntity> petBreedEntities = [];
      List<OrderEntity> orderEntities = [];

      for (var orderJson in jsonData) {
        orderEntities.add(OrderModel.fromJson(orderJson));
      }

      return orderEntities;
    } else if (response.statusCode == 422) {
      print(response.data.toString());
      // throw ServerException();
      return response.data['message'];
    } else {
      throw ServerException();
    }
  }
}
