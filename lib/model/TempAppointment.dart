import 'MyAppointmentListModel.dart';

class TempAppointment {
  bool? responce;
  MyAppointmentListModel? data;
  String? paymentUrl;

  TempAppointment({this.responce, this.data, this.paymentUrl});

  TempAppointment.fromJson(Map<String, dynamic> json) {
    responce = json['responce'];
    data = json['data'] != null
        ? MyAppointmentListModel.fromJson(json['data'])
        : null;
    paymentUrl = json['payment_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responce'] = this.responce;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['payment_url'] = this.paymentUrl;
    return data;
  }
}
