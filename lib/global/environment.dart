import 'dart:io';

class Environment {
  static String apiUrl    = Platform.isAndroid ? 'http://10.0.2.2:5000/api' : 'http://localhost:5000/api';
  static String urlSocket = Platform.isAndroid ? 'http://192.168.1.2:5000'     : 'http://localhost:5000';
  static String urlMapBox = "";
  static String tokenMapBox = "";
  static String idMapBox    = "";  
  static String mapToken  = "";

}