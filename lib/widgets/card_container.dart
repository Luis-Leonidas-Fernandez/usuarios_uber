import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  //const CardContainer({Key? key}) : super(key: key);

  final Widget child;

  const CardContainer({
  super.key,
  required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(40),        
      decoration: _createCard(),
      child: child,
    );
  }

  BoxDecoration _createCard() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow( color: Colors.black12,
      blurRadius: 15,
      offset: Offset(0, 5)
  )]
    
  );
}