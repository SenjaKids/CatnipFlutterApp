import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zladag_flutter_app/core/connection/location_info.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  Position? _currPosition;

  Future<void> _getCurrentPosition() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final hasPermission =
        await LocationInfoImpl().handleLocationPermission(context);
    if (hasPermission) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        setState(() => _currPosition = position);
        prefs.setDouble('userLongitude', position.longitude);
        prefs.setDouble('userLatitude', position.latitude);
      }).catchError((e) {
        debugPrint(e);
      });
    }

    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.popAndPushNamed(
          context,
          '/main_activity',
          arguments: _currPosition,
        );
      },
    );
  }

  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColor.white),
      child: Center(
        child: SvgPicture.asset(
          'assets/images/logo-catnip.svg',
          width: 86,
          height: 86,
        ),
      ),
    );
  }
}
