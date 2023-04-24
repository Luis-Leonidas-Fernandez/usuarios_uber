// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


//import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';

class BtnMyTracking extends StatelessWidget { 
  

  const BtnMyTracking({
  Key? key,   
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { 

    //final locationBloc = BlocProvider.of<LocationBloc>(context);
    //final mapBloc = BlocProvider.of<MapBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      
      
        children:  <Widget>[
    
          FloatingActionButton(
            backgroundColor: Colors.indigo,
            child: const Icon(Icons.gps_fixed),
            onPressed: () {

                 data();
              
              }   
                      
          ),          
          const SizedBox(
            height: 90)
        ] 
    );
  }
}

void data() async {
   final item = await rootBundle.loadString("assets/developer.xml");
   final res = XmlDocument.parse(item);
   
   print(res);
   
  }
