import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:my_todo_app/presentation/on_boarding/widgets/lang_item.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class LangPage extends StatefulWidget {
  const LangPage({Key? key}) : super(key: key);

  @override
  State<LangPage> createState() => _LangPageState();
}

class _LangPageState extends State<LangPage> {
  String activeLanguage = "";
  @override
  Widget build(BuildContext context) {
    activeLanguage = context.locale.toString();
    print("ACTIVE lang: $activeLanguage");
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Lottie.asset(MyIcons.translate, height: 250.h),
            SizedBox(height: 75.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  height: 4.h,
                  width: 27.w,
                ),
                SizedBox(width: 8.w),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  height: 4.h,
                  width: 27.w,
                ),
                SizedBox(width: 8.w),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  height: 4.h,
                  width: 27.w,
                ),
                SizedBox(width: 8.w),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  height: 4.h,
                  width: 27.w,
                ),
              ],
            ),
            SizedBox(height: 50.h),
            Text(
              tr("select_lang"),
              style: GoogleFonts.lato().copyWith(
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.87),
                letterSpacing: 0.8,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 35.h),
            SizedBox(
              width: double.infinity,
              child: ExpansionTile(
                childrenPadding: EdgeInsets.symmetric(horizontal: 20.w),
                collapsedBackgroundColor: MyColors.C_363636,
                collapsedIconColor: MyColors.white_87,
                collapsedTextColor: MyColors.white_87,
                backgroundColor: MyColors.C_363636,
                iconColor: MyColors.white_87,
                textColor: MyColors.white_87,
                title: Text(tr("language_screen"), style: GoogleFonts.lato()),
                children: [
                  LangItem(
                    onTap: () {
                      if (activeLanguage != "en_EN") {
                        setState(() {
                          context.setLocale(const Locale('en', 'EN'));
                          activeLanguage = "en_EN";
                        });
                      }
                    },
                    text: tr("english"),
                    isActive: activeLanguage == "en_EN",
                    imagePath: MyIcons.engC,
                  ),
                  SizedBox(height: 20.h),
                  LangItem(
                    onTap: () {
                      if (activeLanguage != "uz_UZ") {
                        setState(() {
                          context.setLocale(const Locale('uz', 'UZ'));
                          activeLanguage = "uz_UZ";
                        });
                      }
                    },
                    text: tr("uzbek"),
                    isActive: activeLanguage == "uz_UZ",
                    imagePath: MyIcons.uzbC,
                  ),
                  SizedBox(height: 20.h),
                  LangItem(
                    onTap: () {
                      if (activeLanguage != "ru_RU") {
                        setState(() {
                          context.setLocale(const Locale('ru', 'RU'));
                          activeLanguage = "ru_RU";
                        });
                      }
                    },
                    text: tr("russian"),
                    isActive: activeLanguage == "ru_RU",
                    imagePath: MyIcons.rusC,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
            SizedBox(height: 35.h),
            Text(
              tr("later"),
              style: GoogleFonts.lato().copyWith(color: Colors.white.withOpacity(0.87), height: 1.7),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
