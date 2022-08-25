import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:my_todo_app/db/cached_category.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({
    Key? key,
    required this.categorySelected,
    required this.onTap,
    required this.category,
  }) : super(key: key);

  final bool categorySelected;
  final VoidCallback onTap;
  final CachedCategory category;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.19,
                height: MediaQuery.of(context).size.width * 0.19,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: !widget.categorySelected
                      ? Color(widget.category.categoryColor)
                      : Color(widget.category.categoryColor).withOpacity(0.6),
                ),
                child: SvgPicture.asset(widget.category.categoryIcon),
              ),
              Visibility(
                visible: widget.categorySelected,
                child: Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Lottie.asset(
                    MyIcons.done,
                    repeat: false,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            widget.category.categoryName,
            style: GoogleFonts.lato().copyWith(
              color: MyColors.white_87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
