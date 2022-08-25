import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/utils/colors.dart';

class DateItem extends StatelessWidget {
  const DateItem({
    Key? key,
    required this.text,
    required this.onTap,
    required this.prefixText,
  }) : super(key: key);

  final String text;
  final String prefixText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(prefixText, style: GoogleFonts.lato().copyWith(color: MyColors.white_87, fontSize: 17.sp)),
        TextButton(
          onPressed: onTap,
          child: Text(
            text,
            style: GoogleFonts.lato().copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: MyColors.white_87,
            ),
          ),
        ),
      ],
    );
  }
}
