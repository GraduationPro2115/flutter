import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:doct_app/screen/utils/app_preferences.dart';
import 'package:doct_app/screen/utils/commonUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/call_api.dart';
import '../../main.dart';
import '../home/Home.dart';
import '../utils/apiURLs.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _UpdateProfileState extends State<UpdateProfile> {
  AppPreferences _preferences = AppPreferences();
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController userPhoneTextController = TextEditingController();
  TextEditingController userEmailTextController = TextEditingController();
  var userId = "0";
  String id = "";
  String email = "";
  String name = "";
  String phone = "";
  String imgUrl = "";
  XFile? _pickedFile;
  CroppedFile? _croppedFile;

  @override
  void initState() {
    super.initState();
    UserData();
  }

  UserData() async {
    id = await _preferences.getUserId();
    email = await _preferences.getUserEmail();
    name = await _preferences.getUserName();
    phone = await _preferences.getUserPhone();
    imgUrl = await _preferences.getUserImage();
    userEmailTextController.text = email.toString();
    userNameTextController.text = name.toString();
    userPhoneTextController.text = phone.toString();
    userId = id;
    setState(() {});
    ApiCallGetUserData(false);
    print("img url in profile init${ApiURLs.IMAGE_URL_PROFILE}${imgUrl}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
              color: ColorsInt.colorTitleText,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
        backgroundColor: ColorsInt.colorBG,
      ),
      backgroundColor: ColorsInt.colorBG,
      body: Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 30),
        child: ListView(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Stack(children: [
                  CachedNetworkImage(
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                    imageUrl: "${ApiURLs.IMAGE_URL_PROFILE}${imgUrl}",
                    placeholder: (context, url) =>
                        Image.asset("assets/images/logo.png"),
                    // progressIndicatorBuilder: (context, url, downloadProgress) =>
                    //     CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/images/ic_error.png"),
                  ),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: InkWell(
                        child: Image.asset(
                          "assets/images/ic_edit.png",
                          height: 25,
                          width: 25,
                        ),
                        onTap: () {
                          _cropImage(false);
                        },
                      ))
                ]),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                  child: Text(name,
                      style: TextStyle(
                          color: ColorsInt.colorBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Roboto"))),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsInt.colorWhite,
                borderRadius: BorderRadius.all(
                  Radius.circular(7.0),
                ),
                border: Border.all(color: ColorsInt.colorBorderMyAppointment),
              ),
              margin: EdgeInsets.only(top: 10, bottom: 20),
              padding: EdgeInsets.all(10),
              child: Column(children: [
                TextFormField(
                  style: TextStyle(
                      color: ColorsInt.colorBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Manrope"),
                  controller: userNameTextController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorsInt.colorTextgray.withOpacity(0.1)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsInt.colorPrimary1),
                    ),
                    prefixIcon: Icon(
                      Icons.account_circle_rounded,
                      size: 25,
                      color: ColorsInt.colorPrimary1,
                    ),
                    labelText: 'Full Name',
                    labelStyle: TextStyle(
                        color: ColorsInt.colorBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Manrope"),
                    // enabledBorder: UnderlineInputBorder(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    style: TextStyle(
                        color: ColorsInt.colorBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Manrope"),
                    controller: userEmailTextController,
                    enableInteractiveSelection: false,
                    // will disable paste operation
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.mail,
                        size: 25,
                        color: ColorsInt.colorPrimary1,
                      ),
                      labelText: 'Email address',
                      iconColor: ColorsInt.colorTextgray,
                      labelStyle: TextStyle(
                          color: ColorsInt.colorBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Manrope"),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorsInt.colorTextgray.withOpacity(0.1)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorsInt.colorPrimary1),
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      style: TextStyle(
                          color: ColorsInt.colorBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Manrope"),
                      controller: userPhoneTextController,
                      decoration: InputDecoration(
                        labelText: 'Your Phone',
                        prefixIcon: Icon(
                          Icons.phone,
                          size: 25,
                          color: ColorsInt.colorPrimary1,
                        ),
                        labelStyle: TextStyle(
                            color: ColorsInt.colorBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Manrope"),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorsInt.colorTextgray.withOpacity(0.1)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorsInt.colorPrimary1),
                        ),
                      ),
                    )),
              ]),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsInt.colorPrimary1,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Material(
                color: ColorsInt.colorPrimary1,
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    if (userNameTextController.text.isEmpty) {
                      CommonUtils().ShowToast("Name Required", context);
                    } else if (userPhoneTextController.text.isEmpty) {
                      CommonUtils().ShowToast("Phone Number Required", context);
                    } else if (userEmailTextController.text.isEmpty) {
                      CommonUtils().ShowToast("Email Required", context);
                    } else if (CommonUtils().validateMobileNumber(
                        userPhoneTextController.text.trim())) {
                      CommonUtils.displaySnackBar(
                          context, "Enter Valid Phone Number");
                    } else if (CommonUtils()
                        .validateEmail(userEmailTextController.text.trim())) {
                      CommonUtils.displaySnackBar(context, "Enter Valid Email");
                    } else {
                      ApiCallUpdateProfile();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Update",
                        style: TextStyle(
                            color: ColorsInt.colorWhite,
                            fontFamily: "Roboto-Regular",
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
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

  ApiCallUpdateProfile() async {
    String? userId = await _preferences.getUserId();
    var body = {
      "user_fullname": userNameTextController.text,
      "user_phone": userPhoneTextController.text,
      "user_id": userId,
    };
    CallApi().PostWithBody(context, ApiURLs.UPDATE_PROFILE, body).then(
      (response) async {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
        ApiCallGetUserData(true);
      },
    );
  }

  ApiCallGetUserData(bool goHome) async {
    var body = {
      "user_id": userId,
    };
    CallApi().PostWithBody(context, ApiURLs.USERDATA, body).then(
      (response) async {
        Map responseOfData = jsonDecode(response!);
        var userId = responseOfData["user_id"].toString();
        var userName = responseOfData["user_fullname"].toString();
        var userEmail = responseOfData["user_email"].toString();
        var userPhone = responseOfData["user_phone"].toString();
        var userImage = responseOfData["user_image"].toString();
        email = userEmail;
        name = userName;
        phone = userPhone;
        imgUrl = userImage;
        _preferences.setUserId(userid: userId);
        _preferences.setUserEmail(email: userEmail);
        _preferences.setUserPhone(phone: userPhone);
        _preferences.setUserName(name: userName);
        _preferences.setUserImage(url: userImage);
        print("img url is $imgUrl");
        print("${ApiURLs.IMAGE_URL_PROFILE}${imgUrl}");
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
        if (goHome) {
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                duration: Duration(milliseconds: 500),
                alignment: Alignment.center,
                child: Home()),
          );
        }
      },
    );
  }

  Future<void> _cropImage(bool isBanner) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
      );
      if (croppedFile != null) {
        print("this is file after crop${croppedFile.path}");
        setState(() {
          _croppedFile = croppedFile;
        });
        _addFile(_croppedFile!.path, isBanner);
      }
    } else {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _pickedFile = pickedFile;
          _cropImage(isBanner);
        });
      }
    }
  }

  _addFile(String path, bool isBanner) async {
    CallApi()
        .fileNewUpload(
      context,
      ApiURLs.UPLOAD_IMAGE,
      File(path),
      id,
    )
        .then((value) {
      _pickedFile = null;
      print("Image Upload Response ::$value");
      Navigator.of(context, rootNavigator: true).pop('dialog');
      setState(() {});
      ApiCallGetUserData(false);
    });
  }
}
