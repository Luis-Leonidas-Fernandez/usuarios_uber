// ignore_for_file: avoid_print

import 'package:flutter/material.dart';




class BtnMyTracking extends StatelessWidget { 
  

  const BtnMyTracking({
  Key? key,   
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      
      
        children:  <Widget>[
    
          FloatingActionButton(
            backgroundColor: Colors.indigo,
            child: const Icon(Icons.gps_fixed),
            onPressed: () {

                 
              
              }   
                      
          ),          
          const SizedBox(
            height: 90)
        ] 
    );
  }
}


