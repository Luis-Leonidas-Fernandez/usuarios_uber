import 'package:flutter/material.dart';

class ContainerStyles {

  
  static BoxDecoration containerDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: const Color.fromARGB(255, 251, 250, 252),
        width: 1.6,
      ),
      color: const Color.fromARGB(255, 2, 2, 2),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static BoxDecoration containerIconDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      gradient: LinearGradient(
        colors: const [
          Color.fromARGB(188, 126, 124, 250),
          Color.fromARGB(188, 126, 124, 250),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }
}