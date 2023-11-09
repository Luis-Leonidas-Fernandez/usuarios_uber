import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthBackground extends StatelessWidget {
  
  
  final Widget child;

  const AuthBackground({
    Key? key,
    required this.child,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      width:  double.infinity,
      height: double.infinity,
      child: Stack(

        children: [

          _PurpleBox(),
          _HederIconLocation(),
          _HederIconText(),
          _HederIcon(),          
          child,

        ],
      ),

    );
  }
}

class _HederIcon extends StatelessWidget {
  const _HederIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
                top: 140,
                left: 110,
                right: 110,
      child: Container(
        alignment: AlignmentDirectional.bottomCenter,       
        height: 80,
        width: 150,
        margin: const EdgeInsets.only(top: 18),           
        child: Image.asset('assets/driver.png'),        
      ),
    );
  }
}

class _HederIconText extends StatelessWidget {


  
  const _HederIconText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

      
    return Positioned(
                top: 75,
                left: 60,
                right: 60,
      child: Container(        
        alignment: AlignmentDirectional.bottomCenter,    
        margin: const EdgeInsets.only(top: 45),           
        child: Text('I N R I   R E M I S E S',
                  style: GoogleFonts.lobster(
                    color: Colors.white, fontSize: 29
                    ),
                    ),
      ),
    );
  }
}

class _HederIconLocation extends StatelessWidget {
  const _HederIconLocation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
                top: 10,
                left: 105,
                right: 105,
      child: Container(
        alignment: AlignmentDirectional.bottomCenter,     
        margin: const EdgeInsets.only(top: 16),           
        child: const Icon(Icons.location_on,
         color:  Colors.white,
         size: 95 ,

         ),        
      ),
    );
  }
}



class _PurpleBox extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
  
  final size = MediaQuery.of(context).size;
  
    return Container(
      width: double.infinity,
      height: size.height * 0.5,      
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(top: 90, left: 30,child: _Bubble(),),
          Positioned(top: -40, left: -30,child: _Bubble(),),
          Positioned(top: -50, right: -20,child: _Bubble(),),
          Positioned(bottom: -50, left: 10,child: _Bubble(),),
          Positioned(bottom: 120, right: 20,child: _Bubble(),), 
      ],  
      ),
    );
  }

  BoxDecoration _purpleBackground() => BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1)
      ] 
      )
  );
}
class _Bubble extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );
  }
}