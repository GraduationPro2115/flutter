class LocalityListModel {
  LocalityListModel({
    this.localityId,
    this.cityId,
    this.countryId,
    this.locality,
    this.localityLat,
    this.localityLon,
    this.status,
    this.countryName,
    this.cityName,
  });

  String? localityId;
  String? cityId;
  String? countryId;
  String? locality;
  String? localityLat;
  String? localityLon;
  String? status;
  String? countryName;
  String? cityName;

  factory LocalityListModel.fromJson(Map<String, dynamic> json) =>
      LocalityListModel(
        localityId: json["locality_id"],
        cityId: json["city_id"],
        countryId: json["country_id"],
        locality: json["locality"],
        localityLat: json["locality_lat"],
        localityLon: json["locality_lon"],
        status: json["status"],
        countryName: json["country_name"],
        cityName: json["city_name"],
      );

  Map<String, dynamic> toJson() => {
        "locality_id": localityId,
        "city_id": cityId,
        "country_id": countryId,
        "locality": locality,
        "locality_lat": localityLat,
        "locality_lon": localityLon,
        "status": status,
        "country_name": countryName,
        "city_name": cityName,
      };
}
