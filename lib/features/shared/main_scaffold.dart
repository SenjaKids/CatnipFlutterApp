import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zladag_flutter_app/features/discovery/presentation/pages/home.dart';
import 'package:zladag_flutter_app/features/reservation/presentation/pages/your_orders.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/user/presentation/pages/profile.dart';

class MainScaffoldWidget extends StatefulWidget {
  const MainScaffoldWidget({super.key});

  @override
  State<MainScaffoldWidget> createState() => _MainScaffoldWidgetState();
}

class _MainScaffoldWidgetState extends State<MainScaffoldWidget> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = [
    HomeWidget(),
    YourOrderWidget(),
    ProfileWidget(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/ic-tab-home.svg',
              colorFilter: ColorFilter.mode(
                  (_selectedIndex == 0 ? AppColor.orange_1 : AppColor.grey_2),
                  BlendMode.srcIn),
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/ic-tab-order.svg',
              colorFilter: ColorFilter.mode(
                  (_selectedIndex == 1 ? AppColor.orange_1 : AppColor.grey_2),
                  BlendMode.srcIn),
            ),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/ic-tab-pet.svg',
              colorFilter: ColorFilter.mode(
                  (_selectedIndex == 2 ? AppColor.orange_1 : AppColor.grey_2),
                  BlendMode.srcIn),
            ),
            label: 'Your Pet',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'SF-Pro',
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
        selectedLabelStyle: const TextStyle(
          fontFamily: 'SF-Pro',
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
        unselectedItemColor: AppColor.grey_2,
        selectedItemColor: AppColor.orange_1,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
