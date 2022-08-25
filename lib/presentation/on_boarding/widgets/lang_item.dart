import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class LangItem extends StatelessWidget {
  const LangItem({
    Key? key,
    required this.onTap,
    required this.text,
    required this.isActive,
    required this.imagePath,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  final bool isActive;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(imagePath, width: 28.w),
          SizedBox(width: 15.w),
          Text(text, style: GoogleFonts.lato().copyWith(fontSize: 20.sp, color: MyColors.white_87)),
          const Expanded(child: SizedBox()),
          Visibility(
            visible: isActive,
            child: isActive
                ? Image.asset(MyIcons.check, width: 15.w, height: 15.h)
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
