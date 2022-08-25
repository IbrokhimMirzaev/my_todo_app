import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/utils/colors.dart';

class MyEditRow extends StatelessWidget {
  const MyEditRow({
    Key? key,
    required this.text,
    required this.taskName,
    required this.icon,
  }) : super(key: key);

  final Widget text;
  final String taskName;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            icon,
            SizedBox(width: 10.w),
            Text(
              taskName,
              style: GoogleFonts.lato().copyWith(
                fontSize: 16.sp,
                color: MyColors.white_87,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: text,
          ),
        ),
      ],
    );
  }
}
