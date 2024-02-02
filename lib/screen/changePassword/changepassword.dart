import 'package:doct_app/screen/theme/Color.dart';
import 'package:doct_app/screen/utils/app_preferences.dart';
import 'package:doct_app/screen/utils/commonUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:page_transition/page_transition.dart';

import '../../api/call_api.dart';
import '../../main.dart';
import '../home/Home.dart';
import '../utils/apiURLs.dart';
import '../utils/global.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentPasswordTextController = TextEditingController();
  TextEditingController newPasswordTextController = TextEditingController();
  TextEditingController rePasswordTextController = TextEditingController();
  bool currentPasswordVisible = false;
  bool NewPasswordVisible = false;
  bool RePasswordVisible = false;

  AppPreferences _preferences = AppPreferences();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ColorsInt.colorBlack,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: "Manrope"),
        ),
        backgroundColor: ColorsInt.colorWhite,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
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
              height: 50,
            ),
            TextFormField(
              style: TextStyle(
                fontSize: 16,
                color: ColorsInt.colorText,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
              ),
              controller: currentPasswordTextController,
              obscureText: !currentPasswordVisible,
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
                    currentPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: ColorsInt.colorgray,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      currentPasswordVisible = !currentPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 30,
            ),
            TextFormField(
              style: TextStyle(
                fontSize: 16,
                color: ColorsInt.colorText,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
              ),
              controller: newPasswordTextController,
              obscureText: !NewPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  size: 25,
                  color: ColorsInt.colorPrimary1,
                ),
                labelText: 'New Password',
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
                    NewPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: ColorsInt.colorgray,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      NewPasswordVisible = !NewPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 30,
            ),
            TextFormField(
              style: TextStyle(
                fontSize: 16,
                color: ColorsInt.colorText,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter",
              ),
              controller: rePasswordTextController,
              obscureText: !RePasswordVisible,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  size: 25,
                  color: ColorsInt.colorPrimary1,
                ),
                labelText: 'Re-enter Password',
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
                    RePasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: ColorsInt.colorgray,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      RePasswordVisible = !RePasswordVisible;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 50,
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
                    if (currentPasswordTextController.text.isEmpty) {
                      CommonUtils()
                          .ShowToast("Current Password Required", context);
                    } else if (newPasswordTextController.text.isEmpty) {
                      CommonUtils().ShowToast("New Password Required", context);
                    } else if (rePasswordTextController.text.isEmpty) {
                      CommonUtils()
                          .ShowToast("Confirm Password Required", context);
                    } else if (newPasswordTextController.text !=
                        rePasswordTextController.text) {
                      CommonUtils().ShowToast(
                          "New Password and Confirm Password must be same",
                          context);
                    } else {
                      ApiCallChangePassword();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Change Password",
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

  ApiCallChangePassword() async {
    String? userId = await _preferences.getUserId();
    var body = {
      "c_password": currentPasswordTextController.text,
      "n_password": newPasswordTextController.text,
      "r_password": rePasswordTextController.text,
      "user_id": userId,
    };
    CallApi().PostWithBody(context, ApiURLs.CHANGE_PASSWORD, body).then(
      (response) async {
        // Map responseOfData = jsonDecode(response!);
        // var userId = responseOfData["user_id"].toString();
        // var userName = responseOfData["user_fullname"].toString();
        // var userEmail = responseOfData["user_email"].toString();
        // var userPhone = responseOfData["user_phone"].toString();
        // _preferences.setUserId(userid: userId);
        // _preferences.setUserEmail(email: userEmail);
        // _preferences.setUserPhone(phone: userPhone);
        // _preferences.setUserName(name: userName);
        // _preferences.setUserLogin(isLogin: true);

        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              duration: Duration(milliseconds: 500),
              alignment: Alignment.center,
              child: Home(),
            ),
            (Route<dynamic> route) => false);
      },
    );
  }
}
