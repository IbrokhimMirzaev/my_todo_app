import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class MyRow extends StatelessWidget {
  const MyRow({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.arrow,
    this.textColor,
    this.hColor,
  }) : super(key: key);

  final String icon;
  final String text;
  final String? arrow;
  final Color? textColor;
  final VoidCallback onTap;
  final Color? hColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: hColor,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child : Row(
                children: [
                  SvgPicture.asset(icon),
                  SizedBox(width: 15.w),
                  Text(
                    text,
                    style: GoogleFonts.lato().copyWith(
                      fontSize: 16.sp,
                      color: textColor ?? MyColors.white_87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Image.asset(arrow ?? MyIcons.arrowLeft, color: MyColors.white_87, width: 17.w, height: 17.h),
          ],
        ),
      ),
    );
  }
}
