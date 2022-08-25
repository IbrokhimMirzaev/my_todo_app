import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class PriorityItem extends StatefulWidget {
  const PriorityItem({
    Key? key,
    required this.isSelected,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  @override
  State<PriorityItem> createState() => _PriorityItemState();
}

class _PriorityItemState extends State<PriorityItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: (widget.isSelected == false) ? const Color(0xFF272727) : MyColors.C_8687E7,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 2, child: Container(width: MediaQuery.of(context).size.width * 0.1, height: double.infinity, child: Center(child: SvgPicture.asset(MyIcons.bigFlag, fit: BoxFit.cover)))),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    (widget.index + 1).toString(),
                    style: GoogleFonts.lato().copyWith(
                      fontSize: 15.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
