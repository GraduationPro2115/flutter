class BusinessListModel {
  String? busId;
  String? userId;
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
  String? currency;
  String? workingDays;
  String? morningTimeStart;
  String? eveningTimeEnd;
  String? userFullname;
  String? avgRating;
  String? totalRating;
  String? reviewCount;
  String? distanceInKm;

  BusinessListModel(
      {this.busId,
      this.userId,
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
      this.currency,
      this.workingDays,
      this.morningTimeStart,
      this.eveningTimeEnd,
      this.userFullname,
      this.avgRating,
      this.totalRating,
      this.reviewCount,
      this.distanceInKm});

  BusinessListModel.fromJson(Map<String, dynamic> json) {
    busId = json['bus_id'];
    userId = json['user_id'];
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
    currency = json['currency'];
    workingDays = json['working_days'];
    morningTimeStart = json['morning_time_start'];
    eveningTimeEnd = json['evening_time_end'];
    userFullname = json['user_fullname'];
    avgRating = json['avg_rating'];
    totalRating = json['total_rating'];
    reviewCount = json['review_count'];
    distanceInKm = json['distance_in_km'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bus_id'] = this.busId;
    data['user_id'] = this.userId;
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
    data['currency'] = this.currency;
    data['working_days'] = this.workingDays;
    data['morning_time_start'] = this.morningTimeStart;
    data['evening_time_end'] = this.eveningTimeEnd;
    data['user_fullname'] = this.userFullname;
    data['avg_rating'] = this.avgRating;
    data['total_rating'] = this.totalRating;
    data['review_count'] = this.reviewCount;
    data['distance_in_km'] = this.distanceInKm;
    return data;
  }
}
