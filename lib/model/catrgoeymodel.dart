
class CategoryModel {
  CategoryModel({
    this.id,
    this.title,
    this.slug,
    this.parent,
    this.leval,
    this.description,
    this.image,
    this.status,
    this.count,
    this.pCount,
  });

  String? id;
  String? title;
  String? slug;
  String? parent;
  String? leval;
  String? description;
  String? image;
  String? status;
  String? count;
  String? pCount;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    title: json["title"],
    slug: json["slug"],
    parent: json["parent"],
    leval: json["leval"],
    description: json["description"],
    image: json["image"],
    status: json["status"],
    count: json["Count"],
    pCount: json["PCount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "slug": slug,
    "parent": parent,
    "leval": leval,
    "description": description,
    "image": image,
    "status": status,
    "Count": count,
    "PCount": pCount,
  };
}
