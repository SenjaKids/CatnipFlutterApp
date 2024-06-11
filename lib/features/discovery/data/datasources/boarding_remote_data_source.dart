// import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zladag_flutter_app/core/constants/constants.dart';
import 'package:zladag_flutter_app/core/errors/exceptions.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/discovery/data/models/boarding_model.dart';
import 'package:zladag_flutter_app/features/discovery/data/models/sub_models.dart';

abstract class BoardingRemoteDataSource {
  Future<List<BoardingModel>> getHomeFilteredBoarding(
      {required String boardingFilter,
      required HomeFilteredBoardingParams params});
  Future<List<BoardingModel>> getSearchedBoarding(
      {required BoardingSearchParams params});
  Future<BoardingModel> getBoardingDetails(
      {required BoardingDetailsParams params});
  Future<List<AutocompletePrediction>> getAutocomplete(
      {required AutoCompleteParams params});
  Future<LatLng> getAutocompleteLocation({required String locationID});
}

class BoardingRemoteDataSourceImpl implements BoardingRemoteDataSource {
  final Dio dio;

  const BoardingRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BoardingModel>> getHomeFilteredBoarding(
      {required String boardingFilter,
      required HomeFilteredBoardingParams params}) async {
    final response = await dio.get(
        'https://zladag-catnip-services.as.r.appspot.com/api/home',
        queryParameters: {
          'latitude': params.latitude,
          'longitude': params.longitude,
        });

    var boardingsJson = response.data['data'][boardingFilter];

    if (response.statusCode == 200) {
      List<BoardingModel> boardingModels = [];

      for (var boardingJson in boardingsJson) {
        boardingModels.add(BoardingModel.fromJson(boardingJson));
      }

      return boardingModels;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<BoardingModel>> getSearchedBoarding(
      {required BoardingSearchParams params}) async {
    Uri uri = Uri(
      scheme: 'http',
      host: 'zladag-catnip-services.as.r.appspot.com',
      path: '/api/search',
      queryParameters: {
        'latitude': params.latitude,
        'longitude': params.longitude,
        'sortBy': params.sortBy,
        'lowestPriceRange':
            params.lowestPriceRange != '' && params.lowestPriceRange != null
                ? (params.lowestPriceRange!
                        .substring(2, params.lowestPriceRange!.length))
                    .replaceAll(RegExp(r'[^\w\s]+'), '')
                : null,
        'highestPriceRange':
            params.highestPriceRange != '' && params.highestPriceRange != null
                ? (params.highestPriceRange!
                        .substring(2, params.highestPriceRange!.length))
                    .replaceAll(RegExp(r'[^\w\s]+'), '')
                : null,
        (params.boardingCategories != null
            ? 'boardingCategories[]'
            : 'boardingCategories'): params.boardingCategories,
        (params.boardingFacilities != null
            ? 'boardingFacilities[]'
            : 'boardingFacilities'): params.boardingFacilities,
        (params.boardingPetCategories != null
            ? 'boardingPetCategories[]'
            : 'boardingPetCategories'): params.boardingPetCategories,
      },
    );
    print(' after search func: ${uri}');
    final response = await dio.getUri(uri);

    print(' after search func: ${response}');

    var boardingsJson = response.data['data'];

    if (response.statusCode == 200) {
      List<BoardingModel> boardingModels = [];

      for (var boardingJson in boardingsJson) {
        boardingModels.add(BoardingModel.fromJson(boardingJson));
      }

      return boardingModels;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<BoardingModel> getBoardingDetails(
      {required BoardingDetailsParams params}) async {
    final response = await dio.get(
        'https://zladag-catnip-services.as.r.appspot.com/api/boardings/${params.slug}',
        queryParameters: {
          'latitude': params.latitude,
          'longitude': params.longitude,
        });

    print('debug latitude' + params.latitude.toString());

    var boardingJson = response.data['data'];

    if (response.statusCode == 200) {
      BoardingModel boardingModel = BoardingModel();

      boardingModel = BoardingModel.fromJson(boardingJson);

      return boardingModel;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<AutocompletePrediction>> getAutocomplete(
      {required AutoCompleteParams params}) async {
    final response = await dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'key': params.googleApiKey,
          'input': params.query,
          "components": "country:id",
          'language': 'id_ID',
        });

    // print(getAutocompleteLocation(locationID: 'ChIJnUvjRenzaS4RoobX2g-_cVM'));

    if (response.statusCode == 200) {
      PlaceAutocompleteResponse placeAutocompleteResponse =
          PlaceAutocompleteResponse.fromJson(response.data);
      if (placeAutocompleteResponse.predictions != null) {
        return placeAutocompleteResponse.predictions!;
      }
      return [];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<LatLng> getAutocompleteLocation({required String locationID}) async {
    final response = await dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'key': googleApikey,
          'place_id': locationID,
        });

    if (response.statusCode == 200) {
      LatLng latLng = LatLng(
          response.data['result']['geometry']['location']['lat'],
          response.data['result']['geometry']['location']['lng']);
      print(latLng);
      return latLng;
    } else {
      throw ServerException();
    }
  }
}
