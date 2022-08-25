import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/data/my_repository.dart';
import 'package:my_todo_app/db/cached_category.dart';
import 'package:my_todo_app/presentation/login/widgets/my_text_field.dart';
import 'package:my_todo_app/presentation/tabs/tab_box/widgets/my_button.dart';
import 'package:my_todo_app/presentation/tabs/todo_list/widgets/color_item.dart';
import 'package:my_todo_app/presentation/tabs/todo_list/widgets/new_categ_item.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';
import 'package:my_todo_app/utils/utility_functions.dart';

class NewCategory extends StatefulWidget {
  const NewCategory({Key? key, required this.listenerCallBack}) : super(key: key);

  final ValueChanged<bool> listenerCallBack;

  @override
  State<NewCategory> createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  final FocusNode categoryFocus = FocusNode();
  final TextEditingController categoryController = TextEditingController();

  List<Color> colors = [
    const Color(0xFFC9CC41),
    const Color(0xFF66CC41),
    const Color(0xFF41CCA7),
    const Color(0xFF4181CC),
    const Color(0xFF41A2CC),
    const Color(0xFFCC8441),
    const Color(0xFF9741CC),
    const Color(0xFFCC4173),
    Colors.black,
    Colors.brown,
    Colors.grey,
    Colors.white,
  ];

  List<String> icons = [
    MyIcons.codingSvg,
    MyIcons.soccerBallSvg,
    MyIcons.telegramSvg,
    MyIcons.consoleSvg,
    MyIcons.twitterSvg,
    MyIcons.fastFoodSvg,
    MyIcons.trophy,
    MyIcons.cycling,
  ];

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  int newCategorySelectedIndex = -1;
  int colorSelectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.bgColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr("new_c"),
                style: GoogleFonts.lato().copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                  color: MyColors.white_87,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                tr("c_name"),
                style: GoogleFonts.lato().copyWith(
                  fontSize: 16.sp,
                  color: MyColors.white_87,
                ),
              ),
              SizedBox(height: 16.h),
              MyTextField(
                hintText: tr("c_name"),
                keyType: TextInputType.text,
                controller: categoryController,
                focusNode: categoryFocus,
                onSubmitted: (v) {
                  categoryFocus.unfocus();
                },
              ),
              SizedBox(height: 20.h),
              Text(
                tr("c_icon"),
                style: GoogleFonts.lato().copyWith(
                  fontSize: 16.sp,
                  color: MyColors.white_87,
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 50.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    icons.length,
                    (index) => NewCategoryItem(
                      onTap: () {
                        setState(() {
                          newCategorySelectedIndex = index;
                        });
                      },
                      isActive: newCategorySelectedIndex == index,
                      icon: icons[index],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                tr("c_color"),
                style: GoogleFonts.lato().copyWith(
                  fontSize: 16.sp,
                  color: MyColors.white_87,
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 36.h,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    colors.length,
                    (index) => ColorItem(
                      onTap: () {
                        setState(() {
                          colorSelectedIndex = index;
                        });
                      },
                      isColorSelected: colorSelectedIndex == index,
                      color: colors[index],
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: MyButton(
                        textColor: MyColors.C_8687E7,
                        buttonColor: MyColors.bgColor,
                        text: tr("cancel"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        if (categoryController.text.isNotEmpty) {
                          if (newCategorySelectedIndex != -1) {
                            if (colorSelectedIndex != -1) {
                              var cachedCategory = CachedCategory(
                                categoryIcon: icons[newCategorySelectedIndex],
                                categoryName: categoryController.text,
                                categoryColor: colors[colorSelectedIndex].value,
                              );
                              await MyRepository.insertCachedCategory(cachedCategory: cachedCategory);
                              widget.listenerCallBack.call(true);
                              UtilityFunctions.getMyToast(message: "Successfully added!");
                              Navigator.pop(context);
                            } else {
                              UtilityFunctions.getMyToast(
                                  message: "Select one color");
                            }
                          } else {
                            UtilityFunctions.getMyToast(
                                message: "Select one category icon");
                          }
                        } else {
                          UtilityFunctions.getMyToast(
                              message: "Give name to category!");
                        }
                      },
                      child: MyButton(
                        text: tr("c_categ"),
                        buttonColor: MyColors.C_8687E7,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
