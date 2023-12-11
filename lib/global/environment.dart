import 'dart:io';


class Environment {
  //url services
  static String apiUrl    = Platform.isAndroid ? 'https://www.inriservice.com/api' : 'http://http://localhost:3000/api';
  static String urlSocket = Platform.isAndroid ? 'https://www.inriservice.com/'     : 'http://http://localhost:3000';
  
 

}