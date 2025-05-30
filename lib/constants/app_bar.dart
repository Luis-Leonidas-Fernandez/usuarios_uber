import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/constants/constants.dart';
import 'package:usuario_inri/pages/login_page.dart';
import 'package:usuario_inri/service/storage_service.dart';
import 'package:usuario_inri/utils/viaje_util.dart';

class AppBarConstants {
  AppBarConstants._();

  static AppBar customAppBar(BuildContext context, AddressBloc addressBloc, String nombre ) {

    final screenHeight = MediaQuery.of(context).size.height;
    final storage = StorageService.instance;

    String textoOriginal = nombre;
    String name = textoOriginal.length > 7
    ? '${textoOriginal.substring(0, 7)}...'
    : textoOriginal;

    

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: SafeArea(
        // ✅ para evitar superposición con la barra de estado
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0), // 🔝 espacio extra opcional
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola,',
                style: GoogleFonts.lobsterTwo(
                  fontSize: screenHeight <= 640 ? 18 : 23,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.secondColor,
                  shadows: const [
                    Shadow(
                      color: Color.fromRGBO(218, 145, 252, 0.843),
                      blurRadius: 20.0,
                    )
                  ],
                  letterSpacing: 1.7,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: screenHeight <= 640 ? 18 : 20,
                  fontWeight: FontWeight.w700,
                  color: AppConstants.secondColor,
                  shadows: const [
                    Shadow(
                      color: Color.fromRGBO(218, 145, 252, 0.843),
                      blurRadius: 20.0,
                    )
                  ],
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: CircleAvatar(
            backgroundColor: AppConstants.containerColors,
            child: Icon(
              Icons.person,
              size: 26,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            await storage.deleteIdOrder();

            if (!context.mounted) return;
            await ViajeUtils.finalizarViajeYLimpiarTodo(context);

            if (!context.mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const LoginPage(),
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
              (_) => false,
            );
          },
          icon: Icon(
            Icons.exit_to_app,
            size: 26,
            color: AppConstants.secondColor,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
