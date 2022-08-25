import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/data/local_data/storage.dart';
import 'package:my_todo_app/data/my_repository.dart';
import 'package:my_todo_app/db/cached_category.dart';
import 'package:my_todo_app/presentation/login/login_screen/login_screen.dart';
import 'package:my_todo_app/presentation/on_boarding/pages/lang_page.dart';
import 'package:my_todo_app/presentation/on_boarding/pages/page_1.dart';
import 'package:my_todo_app/presentation/on_boarding/pages/page_2.dart';
import 'package:my_todo_app/presentation/on_boarding/pages/page_3.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  final PageController pageController = PageController();
  String buttonText = "NEXT";

  List<Widget> pages =  [
    LangPage(),
    FirstPage(),
    SecondPage(),
    ThirdPage(),
  ];

  @override
  initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    await StorageRepository.putBool("isRegistered", true);
    await MyRepository.insertCachedCategory(
        cachedCategory: CachedCategory(
            categoryIcon: MyIcons.bread,
            categoryName: "Grocery",
            categoryColor: const Color(0xFFCCFF80).value));
    await MyRepository.insertCachedCategory(
        cachedCategory: CachedCategory(
            categoryIcon: MyIcons.briefcase,
            categoryName: "Work",
            categoryColor: const Color(0xFFFF9680).value));
    await MyRepository.insertCachedCategory(
        cachedCategory: CachedCategory(
            categoryIcon: MyIcons.sport,
            categoryName: "Sport",
            categoryColor: const Color(0xFF80FFFF).value));
    await MyRepository.insertCachedCategory(
        cachedCategory: CachedCategory(
            categoryIcon: MyIcons.design,
            categoryName: "Design",
            categoryColor: const Color(0xFF80FFD9).value));
    await MyRepository.insertCachedCategory(
        cachedCategory: CachedCategory(
            categoryIcon: MyIcons.univer,
            categoryName: "University",
            categoryColor: const Color(0xFF80D1FF).value));
    await MyRepository.insertCachedCategory(
        cachedCategory: CachedCategory(
            categoryIcon: MyIcons.megaphone,
            categoryName: "Social",
            categoryColor: const Color(0xFFFF80EB).value));
    await MyRepository.insertCachedCategory(
        cachedCategory: CachedCategory(
            categoryIcon: MyIcons.music,
            categoryName: "Music",
            categoryColor: const Color(0xFFFC80FF).value));
    await MyRepository.insertCachedCategory(
        cachedCategory: CachedCategory(
            categoryIcon: MyIcons.health,
            categoryName: "Health",
            categoryColor: const Color(0xFF80FFA3).value));
    await MyRepository.insertCachedCategory(
        cachedCategory: CachedCategory(
            categoryIcon: MyIcons.movie,
            categoryName: "Movie",
            categoryColor: const Color(0xFF80D1FF).value));
    await MyRepository.insertCachedCategory(
        cachedCategory: CachedCategory(
            categoryIcon: MyIcons.home2,
            categoryName: "Home",
            categoryColor: const Color(0xFFFFCC80).value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext c) {
                        return const LoginScreen();
                      }));
                    },
                    child: Text(
                      tr("Skip"),
                      style: GoogleFonts.lato().copyWith(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: pages,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (currentIndex > 0) {
                          currentIndex--;
                          pageController.jumpToPage(currentIndex);
                        }

                        if (currentIndex < 3) {
                          buttonText = tr("Next");
                        }
                      });
                    },
                    child: Text(
                      tr("Back"),
                      style: GoogleFonts.lato().copyWith(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          if (currentIndex < 3) {
                            currentIndex++;
                            pageController.jumpToPage(currentIndex);
                          } else {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (BuildContext c) {
                              return const LoginScreen();
                            }));
                          }

                          if (currentIndex == 3) {
                            buttonText = tr("g_started");
                          }
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: MyColors.buttonColor,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Center(
                        child: Text(
                          buttonText,
                          style: GoogleFonts.lato().copyWith(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
