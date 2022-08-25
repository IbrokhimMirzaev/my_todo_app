import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/presentation/tabs/profile/widgets/language_item.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String activeLanguage = "";

  @override
  Widget build(BuildContext context) {
    activeLanguage = context.locale.toString();
    print("ACTIVE LANG: $activeLanguage");
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.bgColor,
        leading: Center(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(MyIcons.back, color: MyColors.white_87),
          ),
        ),
        title: Text(
          tr("language_screen"),
          style: GoogleFonts.lato()
              .copyWith(fontSize: 20.sp, color: MyColors.white_87),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Column(
          children: [
            LanguageItem(
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
              imagePath: MyIcons.eng,
            ),
            SizedBox(height: 20.h),
            LanguageItem(
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
              imagePath: MyIcons.uzb,
            ),
            SizedBox(height: 20.h),
            LanguageItem(
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
              imagePath: MyIcons.rus,
            ),
          ],
        ),
      ),
    );
  }
}
