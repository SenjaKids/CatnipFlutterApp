import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zladag_flutter_app/core/connection/network_info.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/reservation/data/datasources/reservation_remote_data_source.dart';
import 'package:zladag_flutter_app/features/reservation/data/repositories/reservation_repository_impl.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/reservation_entity.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/sub_entity.dart';
import 'package:zladag_flutter_app/features/reservation/domain/repositories/reservation_repository.dart';
import 'package:zladag_flutter_app/features/reservation/domain/usecases/get_reservation_boarding_detail.dart';
import 'package:zladag_flutter_app/features/reservation/domain/usecases/get_user_order_data.dart';
import 'package:zladag_flutter_app/features/reservation/domain/usecases/post_order.dart';

class ReservationProvider extends ChangeNotifier {
  ReservationBoardingDetail? reservationBoardingDetail;
  // String? accessToken;
  List<OrderEntity>? activeOrderEntities, historyOrderEntities;
  Failure? failure;

  void eitherFailureOrReservationBoardingDetail(
      {required String accessToken,
      required String slug,
      required BuildContext context}) async {
    ReservationRepository repository = ReservationRepositoryImpl(
      remoteDataSource: ReservationRemoteDataSourceImpl(dio: Dio()),
      // localDataSource: AuthLocalDataSourceImpl(
      //     sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrReservationBoardingDetail =
        await GetReservationBoardingDetail(repository)
            .call(accessToken: accessToken, slug: slug);

    failureOrReservationBoardingDetail.fold(
      (newFailure) {
        print('failure');
        reservationBoardingDetail = null;
        failure = newFailure;
        notifyListeners();
      },
      (newReservationBoardingDetail) {
        print('success');
        reservationBoardingDetail = newReservationBoardingDetail;
        print(newReservationBoardingDetail);
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrPostOrderSuccess(
      {required String accessToken,
      required PostOrderBody postOrderBody,
      required BuildContext context}) async {
    ReservationRepository repository = ReservationRepositoryImpl(
      remoteDataSource: ReservationRemoteDataSourceImpl(dio: Dio()),
      // localDataSource: AuthLocalDataSourceImpl(
      //     sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrSuccess = await PostOrder(repository)
        .call(accessToken: accessToken, postOrderBody: postOrderBody);

    failureOrSuccess.fold(
      (newFailure) {
        print('failure');
        failure = newFailure;
        notifyListeners();
      },
      (newSuccess) {
        print('success: $newSuccess');
        // reservationBoardingDetail = newReservationBoardingDetail;
        // print(newReservationBoardingDetail);
        if (newSuccess) {
          Navigator.popAndPushNamed(context, '/main_activity');
        }
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrHistoryOrderEntities(
      {required String accessToken,
      required bool active,
      required BuildContext context}) async {
    ReservationRepository repository = ReservationRepositoryImpl(
      remoteDataSource: ReservationRemoteDataSourceImpl(dio: Dio()),
      // localDataSource: AuthLocalDataSourceImpl(
      //     sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrHistoryOrderEntities = await GetUserOrderData(repository)
        .call(accessToken: accessToken, active: active);

    failureOrHistoryOrderEntities.fold(
      (newFailure) {
        print('failure');
        // reservationBoardingDetail = null;
        if (active) {
          activeOrderEntities = null;
        } else {
          historyOrderEntities = null;
        }
        failure = newFailure;
        notifyListeners();
      },
      (newOrderEntities) {
        print('success');
        print(newOrderEntities);
        if (active) {
          activeOrderEntities = newOrderEntities;
        } else {
          historyOrderEntities = newOrderEntities;
        }
        // reservationBoardingDetail = newReservationBoardingDetail;
        failure = null;
        notifyListeners();
      },
    );
  }
}
