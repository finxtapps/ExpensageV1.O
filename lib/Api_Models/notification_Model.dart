class AppNotification {
  final String title;
  final String body;
  final String time;

  AppNotification({
    required this.title,
    required this.body,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "time": time,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      title: json["title"] ?? "",
      body: json["body"] ?? "",
      time: json["time"] ?? "",
    );
  }
}