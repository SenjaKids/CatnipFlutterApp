import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/reservation/presentation/pages/order_details.dart';
import 'package:zladag_flutter_app/features/reservation/presentation/pages/reservasi.dart';
import 'package:zladag_flutter_app/features/reservation/presentation/provider/reservation_provider.dart';
import 'package:zladag_flutter_app/features/shared/main_scaffold.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/edit_anabul.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/login.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/login_whatsapp.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/pet_details.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/profile.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/profile_settings.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/register.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/splashscreen.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/starting_form.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/tambah_anabul.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/varifikasi_otp.dart';
import 'package:zladag_flutter_app/features/user/presentation/providers/auth_provider.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/pages/boarding_details.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/pages/home.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/pages/search.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/providers/boarding_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('id_ID', null).then((_) => runApp(
        const MainApp(),
      ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BoardingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReservationProvider(),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreenWidget(),
          '/main_activity': (context) => const MainScaffoldWidget(),
          '/register': (context) => const RegisterWidget(),
          '/login': (context) => const LoginWidget(),
          '/login_whatsapp': (context) => const LoginWhatsappWidget(),
          '/verifikasi_otp': (context) => VerifikasiOTPWidget(
              phoneNumber:
                  ModalRoute.of(context)!.settings.arguments.toString()),
          '/starting_form': (context) => const StartingFormWidget(),
          '/home': (context) {
            return const HomeWidget();
          },
          '/profile': (context) => const ProfileWidget(),
          '/profile_setting': (context) => const ProfileSettingsWidget(),
          '/pet_details': (context) => const PetDetailsWidget(),
          '/tambah_anabul': (context) => const TambahAnabulWidget(),
          '/edit_anabul': (context) => const EditAnabulWidget(),
          '/reservasi': (context) => ReservasiWidget(
              slug: ModalRoute.of(context)!.settings.arguments.toString()),
          '/order_details': (context) => const OrderDetailsWidget(),
          '/boarding_details': (context) {
            final arg = ModalRoute.of(context)!.settings.arguments
                as BoardingDetailsParams;
            return BoardingDetailsWidget(
              slug: arg.slug,
              longitude: arg.longitude,
              latitude: arg.latitude,
            );
          },
          '/search': (context) {
            final arg = ModalRoute.of(context)!.settings.arguments as Map;
            return SearchWidget(
              boardingSearchParams:
                  arg['boardingSearchParams'] as BoardingSearchParams,
              dogQty: arg['dogQty'],
              catQty: arg['catQty'],
              location: arg['location'],
              startDate: arg['startDate'],
              endDate: arg['endDate'],
            );
          }
        },
        theme: ThemeData(
          fontFamily: 'Mulish',
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.transparent),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
