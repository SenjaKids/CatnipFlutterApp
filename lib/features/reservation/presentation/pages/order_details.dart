import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_button.dart';

class OrderDetailsWidget extends StatefulWidget {
  const OrderDetailsWidget({super.key});

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.orange_2,
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      //TODO: BACKGROUND COLOR APP BAR
      backgroundColor: AppColor.orange_2,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/ic-chev-left.svg',
            height: 28,
            width: 28,
          ),
        ),
      ),
      title: Text(
        'Order Detail',
        style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(color: AppColor.orange_2),
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  'https://picsum.photos/500/1000',
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 24),
                Text(
                  'Tunggu',
                  style: AppTextStyle(color: AppColor.black_2).mulishTitleM(),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pet hotel akan segera mengkonfirmasi pesananmu',
                  style: AppTextStyle(color: AppColor.grey_1).mulishBodyS(),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            width: double.maxFinite,
            decoration: BoxDecoration(color: AppColor.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.grey_3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Miru pet hotel',
                                  style: AppTextStyle(color: AppColor.black_2)
                                      .mulishTitleM(),
                                ),
                                Text(
                                  'Kemanggisan, jakarta utara',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.14,
                                      color: AppColor.black_2),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/ic-star.svg',
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '4.5',
                                style: TextStyle(
                                  fontFamily: 'SF-Pro',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                  color: AppColor.orange_1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'View Pet Hotel',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.14,
                          color: AppColor.black_2,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Jadwal Penitipan',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 0.14,
                    color: AppColor.black_2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '7 Okt - 8 Okt 2023',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.14,
                    color: AppColor.black_2,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Anabul dan Layanan',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 0.14,
                    color: AppColor.black_2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.grey_3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              'https://picsum.photos/200/300',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pet name',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 16,
                                  height: 1.5,
                                  letterSpacing: 0.16,
                                  color: AppColor.black_2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                // '${petEntity.petBreed} · ${petEntity.age! < 12 ? "${petEntity.age} Bulan" : "${petEntity.age! ~/ 12} Tahun"}',
                                'Kucing Persian Himalaya · 1 tahun',
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle(color: AppColor.grey_1)
                                    .mulishBodyS(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Divider(color: AppColor.grey_3),
                      const SizedBox(height: 24),
                      Text(
                        'Penitipan',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 0.14,
                          color: AppColor.black_2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Kandang normal',
                              style: AppTextStyle(color: AppColor.black_2)
                                  .mulishBodyS()),
                          const Spacer(),
                          Text('Rp50.000',
                              style: AppTextStyle(color: AppColor.black_2)
                                  .mulishBodyS()),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Add-on service',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 0.14,
                          color: AppColor.black_2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Grooming',
                              style: AppTextStyle(color: AppColor.black_2)
                                  .mulishBodyS()),
                          const Spacer(),
                          Text('+Rp50.000',
                              style: AppTextStyle(color: AppColor.black_2)
                                  .mulishBodyS()),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text('Grooming',
                              style: AppTextStyle(color: AppColor.black_2)
                                  .mulishBodyS()),
                          const Spacer(),
                          Text('+Rp50.000',
                              style: AppTextStyle(color: AppColor.black_2)
                                  .mulishBodyS()),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Notes',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 0.14,
                          color: AppColor.black_2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      //TODO: GANTI JADI FONT ITALIC BROW
                      Text('"Kandang Normal"',
                          style: AppTextStyle(color: AppColor.black_2)
                              .mulishBodyS()),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Divider(color: AppColor.grey_3),
                const SizedBox(height: 24),
                //TODO: REVISI FONT
                Row(
                  children: [
                    Text(
                      'Subtotal Penginapan',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 0.14,
                        color: AppColor.black_2,
                      ),
                    ),
                    const Spacer(),
                    Text('Rp150.000',
                        style: AppTextStyle(color: AppColor.black_2)
                            .mulishBodyS()),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'Add-on Service',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 0.14,
                        color: AppColor.black_2,
                      ),
                    ),
                    const Spacer(),
                    Text('Rp150.000',
                        style: AppTextStyle(color: AppColor.black_2)
                            .mulishBodyS()),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'Service fee',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 0.14,
                        color: AppColor.black_2,
                      ),
                    ),
                    const Spacer(),
                    Text('Rp1.000',
                        style: AppTextStyle(color: AppColor.black_2)
                            .mulishBodyS()),
                  ],
                ),
                const SizedBox(height: 24),
                Divider(color: AppColor.grey_3),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 0.14,
                        color: AppColor.black_2,
                      ),
                    ),
                    const Spacer(),
                    Text('Rp151.000',
                        style: AppTextStyle(color: AppColor.black_2)
                            .mulishBodyS()),
                  ],
                ),
                const SizedBox(height: 24),
                const CatnipButton(
                  label: 'Chat Pet Hotel',
                ),
                const SizedBox(height: 40),
              ],
            ),
          )
        ],
      ),
    );
  }
}
