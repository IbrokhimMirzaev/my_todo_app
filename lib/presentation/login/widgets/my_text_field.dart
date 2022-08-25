import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/utils/colors.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.keyType,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    this.isObscure,
    this.hintText,
    this.bgColor,
  }) : super(key: key);
  final bool? isObscure;
  final TextInputType keyType;
  final TextEditingController controller;
  final ValueChanged onSubmitted;
  final FocusNode focusNode;
  final String? hintText;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      style: GoogleFonts.lato().copyWith(fontSize: 16.sp, color: Colors.white),
      obscureText: isObscure ?? false,
      focusNode: focusNode,
      keyboardType: keyType,
      cursorColor: Colors.white,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText ?? "",
        hintStyle: GoogleFonts.lato().copyWith(fontSize: 12.sp, color: MyColors.white_87),
        filled: true,
        fillColor: bgColor ?? const Color(0xFF1D1D1D),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          borderSide: const BorderSide(
            color: Color(0xFF979797),
            width: 0.8,
          ),
        ),
      ),
    );
  }
}
