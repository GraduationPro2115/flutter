import 'dart:convert';
import 'dart:io';

import 'package:doct_app/screen/Webview/WebView.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:doct_app/screen/utils/app_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

import '../../api/call_api.dart';
import '../../main.dart';
import '../home/Home.dart';
import '../utils/apiURLs.dart';
import '../utils/commonUtils.dart';
import '../utils/global.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AppPreferences _preferences = AppPreferences();
  TextEditingController fullNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  var isAcceptPolicy = false;
  bool _passwordVisible = false;
  var userId = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        elevation: 0,
        backgroundColor: ColorsInt.colorWhite,
      ),
      backgroundColor: ColorsInt.colorWhite,
      body: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
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
                const Text(
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
              margin: const EdgeInsets.only(top: 70, bottom: 20),
              child: const Text("Register",
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsInt.colorTitleText,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter",
                  )),
            ),
            TextFormField(
              style: const TextStyle(
                  color: ColorsInt.colorText,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter"),
              controller: fullNameTextController,
              enableInteractiveSelection: false,
              // will disable paste operation
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.account_circle_rounded,
                  size: 25,
                  color: ColorsInt.colorIcon,
                ),
                labelText: 'Full Name',
                iconColor: ColorsInt.colorTextgray,
                labelStyle: const TextStyle(
                    color: ColorsInt.colorText,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter"),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorsInt.colorTextgray.withOpacity(0.1)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsInt.colorPrimary1),
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                  color: ColorsInt.colorText,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter"),
              controller: phoneTextController,
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.phone_android,
                  size: 25,
                  color: ColorsInt.colorIcon,
                ),
                labelText: 'Phone Number',
                iconColor: ColorsInt.colorTextgray,
                labelStyle: const TextStyle(
                    color: ColorsInt.colorText,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter"),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorsInt.colorTextgray.withOpacity(0.1)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsInt.colorPrimary1),
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                  color: ColorsInt.colorText,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter"),
              controller: emailTextController,
              enableInteractiveSelection: false,
              // will disable paste operation
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.mail,
                  size: 25,
                  color: ColorsInt.colorIcon,
                ),
                labelText: 'Email address',
                iconColor: ColorsInt.colorTextgray,
                labelStyle: const TextStyle(
                    color: ColorsInt.colorText,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter"),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorsInt.colorTextgray.withOpacity(0.1)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsInt.colorPrimary1),
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            TextFormField(
              style: const TextStyle(
                fontSize: 16,
                color: ColorsInt.colorText,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
              ),
              controller: passwordTextController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.lock,
                  size: 25,
                  color: ColorsInt.colorIcon,
                ),
                labelText: 'Password',
                labelStyle: const TextStyle(
                  fontSize: 16,
                  color: ColorsInt.colorText,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter",
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorsInt.colorTextgray.withOpacity(0.1)),
                ),
                focusedBorder: const UnderlineInputBorder(
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
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: MaterialStateBorderSide.resolveWith(
                        (states) => const BorderSide(
                            width: 1.0, color: ColorsInt.colorPrimary1),
                      ),
                      activeColor: ColorsInt.colorPrimary1,
                      value: isAcceptPolicy,
                      onChanged: (bool? value) {
                        setState(() {
                          isAcceptPolicy = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'By Singing or in, you Accept our  ',
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorsInt.colorText,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                            ),
                          ),
                          TextSpan(
                            text: 'Terms',
                            style: TextStyle(
                              fontSize: 15,
                              color: ColorsInt.colorPrimary1,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.leftToRight,
                                      duration: Duration(milliseconds: 500),
                                      alignment: Alignment.center,
                                      child: MyWebView(
                                          url: ApiURLs.TERMS_CONDITIONS_URL),
                                    ));
                              },
                          ),
                          TextSpan(
                              text: ' and ',
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorsInt.colorText,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Inter",
                              )),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              fontSize: 15,
                              color: ColorsInt.colorPrimary1,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.leftToRight,
                                      duration: Duration(milliseconds: 500),
                                      alignment: Alignment.center,
                                      child: MyWebView(
                                          url: ApiURLs.PRIVACY_POLICY_URL),
                                    ));
                              },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 20,
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
                    if (fullNameTextController.text.isEmpty) {
                      CommonUtils().ShowToast("Name Required", context);
                    } else if (phoneTextController.text.isEmpty) {
                      CommonUtils().ShowToast("Phone Number Required", context);
                    } else if (emailTextController.text.isEmpty) {
                      CommonUtils().ShowToast("Email Required", context);
                    } else if (passwordTextController.text.isEmpty) {
                      CommonUtils().ShowToast("Password Required", context);
                    } else if (CommonUtils().validateMobileNumber(
                        phoneTextController.text.trim())) {
                      CommonUtils.displaySnackBar(
                          context, "Enter Valid Phone Number");
                    } else if (CommonUtils()
                        .validateEmail(emailTextController.text.trim())) {
                      CommonUtils.displaySnackBar(context, "Enter Valid Email");
                    } else if (isAcceptPolicy) {
                      ApiCallRagister();
                    } else {
                      CommonUtils().ShowToast(
                          "PLease accept our terms and condition", context);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Register",
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

  ApiCallRagister() async {
    var body = {
      "user_fullname": fullNameTextController.text,
      "user_phone": phoneTextController.text,
      "user_email": emailTextController.text,
      "user_password": passwordTextController.text,
    };
    CallApi().PostWithBody(context, ApiURLs.REGISTER, body).then(
      (response) async {
        Map responseOfData = jsonDecode(response!);
        userId = responseOfData["user_id"].toString();
        var userName = responseOfData["user_fullname"].toString();
        var userEmail = responseOfData["user_email"].toString();
        var userPhone = responseOfData["user_phone"].toString();
        _preferences.setUserId(userid: userId);
        _preferences.setUserEmail(email: userEmail);
        _preferences.setUserPhone(phone: userPhone);
        _preferences.setUserName(name: userName);
        _preferences.setUserLogin(isLogin: true);
        getToken();
      },
    );
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
}
