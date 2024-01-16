

class NotificationModel {

    bool? isNotificationPermissionGranted;

    NotificationModel({
        this.isNotificationPermissionGranted,
    });

    //factory GpsModel.fromJson(String str) => GpsModel.fromMap(json.decode(str));

    //String toJson() => json.encode(toMap());

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        isNotificationPermissionGranted: json["isNotificationPermissionGranted"]?? false,
    );

    Map<String, dynamic> toJson() => {
        "isNotificationPermissionGranted": isNotificationPermissionGranted,
    };
}
