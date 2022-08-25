import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/data/my_repository.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';

class MyAppBar extends PreferredSize {
  MyAppBar({Key? key, required this.title})
      : super(
          child: AppBar(
            elevation: 0,
            backgroundColor: MyColors.bgColor,
            centerTitle: true,
            leading: SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(MyIcons.menu, fit: BoxFit.scaleDown),
            ),
            actions: [
              Center(
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: MyRepository.getProfileImageUrl().isEmpty
                        ? Image.asset(MyIcons.defaultPerson, fit: BoxFit.cover)
                        : Image.file(File(MyRepository.getProfileImageUrl()),
                            fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
            title: Text(
              title,
              style: GoogleFonts.lato().copyWith(
                  fontSize: 20, color: Colors.white.withOpacity(0.87)),
            ),
          ),
          preferredSize: const Size.fromHeight(56),
        );
  final String title;
}
