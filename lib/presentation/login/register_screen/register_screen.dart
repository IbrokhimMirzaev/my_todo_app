import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/data/local_data/storage.dart';
import 'package:my_todo_app/presentation/login/login_screen/login_screen.dart';
import 'package:my_todo_app/presentation/login/widgets/google_and_apple.dart';
import 'package:my_todo_app/presentation/login/widgets/my_text_field.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/focusChange.dart';
import 'package:my_todo_app/utils/icons.dart';
import 'package:my_todo_app/utils/utility_functions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pass1Controller = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    super.dispose();
  }

  String pas1 = "", pas2 = "", name = "";

  bool isPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
        elevation: 0,
        leading: SizedBox(
          width: 9.w,
          height: 18.h,
          child: SvgPicture.asset(
            MyIcons.back,
            fit: BoxFit.scaleDown,
          ),
        ),
        backgroundColor: MyColors.bgColor,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr("register"),
              style: GoogleFonts.lato().copyWith(
                color: Colors.white.withOpacity(0.87),
                fontWeight: FontWeight.w700,
                fontSize: 32.sp,
              ),
            ),
            SizedBox(height: 22.h),
            Text(
              tr("name"),
              style: GoogleFonts.lato().copyWith(
                  color: Colors.white.withOpacity(0.87), fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            MyTextField(
              onSubmitted: (value) {
                if (value != "") {
                  MyUtils.fieldFocusChange(context, focusNode1, focusNode2);
                }
              },
              focusNode: focusNode1,
              controller: nameController,
              keyType: TextInputType.name,
            ),
            SizedBox(height: 25.h),
            Text(
              tr("password"),
              style: GoogleFonts.lato().copyWith(
                  color: Colors.white.withOpacity(0.87), fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            MyTextField(
              isObscure: true,
              onSubmitted: (value) {
                if (value != "") {
                  MyUtils.fieldFocusChange(context, focusNode2, focusNode3);
                }
              },
              focusNode: focusNode2,
              controller: pass1Controller,
              keyType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 25.h),
            Text(
              tr("confirm"),
              style: GoogleFonts.lato().copyWith(
                  color: Colors.white.withOpacity(0.87), fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            MyTextField(
              isObscure: true,
              onSubmitted: (value) {
                if (value != "") {
                  focusNode3.unfocus();
                }
              },
              focusNode: focusNode3,
              controller: pass2Controller,
              keyType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 40.h),
            GestureDetector(
              onTap: () async {
                name = nameController.text;
                pas1 = pass1Controller.text;
                pas2 = pass2Controller.text;

                if (name != "" && pas1 != "" && pas2 != "") {
                  if (pas1.length >= 8) {
                    if (pas1 == pas2) {
                      await StorageRepository.putString(
                          key: "password", value: pas1);
                      await StorageRepository.putString(
                          key: "name", value: name);

                      UtilityFunctions.getMyToast(message: tr("s_registr"));

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return LoginScreen();
                      }));
                    } else {
                      UtilityFunctions.getMyToast(message: tr("not_matched"));
                    }
                  } else {
                    UtilityFunctions.getMyToast(message: tr("eight"));
                  }
                } else {
                  UtilityFunctions.getMyToast(message: tr("must"));
                }
              },
              child: Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: MyColors.C_8687E7),
                child: Center(
                  child: Text(
                    tr("register"),
                    style: GoogleFonts.lato()
                        .copyWith(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ),
            ),
            SizedBox(height: 22.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Container(height: 1, color: MyColors.C_979797)),
                const SizedBox(width: 2),
                Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    child: Text(tr("or"),
                        style: GoogleFonts.lato()
                            .copyWith(color: MyColors.C_979797, fontSize: 16.sp))),
                const SizedBox(width: 2),
                Expanded(child: Container(height: 1, color: MyColors.C_979797)),
              ],
            ),
            SizedBox(height: 22.h),
            GoogleAndApple(text: tr("w_google"), svgPath: MyIcons.google),
            SizedBox(height: 10.h),
            GoogleAndApple(text: tr("w_apple"), svgPath: MyIcons.apple),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tr("have_account"),
                  style: GoogleFonts.lato().copyWith(
                    color: MyColors.C_979797,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(width: 5.w),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const LoginScreen();
                    }));
                  },
                  child: Text(
                    tr("login"),
                    style: GoogleFonts.lato().copyWith(
                      color: Colors.white.withOpacity(0.87),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
