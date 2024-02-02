import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:doct_app/screen/utils/app_preferences.dart';
import 'package:doct_app/screen/utils/commonUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

import '../../api/call_api.dart';
import '../../main.dart';
import '../home/Home.dart';
import '../utils/apiURLs.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _ContactUsState extends State<ContactUs> {
  AppPreferences _preferences = AppPreferences();
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController userPhoneTextController = TextEditingController();
  TextEditingController userEmailTextController = TextEditingController();
  TextEditingController messageTextController = TextEditingController();
  var userId = "0";
  String id = "";
  String email = "";
  String name = "";
  String phone = "";

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
    userEmailTextController.text = email.toString();
    userNameTextController.text = name.toString();
    userPhoneTextController.text = phone.toString();
    userId = id;
    messageTextController.text = "Write your message here";
    setState(() {});
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
            "Contact Us",
            style: TextStyle(
                color: ColorsInt.colorTitleText,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          backgroundColor: ColorsInt.colorBG,
        ),
        backgroundColor: ColorsInt.colorBG,
        body: Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 10),
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ColorsInt.colorWhite,
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                    border:
                        Border.all(color: ColorsInt.colorBorderMyAppointment),
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
                          borderSide:
                              BorderSide(color: ColorsInt.colorPrimary1),
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
                                color:
                                    ColorsInt.colorTextgray.withOpacity(0.1)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorsInt.colorPrimary1),
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
                                  color:
                                      ColorsInt.colorTextgray.withOpacity(0.1)),
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
                    color: ColorsInt.colorWhite,
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                    border:
                        Border.all(color: ColorsInt.colorBorderMyAppointment),
                  ),
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    style: TextStyle(
                        color: ColorsInt.colorBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Manrope"),
                    controller: messageTextController,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),

                      labelText: 'Message',
                      labelStyle: TextStyle(
                          color: ColorsInt.colorBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Manrope"),
                      // enabledBorder: UnderlineInputBorder(),
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
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
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.topToBottom,
                              duration: Duration(milliseconds: 500),
                              alignment: Alignment.center,
                              child: const Home()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            "Send",
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorsInt.colorWhite,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Inter",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     if (userNameTextController.text.isEmpty) {
                //       CommonUtils().ShowToast("Name Required",context);
                //     } else if (userPhoneTextController.text.isEmpty) {
                //       CommonUtils().ShowToast("Phone Number Required",context);
                //     } else if (userEmailTextController.text.isEmpty) {
                //       CommonUtils().ShowToast("Email Required",context);
                //     } else {
                //       ApiCallUpdateProfile();
                //     }
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(15),
                //     width: MediaQuery.of(context).size.width - 40,
                //     decoration: BoxDecoration(
                //       color: ColorsInt.colorPrimary1,
                //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                //       border:
                //           Border.all(color: ColorsInt.colorDashboardItemBorder),
                //     ),
                //     child: Center(
                //       child: Text(
                //         "Send",
                //         style: TextStyle(
                //           color: ColorsInt.colorWhite,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )));
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
        ApiCallGetUserData();
      },
    );
  }

  ApiCallGetUserData() async {
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
        _preferences.setUserId(userid: userId);
        _preferences.setUserEmail(email: userEmail);
        _preferences.setUserPhone(phone: userPhone);
        _preferences.setUserName(name: userName);

        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
        Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.leftToRight,
              duration: Duration(milliseconds: 500),
              alignment: Alignment.center,
              child: Home(),
            ));
      },
    );
  }
}
