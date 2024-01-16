

// ignore_for_file: avoid_print

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usuario_inri/service/storage_service.dart';

class LocationService {

LocationService._internal();

  static final LocationService _instance = LocationService._internal();
  static LocationService get instance => _instance;

   // save position
  final userPosition = [];

  final myPosition = [];
   
   final List<dynamic> address = [];


   void saveOrderUser(order){
   address.add(order);    
  }

  Future<bool> isActiveOrder() async {
    final isActive = await StorageService.instance.getIdOrder();
    
    if(isActive == null ){
    return false;
    }
    return true;
  }

  Future<bool> getIdUserAndToken() async {
    final existToken = await StorageService.instance.getToken();
    final existUser = await StorageService.instance.getId();
    
    if(existToken == null && existUser == null){
    return false;
    }
    return true;
  }

   Future<bool> _isAccessDeviceGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> initFollowingBackground() async {
    
    final isPermisionLocation = await _isAccessDeviceGranted();

    try {

      if (isPermisionLocation) {

        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 5));

        final location = "${position.latitude} ${position.longitude}";
        final res = LatLng(position.latitude, position.longitude);

        myPosition.clear();
        userPosition.clear();

        // Position String
        userPosition.add(location);
        // Position LatLng
        myPosition.add(res);
       
        return true;
      }else{
        return false;
      }

    } catch (e) {
       return throw Exception('oops! $e');
    }
  }

}