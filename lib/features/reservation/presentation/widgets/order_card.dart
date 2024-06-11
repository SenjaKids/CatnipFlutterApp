import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:zladag_flutter_app/features/reservation/domain/entities/reservation_entity.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';

class OrderCardWidget extends StatefulWidget {
  final OrderEntity orderEntity;
  const OrderCardWidget({super.key, required this.orderEntity});

  @override
  State<OrderCardWidget> createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.orderEntity.boardingEntity!.name!,
                style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              SvgPicture.asset(
                'assets/icons/ic-chev-right.svg',
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(AppColor.grey_1, BlendMode.srcIn),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${DateFormat.MMMd('id_ID').format(DateTime.parse(widget.orderEntity.checkInDate!))} - ${DateFormat.MMMd('id_ID').format(DateTime.parse(widget.orderEntity.checkOutDate!))}',
            style: AppTextStyle(color: AppColor.grey_1).mulishBodyS(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/ic-paw.svg',
                colorFilter: ColorFilter.mode(AppColor.grey_1, BlendMode.srcIn),
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 4),
              Text(
                widget.orderEntity.petEntity!.name!,
                style: AppTextStyle(color: AppColor.grey_1).mulishBodyS(),
              ),
            ],
          ),
          // const SizedBox(height: 8),
          Divider(
            color: AppColor.grey_3,
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColor.blue_2,
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              //TODO: ATUR TEXT DAN COLOR STATUS ORDER
              widget.orderEntity.status!,
              style: AppTextStyle(color: AppColor.blue_1).mulishBodyS(),
            ),
          )
        ],
      ),
    );
  }
}
