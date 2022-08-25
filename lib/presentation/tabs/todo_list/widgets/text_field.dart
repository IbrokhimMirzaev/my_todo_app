import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/utils/colors.dart';

class TextField2 extends StatelessWidget {
  const TextField2({
    Key? key,
    required this.keyType,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    this.isObscure,
    this.hintText,
  }) : super(key: key);
  final bool? isObscure;
  final TextInputType keyType;
  final TextEditingController controller;
  final ValueChanged onSubmitted;
  final FocusNode focusNode;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      scrollPadding: EdgeInsets.zero,
      onSubmitted: onSubmitted,
      style: GoogleFonts.lato().copyWith(fontSize: 16.sp, color: Colors.white),
      obscureText: isObscure ?? false,
      focusNode: focusNode,
      keyboardType: keyType,
      cursorColor: Colors.white,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText ?? "",
        hintStyle: GoogleFonts.lato().copyWith(fontSize: 16.sp, color: MyColors.white_87),
        filled: true,
        fillColor: MyColors.C_363636,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          borderSide: const BorderSide(
            color: MyColors.C_979797,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          borderSide: const BorderSide(
            color: MyColors.C_363636,
            width: 0.8,
          ),
        ),
      ),
    );
  }
}
