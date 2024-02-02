
class DoctorListModel {
  DoctorListModel({
    this.doctId,
    this.busId,
    this.doctName,
    this.doctDegree,
    this.doctPhone,
    this.doctEmail,
    this.doctSpeciality,
    this.doctPhoto,
    this.doctAbout,
  });

  String? doctId;
  String? busId;
  String? doctName;
  String? doctDegree;
  String? doctPhone;
  String? doctEmail;
  String? doctSpeciality;
  String? doctPhoto;
  String? doctAbout;

  factory DoctorListModel.fromJson(Map<String, dynamic> json) => DoctorListModel(
    doctId: json["doct_id"],
    busId: json["bus_id"],
    doctName: json["doct_name"],
    doctDegree: json["doct_degree"],
    doctPhone: json["doct_phone"],
    doctEmail: json["doct_email"],
    doctSpeciality: json["doct_speciality"],
    doctPhoto: json["doct_photo"],
    doctAbout: json["doct_about"],
  );

  Map<String, dynamic> toJson() => {
    "doct_id": doctId,
    "bus_id": busId,
    "doct_name": doctName,
    "doct_degree": doctDegree,
    "doct_phone": doctPhone,
    "doct_email": doctEmail,
    "doct_speciality": doctSpeciality,
    "doct_photo": doctPhoto,
    "doct_about": doctAbout,
  };
}
