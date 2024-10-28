import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:usuario_inri/animation/animate_page.dart';
import 'package:usuario_inri/constants/constants.dart';
import 'package:usuario_inri/pages/login_page.dart';
import 'package:usuario_inri/providers/login_form_validar.dart';
import 'package:usuario_inri/responsive/responsive_ui.dart';
import 'package:usuario_inri/widgets/imput_register.dart';



class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {


    final height = MediaQuery.of(context).size.height;

    return  Scaffold(
      body: SingleChildScrollView(
        child: Container(
            constraints: const BoxConstraints(maxHeight: 950),
            decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage('assets/background_image.png'),
                    fit: BoxFit.cover,
                    opacity: 0.9),
                gradient: AppConstants.backgroundCard
                ),
            child: Stack(
        
              children: [
        
                Positioned(
                  top: height * 0.6,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    width: double.infinity,
                    height: 600,                 
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      AppConstants.cardColor.withAlpha(2),
                      AppConstants.cardColor,
                    ], begin: Alignment.topCenter, end: Alignment.center)
                    ), 
                    ),
                ),
        
                Positioned(
                  top:  height < 650 ? 0.02  : 28,
                  left: 05.0,
                  right: 05.0,
                  child: ChangeNotifierProvider(
                    create: (_) => LoginFormValidar(),
                    child: const FormRegister()
                    )
                  
                 
                ),
        
                Positioned(
                  top: height * 0.30,
                  left: 10.0,
                  right: 10.0,
                  child: Container(
                   width: 250,
                   height: 140,         
                   decoration: const BoxDecoration(                
                   image: DecorationImage(
                   image: AssetImage('assets/car_b.png'),                
                ),
                
                ),
                  ),
                )
        
        
              ],
            )
           
            ),
      ),
    );
  }
}


class FormRegister extends StatefulWidget {

  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  @override
  Widget build(BuildContext context) {

  final height = MediaQuery.of(context).size.height;
  ResponsiveUtil responsiveUtil = ResponsiveUtil(context);
  double responsiveHeight = responsiveUtil.getResponsiveHeight(0.33);

    return SafeArea(
      child: Center(
    child: SingleChildScrollView(
      child: Container(
        height: 800,
        color: Colors.transparent,
        child: Column(
          children: [
            Text('¡Hola de Nuevo!',
                style: GoogleFonts.lobsterTwo(
                    fontSize: 48,
                    color: AppConstants.textColor,
                    shadows: <Shadow>[
                      const Shadow(color: Colors.black87, blurRadius: 20.0)
                    ])),
            const SizedBox(height: 10),
            ShaderMask(
              shaderCallback: (bounds) {
                return const RadialGradient(
                    center: Alignment.topRight,
                    radius: 4.0,
                    colors: [
                      Color.fromARGB(255, 99, 47, 241),
                      Color.fromARGB(255, 42, 138, 248), 
                    ]).createShader(bounds);
              },
              child: Text('Bienvenido, lo hemos extrañado',
                  style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: AppConstants.textColor,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: responsiveHeight),

            const ImputsRegister(),   

            SizedBox(height: height < 365 ? 1 : 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿Tienes Cuenta?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 221, 203, 252)),
                ),
                const SizedBox(width: 10),
                TextButton(
                    onPressed: () {

                      Future.delayed(const Duration(milliseconds: 300), () {     
                      Navigator.of(context).push(     
                      AnimatePage(child: const LoginPage())    
                      );
                     });    
                      //Navigator.pushNamed(context, 'login');
                    },
                    child: Text(
                      'Inicia sesion aquí',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: AppConstants.yellow),
                    ))
              ],
            )
          ],
        ),
      ),
    ),
  ));
  }
}

