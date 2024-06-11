import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/reservation_entity.dart';
import 'package:zladag_flutter_app/features/reservation/presentation/provider/reservation_provider.dart';
import 'package:zladag_flutter_app/features/reservation/presentation/widgets/order_card.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_loading_state.dart';

class YourOrderWidget extends StatefulWidget {
  const YourOrderWidget({super.key});

  @override
  State<YourOrderWidget> createState() => _YourOrderWidgetState();
}

class _YourOrderWidgetState extends State<YourOrderWidget> {
  String? accessToken;
  List<OrderEntity>? activeOrderEntities, historyOrderEntities;
  void _getSavedAccessToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    const cachedAccessToken = 'CACHED_ACCESS_TOKEN';
    setState(() {
      accessToken = prefs.getString(cachedAccessToken);
      Provider.of<ReservationProvider>(context, listen: false)
          .eitherFailureOrHistoryOrderEntities(
              accessToken: accessToken!, active: true, context: context);
      Provider.of<ReservationProvider>(context, listen: false)
          .eitherFailureOrHistoryOrderEntities(
              accessToken: accessToken!, active: false, context: context);
    });

    // if (accessToken != null) {
    //   // ignore: use_build_context_synchronously
    //   Provider.of<Reser>(context, listen: false)
    //       .eitherFailureOrUserData(accessToken: accessToken!, context: context);
    // }

    // print("token saved $accessToken");
  }

  @override
  void initState() {
    // TODO: implement initState
    _getSavedAccessToken(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    activeOrderEntities =
        Provider.of<ReservationProvider>(context, listen: true)
            .activeOrderEntities;
    historyOrderEntities =
        Provider.of<ReservationProvider>(context, listen: true)
            .historyOrderEntities;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColor.grey_3,
        appBar: _appBar(),
        body: _body(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Your Orders',
        style: TextStyle(
          fontFamily: 'SF-Pro',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColor.black_2,
        ),
      ),
      backgroundColor: AppColor.white,
      elevation: 0,
      bottom: TabBar(
        indicatorColor: AppColor.orange_1,
        indicatorWeight: 2,
        unselectedLabelColor: AppColor.grey_1,
        labelColor: AppColor.black_1,
        unselectedLabelStyle:
            AppTextStyle(color: AppColor.grey_1).mulishBodyM(),
        labelStyle: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Active',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'History',
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return TabBarView(
      children: [
        _activeTabView(),
        _historyTabView(),
      ],
    );
  }

  Widget _activeTabView() {
    late Widget widget;

    if (activeOrderEntities == null) {
      widget = const CatnipLoadingState();
    } else if (activeOrderEntities!.isEmpty) {
      widget = _emptyStateOrder();
    } else {
      widget = ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: activeOrderEntities!.length,
        itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/order_details'),
            child: OrderCardWidget(orderEntity: activeOrderEntities![index])),
      );
    }

    return widget;
  }

  Widget _historyTabView() {
    late Widget widget;

    if (historyOrderEntities == null) {
      widget = const CatnipLoadingState();
    } else if (historyOrderEntities!.isEmpty) {
      widget = _emptyStateOrder();
    } else {
      widget = ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: historyOrderEntities!.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/order_details'),
          child: OrderCardWidget(orderEntity: historyOrderEntities![index]),
        ),
      );
    }

    return widget;
  }

  Widget _emptyStateOrder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/il-empty-state.svg',
            width: 173,
            height: 173,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Text(
            'Belum ada pesanan',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 24,
              letterSpacing: 0.24,
              color: AppColor.black_2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Cari pet hotel untuk anabulmu',
            style: TextStyle(
                fontFamily: 'SF-Pro',
                fontSize: 16,
                color: AppColor.grey_1,
                fontWeight: FontWeight.w400,
                height: 1.5),
          ),
        ],
      ),
    );
  }
}
