
import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration(
    
 {required String hintText,
      required String labelText,
 }
  ){
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green,width: 2)
        ),
        hintText: hintText,
        labelText: labelText

     
       
    );
  }
  
}