class AlarmModel {

    bool? isAlarmPermissionGranted;

    AlarmModel({
        this.isAlarmPermissionGranted,
    });

    //factory GpsModel.fromJson(String str) => GpsModel.fromMap(json.decode(str));

    //String toJson() => json.encode(toMap());

    factory AlarmModel.fromJson(Map<String, dynamic> json) => AlarmModel(
        isAlarmPermissionGranted: json["isNotificationPermissionGranted"]?? false,
    );

    Map<String, dynamic> toJson() => {
        "isAlarmPermissionGranted": isAlarmPermissionGranted,
    };
}
