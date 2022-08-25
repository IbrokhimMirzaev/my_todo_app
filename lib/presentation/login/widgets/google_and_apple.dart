import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/utils/colors.dart';

class GoogleAndApple extends StatelessWidget {
  const GoogleAndApple({Key? key, required this.text, required this.svgPath}) : super(key: key);

  final String text;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: MyColors.buttonColor, width: 1.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(svgPath),
          SizedBox(width: 15.w),
          Text(
            text,
            style: GoogleFonts.lato().copyWith(
              color: Colors.white.withOpacity(0.87),
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
