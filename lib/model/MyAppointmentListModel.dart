class MyAppointmentListModel {
  String? id;
  String? userId;
  String? busId;
  String? doctId;
  String? appointmentDate;
  String? startTime;
  String? timeToken;
  String? status;
  String? appName;
  String? appEmail;
  String? appPhone;
  String? createdAt;
  String? paymentType;
  String? paymentRef;
  String? paymentMode;
  String? paymentAmount;
  String? busTitle;
  String? busSlug;
  String? busEmail;
  String? busDescription;
  String? busGoogleStreet;
  String? busLatitude;
  String? busLongitude;
  String? busContact;
  String? busLogo;
  String? busStatus;
  String? busFee;
  String? busConTime;
  String? cityId;
  String? countryId;
  String? localityId;
  String? isTrusted;
  String? isRecommonded;
  String? countryName;
  String? currency;
  String? doctName;
  String? doctDegree;
  String? isPaid;
  String? takenTime;
  String? totalService;
  String? totalAmount;
  String? doctPhoto;

  MyAppointmentListModel({
    this.id,
    this.userId,
    this.busId,
    this.doctId,
    this.appointmentDate,
    this.startTime,
    this.timeToken,
    this.status,
    this.appName,
    this.appEmail,
    this.appPhone,
    this.createdAt,
    this.paymentType,
    this.paymentRef,
    this.paymentMode,
    this.paymentAmount,
    this.busTitle,
    this.busSlug,
    this.busEmail,
    this.busDescription,
    this.busGoogleStreet,
    this.busLatitude,
    this.busLongitude,
    this.busContact,
    this.busLogo,
    this.busStatus,
    this.busFee,
    this.busConTime,
    this.cityId,
    this.countryId,
    this.localityId,
    this.isTrusted,
    this.isRecommonded,
    this.countryName,
    this.currency,
    this.doctName,
    this.doctDegree,
    this.isPaid,
    this.takenTime,
    this.totalService,
    this.totalAmount,
    this.doctPhoto,
  });

  MyAppointmentListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    busId = json['bus_id'];
    doctId = json['doct_id'];
    appointmentDate = json['appointment_date'];
    startTime = json['start_time'];
    timeToken = json['time_token'];
    status = json['status'];
    appName = json['app_name'];
    appEmail = json['app_email'];
    appPhone = json['app_phone'];
    createdAt = json['created_at'];
    paymentType = json['payment_type'];
    paymentRef = json['payment_ref'];
    paymentMode = json['payment_mode'];
    paymentAmount = json['payment_amount'];
    busTitle = json['bus_title'];
    busSlug = json['bus_slug'];
    busEmail = json['bus_email'];
    busDescription = json['bus_description'];
    busGoogleStreet = json['bus_google_street'];
    busLatitude = json['bus_latitude'];
    busLongitude = json['bus_longitude'];
    busContact = json['bus_contact'];
    busLogo = json['bus_logo'];
    busStatus = json['bus_status'];
    busFee = json['bus_fee'];
    busConTime = json['bus_con_time'];
    cityId = json['city_id'];
    countryId = json['country_id'];
    localityId = json['locality_id'];
    isTrusted = json['is_trusted'];
    isRecommonded = json['is_recommonded'];
    countryName = json['country_name'];
    currency = json['currency'];
    doctName = json['doct_name'];
    doctDegree = json['doct_degree'];
    isPaid = json['is_paid'];
    takenTime = json['taken_time'];
    totalService = json['total_service'];
    totalAmount = json['total_amount'];
    doctPhoto = json['doct_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['bus_id'] = this.busId;
    data['doct_id'] = this.doctId;
    data['appointment_date'] = this.appointmentDate;
    data['start_time'] = this.startTime;
    data['time_token'] = this.timeToken;
    data['status'] = this.status;
    data['app_name'] = this.appName;
    data['app_email'] = this.appEmail;
    data['app_phone'] = this.appPhone;
    data['created_at'] = this.createdAt;
    data['payment_type'] = this.paymentType;
    data['payment_ref'] = this.paymentRef;
    data['payment_mode'] = this.paymentMode;
    data['payment_amount'] = this.paymentAmount;
    data['bus_title'] = this.busTitle;
    data['bus_slug'] = this.busSlug;
    data['bus_email'] = this.busEmail;
    data['bus_description'] = this.busDescription;
    data['bus_google_street'] = this.busGoogleStreet;
    data['bus_latitude'] = this.busLatitude;
    data['bus_longitude'] = this.busLongitude;
    data['bus_contact'] = this.busContact;
    data['bus_logo'] = this.busLogo;
    data['bus_status'] = this.busStatus;
    data['bus_fee'] = this.busFee;
    data['bus_con_time'] = this.busConTime;
    data['city_id'] = this.cityId;
    data['country_id'] = this.countryId;
    data['locality_id'] = this.localityId;
    data['is_trusted'] = this.isTrusted;
    data['is_recommonded'] = this.isRecommonded;
    data['country_name'] = this.countryName;
    data['currency'] = this.currency;
    data['doct_name'] = this.doctName;
    data['doct_degree'] = this.doctDegree;
    data['is_paid'] = this.isPaid;
    data['taken_time'] = this.takenTime;
    data['total_service'] = this.totalService;
    data['total_amount'] = this.totalAmount;
    data['doct_photo'] = this.doctPhoto;
    return data;
  }
}
