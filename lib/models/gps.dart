
// Gps Model

class GpsModel {
  
    bool? isGpsEnabled;
    bool? isGpsPermissionGranted;

    GpsModel({
        this.isGpsEnabled,
        this.isGpsPermissionGranted,
    });
   

    factory GpsModel.fromJson(Map<String, dynamic> json) => GpsModel(
        isGpsEnabled: json["isGpsEnabled"]?? false,
        isGpsPermissionGranted: json["isGpsPermissionGranted"]?? false,
    );

    Map<String, dynamic> toJson() => {
        "isGpsEnabled": isGpsEnabled,
        "isGpsPermissionGranted": isGpsPermissionGranted,
    };
}
