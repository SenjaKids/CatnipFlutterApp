import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zladag_flutter_app/features/shared/widgets/catnip_checkbox.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_color.dart';
import 'package:zladag_flutter_app/features/shared/theme/app_text_style.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';

class InputDropdownCheckbox extends StatefulWidget {
  // final List<String> choices;
  final List<PetHabitEntity> habits;
  final Function onTap;
  const InputDropdownCheckbox(
      {super.key, required this.habits, required this.onTap});

  @override
  State<InputDropdownCheckbox> createState() => _InputDropdownCheckboxState();
}

class _InputDropdownCheckboxState extends State<InputDropdownCheckbox> {
  bool isOpen = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.grey_3,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() {
              isOpen = !isOpen;
            }),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pilih Kebiasaan',
                      style: AppTextStyle(color: AppColor.grey_1).sfproBodyS(),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/ic-chev-${isOpen ? "up" : "bottom"}.svg',
                    colorFilter:
                        ColorFilter.mode(AppColor.grey_1, BlendMode.srcIn),
                  ),
                ],
              ),
            ),
          ),
          (isOpen
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: widget.habits.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CatnipCheckbox(
                        primaryLabel: widget.habits[index].name,
                        catnipCheckboxType: CatnipCheckboxType.regular,
                        checkboxIconSize: 20,
                        onClick: () {
                          // print('a');
                          widget.onTap(widget.habits[index].id,
                              widget.habits[index].name);
                        },
                      ),
                    );
                  },
                )
              : const SizedBox())
        ],
      ),
    );
  }
}
