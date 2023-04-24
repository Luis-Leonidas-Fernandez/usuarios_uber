import 'dart:io';

class Environment {
  static String apiUrl    = Platform.isAndroid ? 'http://10.0.2.2:5000/api' : 'http://localhost:5000/api';
  static String urlSocket = Platform.isAndroid ? 'http://192.168.1.2:5000'     : 'http://localhost:5000';
  static String urlMapBox = 'https://api.mapbox.com/styles/v1/luisleonidas/clawgaqa5000f17n1ck3nlma9/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibHVpc2xlb25pZGFzIiwiYSI6ImNrbnhhcWFiazBpNGoycG40YzVmbng1dW8ifQ.H3n7NYagN5ZjNWTPZxJVAw';
  static String tokenMapBox = 'pk.eyJ1IjoibHVpc2xlb25pZGFzIiwiYSI6ImNrbnhhcWFiazBpNGoycG40YzVmbng1dW8ifQ.H3n7NYagN5ZjNWTPZxJVAw';
  static String idMapBox    = 'mapbox.mapbox-streets-v8';  
  static String mapToken  = 'sk.eyJ1IjoibHVpc2xlb25pZGFzIiwiYSI6ImNsZHozNmNpdTBpMmgzbnBvbXpwazZqejQifQ.BmLWsc31KgWMRxGg6HQH3w';

}