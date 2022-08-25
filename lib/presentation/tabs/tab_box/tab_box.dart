import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_todo_app/presentation/tabs/basket/basket_screen.dart';
import 'package:my_todo_app/presentation/tabs/done_list/done_list_screen.dart';
import 'package:my_todo_app/presentation/tabs/profile/profile_screen.dart';
import 'package:my_todo_app/presentation/tabs/todo_list/todo_list_screen.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class TabBox extends StatefulWidget {
  const TabBox({Key? key}) : super(key: key);

  @override
  State<TabBox> createState() => _TabBoxState();
}

class _TabBoxState extends State<TabBox> {
  bool isSelected = false;
  int currentIndex = 0;

  List<Widget> screens = [
    const ToDoListScreen(),
    const DoneListScreen(),
    const BasketScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: screens[currentIndex],
      bottomNavigationBar: SizedBox(
        height: 90.h,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: MyColors.bottomBgColor,
          iconSize: 28.sp,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: currentIndex,
          selectedItemColor: Colors.white,
          selectedFontSize: 13,
          unselectedItemColor: Colors.white.withOpacity(0.7),
          items: [
            getItem(
              icon: SizedBox(
                width: 28.h,
                height: 28.h,
                child: SvgPicture.asset(
                  MyIcons.home,
                  fit: BoxFit.fill,
                ),
              ),
              activeIcon: SizedBox(
                width: 28.h,
                height: 28.h,
                child: SvgPicture.asset(
                  MyIcons.filledHome,
                  fit: BoxFit.fill,
                ),
              ),
              labelText: tr("home"),
            ),
            getItem(
              icon: const Icon(Icons.done),
              activeIcon: const Icon(Icons.done_all_sharp),
              labelText: tr("done"),
            ),
            getItem(
              icon:
                  Icon(Icons.shopping_cart_outlined, color: MyColors.white_87),
              activeIcon:
                  Icon(Icons.shopping_cart_rounded, color: MyColors.white_87),
              labelText: tr("trash"),
            ),
            getItem(
              icon: SizedBox(
                width: 28.h,
                height: 28.h,
                child: SvgPicture.asset(
                  MyIcons.user,
                  fit: BoxFit.fill,
                ),
              ),
              activeIcon: SizedBox(
                width: 28.h,
                height: 28.h,
                child: Image.asset(
                  MyIcons.filledUserImg,
                  fit: BoxFit.fill,
                  color: Colors.white,
                ),
              ),
              labelText: tr("profile"),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem getItem(
      {required Widget icon,
      required Widget activeIcon,
      required String labelText}) {
    return BottomNavigationBarItem(
      label: labelText,
      icon: Container(margin: EdgeInsets.only(bottom: 9.h), child: icon),
      activeIcon: Container(
          margin: EdgeInsets.only(bottom: 9.h), child: activeIcon),
    );
  }
}
