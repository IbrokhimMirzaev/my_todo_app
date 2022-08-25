import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      body: Column(
        children: [
          Image.asset(MyIcons.intro2, height: 250.h),
          SizedBox(height: 75.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                height: 4.h,
                width: 27.w,
              ),
              SizedBox(width: 8.w),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                height: 4.h,
                width: 27.w,
              ),
              SizedBox(width: 8.w),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                height: 4.h,
                width: 27.w,
              ),
              SizedBox(width: 8.w),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                height: 4.h,
                width: 27.w,
              ),
            ],
          ),
          SizedBox(height: 50.h),
          Text(
            tr("routine"),
            style: GoogleFonts.lato().copyWith(
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.87),
              letterSpacing: 0.8,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 42.h),
          Text(
            tr("uptodo"),
            style: GoogleFonts.lato().copyWith(color: Colors.white.withOpacity(0.87), height: 1.7), textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
