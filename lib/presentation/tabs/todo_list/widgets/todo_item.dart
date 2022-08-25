import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/data/my_repository.dart';
import 'package:my_todo_app/db/cached_category.dart';
import 'package:my_todo_app/db/cached_todo.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({
    Key? key,
    required this.toDo,
    required this.onTap,
    required this.isSelected,
    required this.onDismissed,
    required this.onUpdate,
  }) : super(key: key);

  final CachedTodo toDo;
  final VoidCallback onTap;
  final bool isSelected;
  final VoidCallback onDismissed;
  final VoidCallback onUpdate;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  initState() {
    super.initState();
  }

  Future<CachedCategory> _init() async {
    return await MyRepository.getCachedCategoryById(id: widget.toDo.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(key: UniqueKey(), onDismissed: widget.onDismissed),
        children: [
          SlidableAction(
            onPressed: (v) {},
            backgroundColor: const Color(0xFFFE4A49).withOpacity(0.5),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: tr("delete"),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: MyColors.C_363636,
            borderRadius: BorderRadius.circular(4),
          ),
          width: double.infinity,
          height: 95.h,
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onTap,
                child: (widget.isSelected)
                    ? const Icon(Icons.check_circle,
                        color: Colors.greenAccent, size: 25)
                    : const Icon(Icons.circle_outlined, size: 25),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.toDo.todoTitle,
                            style: GoogleFonts.lato().copyWith(
                              fontSize: 16.sp,
                              color: MyColors.white_87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      widget.toDo.dateTime,
                      style:
                          GoogleFonts.lato().copyWith(color: MyColors.C_AFAFAF),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 38.h,
                    width: 38.h,
                    child: TextButton(
                      onPressed: widget.onUpdate,
                      child: SvgPicture.asset(MyIcons.edit, color: MyColors.secondaryColor),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Row(
                    children: [
                      FutureBuilder<CachedCategory>(
                          future: _init(),
                          builder: (BuildContext context,
                              AsyncSnapshot<CachedCategory> snapshot) {
                            if (snapshot.hasData) {
                              var d = snapshot.data!;
                              return Container(
                                height: 30.h,
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                decoration: BoxDecoration(
                                  color: Color(d.categoryColor),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 15.h,
                                      height: 15.h,
                                      child: SvgPicture.asset(d.categoryIcon),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      d.categoryName,
                                      style: GoogleFonts.lato().copyWith(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                      SizedBox(width: 10.w),
                      Container(
                        height: 30.h,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: MyColors.C_8687E7, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 15.h,
                                height: 15.h,
                                child: SvgPicture.asset(MyIcons.flag)),
                            SizedBox(width: 6.w),
                            Text(
                              widget.toDo.urgentLevel.toString(),
                              style: GoogleFonts.lato().copyWith(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
