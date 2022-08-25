import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/data/local_data/storage.dart';
import 'package:my_todo_app/presentation/login/register_screen/register_screen.dart';
import 'package:my_todo_app/presentation/login/widgets/google_and_apple.dart';
import 'package:my_todo_app/presentation/login/widgets/my_text_field.dart';
import 'package:my_todo_app/presentation/tabs/tab_box/tab_box.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/focusChange.dart';
import 'package:my_todo_app/utils/icons.dart';
import 'package:my_todo_app/utils/utility_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    nameFocusNode.dispose();
    passwordFocusNode.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isObscure = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr("login"),
              style: GoogleFonts.lato().copyWith(
                  color: Colors.white.withOpacity(0.87),
                  fontWeight: FontWeight.w700,
                  fontSize: 32.sp),
            ),
            SizedBox(height: 50.h),
            Text(
              tr("name"),
              style: GoogleFonts.lato().copyWith(
                  color: Colors.white.withOpacity(0.87), fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            MyTextField(
              onSubmitted: (value) {
                if (value != "") {
                  MyUtils.fieldFocusChange(context, nameFocusNode, passwordFocusNode);
                }
              },
              focusNode: nameFocusNode,
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
                  passwordFocusNode.unfocus();
                }
              },
              focusNode: passwordFocusNode,
              controller: passwordController,
              keyType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 70.h),
            GestureDetector(
              onTap: () async {
                String password = passwordController.text;
                String name = nameController.text;

                String savedName = StorageRepository.getString("name");
                String savedPassword = StorageRepository.getString("password");

                print("NAME:$savedName");
                print("PASSWORD:$savedPassword");

                if (password == savedPassword && name == savedName && password.isNotEmpty && name.isNotEmpty) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const TabBox();
                  }));
                  UtilityFunctions.getMyToast(message: tr("s_logged"));
                  await StorageRepository.putBool("isLogged", true);
                } else {
                  UtilityFunctions.getMyToast(message: tr("incorrect"));
                }
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: MyColors.C_8687E7),
                child: Center(
                  child: Text(
                    tr("login"),
                    style: GoogleFonts.lato()
                        .copyWith(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Container(height: 1, color: MyColors.C_979797)),
                SizedBox(width: 2.w),
                Container(
                    margin: EdgeInsets.only(bottom: 3.h),
                    child: Text(tr("or"),
                        style: GoogleFonts.lato()
                            .copyWith(color: MyColors.C_979797, fontSize: 16.sp))),
                SizedBox(width: 2.w),
                Expanded(child: Container(height: 1, color: MyColors.C_979797)),
              ],
            ),
            SizedBox(height: 40.h),
            GoogleAndApple(text: tr("w_google"), svgPath: MyIcons.google),
            SizedBox(height: 20.h),
            GoogleAndApple(text: tr("w_apple"), svgPath: MyIcons.apple),
            const Expanded(child: SizedBox()),
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
                      return const RegisterScreen();
                    }));
                  },
                  child: Text(
                    tr("register"),
                    style: GoogleFonts.lato().copyWith(
                      color: Colors.white.withOpacity(0.87),
                      fontSize: 14.sp,
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
