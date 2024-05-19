enum NotificationType {
  //TODO add all notification
  appUpdate,
  text
}

class NotificationTypeHelpers {
  static Map<String, NotificationType> jsonMap = {
    "text": NotificationType.text,
    "appUpdate": NotificationType.appUpdate,
  };

  static NotificationType fromJson(String json) {
    final value = jsonMap[json];
    if (value == null) throw "Json not supported";
    return value;
  }
}

extension NotificationTypeX on NotificationType {
  String toJson() {
    return NotificationTypeHelpers.jsonMap.keys.firstWhere(
      (element) => NotificationTypeHelpers.jsonMap[element] == this,
      orElse: () => throw "NotificationType not supported",
    );
  }
}

enum NotificationImportance { low, medium, high }

class NotificationImportanceHelpers {
  static Map<String, NotificationImportance> jsonMap = {
    "l": NotificationImportance.low,
    "m": NotificationImportance.medium,
    "h": NotificationImportance.high,
  };

  static NotificationImportance fromJson(String json) {
    final value = jsonMap[json];
    if (value == null) throw "Json not supported";
    return value;
  }
}

extension NotificationImportanceX on NotificationImportance {
  String toJson() {
    return NotificationImportanceHelpers.jsonMap.keys.firstWhere(
      (element) => NotificationImportanceHelpers.jsonMap[element] == this,
      orElse: () => throw "NotificationType not supported",
    );
  }
}

class Notification {
  final NotificationType type;
  final NotificationImportance importance;
  final dynamic data;

  Notification(
      {required this.type, required this.importance, required this.data});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      type: NotificationTypeHelpers.fromJson(json["type"]),
      importance: NotificationImportanceHelpers.fromJson(json["importance"]),
      data: json["importance"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      'importance': importance.toJson(),
      'data': data,
    };
  }
}
