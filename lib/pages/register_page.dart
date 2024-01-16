import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:usuario_inri/blocs/user/auth_bloc.dart';

import 'package:usuario_inri/login-ui/input_decorations.dart';
import 'package:usuario_inri/providers/login_form_validar.dart';

import 'package:usuario_inri/routes/routes.dart';
import 'package:usuario_inri/widgets/alert_screen.dart';
import 'package:usuario_inri/widgets/card_container.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          
        
        child: Column(

          children: [

            SizedBox( height: 250),

            CardContainer(
              child: Column(

                children:  [

                  SizedBox(height: 10,),

                  Text('Registrarme', style: GoogleFonts.lobster(
                    color: Colors.black, fontSize: 25
                    ),),

                  SizedBox(height: 45,),

                  ChangeNotifierProvider(
                    create: (_) => LoginFormValidar(),
                    child:  _LoginForm(),
                    
                    ),
                
                ],
              )
            ),
            
            
          
          ],
        ),
        )
      )
            
      );
    
  }
}
class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  
  final nameCtrl  = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

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
           keyboardType: TextInputType.text,                     
           decoration: InputDecorations.authInputDecoration(
             hintText: 'exequiel',
             labelText: 'nombre',
             prefixIcon: Icons.person_pin_sharp,      

           ),
           controller: nameCtrl,            
           ),
         
         SizedBox(height: 10),
         
         TextFormField(
           autocorrect: false,
           keyboardType: TextInputType.emailAddress,            
           decoration: InputDecorations.authInputDecoration(
             hintText: 'exequiel7@gmail.com',
             labelText: 'email',
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
             labelText: 'password',
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
         SizedBox(height: 25,),
         
         MaterialButton(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
           disabledColor: Colors.grey,
           elevation: 0,
           color: Colors.indigo,           
           onPressed:  authUser.state.authenticando == true ? (){} 
           : () async {

           
           if (!loginFormValidar.isValidForm()) return;
            loginFormValidar.isLoading = true;
            await Future.delayed(Duration(seconds: 2));
            loginFormValidar.isLoading = false;
            
             final registerOk = await authUser.initRegister(nameCtrl.text.toString(), emailCtrl.text.toString(), passCtrl.text.toString());             
                         

            if(!mounted) return;      
                      
            if(registerOk && mounted){

             Navigator.pushReplacementNamed(context, 'loading');

            }else{
              
             mostrarAlerta(context, 'Registro incorrecto', registerOk.toString() );
            }

            
          
        },
        child: Container(
             padding: const EdgeInsets.symmetric(horizontal:  80, vertical: 15),
             child: Text(
               loginFormValidar.isLoading? 'Espere'
               : 'Registrar',
               style: const TextStyle(color: Colors.white, fontSize: 18),
             ),
           )           
      ),
      SizedBox(height: 15),
            ElevatedButton(onPressed: ()=> Navigator.pushReplacementNamed(context, 'login'),
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.2))
            ),
             
              
              child: const Text('Tengo una Cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            )
      ],
     ) 
    );
  }
}