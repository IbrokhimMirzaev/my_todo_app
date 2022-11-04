import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/presentation/tabs/profile/sub_screens/language_screen.dart';
import 'package:my_todo_app/presentation/tabs/profile/widgets/my_custom_row.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key, required this.listenerCallBack}) : super(key: key);

  final ValueChanged<bool> listenerCallBack;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.bgColor,
        leading: Center(
          child: IconButton(
            onPressed: () {
              widget.listenerCallBack.call(true);
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(MyIcons.back, color: MyColors.white_87),
          ),
        ),
        title: Text(
          tr("settings"),
          style: GoogleFonts.lato().copyWith(fontSize: 20.sp, color: MyColors.white_87),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr("settings"), style: GoogleFonts.lato().copyWith(color: MyColors.C_AFAFAF)),
            SizedBox(height: 16.h),
            MyRow(onTap: (){}, icon: MyIcons.brush, text: tr("change_app_color")),
            SizedBox(height: 14.h),
            MyRow(onTap: (){}, icon: MyIcons.text, text: tr("change_app_ty")),
            SizedBox(height: 14.h),
            MyRow(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c) => LanguageScreen()));
            }, icon: MyIcons.lang, text: tr("change_app_lang")),
            SizedBox(height: 14.h),
            Text(tr("import"), style: GoogleFonts.lato().copyWith(color: MyColors.C_AFAFAF)),
            SizedBox(height: 16.h),
            MyRow(onTap: (){}, icon: MyIcons.import, text: tr("import_from")),
          ],
        ),
      ),
    );
  }
}
