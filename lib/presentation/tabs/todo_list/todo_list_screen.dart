import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_todo_app/data/local_data/storage.dart';
import 'package:my_todo_app/data/my_repository.dart';
import 'package:my_todo_app/db/cached_category.dart';
import 'package:my_todo_app/db/cached_todo.dart';
import 'package:my_todo_app/global_widgets/my_app_bar.dart';
import 'package:my_todo_app/presentation/tabs/basket/sub_screens/edit_page.dart';
import 'package:my_todo_app/presentation/tabs/tab_box/widgets/my_button.dart';
import 'package:my_todo_app/presentation/tabs/todo_list/sub_screens/new_category.dart';
import 'package:my_todo_app/presentation/tabs/todo_list/widgets/category_item.dart';
import 'package:my_todo_app/presentation/tabs/todo_list/widgets/date_item.dart';
import 'package:my_todo_app/presentation/tabs/todo_list/widgets/priority_item.dart';
import 'package:my_todo_app/presentation/tabs/todo_list/widgets/text_field.dart';
import 'package:my_todo_app/presentation/tabs/todo_list/widgets/todo_item.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/focusChange.dart';
import 'package:my_todo_app/utils/icons.dart';
import 'package:my_todo_app/utils/utility_functions.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  int tickIndex = -1;
  int selectedIndex = -1;
  int selectedCategoryIndex = -1;
  String taskPriority = "";
  String selectedCategoryIconPath = "";
  String selectedCategoryName = "";

  String profileImage = StorageRepository.getString("profile_image");

  final TextEditingController taskController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final FocusNode taskFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  final FocusNode timeFocus = FocusNode();

  /// ---------------    DATE SELECTING ---------------------  ///

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }

  /// ----------------------------------------------------- ///

  List<CachedCategory> categories = [];
  List<CachedTodo> todos = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    categories = await MyRepository.getAllCachedCategories();
    todos = await MyRepository.getTodosByDone(isDone: 0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      floatingActionButton: SizedBox(
        height: 64.h,
        width: 64.h,
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: MyColors.C_8687E7,
          child: const Icon(Icons.add, size: 30),
          onPressed: () {
            myBottomSheet();
          },
        ),
      ),
      appBar: MyAppBar(title: tr("daily_todos")),
      body: (todos.isEmpty)
          ? SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 86.h),
                  Lottie.asset(MyIcons.todo, width: 300.w, height: 300.h),
                  Text(tr("what"),
                      style: GoogleFonts.lato()
                          .copyWith(fontSize: 20.sp, color: MyColors.white_87)),
                  SizedBox(height: 10.h),
                  Text(
                    tr("tap_plus"),
                    style: GoogleFonts.lato()
                        .copyWith(fontSize: 16.sp, color: MyColors.white_87),
                  ),
                  SizedBox(height: 125.h),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              width: double.infinity,
              height: double.infinity,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: List.generate(todos.length, (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: TodoItem(
                      onUpdate: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return EditPage(
                            isChanged: (v) {
                              if (v) {
                                _init();
                              }
                            },
                            cachedTodo: todos[index],
                            onPressed: () async {
                              await MyRepository.deleteCachedTodoById(
                                  id: todos[index].id!);
                              _init();
                              Navigator.pop(context);
                              UtilityFunctions.getMyToast(
                                  message: tr("delete_success"));
                            },
                          );
                        }));
                      },
                      onDismissed: () async {
                        await MyRepository.updateCachedTodo(id: todos[index].id!, status: 2);
                        _init();
                        UtilityFunctions.getMyToast(message: tr("deleted"));
                      },
                      isSelected: tickIndex == index,
                      toDo: todos[index],
                      onTap: () async {
                        setState(() {
                          tickIndex = index;
                        });
                        await Future.delayed(const Duration(seconds: 1));
                        tickIndex = -1;
                        await MyRepository.updateCachedTodo(
                            id: todos[index].id!, status: 1);
                        _init();
                        UtilityFunctions.getMyToast(
                            message: tr("added_to_done"));
                      },
                    ),
                  );
                }),
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
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              backgroundColor: MyColors.C_363636,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Container(
                width: double.infinity,
                height: 556.h,
                padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 10.h),
                child: Column(
                  children: [
                    Text(
                      tr("choose_category"),
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
                        crossAxisSpacing: 7,
                        mainAxisSpacing: 15,
                        children: [
                          ...List.generate(
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
                          ...List.generate(
                            1,
                            (index) => GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (c) {
                                  return NewCategory(
                                    listenerCallBack: (v) {
                                      if (v == true) {
                                        _init();
                                        state();
                                      }
                                    },
                                  );
                                }));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.black,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.19,
                                          height: MediaQuery.of(context).size.width * 0.19,
                                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color: const Color(0xFF80FFD1),
                                          ),
                                          child: SvgPicture.asset(MyIcons.plus),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Create New",
                                    style: GoogleFonts.lato().copyWith(
                                      color: MyColors.white_87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    TextButton(
                      onPressed: () {
                        if (selectedCategoryIndex != -1) {
                          selectedCategoryIconPath =
                              categories[selectedCategoryIndex].categoryIcon;
                          selectedCategoryName =
                              categories[selectedCategoryIndex].categoryName;
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
            insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
            backgroundColor: MyColors.C_363636,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.49,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: [
                  Text(
                    tr("task_p"),
                    style: GoogleFonts.lato().copyWith(
                      fontSize: 16,
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
                          style: TextButton.styleFrom(
                            primary: MyColors.bgColor,
                            surfaceTintColor: MyColors.warningColor,
                          ),
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
                              setState(() {
                                taskPriority = (selectedIndex + 1).toString();
                              });
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

  void myBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.r),
          topLeft: Radius.circular(16.r),
        ),
      ),
      backgroundColor: MyColors.C_363636,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                color: MyColors.C_363636,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr("add_task"),
                      style: GoogleFonts.lato().copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: MyColors.white_87,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField2(
                      hintText: tr("here"),
                      keyType: TextInputType.text,
                      controller: taskController,
                      focusNode: taskFocus,
                      onSubmitted: (value) {
                        MyUtils.fieldFocusChange(
                          context,
                          taskFocus,
                          descFocus,
                        );
                      },
                    ),
                    TextField2(
                      hintText: tr("desc"),
                      keyType: TextInputType.text,
                      controller: descController,
                      focusNode: descFocus,
                      onSubmitted: (value) {
                        descFocus.unfocus();
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Column(
                        children: [
                          (selectedIndex != -1)
                              ? SizedBox(height: 20.h)
                              : const SizedBox(),
                          (selectedIndex != -1)
                              ? Row(
                                  children: [
                                    Text(tr("task_p"),
                                        style: GoogleFonts.lato().copyWith(
                                            color: MyColors.white_87,
                                            fontSize: 17.sp)),
                                    SizedBox(width: 15.w),
                                    SvgPicture.asset(MyIcons.bigFlag,
                                        color: MyColors.C_8687E7),
                                    const SizedBox(width: 5),
                                    Text(taskPriority,
                                        style: GoogleFonts.lato().copyWith(
                                            color: MyColors.white_87,
                                            fontSize: 15.sp)),
                                  ],
                                )
                              : const SizedBox(),
                          (selectedIndex != -1)
                              ? SizedBox(height: 20.h)
                              : const SizedBox(),
                          (selectedCategoryIndex != -1)
                              ? Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text(tr("task_category"),
                                            style: GoogleFonts.lato().copyWith(
                                                color: MyColors.white_87,
                                                fontSize: 17.sp)),
                                        SizedBox(width: 20.w),
                                        SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child: SvgPicture.asset(
                                              selectedCategoryIconPath),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          selectedCategoryName,
                                          style: GoogleFonts.lato().copyWith(
                                            color: MyColors.white_87,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          (selectedCategoryIndex != -1)
                              ? const SizedBox(height: 25)
                              : const SizedBox(),
                          DateItem(
                            text: DateFormat.yMMMd().format(selectedDate),
                            prefixText: tr("date"),
                            onTap: () async {
                              var t = await _selectDate(context);
                              setState(() {
                                selectedDate = t;
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          DateItem(
                            prefixText: tr("time"),
                            text:
                                "${selectedTime.hour} : ${selectedTime.minute}",
                            onTap: () async {
                              var time = await _selectTime(context);
                              setState(() {
                                selectedTime = time;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            myCustomCategoryDialog(() {
                              setState(() {});
                            });
                          },
                          icon: SvgPicture.asset(MyIcons.tag),
                        ),
                        const SizedBox(width: 40),
                        IconButton(
                          onPressed: () {
                            myCustomUrgentDialog(() {
                              setState(() {});
                            });
                          },
                          icon: SvgPicture.asset(MyIcons.bigFlag),
                        ),
                        const Expanded(child: SizedBox()),
                        IconButton(
                          onPressed: () async {
                            if (taskController.text.isNotEmpty &&
                                descController.text.isNotEmpty) {
                              if (taskPriority != "") {
                                if (selectedCategoryIndex != -1) {
                                  await MyRepository.insertCachedTodo(
                                    cachedTodo: CachedTodo(
                                      categoryId:
                                          categories[selectedCategoryIndex].id!,
                                      dateTime: selectedDate
                                          .toString()
                                          .substring(0, 10),
                                      isDone: 0,
                                      todoDescription: descController.text,
                                      todoTitle: taskController.text,
                                      urgentLevel: int.parse(taskPriority),
                                    ),
                                  );
                                  _init();
                                  Navigator.pop(context);
                                  UtilityFunctions.getMyToast(
                                      message: tr("task_added"));
                                  setState(() {
                                    selectedCategoryIndex = -1;
                                    taskPriority = "";
                                    selectedIndex = -1;
                                    selectedDate = DateTime.now();
                                    selectedTime = TimeOfDay.now();
                                  });
                                  taskController.text = "";
                                  descController.text = "";
                                } else {
                                  UtilityFunctions.getMyToast(
                                      message: tr("select_categ"));
                                }
                              } else {
                                UtilityFunctions.getMyToast(
                                    message: tr("select_p"));
                              }
                            } else {
                              UtilityFunctions.getMyToast(
                                  message: tr("fill_gaps"));
                            }
                          },
                          icon: SvgPicture.asset(MyIcons.send),
                        ),
                      ],
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
}
