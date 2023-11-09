import 'package:flutter/material.dart';

class InputDecorations {

static InputDecoration authInputDecoration({
  required String hintText,
  required String labelText,
  IconData? prefixIcon,
}){
    return InputDecoration(

             enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25), 
               borderSide: BorderSide(
                 color: Colors.indigo,
                 width: 2
               ),                 
             ),
             focusedBorder: UnderlineInputBorder(
               borderRadius: BorderRadius.circular(25),
               borderSide: BorderSide(
                 color: Colors.indigo,
                 width: 2 
                 )
             ),
             hintText: hintText,
             labelText: labelText,
             labelStyle: TextStyle(
               color: Colors.blue
             ),
             prefixIcon: prefixIcon != null
             ? Icon(prefixIcon, color: Colors.deepPurple,)
             : null
           );

}

}