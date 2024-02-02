import 'dart:convert';

import 'package:doct_app/screen/theme/Color.dart';
import 'package:doct_app/screen/utils/app_preferences.dart';
import 'package:doct_app/screen/utils/commonUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

import '../../api/call_api.dart';
import '../../main.dart';
import '../home/Home.dart';
import '../register/Register.dart';
import '../utils/apiURLs.dart';
import '../utils/global.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AppPreferences _preferences = AppPreferences();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _passwordVisible = false;
  var userId = "";

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsInt.colorWhite,
        elevation: 0,
      ),
      backgroundColor: ColorsInt.colorWhite,
      body: Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 30),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 50,
                  height: 50,
                ),
                Text(
                  "  ${APP_NAME}",
                  style: TextStyle(
                    fontSize: 30,
                    color: ColorsInt.colorTitleText,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Inter",
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 70, bottom: 20),
              child: Text("Login",
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsInt.colorTitleText,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter",
                  )),
            ),
            TextFormField(
              style: TextStyle(
                  color: ColorsInt.colorText,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter"),
              controller: username,
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
                    color: ColorsInt.colorText,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter"),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorsInt.colorTextgray.withOpacity(0.1)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsInt.colorPrimary1),
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            TextFormField(
              style: TextStyle(
                fontSize: 16,
                color: ColorsInt.colorText,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
              ),
              controller: password,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  size: 25,
                  color: ColorsInt.colorPrimary1,
                ),
                labelText: 'Password',
                labelStyle: TextStyle(
                  fontSize: 16,
                  color: ColorsInt.colorText,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter",
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorsInt.colorTextgray.withOpacity(0.1)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsInt.colorPrimary1),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: ColorsInt.colorgray,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: InkWell(
                onTap: () {
                  if (username.text.isEmpty) {
                    CommonUtils().ShowToast("Email Required", context);
                  } else {
                    ApiCallForgotPassword();
                  }
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password ?",
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorsInt.colorTitleText,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 10,
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
                    if (username.text.isEmpty) {
                      CommonUtils().ShowToast("Email Required", context);
                    } else if (password.text.isEmpty) {
                      CommonUtils().ShowToast("Password Required", context);
                    } else if (CommonUtils()
                        .validateEmail(username.text.trim())) {
                      CommonUtils.displaySnackBar(context, "Enter Valid Email");
                    } else {
                      ApiCallLogin();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Login",
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
            Container(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: ColorsInt.colorPrimary1),
              ),
              child: Material(
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
                          child: const Register()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorsInt.colorPrimary1,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Inter",
                        ),
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

  ApiCallLogin() async {
    var body = {
      "user_email": username.text,
      "user_password": password.text,
    };
    CallApi().PostWithBody(context, ApiURLs.LOGIN, body).then((response) async {
      Map responseOfData = jsonDecode(response!);
      userId = responseOfData["user_id"].toString();
      var userName = responseOfData["user_fullname"].toString();
      var userEmail = responseOfData["user_email"].toString();
      var userPhone = responseOfData["user_phone"].toString();
      var userImage = responseOfData["user_image"].toString();
      print("set image data is $userImage");
      _preferences.setUserId(userid: userId);
      _preferences.setUserEmail(email: userEmail);
      _preferences.setUserPhone(phone: userPhone);
      _preferences.setUserName(name: userName);
      _preferences.setUserImage(url: userImage);
      _preferences.setUserLogin(isLogin: true);
      getToken();
    });
  }

  String token = "";

  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    ApiCallFCMRegister();
  }

  ApiCallFCMRegister() async {
    String deviceType = "android";
    if (Platform.isAndroid) {
      deviceType = "android";
    } else if (Platform.isIOS) {
      deviceType = "ios";
    }
    String? userId = await _preferences.getUserId();
    var body = {
      "user_id": userId,
      "token": token,
      "device": deviceType,
    };
    CallApi().PostWithBody(context, ApiURLs.REGISTER_FCM_URL, body).then(
      (response) async {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
        Navigator.of(context).pushAndRemoveUntil(
            PageTransition(
                type: PageTransitionType.bottomToTop,
                duration: Duration(milliseconds: 500),
                alignment: Alignment.center,
                child: Home()),
            (Route<dynamic> route) => false);
      },
    );
  }

  ApiCallForgotPassword() async {
    var body = {
      "user_email": username.text,
    };
    CallApi().PostWithBody(context, ApiURLs.FORGOT_PASSWORD, body).then(
      (response) async {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
      },
    );
  }
}
