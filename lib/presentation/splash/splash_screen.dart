import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/data/local_data/storage.dart';
import 'package:my_todo_app/presentation/login/login_screen/login_screen.dart';
import 'package:my_todo_app/presentation/on_boarding/on_boarding_screen.dart';
import 'package:my_todo_app/presentation/tabs/tab_box/tab_box.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _init();
    Future.delayed(const Duration(seconds: 3), () {
      bool isLogged = StorageRepository.getBool("isLogged");
      bool isRegistered = StorageRepository.getBool("isRegistered");
      print("IS LOGGED:$isLogged");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return isLogged
            ? const TabBox()
            : (!isRegistered)
                ? const OnBoardingScreen()
                : const LoginScreen();
      }));
    });
    super.initState();
  }

  Future<void> _init() async {
    await StorageRepository.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: MyColors.bgColor,
      statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(MyIcons.doneSvg),
            SizedBox(height: 35.h),
            Text(
              "UpTodo",
              style: GoogleFonts.lato().copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 40.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
