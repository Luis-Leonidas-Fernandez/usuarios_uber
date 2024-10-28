import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usuario_inri/constants/constants.dart';



class AppBarConstants {
  AppBarConstants._();

  static AppBar customAppBar(BuildContext context) {

    const nombre = 'Marco';    
    final screenHeight= MediaQuery.of(context).size.height;

    return AppBar(
      backgroundColor: Colors.transparent,     
      elevation: 0,
      leading: Container(),
      title: SafeArea(
        child: Container(
          color: Colors.transparent,
          child: Column(children: [
            Align(
              alignment: const AlignmentDirectional(-1.63, 0.0),
              child: Text(
                'Hola,',
                style: GoogleFonts.lobsterTwo(
                    fontSize: screenHeight <= 640 ? 18 :23,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.secondColor,
                    shadows: <Shadow>[
                      const Shadow(color:Color.fromRGBO(218, 145, 252, 0.843),
                       blurRadius: 20.0)
                    ],
                    letterSpacing: 1.7
                  ),
                
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(-1.56, 0.0),
              child: Text(
                nombre,
                style: TextStyle(
                  fontSize: screenHeight <= 640 ? 18 :20,
                  fontWeight: FontWeight.w700,
                  color: AppConstants.secondColor,
                  shadows: const <Shadow>[
                    Shadow(
                        color: Color.fromRGBO(218, 145, 252, 0.843),
                        blurRadius: 20.0)
                  ],
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ]),
        ),
      ),
      actions: [
        Align(
          alignment: const AlignmentDirectional(-1.0, 0.5),
          child: Row(children: [
            IconButton(
                onPressed: () {},
                icon: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 27,
                    color: AppConstants.secondColor,
                  ),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
                iconAlignment: IconAlignment.start,
                child: Icon(
                  Icons.exit_to_app,
                  size: 29,
                  color: AppConstants.secondColor,
                  
                )),
          ]),
        )
      ],
    );
  }
}
