import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:usuario_inri/blocs/user/auth_bloc.dart';

import 'package:usuario_inri/login-ui/input_decorations.dart';
import 'package:usuario_inri/providers/login_form_validar.dart';
import 'package:usuario_inri/responsive/responsive_ui.dart';

import 'package:usuario_inri/routes/routes.dart';
import 'package:usuario_inri/widgets/alert_screen.dart';
import 'package:usuario_inri/widgets/card_container.dart';
import 'package:connectivity_plus/connectivity_plus.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  @override
  void initState() {   
    
    super.initState();
    
  }



  
  @override
  Widget build(BuildContext context) {


    return  Scaffold(

      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {

        if(snapshot.hasData ) {
          final ConnectivityResult ? result = snapshot.data;

          
          if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi  ){

           return authScaffold(context);
           
          
          }else{
            
            return disconnected();
          }

        } else{


         return disconnected();
         
        }

         
        }
      )
            
      );
    
  }

  Widget loading(){
    return Center(
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),),
    );
  }

  Widget connected(String type){

    return Center(
      child: Text(
        "$type Connected",
        style: TextStyle(
          color: Colors.indigo,
          fontSize: 20,
        ),
      ),
    );
  }

 Widget disconnected(){
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      Image.asset('assets/no_internet.png',
      color: Colors.red,
      height: 100,
      ),
      Container(
        margin: const EdgeInsets.only(top: 20, bottom: 10, left: 30, right: 30),        
        child: const Text(
          "No estas Conectado a Internet",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: const Text(
          "Comprueba tu conección por favor",
           style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17
            )
        ),
      )

    ],
  );
 }
}

Widget authScaffold(BuildContext context){
  
  ResponsiveUtil responsiveUtil = ResponsiveUtil(context);
 
  double responsiveFontSize = responsiveUtil.getResponsiveFontSize(17);
  double responsiveHeight = responsiveUtil.getResponsiveHeight(0.35);


  return AuthBackground(
            child: SingleChildScrollView(
            
            child: Column(
          
              children: [
          
                SizedBox( height: responsiveHeight),
          
                CardContainer(
                  child: Column(
          
                    children:  [
          
                      SizedBox(height: 10,),
          
                      Text('Inicio sesion', style: GoogleFonts.lobster(
                        color: Colors.black,
                        fontSize: responsiveFontSize 
                        )
                      ),
          
                      SizedBox(height: 25,),
          
                      ChangeNotifierProvider(
                        create: (_) => LoginFormValidar(),
                        child:  _LoginForm(),
                        
                        )
                      
                     
                      
                    
                    ],
                  )
                ),
                SizedBox(height: 50),
                
              ],
            ),
            )
          ); 
}


class _LoginForm extends StatefulWidget {

  
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {

  late ResponsiveUtil responsiveUtil;

  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();


  @override
  void didChangeDependencies() {
   
    super.didChangeDependencies();
    // Initialize ResponsiveUtil here
    responsiveUtil = ResponsiveUtil(context);
  }

  @override
  Widget build(BuildContext context) {
    
    final authUser = BlocProvider.of<AuthBloc>(context);

    final loginFormValidar = Provider.of<LoginFormValidar>(context);
    

    return Form(
      key: loginFormValidar.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
     child: Column(
       children: [
         
         TextFormField(
           autocorrect: false,
           keyboardType: TextInputType.emailAddress,
           decoration: InputDecorations.authInputDecoration(
             hintText: 'exequiel7@gmail.com',
             labelText: 'correo electrónico',
             prefixIcon: Icons.alternate_email_rounded,
           ),
           onChanged: (value) => loginFormValidar.email,
             validator:(value){
               String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp  = RegExp(pattern);
                  
                  return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
             },
             controller: emailCtrl,             
           ),
         
         SizedBox(height: 10),
         
         TextFormField(
           autocorrect: false,
           obscureText: true,
           keyboardType: TextInputType.emailAddress,
           decoration: InputDecorations.authInputDecoration(
             hintText: '********',
             labelText: 'contraseña',
             prefixIcon: Icons.lock_outline
           ),
           onChanged: (value) => loginFormValidar.password,
            validator: ( value ) {

                  return ( value != null && value.length >= 8 ) 
                    ? null
                    : 'La contraseña debe de ser de 8 caracteres';                                    
                  
              },
              controller: passCtrl,
         ),
         SizedBox(height: 25),
         MaterialButton(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
           disabledColor: Colors.grey,
           elevation: 0,
           color: Colors.indigo,          
           onPressed: authUser.state.authenticando == true? (){}
           : () async {
             
              final loginOk =await authUser.initLogin(emailCtrl.text.toString(), passCtrl.text.toString());
                           
             
             if(!mounted) return;
             
             if(loginOk && mounted){

              Navigator.pushReplacementNamed(context, 'loading');

             } else{

              mostrarAlerta(context, 'Login incorrecto','Revise sus credenciales nuevamente');
             }

          

          },
           child: Container(
             padding: const EdgeInsets.symmetric(horizontal:  80, vertical: 15),
             child: Text(
               loginFormValidar.isLoading? 'Espere'
               : 'Ingresar',
               style: TextStyle(color: Colors.white, fontSize: responsiveUtil.getResponsiveFontSize(27),
             ),
           )
          
          ),
         ), 
          SizedBox(height: 15),
          ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'privacy'),
                style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(
                        Colors.indigo.withOpacity(0.2))),
                child: Text(
                  'Crear una Cuenta',
                  style: TextStyle(fontSize: responsiveUtil.getResponsiveFontSize(30),
                   fontWeight: FontWeight.bold),
                ))
       ],
     ) 
     );
  } 
}