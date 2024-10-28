import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:usuario_inri/animation/animate_page.dart';
import 'package:usuario_inri/pages/login_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  double boxHeight = 350;
  double boxWidth = 350;
  double boxX = 0;
  double boxY = -2;

  void _expandBox(){
    
    setState(() {
      boxHeight = 300;
      boxWidth = 300;
    });
  }

  void _moveBox(){
    setState(() {
      boxX = 0;
      boxY= 0;

    });
  }
 
 @override 
 void initState() {
   super.initState();
   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
   Future.delayed(const Duration(seconds: 1), () { _moveBox();});   
   Future.delayed(const Duration(seconds: 5), () {     
   Navigator.of(context).push(     
    AnimatePage(child: const LoginPage())    
   );
   });    
 }



 @override
 void dispose() {
   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
   overlays: SystemUiOverlay.values);
   super.dispose();
 }


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [          
          Color.fromARGB(250, 63, 2, 230),          
          Color.fromARGB(251, 61, 3, 223)
        ],
         begin: Alignment.topCenter, end: Alignment.bottomCenter)),
         child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.5),
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.bounceOut,
              alignment: Alignment(boxX, boxY),
              child: Container(
                    width: 350,
                    height: 350,  
                    decoration: const BoxDecoration(              
                   image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                    fit: BoxFit.cover
                    )
                  ),  
              ),
            ),
          ),
         ),
      ),
      
    );
  }
}
