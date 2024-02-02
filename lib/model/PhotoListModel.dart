class PhotosListModel {
  PhotosListModel({
    this.id,
    this.busId,
    this.photoTitle,
    this.photoImage,
  });

  String? id;
  String? busId;
  String? photoTitle;
  String? photoImage;

  factory PhotosListModel.fromJson(Map<String, dynamic> json) =>
      PhotosListModel(
        id: json["id"],
        busId: json["bus_id"],
        photoTitle: json["photo_title"],
        photoImage: json["photo_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bus_id": busId,
        "photo_title": photoTitle,
        "photo_image": photoImage,
      };
}
