
import 'package:doct_app/screen/payment/paypalWebViewBody.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../model/MyAppointmentListModel.dart';

class Payment extends StatefulWidget {
  Payment({
    Key? key,
    this.paymentUrl,
    required this.booking_data,
  }) : super(key: key);
  MyAppointmentListModel booking_data;
  final String? paymentUrl;

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  InAppWebViewController? _controller;
  String testingUrl = '';

  @override
  void initState() {
    super.initState();
    print('Your PaymentUrl is :=>  ${widget.paymentUrl} \n');
    WebViewImplementation.NATIVE;
    InAppWebViewOptions(
      cacheEnabled: false,
      clearCache: true,
    );
    /*SchedulerBinding.instance.addPostFrameCallback((_) {
      globles.isLoading = true;
      CallApi().showLoading(context);
    });*/
  }

  Future<bool> _onWillPop() async {
    if (await _controller?.canGoBack() ?? false) {
      _controller?.goBack();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _onWillPop2() async {
    if (await _controller?.canGoBack() ?? false) {
      Navigator.pop(context);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorsInt.colorPrimary1,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light),
          excludeHeaderSemantics: true,
         centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: 60,
          title: Text(
            "Payment",
            style: TextStyle(fontSize: 16, color: ColorsInt.colorWhite),
          )),
      resizeToAvoidBottomInset: false,
      body: Body(
          url: widget.paymentUrl.toString(),
          controller: _controller,

          setWebController: (controller) => setState(() {
                _controller = controller;
              }),
          onLoadStart: () {
            print("start");
          },
          onLoadStop: () {
            print("stop");
          },
          onPaymentSuccess: (url) => _makeGetPaymentData(context, url),
          booking_data: widget.booking_data),

    );
  }

  _makeGetPaymentData(BuildContext context, String url) async {
    print('Success Called ');
    // var a=await ApiCall().sendApiRequest(url: url, context: context, callType: 'get', showLoader: true, visibleLoad: false);
    // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeScreen(position: 0,key: a,)));
    // print(a);
    // print(a['state']);
    // print('PaymenthChecks');
    // print(a);
    //
    //   showToastWidget(
    //     Container(
    //       padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
    //       margin: EdgeInsets.symmetric(horizontal: 50.0),
    //       width: MediaQuery.of(context).size.width,
    //       decoration: ShapeDecoration(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(5.0),
    //         ),
    //         color: ColorData.colorPrimary2,
    //       ),
    //       child: Text(
    //         'Youe Appointment Booked Successfully.\n'
    //             'visit MyAppointment for more detils',maxLines: 5,
    //         style: TextStyle(
    //             color: ColorData.text_light,
    //             fontSize: 18,
    //             fontWeight: dimension.weight7
    //         ),
    //       ),
    //     ),
    //     context: context,
    //     isIgnoring: false,
    //     duration: Duration(milliseconds: 3000),
    //   );
    //   Future.delayed(Duration(milliseconds:3200,),() =>  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeScreen(position: 0,),)));
    //
  }

  _makeGetPaymentDataFinal(
      BuildContext context, String url, String tkVal) async {
    // print("Payment success +++++++++++++++++++" + url);
    // var resultJson2=await CallApi().sendApiRequest(url: url, context: context, callType: 'get',tokenVal: tkVal);
    //
    // print(jsonEncode(resultJson2));
    // await ValueStore().secureWriteData('ORDER_ID_VALUE', resultJson2['data']["order_id"]);
  }
}
