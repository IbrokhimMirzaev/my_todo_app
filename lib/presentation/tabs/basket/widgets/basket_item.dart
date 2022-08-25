import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/data/my_repository.dart';
import 'package:my_todo_app/db/cached_category.dart';
import 'package:my_todo_app/db/cached_todo.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class BasketItem extends StatefulWidget {
  const BasketItem({
    Key? key,
    required this.onDeleteTapped,
    required this.cachedTodo,
  }) : super(key: key);

  final VoidCallback onDeleteTapped;
  final CachedTodo cachedTodo;

  @override
  State<BasketItem> createState() => _BasketItemState();
}

class _BasketItemState extends State<BasketItem> {
  @override
  initState() {
    super.initState();
  }

  Future<CachedCategory> _init() async {
    return await MyRepository.getCachedCategoryById(id: widget.cachedTodo.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: MyColors.C_363636,
        borderRadius: BorderRadius.circular(4.r),
      ),
      width: double.infinity,
      height: 150.h,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cachedTodo.todoTitle,
                        style: GoogleFonts.lato().copyWith(
                          fontSize: 16.sp,
                          color: MyColors.white_87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        widget.cachedTodo.dateTime,
                        style: GoogleFonts.lato()
                            .copyWith(color: MyColors.C_AFAFAF),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 30.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.C_8687E7, width: 1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 15.w,
                              height: 15.h,
                              child: SvgPicture.asset(MyIcons.flag)),
                          SizedBox(width: 6.w),
                          Text(
                            widget.cachedTodo.urgentLevel.toString(),
                            style: GoogleFonts.lato().copyWith(
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
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
                                children: [
                                  SizedBox(
                                    width: 15.w,
                                    height: 15.h,
                                    child: SvgPicture.asset(d.categoryIcon),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    d.categoryName,
                                    style: GoogleFonts.lato().copyWith(fontSize: 12.sp, color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: widget.onDeleteTapped,
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/svg/trash.svg"),
                      SizedBox(width: 10.w),
                      Text(tr("delete"), style: GoogleFonts.lato().copyWith(color: const Color(0xFFFF4949))),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
