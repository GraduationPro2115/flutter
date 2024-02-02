import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screen/utils/apiURLs.dart';
import '../screen/utils/commonUtils.dart';

class CallApi {
  Future<String?> get(BuildContext context,
      String url,) async {
    print("url is::$url");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      CommonUtils().showDailog(context);

      try {
        final response = await http.get(Uri.parse(url), headers: {
          "authorization": ApiURLs.AUTH_KEY
        }).timeout(Duration(seconds: 300), onTimeout: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          CommonUtils.displaySnackBar(context, "Connection Time Out".tr());
          throw Exception('Connection Time Out');
        });

        debugPrint("Request url: $url");
        debugPrint("Request status: ${response.statusCode}");
        debugPrint("Request body: ${response.body}");
        if (response.statusCode == 200) {
          // If the call to the server was RESPONSE, parse the JSON.
          Map responseData = jsonDecode(response.body);
          var dataString = jsonEncode(responseData[ApiURLs.DATA]).toString();
          return dataString;
        } else {
          Map responseData = jsonDecode(response.body);
          if (responseData.containsKey(ApiURLs.DATA)) {
            var errorString = responseData[ApiURLs.DATA].toString();

            if (responseData.containsKey(ApiURLs.DATA)) {
              Map dataMap = responseData[ApiURLs.DATA];
            }
            debugPrint("Request error: $errorString");
            throw errorString;
          }
        }
      } on Exception catch (e) {
        // If that call was not RESPONSE, throw an error.
        throw Exception('Something wrong.$e');
      }
    } else {
      CommonUtils.displaySnackBar(context, "check_internet".tr());
    }
  }

  Future<String?> getWithParam(BuildContext context, String url, param) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      CommonUtils().showDailog(context);
      try {
        final response = await http
            .get(Uri.parse(url).replace(queryParameters: param), headers: {
          "authorization": ApiURLs.AUTH_KEY
        }).timeout(const Duration(seconds: 300), onTimeout: () {
          CommonUtils.displaySnackBar(context, "connection_time_out".tr());
          Navigator.of(context, rootNavigator: true).pop('dialog');

          throw Exception('Connection Time Out');
        });

        debugPrint("Request url: ${response.request}");
        debugPrint("Request status: ${response.statusCode}");
        debugPrint("Request param: ${param}");
        debugPrint("Request body: ${response.body}");
        if (response.statusCode == 200) {
          // If the call to the server was RESPONSE, parse the JSON.
          Map responseData = jsonDecode(response.body);
          var dataString = jsonEncode(responseData[ApiURLs.DATA]).toString();
          return dataString;
        } else {
          Map responseData = jsonDecode(response.body);

          if (responseData.containsKey(ApiURLs.DATA)) {
            var errorString = responseData[ApiURLs.DATA].toString();

            if (responseData.containsKey(ApiURLs.DATA)) {
              Map dataMap = responseData[ApiURLs.DATA];
            }

            debugPrint("Request error: $errorString");
            throw errorString;
          }
        }
      } on Exception catch (e) {
        // If that call was not RESPONSE, throw an error.
        throw Exception('Something wrong.');
      }
    } else {
      CommonUtils.displaySnackBar(context, "check_internet".tr());
    }
  }

  Future<String?> PostWithParam(BuildContext context, String url,
      Map<String, dynamic>? param) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      CommonUtils().showDailog(context);

      try {
        final response = await http
            .post(Uri.parse(url).replace(queryParameters: param), headers: {
          "authorization": ApiURLs.AUTH_KEY
        }).timeout(const Duration(seconds: 300), onTimeout: () {
          CommonUtils.displaySnackBar(context, "connection_time_out".tr());
          Navigator.of(context, rootNavigator: true).pop('dialog');

          throw Exception('Connection Time Out');
        });
        debugPrint("Request url: $url");
        debugPrint("Request status: ${response.statusCode}");
        debugPrint("Request param: ${param}");
        debugPrint("Request body: ${response.body}");
        if (response.statusCode == 200) {
          /// If the call to the server was RESPONSE, parse the JSON.

          Map responseData = jsonDecode(response.body);

          if (responseData.containsKey(ApiURLs.RESPONSE)) {
            if (responseData[ApiURLs.RESPONSE]) {
              var dataString =
              jsonEncode(responseData[ApiURLs.DATA]).toString();
              debugPrint("Request response: $dataString");

              return dataString;
            } else {
              Navigator.of(context, rootNavigator: true).pop('dialog');

              var errorString = responseData[ApiURLs.ERROR].toString();

              CommonUtils.displaySnackBar(context, errorString);
              if (responseData.containsKey(ApiURLs.DATA)) {
                Map dataMap = responseData[ApiURLs.DATA];
                print(dataMap);
              }

              debugPrint("Request error: $errorString");
              throw errorString;
            }
          } else {
            CommonUtils.displaySnackBar(context, "something_went_wrong".tr());
            debugPrint("something went wrong");
          }
        } else {
          Map responseData = jsonDecode(response.body);
          if (responseData.containsKey(ApiURLs.DATA)) {
            var errorString = responseData[ApiURLs.DATA].toString();

            if (responseData.containsKey(ApiURLs.DATA)) {
              Map dataMap = responseData[ApiURLs.DATA];
            }
            debugPrint("Request error: $errorString");
            throw errorString;
          }
        }
      } on Exception catch (e) {
        // If that call was not RESPONSE, throw an error.
        throw Exception('Something wrong.');
      }
    } else {
      CommonUtils.displaySnackBar(context, "check_internet".tr());
    }
  }

  Future<String?> PostWithBody(BuildContext context, String url,
      Map<String, dynamic>? body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      CommonUtils().showDailog(context);
      try {
        final response = await http.post(Uri.parse(url), body: body, headers: {
          "authorization": ApiURLs.AUTH_KEY
        }).timeout(const Duration(seconds: 300), onTimeout: () {
          CommonUtils.displaySnackBar(context, "connection_time_out".tr());
          Navigator.of(context, rootNavigator: true).pop('dialog');

          throw Exception('Connection Time Out');
        });
        debugPrint("Request url: $url");
        debugPrint("Request status: ${response.statusCode}");
        debugPrint("Request param: ${body}");
        debugPrint("Request body: ${response.body}");
        if (response.statusCode == 200) {
          /// If the call to the server was RESPONSE, parse the JSON.

          Map responseData = jsonDecode(response.body);

          if (responseData.containsKey(ApiURLs.RESPONSE)) {
            if (responseData[ApiURLs.RESPONSE]) {
              if (responseData.containsKey(ApiURLs.ERROR)) {
                var errorString = responseData[ApiURLs.ERROR].toString();
                CommonUtils.displaySnackBar(context, errorString);
              }
              var dataString =
              jsonEncode(responseData[ApiURLs.DATA]).toString();
              debugPrint("Request response: $dataString");

              return dataString;
            } else {
              Navigator.of(context, rootNavigator: true).pop('dialog');

              var errorString = responseData[ApiURLs.ERROR].toString();
              CommonUtils.displaySnackBar(context, errorString);
              if (responseData.containsKey(ApiURLs.DATA)) {
                Map dataMap = responseData[ApiURLs.DATA];
                print(dataMap);
              }

              debugPrint("Request error: $errorString");
              throw errorString;
            }
          } else {
            CommonUtils.displaySnackBar(context, "something_went_wrong".tr());
            debugPrint("something went wrong");
          }
        } else {
          Map responseData = jsonDecode(response.body);
          if (responseData.containsKey(ApiURLs.DATA)) {
            var errorString = responseData[ApiURLs.DATA].toString();

            if (responseData.containsKey(ApiURLs.DATA)) {
              Map dataMap = responseData[ApiURLs.DATA];
            }
            debugPrint("Request error: $errorString");
            throw errorString;
          }
        }
      } on Exception catch (e) {
        throw Exception('Something wrong.');
      }
    } else {
      CommonUtils.displaySnackBar(context, "check_internet".tr());
    }
  }

  Future<String?> fileNewUpload(BuildContext context, String url, File file,
      String userId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      CommonUtils().showDailog(context);
      try {
        Map<String, String> headers = {"authorization": ApiURLs.AUTH_KEY};
        var request = http.MultipartRequest("POST", Uri.parse(url));
        request.headers.addAll(headers);
        request.fields["user_id"] = userId;
        print("file path is ::${file.path}");

        //create multipart using filepath,string or bytes
        var pic =
        await http.MultipartFile.fromPath("user_image", file.absolute.path);
        //add multipart to request
        request.files.add(pic);
        var response = await request.send();
        print("send file to server");

        //Get the response from the server
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print(responseString);
        // return responseString;

        debugPrint("Request url: $url");
        debugPrint("Request status: ${response.statusCode}");
        debugPrint("Request body: ${responseString}");
        if (response.statusCode == 200) {
          /// If the call to the server was RESPONSE, parse the JSON.

          Map responseData = jsonDecode(responseString);
          if (responseData.containsKey(ApiURLs.RESPONSE)) {
            if (responseData[ApiURLs.RESPONSE]) {
              var dataString =
              jsonEncode(responseData[ApiURLs.DATA]).toString();
              debugPrint("Request response: $dataString");

              return dataString;
            } else {
              Navigator.of(context, rootNavigator: true).pop('dialog');

              var errorString = responseData[ApiURLs.DATA].toString();
              if (responseData.containsKey(ApiURLs.DATA)) {
                Map dataMap = responseData[ApiURLs.DATA];
                print(dataMap);
              }

              debugPrint("Request error: $errorString");
              throw errorString;
            }
          } else {
            CommonUtils.displaySnackBar(context, "something_went_wrong".tr());
            debugPrint("something went wrong");
          }
        } else {
          Map responseData = jsonDecode(responseString);
          if (responseData.containsKey(ApiURLs.DATA)) {
            var errorString = responseData[ApiURLs.DATA].toString();

            if (responseData.containsKey(ApiURLs.DATA)) {
              Map dataMap = responseData[ApiURLs.DATA];
            }
            debugPrint("Request error: $errorString");
            throw errorString;
          }
        }
      } on Exception catch (e) {
        debugPrint("Something wrong. $e");
        throw Exception('Something wrong.');
      }
    } else {
      debugPrint("no internet");
    }
  }

  // for online payment
  Future<String?> PostWithBodyAppointment(BuildContext context, String url,
      Map<String, dynamic>? body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      CommonUtils().showDailog(context);
      try {
        final response = await http.post(Uri.parse(url), body: body, headers: {
          "authorization": ApiURLs.AUTH_KEY
        }).timeout(const Duration(seconds: 300), onTimeout: () {
          CommonUtils.displaySnackBar(context, "connection_time_out".tr());
          Navigator.of(context, rootNavigator: true).pop('dialog');

          throw Exception('Connection Time Out');
        });
        debugPrint("Request url: $url");
        debugPrint("Request status: ${response.statusCode}");
        debugPrint("Request param: ${body}");
        debugPrint("Request body: ${response.body}");
        if (response.statusCode == 200) {
          /// If the call to the server was RESPONSE, parse the JSON.

          return response.body.toString();
          // Map responseData = jsonDecode(response.body);
          //
          // if (responseData.containsKey(ApiURLs.RESPONSE)) {
          //   if (responseData[ApiURLs.RESPONSE]) {
          //     if (responseData.containsKey(ApiURLs.ERROR)) {
          //       var errorString = responseData[ApiURLs.ERROR].toString();
          //       CommonUtils.displaySnackBar(context, errorString);
          //     }
          //
          //     return response.body.toString();
          //   } else {
          //     Navigator.of(context, rootNavigator: true).pop('dialog');
          //
          //     var errorString = responseData[ApiURLs.ERROR].toString();
          //     CommonUtils.displaySnackBar(context, errorString);
          //     if (responseData.containsKey(ApiURLs.DATA)) {
          //       Map dataMap = responseData[ApiURLs.DATA];
          //       print(dataMap);
          //     }
          //
          //     debugPrint("Request error: $errorString");
          //     throw errorString;
          //   }
          // } else {
          //   CommonUtils.displaySnackBar(context, "something_went_wrong".tr());
          //   debugPrint("something went wrong");
          // }
        } else {
          Map responseData = jsonDecode(response.body);
          if (responseData.containsKey(ApiURLs.DATA)) {
            var errorString = responseData[ApiURLs.DATA].toString();

            if (responseData.containsKey(ApiURLs.DATA)) {
              Map dataMap = responseData[ApiURLs.DATA];
            }
            debugPrint("Request error: $errorString");
            throw errorString;
          }
        }
      } on Exception catch (e) {
        throw Exception('Something wrong.');
      }
    } else {
      CommonUtils.displaySnackBar(context, "check_internet".tr());
    }
  }
}
