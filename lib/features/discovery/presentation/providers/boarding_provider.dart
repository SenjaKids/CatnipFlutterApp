import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/discovery/data/datasources/boarding_remote_data_source.dart';
import 'package:zladag_flutter_app/features/discovery/data/models/sub_models.dart';
import 'package:zladag_flutter_app/features/discovery/data/repositories/boarding_repository_impl.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/boarding_entity.dart';
import 'package:zladag_flutter_app/features/discovery/domain/usecases/get_auto_complete.dart';
import 'package:zladag_flutter_app/features/discovery/domain/usecases/get_auto_complete_location.dart';
import 'package:zladag_flutter_app/features/discovery/domain/usecases/get_boarding_details.dart';
import 'package:zladag_flutter_app/features/discovery/domain/usecases/get_home_filtered_boarding.dart';
import 'package:zladag_flutter_app/features/discovery/domain/usecases/get_searched_boarding.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';

class BoardingProvider extends ChangeNotifier {
  List<BoardingEntity>? boardings;
  BoardingEntity? boarding;
  List<BoardingEntity>? homeBoardingsWithFood;
  List<BoardingEntity>? homeBoardingsWithPlayground;
  List<AutocompletePrediction>? autoComplete;
  Failure? failure;
  LatLng? latLng;

  BoardingProvider({
    this.boardings,
    this.failure,
  });

  void eitherFailureOrHomeBoardingsWithFood(
      {required HomeFilteredBoardingParams params}) async {
    BoardingRepositoryImpl repository = BoardingRepositoryImpl(
      remoteDataSource: BoardingRemoteDataSourceImpl(dio: Dio()),
      // localDataSource: PokemonLocalDataSourceImpl(
      //     sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrHomeFilteredBoardings =
        await GetHomeFilteredBoarding(repository)
            .call(boardingFilter: 'petHotelsWithFoodFacility', params: params);

    failureOrHomeFilteredBoardings.fold(
      (newFailure) {
        homeBoardingsWithFood = null;
        failure = newFailure;
        notifyListeners();
      },
      (newBoardings) {
        homeBoardingsWithFood = newBoardings;
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrHomeBoardingsWithPlayground(
      {required HomeFilteredBoardingParams params}) async {
    BoardingRepositoryImpl repository = BoardingRepositoryImpl(
      remoteDataSource: BoardingRemoteDataSourceImpl(dio: Dio()),
      // localDataSource: PokemonLocalDataSourceImpl(
      //     sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrHomeFilteredBoardings =
        await GetHomeFilteredBoarding(repository).call(
      boardingFilter: 'petHotelsWithPlaygroundFacility',
      params: params,
    );

    failureOrHomeFilteredBoardings.fold(
      (newFailure) {
        homeBoardingsWithPlayground = null;
        failure = newFailure;
        notifyListeners();
      },
      (newBoardings) {
        homeBoardingsWithPlayground = newBoardings;
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrSearchedBoardings({
    String? latitude,
    String? longitude,
    String? sortBy,
    String? topPriceRange,
    String? bottomPriceRange,
    List<String>? petCategories,
    List<String>? boardingCategories,
    List<String>? facilities,
  }) async {
    BoardingRepositoryImpl repository = BoardingRepositoryImpl(
      remoteDataSource: BoardingRemoteDataSourceImpl(dio: Dio()),
      // localDataSource: PokemonLocalDataSourceImpl(
      //     sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrSearchedBoardings =
        await GetSearchedBoarding(repository).call(
      params: BoardingSearchParams(
        latitude: latitude,
        longitude: longitude,
        sortBy: sortBy,
        boardingCategories: boardingCategories,
        boardingFacilities: facilities,
        boardingPetCategories: petCategories,
        highestPriceRange: topPriceRange,
        lowestPriceRange: bottomPriceRange,
      ),
    );

    debugPrint(BoardingSearchParams(
      latitude: latitude,
      longitude: longitude,
      sortBy: sortBy,
      boardingCategories: boardingCategories,
      boardingFacilities: facilities,
      boardingPetCategories: petCategories,
      highestPriceRange: topPriceRange,
      lowestPriceRange: bottomPriceRange,
    ).toString());

    failureOrSearchedBoardings.fold(
      (newFailure) {
        boardings = null;
        failure = newFailure;

        notifyListeners();
      },
      (newBoardings) {
        boardings = newBoardings;
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrBoardingDetails({
    required String slug,
    required String? latitude,
    required String? longitude,
  }) async {
    BoardingRepositoryImpl repository = BoardingRepositoryImpl(
      remoteDataSource: BoardingRemoteDataSourceImpl(dio: Dio()),
      // localDataSource: PokemonLocalDataSourceImpl(
      //     sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrBoardingDetails = await GetBoardingDetails(repository).call(
      boardingDetailsParams: BoardingDetailsParams(
        slug: slug,
        latitude: latitude,
        longitude: longitude,
      ),
    );

    failureOrBoardingDetails.fold(
      (newFailure) {
        boarding = null;
        failure = newFailure;
        notifyListeners();
      },
      (newBoarding) {
        boarding = newBoarding;
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrAutocomplete({
    required String key,
    required String query,
  }) async {
    BoardingRepositoryImpl repository = BoardingRepositoryImpl(
      remoteDataSource: BoardingRemoteDataSourceImpl(dio: Dio()),
      // localDataSource: PokemonLocalDataSourceImpl(
      //     sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrAutocompletePrediction =
        await GetAutoComplete(repository).call(
      autoCompleteParams: AutoCompleteParams(
        googleApiKey: key,
        query: query,
      ),
    );

    failureOrAutocompletePrediction.fold(
      (newFailure) {
        autoComplete = null;
        failure = newFailure;
        notifyListeners();
      },
      (predictions) {
        autoComplete = predictions;
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrLatlng({
    required String locationID,
  }) async {
    BoardingRepositoryImpl repository = BoardingRepositoryImpl(
      remoteDataSource: BoardingRemoteDataSourceImpl(dio: Dio()),
      // localDataSource: PokemonLocalDataSourceImpl(
      //     sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrlatlng = await GetAutoCompleteLocation(repository).call(
      locationID: locationID,
    );

    failureOrlatlng.fold(
      (newFailure) {
        latLng = null;
        failure = newFailure;
        notifyListeners();
      },
      (newLatlng) {
        latLng = newLatlng;
        failure = null;
        notifyListeners();
      },
    );
  }
}
