import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/connection/log_out.dart';
import 'package:usuario_inri/responsive/responsive_ui.dart';


class AppConstants {

  AppConstants._();

  static const Color cardColor = Colors.indigo;
  static const Color redColor    =  Color.fromARGB(255, 243, 44, 30);
  static const Color yellowColor =  Color.fromARGB(255, 243, 221, 26);
  static const Color greenColor  =  Color.fromARGB(255, 51, 241, 58);
  static const Color blueColor   =  Color.fromARGB(255, 20, 144, 245);


  static String getFormattedDate() {
    final now = DateTime.now();
    return "${now.day}-${now.month}-${now.year}";
  }

  static String getFormattedTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  static AppBar customAppBar(BuildContext context,  AddressBloc addressBloc, AuthBloc usuarioBloc) {    
    
    final nombre = usuarioBloc.state.usuario!.nombre;
    ResponsiveUtil responsiveUtil = ResponsiveUtil(context);
    double responsiveFontSize = responsiveUtil.getResponsiveFontSize(19);

    return AppBar(
      backgroundColor: AppConstants.cardColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      title: Center(
        child: Text(
          'Bienvenido a Inri $nombre',
          style: GoogleFonts.satisfy(
              color: Colors.white, fontSize: responsiveFontSize),
        ),
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.exit_to_app_rounded,
              color: Colors.white,
            ),
            onPressed: () async {
              LogOutApp.instance.finishApp();

              // emitir un estado limpio              
              addressBloc.add(const OnClearStateEvent());
              Navigator.pushReplacementNamed(context, 'login');
            },
          );
        },
      ),
    );
  }
}
