import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_todo_app/data/local_data/storage.dart';
import 'package:my_todo_app/data/my_repository.dart';
import 'package:my_todo_app/db/cached_todo.dart';
import 'package:my_todo_app/presentation/login/register_screen/register_screen.dart';
import 'package:my_todo_app/presentation/login/widgets/my_text_field.dart';
import 'package:my_todo_app/presentation/tabs/profile/sub_screens/settings_screen.dart';
import 'package:my_todo_app/presentation/tabs/profile/widgets/my_custom_row.dart';
import 'package:my_todo_app/presentation/tabs/tab_box/widgets/my_button.dart';
import 'package:my_todo_app/utils/colors.dart';
import 'package:my_todo_app/utils/icons.dart';
import 'package:my_todo_app/utils/utility_functions.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "";
  final TextEditingController changeNameController = TextEditingController();
  final FocusNode changeNameFocusNode = FocusNode();

  @override
  void dispose() {
    changeNameController.dispose();
    super.dispose();
  }

// --------------------------------------------- //
  String imagePath = "";
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;

  List<CachedTodo> undoneTodos = [];
  List<CachedTodo> doneTodos = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    undoneTodos = await MyRepository.getTodosByDone(isDone: 0);
    doneTodos = await MyRepository.getTodosByDone(isDone: 1);
    username = StorageRepository.getString("name");
    imagePath = StorageRepository.getString("profile_image");
    changeNameController.text = username;
    setState(() {});
  }

  getFromGallery() async {
    bool hasPermission = await _requestGetFromGalleryPermission();
    if (!hasPermission) return;

    imageFile = await _picker.pickImage(
      maxHeight: 200,
      maxWidth: 200,
      source: ImageSource.gallery,
    );
    if (imageFile != null) {
      await StorageRepository.putString(
        key: "profile_image",
        value: imageFile!.path,
      );
      setState(() {
        imagePath = imageFile!.path;
      });
    }
  }

  getFromCamera() async {
    bool hasPermission = await _requestGetFromCameraPermission();
    if (!hasPermission) return;

    imageFile = await _picker.pickImage(
      maxHeight: 200,
      maxWidth: 200,
      source: ImageSource.camera,
    );
    if (imageFile != null) {
      await StorageRepository.putString(
          key: "profile_image", value: imageFile!.path);
      setState(() {
        imagePath = imageFile!.path;
      });
    }
  }

  Future<bool> _requestGetFromGalleryPermission() async {
    await Permission.storage.status;
    return await Permission.storage.request().isGranted;
  }

  Future<bool> _requestGetFromCameraPermission() async {
    await Permission.camera.request();
    return await Permission.camera.request().isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.bgColor,
        centerTitle: true,
        title: Text(
          tr("profile"),
          style: GoogleFonts.lato()
              .copyWith(fontSize: 20.sp, color: Colors.white.withOpacity(0.87)),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.black,
        backgroundColor: MyColors.C_8687E7,
        onRefresh: () async {
          _init();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 150.h,
                        width: 150.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: imagePath.isEmpty
                              ? Image.asset(MyIcons.defaultPerson)
                              : Image.file(File(imagePath), fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              selectImageDialog(context);
                            },
                            icon: Container(
                              width: 50.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    offset: const Offset(0, 5),
                                    color: Colors.grey.shade500,
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      MyIcons.camera,
                                      color: Colors.grey.shade500,
                                      width: 30.w,
                                      height: 30.h,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 7,
                                    right: 7,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 8.r,
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 18.sp,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                Center(child: Text(username, style: GoogleFonts.lato().copyWith(color: MyColors.white_87, fontSize: 18.sp))),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 58.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: MyColors.C_363636,
                        ),
                        child: Center(
                          child: Text(
                            "${undoneTodos.length} ${tr("task_left")}",
                            style: GoogleFonts.lato().copyWith(
                              fontSize: 16.sp,
                              color: MyColors.white_87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Container(
                        height: 58.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: MyColors.C_363636,
                        ),
                        child: Center(
                          child: Text(
                            "${doneTodos.length} ${tr("task_done")}",
                            style: GoogleFonts.lato().copyWith(
                              fontSize: 16.r,
                              color: MyColors.white_87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Text(tr("settings"), style: GoogleFonts.lato().copyWith(color: MyColors.C_AFAFAF)),
                SizedBox(height: 16.h),
                MyRow(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => SettingsScreen(
                            listenerCallBack: (v) {
                              if (v == true) {
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      );
                    },
                    icon: MyIcons.settings,
                    text: tr("app_settings")),
                SizedBox(height: 14.h),
                Text("Account",
                    style:
                        GoogleFonts.lato().copyWith(color: MyColors.C_AFAFAF)),
                SizedBox(height: 16.h),
                MyRow(
                    onTap: () {
                      myCustomChangeNameDialog(() {
                        setState(() {});
                      });
                    },
                    icon: MyIcons.user,
                    text: tr("change_account_name")),
                SizedBox(height: 4.h),
                MyRow(
                    onTap: () {},
                    icon: MyIcons.key,
                    text: tr("change_account_password")),
                SizedBox(height: 4.h),
                MyRow(
                    onTap: () {
                      selectImageDialog(context);
                    },
                    icon: MyIcons.account,
                    text: tr("change_account_image")),
                SizedBox(height: 14.h),
                Text("Uptodo", style: GoogleFonts.lato().copyWith(color: MyColors.C_AFAFAF)),
                SizedBox(height: 16.h),
                MyRow(onTap: () {}, icon: MyIcons.about, text: tr("about_us")),
                SizedBox(height: 14.h),
                MyRow(onTap: () {}, icon: MyIcons.faq, text: tr("faq")),
                SizedBox(height: 14.h),
                MyRow(onTap: () {}, icon: MyIcons.flesh, text: tr("help")),
                SizedBox(height: 14.h),
                MyRow(onTap: () {}, icon: MyIcons.like, text: tr("support")),
                SizedBox(height: 14.h),
                MyRow(
                    onTap: () {
                      myCustomLogOut();
                    },
                    hColor: Colors.red.withOpacity(0.5),
                    icon: MyIcons.logout,
                    text: tr("logout"),
                    textColor: Colors.red),
                SizedBox(height: 14.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectImageDialog(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.r),
          topLeft: Radius.circular(16.r),
        ),
      ),
      backgroundColor: MyColors.bgColor,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: 160.h, //MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  ListTile(
                      leading: Icon(Icons.photo_library, color: MyColors.white_87),
                      title: Text(tr("gallery"), style: GoogleFonts.lato().copyWith(color: MyColors.white_87)),
                      onTap: () {
                        getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera, color: MyColors.white_87),
                    title: Text(tr("camera"), style: GoogleFonts.lato().copyWith(color: MyColors.white_87)),
                    onTap: () {
                      getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void myCustomLogOut() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
            backgroundColor: MyColors.C_363636,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 150.h,
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
                          tr("sure"),
                          style: GoogleFonts.lato().copyWith(
                            fontSize: 16.sp,
                            color: MyColors.white_87,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(child: Container(height: 1, color: MyColors.C_979797)),
                          ],
                        ),
                        SizedBox(height: 20.h),
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
                            text: tr("no"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()));
                            StorageRepository.deleteString("name");
                            StorageRepository.deleteString("password");
                            StorageRepository.deleteString("isRegistered");
                            StorageRepository.deleteString("isLogged");
                            UtilityFunctions.getMyToast(message: tr("logged"));
                          },
                          child: MyButton(text: tr("yes")),
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
  void myCustomChangeNameDialog(VoidCallback update) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            backgroundColor: MyColors.C_363636,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 202.h,
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
                          tr("change_account_name"),
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
                                    height: 1, color: MyColors.C_979797)),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        SizedBox(
                          child: MyTextField(
                            bgColor: MyColors.C_363636,
                            hintText: tr("your_name"),
                            keyType: TextInputType.name,
                            controller: changeNameController,
                            focusNode: changeNameFocusNode,
                            onSubmitted: (v) {
                              changeNameFocusNode.unfocus();
                            },
                          ),
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
                            username = changeNameController.text;
                            setState(() {});
                            Navigator.pop(context);
                            await StorageRepository.putString(
                                key: "name", value: changeNameController.text);
                            UtilityFunctions.getMyToast(
                                message:
                                    "${tr("now_name")} ${changeNameController.text}");
                            update();
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
  }
}
