
class ServiceModel {
  ServiceModel({
    this.id,
    this.busId,
    this.serviceTitle,
    this.servicePrice,
    this.serviceDiscount,
    this.businessApproxtime,
  });

  String? id;
  String? busId;
  String? serviceTitle;
  String? servicePrice;
  String? serviceDiscount;
  String? businessApproxtime;
  bool isChecked = false;
  int discountAmt =0;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json["id"],
    busId: json["bus_id"],
    serviceTitle: json["service_title"],
    servicePrice: json["service_price"],
    serviceDiscount: json["service_discount"],
    businessApproxtime: json["business_approxtime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bus_id": busId,
    "service_title": serviceTitle,
    "service_price": servicePrice,
    "service_discount": serviceDiscount,
    "business_approxtime": businessApproxtime,
  };
}
