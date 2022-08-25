import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/data/local_data/storage.dart';
import 'package:my_todo_app/data/my_repository.dart';
import 'package:my_todo_app/db/cached_category.dart';
import 'package:my_todo_app/db/cached_todo.dart';
import 'package:my_todo_app/global_widgets/my_app_bar.dart';
import 'package:my_todo_app/presentation/tabs/basket/sub_screens/edit_page.dart';
import 'package:my_todo_app/presentation/tabs/todo_list/widgets/todo_item.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';
import 'package:my_todo_app/utils/utility_functions.dart';

class DoneListScreen extends StatefulWidget {
  const DoneListScreen({Key? key}) : super(key: key);

  @override
  State<DoneListScreen> createState() => _DoneListScreenState();
}

class _DoneListScreenState extends State<DoneListScreen> {
  List<CachedTodo> todos = [];
  List<CachedCategory> categories = [];
  String profileImage = StorageRepository.getString("profile_image");

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    todos = await MyRepository.getTodosByDone(isDone: 1);
    categories = await MyRepository.getAllCachedCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: MyAppBar(title: tr("done_todos")),
      body: (todos.isEmpty)
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 86.h),
                  Image.asset(MyIcons.empty, width: 300.w, height: 300.h),
                  Text(
                    tr("any_yet"),
                    style: GoogleFonts.lato().copyWith(
                      fontSize: 20.sp,
                      color: MyColors.white_87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 125.h),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 105.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tr("completed"),
                            style: GoogleFonts.lato().copyWith(
                                fontSize: 12.sp, color: MyColors.white_87)),
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: MyColors.white_87,
                          size: 17.sp,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Expanded(
                    child: ListView(
                      children: List.generate(todos.length, (index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          child: TodoItem(
                            onUpdate: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (c) {
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
                              await MyRepository.updateCachedTodo(
                                  id: todos[index].id!, status: 2);
                              _init();
                              UtilityFunctions.getMyToast(
                                  message: tr("deleted"));
                            },
                            isSelected: true,
                            toDo: todos[index],
                            onTap: () {},
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
