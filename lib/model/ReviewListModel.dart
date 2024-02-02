
class ReviewListModel {
  ReviewListModel({
    this.id,
    this.busId,
    this.userId,
    this.reviews,
    this.ratings,
    this.onDate,
    this.userFullname,
    this.userImage,
  });

  String? id;
  String? busId;
  String? userId;
  String? reviews;
  String? ratings;
  DateTime? onDate;
  String? userFullname;
  String? userImage;

  factory ReviewListModel.fromJson(Map<String, dynamic> json) => ReviewListModel(
    id: json["id"],
    busId: json["bus_id"],
    userId: json["user_id"],
    reviews: json["reviews"],
    ratings: json["ratings"],
    onDate: DateTime.parse(json["on_date"]),
    userFullname: json["user_fullname"],
    userImage: json["user_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bus_id": busId,
    "user_id": userId,
    "reviews": reviews,
    "ratings": ratings,
    "on_date": onDate?.toIso8601String(),
    "user_fullname": userFullname,
    "user_image": userImage,
  };
}
