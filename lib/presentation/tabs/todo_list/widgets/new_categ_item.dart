import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_todo_app/utils/colors.dart';

class NewCategoryItem extends StatelessWidget {
  const NewCategoryItem({
    Key? key,
    required this.isActive,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final bool isActive;
  final VoidCallback onTap;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        width: 70.w,
        decoration: BoxDecoration(
          color: MyColors.C_363636,
          border: Border.all(color: (isActive) ? Colors.white : MyColors.C_363636),
          borderRadius: BorderRadius.circular(7.r),
        ),
        margin: const EdgeInsets.only(right: 12),
        child: SvgPicture.asset(icon),
      ),
    );
  }
}
