import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/utils/colors.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.text,
    this.width,
    this.buttonColor,
    this.textColor,
  }) : super(key: key);

  final String text;
  final double? width;
  final Color? textColor;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 48.h,
      decoration: BoxDecoration(
        color: buttonColor ?? MyColors.C_8687E7,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.lato().copyWith(
            color: textColor ?? Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
