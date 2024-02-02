import 'package:doct_app/model/DoctorListModel.dart';
import 'package:doct_app/model/businesslistmodel.dart';
import 'package:doct_app/screen/patientcontact/paitentcontact.dart';
import 'package:doct_app/screen/thankyou/thankyou.dart';
import 'package:doct_app/screen/utils/commonUtils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../../model/MyAppointmentListModel.dart';

BusinessListModel? businessModel;

DoctorListModel? doctorModel;

class Body extends StatefulWidget {
  Body({
    Key? key,
    required this.url,
    required this.controller,
    required this.setWebController,
    required this.onLoadStart,
    required this.onLoadStop,
    required this.onPaymentSuccess,
    required this.booking_data,
  }) : super(key: key);

  final String url;
  MyAppointmentListModel booking_data;
  final InAppWebViewController? controller;
  final Function(InAppWebViewController) setWebController;
  final VoidCallback onLoadStart;
  final VoidCallback onLoadStop;




  final Function(String) onPaymentSuccess;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var _opacity = 1.0;


  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity,
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),

        initialOptions: InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
          ),
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,

            cacheEnabled: false,
            clearCache: true,
            javaScriptCanOpenWindowsAutomatically: true,
            supportZoom: false,
            transparentBackground: true,
            useShouldOverrideUrlLoading: true,
            useShouldInterceptFetchRequest: true,
          ),
        ),
        onWebViewCreated: (controller) {
          widget.setWebController(controller);
        },
        onLoadStop: (controller, url) async {
          widget.onLoadStop();
          print("onLoadStop$url");
          bool hasSuccess =
              RegExp(".*payment_success.*").hasMatch(url.toString());
          if (hasSuccess) {
            // print( url!.data);
            setState(() {
              _opacity = 0.0;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ThankYou(appointmentModel: widget.booking_data)));
          }
          bool hasFailed = RegExp(".*payment/payment_failed.*").hasMatch(url.toString());
          if(hasFailed){
            // print( url!.data);
            setState(() {
              _opacity = 0.0;
            });
            Navigator.pop(context);
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PatientContact(businessModel: BusinessListModel(), doctorModel: DoctorListModel()),));
          }
          setState(() {

          });
          print(url);
        },

        onLoadStart: (controller, url) async {
          widget.onLoadStart();
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var url = navigationAction.request.url.toString();
          //var uri = Uri.parse(url);

          print("overrideUrl::${url.toString()}");

          bool hasSuccess = RegExp(".*payment_success.*").hasMatch(url);
          bool hasFailed = RegExp(".*payment/payment_failed.*").hasMatch(url);
          bool hasCanceled = RegExp(".*paypalcancel.*").hasMatch(url);

          if (hasSuccess) {
            print('Success Called ');
            return NavigationActionPolicy.ALLOW;
          } else if (hasFailed) {
            print("paymentFailed");
            return NavigationActionPolicy.CANCEL;
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PatientContact(businessModel: BusinessListModel(), doctorModel: DoctorListModel()),));
            return NavigationActionPolicy.ALLOW;
          } else if (hasCanceled) {
            CommonUtils().ShowToast('Payment Is Canceled', context);
            print('Payment Is Canceled');
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PatientContact(businessModel: BusinessListModel(), doctorModel: DoctorListModel()),));
            return NavigationActionPolicy.ALLOW;
          }
          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }
}
