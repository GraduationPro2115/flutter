
class TimeSloteListModel {
  TimeSloteListModel({
    this.slot,
    this.isBooked,
    this.timeToken,
  });

  String? slot;
  bool? isBooked;
  int? timeToken;

  factory TimeSloteListModel.fromJson(Map<String, dynamic> json) => TimeSloteListModel(
    slot: json["slot"],
    isBooked: json["is_booked"],
    timeToken: json["time_token"],
  );

  Map<String, dynamic> toJson() => {
    "slot": slot,
    "is_booked": isBooked,
    "time_token": timeToken,
  };
}
