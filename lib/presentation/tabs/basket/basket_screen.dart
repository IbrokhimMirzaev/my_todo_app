import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:my_todo_app/data/my_repository.dart';
import 'package:my_todo_app/db/cached_todo.dart';
import 'package:my_todo_app/global_widgets/my_app_bar.dart';
import 'package:my_todo_app/presentation/tabs/basket/widgets/basket_item.dart';
import 'package:my_todo_app/presentation/tabs/tab_box/widgets/my_button.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({Key? key}) : super(key: key);

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  List<CachedTodo> deletedTodos = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    deletedTodos = await MyRepository.getTodosByDone(isDone: 2);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: MyAppBar(title: tr("basket")),
      body: (deletedTodos.isEmpty)
          ? Center(child: Lottie.asset(MyIcons.no, repeat: false))
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: ListView(
                children: List.generate(
                  deletedTodos.length,
                  (index) {
                    var toDo = deletedTodos[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      child: BasketItem(
                        cachedTodo: toDo,
                        onDeleteTapped: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext con) {
                              return Dialog(
                                insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                                backgroundColor: MyColors.C_363636,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 170.h,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                                        child: Column(
                                          children: [
                                            Text(
                                              tr("delete_task"),
                                              style:
                                                  GoogleFonts.lato().copyWith(
                                                fontSize: 16.sp,
                                                color: MyColors.white_87,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Row(children: [
                                              Expanded(
                                                  child: Container(
                                                      height: 1,
                                                      color: MyColors.C_979797))
                                            ],),
                                            const SizedBox(height: 20),
                                            Text(
                                              tr("delete_sure"),
                                              style:
                                                  GoogleFonts.lato().copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17.sp,
                                                color: MyColors.white_87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
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
                                              onPressed: () {
                                                MyRepository
                                                    .deleteCachedTodoById(
                                                  id: toDo.id!,
                                                );
                                                _init();
                                                Navigator.pop(context);
                                              },
                                              child: const MyButton(
                                                  text: "Delete"),
                                            ),
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
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
