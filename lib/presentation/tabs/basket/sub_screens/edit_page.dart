import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/data/my_repository.dart';
import 'package:my_todo_app/db/cached_category.dart';
import 'package:my_todo_app/db/cached_todo.dart';
import 'package:my_todo_app/presentation/login/widgets/my_text_field.dart';
import 'package:my_todo_app/presentation/tabs/basket/widgets/my_edit_row.dart';
import 'package:my_todo_app/presentation/tabs/tab_box/widgets/my_button.dart';
import 'package:my_todo_app/presentation/tabs/todo_list/widgets/category_item.dart';
import 'package:my_todo_app/presentation/tabs/todo_list/widgets/priority_item.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/focusChange.dart';
import 'package:my_todo_app/utils/icons.dart';
import 'package:my_todo_app/utils/utility_functions.dart';

class EditPage extends StatefulWidget {
  const EditPage({
    Key? key,
    required this.cachedTodo,
    required this.onPressed,
    required this.isChanged,
  }) : super(key: key);

  final CachedTodo cachedTodo;
  final VoidCallback onPressed;
  final ValueChanged<bool> isChanged;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  int selectedCategoryIndex = -1;
  String taskPriority = "";
  int selectedIndex = -1;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final FocusNode titleFocus = FocusNode();
  final FocusNode descFocus = FocusNode();

  List<CachedCategory> categories = [];

  @override
  void initState() {
    titleController.text = widget.cachedTodo.todoTitle;
    descController.text = widget.cachedTodo.todoDescription;
    selectedCategoryIndex = widget.cachedTodo.categoryId - 1;
    selectedIndex = widget.cachedTodo.urgentLevel - 1;
    _init();
    super.initState();
  }

  Future<void> _init() async {
    categories = await MyRepository.getAllCachedCategories();
    setState(() {});
  }

  Future<CachedCategory> getFutureCategory() async {
    return await MyRepository.getCachedCategoryById(
        id: widget.cachedTodo.categoryId);
  }

  void update() {
    setState(() {});
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
        backgroundColor: MyColors.bgColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(MyIcons.close,
              color: Colors.white, width: 32.w, height: 32.h),
        ),
        actions: [
          Center(
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: const Color(0xFF1D1D1D),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: SvgPicture.asset(MyIcons.repeat,
                  color: Colors.white, fit: BoxFit.scaleDown),
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 17.w,
                  height: 17.h,
                  decoration: BoxDecoration(
                    color: MyColors.C_363636,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleController.text,
                        style: GoogleFonts.lato().copyWith(
                          fontSize: 20.sp,
                          color: MyColors.white_87,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        descController.text,
                        style: GoogleFonts.lato().copyWith(
                          fontSize: 16.sp,
                          color: MyColors.C_AFAFAF,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                            builder: (BuildContext context, setState) {
                          return Dialog(
                            insetPadding:
                                EdgeInsets.symmetric(horizontal: 24.w),
                            backgroundColor: MyColors.C_363636,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 275.h,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15.w,
                                      vertical: 10.h,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          tr("edit_task_title"),
                                          style: GoogleFonts.lato().copyWith(
                                            fontSize: 16.sp,
                                            color: MyColors.white_87,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  height: 1,
                                                  color: MyColors.C_979797),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        MyTextField(
                                          bgColor: MyColors.C_363636,
                                          hintText: tr("task_title"),
                                          keyType: TextInputType.name,
                                          controller: titleController,
                                          focusNode: titleFocus,
                                          onSubmitted: (v) {
                                            MyUtils.fieldFocusChange(
                                                context, titleFocus, descFocus);
                                          },
                                        ),
                                        SizedBox(height: 15.h),
                                        MyTextField(
                                          bgColor: MyColors.C_363636,
                                          hintText: tr("task_desc"),
                                          keyType: TextInputType.name,
                                          controller: descController,
                                          focusNode: descFocus,
                                          onSubmitted: (v) {
                                            descFocus.unfocus();
                                          },
                                        ),
                                      ],
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
                                            buttonColor: MyColors.C_363636,
                                            text: tr("cancel"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () async {
                                            update();
                                            Navigator.pop(context);
                                          },
                                          child: MyButton(text: tr("edit")),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  },
                  icon: SvgPicture.asset(MyIcons.edit),
                ),
              ],
            ),
            SizedBox(height: 60.h),
            MyEditRow(
              text: Text(
                widget.cachedTodo.dateTime.toString().substring(0, 10),
                style: GoogleFonts.lato().copyWith(
                  fontSize: 12.sp,
                  color: MyColors.white_87,
                ),
              ),
              taskName: tr("task_time"),
              icon: SvgPicture.asset(MyIcons.timer),
            ),
            SizedBox(height: 27.h),
            TextButton(
              onPressed: () {
                myCustomCategoryDialog(() {
                  setState(() {});
                });
              },
              child: MyEditRow(
                text: FutureBuilder<CachedCategory>(
                  future: getFutureCategory(),
                  builder: (BuildContext context,
                      AsyncSnapshot<CachedCategory> snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 15.w,
                            height: 15.h,
                            child: SvgPicture.asset(
                                categories[selectedCategoryIndex].categoryIcon),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            categories[selectedCategoryIndex].categoryName,
                            style: GoogleFonts.lato().copyWith(
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                taskName: tr("task_category"),
                icon: SvgPicture.asset(MyIcons.tag),
              ),
            ),
            SizedBox(height: 27.h),
            TextButton(
              onPressed: () {
                myCustomUrgentDialog(() {
                  setState(() {});
                });
              },
              child: MyEditRow(
                text: Text(
                  (selectedIndex + 1).toString(),
                  style: GoogleFonts.lato().copyWith(
                    fontSize: 12.sp,
                    color: MyColors.white_87,
                  ),
                ),
                taskName: tr("task_p"),
                icon: SvgPicture.asset(MyIcons.bigFlag),
              ),
            ),
            SizedBox(height: 40.h),
            TextButton(
              onPressed: widget.onPressed,
              child: Row(
                children: [
                  SvgPicture.asset(MyIcons.trash),
                  SizedBox(width: 10.w),
                  Text(tr("delete_task"),
                      style: GoogleFonts.lato()
                          .copyWith(color: const Color(0xFFFF4949))),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            TextButton(
              onPressed: () async {
                await MyRepository.updateAllCachedTodoFields(
                  id: widget.cachedTodo.id!,
                  title: titleController.text,
                  desc: descController.text,
                  categoryId: selectedCategoryIndex + 1,
                  urgentLevel: selectedIndex + 1,
                );
                _init();
                widget.isChanged.call(true);
                Navigator.pop(context);
                UtilityFunctions.getMyToast(message: tr("s_edited"));
              },
              child: MyButton(text: tr("edit_task")),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  void myCustomCategoryDialog(VoidCallback state) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
              backgroundColor: MyColors.C_363636,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Container(
                width: double.infinity,
                height: 556.h,
                padding: EdgeInsets.symmetric(horizontal: 19.h, vertical: 10.h),
                child: Column(
                  children: [
                    Text(
                      tr("choose_category"),
                      style: GoogleFonts.lato().copyWith(
                        fontSize: 16,
                        color: MyColors.white_87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                            child:
                                Container(height: 1, color: MyColors.C_979797)),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Expanded(
                      child: GridView.count(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 15,
                        children: List.generate(
                          categories.length,
                          (index) => CategoryItem(
                            categorySelected: selectedCategoryIndex == index,
                            onTap: () {
                              setState(() {
                                selectedCategoryIndex = index;
                              });
                            },
                            category: categories[index],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    TextButton(
                      onPressed: () {
                        if (selectedCategoryIndex != -1) {
                          state();
                          UtilityFunctions.getMyToast(
                              message: tr("c_selected"));
                          Navigator.pop(context);
                        } else {
                          UtilityFunctions.getMyToast(message: tr("s_one"));
                        }
                      },
                      child: MyButton(text: tr("add_category")),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void myCustomUrgentDialog(VoidCallback update) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 24.h),
            backgroundColor: MyColors.C_363636,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Container(
              width: double.infinity,
              height: 405.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
              child: Column(
                children: [
                  Text(
                    tr("task_p"),
                    style: GoogleFonts.lato().copyWith(
                      fontSize: 16.sp,
                      color: MyColors.white_87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(children: [
                    Expanded(
                        child: Container(height: 1, color: MyColors.C_979797))
                  ]),
                  SizedBox(height: 15.h),
                  Expanded(
                    child: GridView.count(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 4,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: List.generate(
                        10,
                        (index) => PriorityItem(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          isSelected: selectedIndex == index,
                          index: index,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: MyButton(
                            textColor: MyColors.C_8687E7,
                            buttonColor: MyColors.C_363636,
                            text: tr("cancel"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            if (selectedIndex != -1) {
                              update();
                              UtilityFunctions.getMyToast(
                                  message: tr("t_selected"));
                              Navigator.pop(context);
                            } else {
                              UtilityFunctions.getMyToast(message: tr("s_one"));
                            }
                          },
                          child: MyButton(text: tr("save")),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
