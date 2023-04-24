import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:usuario_inri/login-ui/input_decorations.dart';
import 'package:usuario_inri/providers/login_form_validar.dart';

import 'package:usuario_inri/routes/routes.dart';
import 'package:usuario_inri/service/auth_service.dart';
import 'package:usuario_inri/widgets/card_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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

                  Text('Inicio sesion', style: TextStyle(fontSize: 20)),

                  SizedBox(height: 25,),

                  ChangeNotifierProvider(
                    create: (_) => LoginFormValidar(),
                    child:  _LoginForm(),
                    
                    )
                  
                 
                  
                
                ],
              )
            ),
            SizedBox(height: 50),
            TextButton(onPressed: ()=> Navigator.pushReplacementNamed(context, 'register'),
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.2))
            ),
             child: Text('Crear una Cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            )
          ],
        ),
        )
      )
            
      );
    
  }
}
class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {

  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
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
         
         SizedBox(height: 30),
         
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
         SizedBox(height: 30,),
         MaterialButton(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
           disabledColor: Colors.grey,
           elevation: 0,
           color: Colors.purple,          
           onPressed: authService.autenticando ? null : () async {
             
             loginOk(context);
             
            

          

          },
           child: Container(
             padding: const EdgeInsets.symmetric(horizontal:  80, vertical: 15),
             child: Text(
               loginFormValidar.isLoading? 'Espere'
               : 'Ingresar',
               style: const TextStyle(color: Colors.white),
             ),
           )
          
         )
       ],
     ) 
     );
  }
  void loginOk(BuildContext context) async {

   

  final authService = Provider.of<AuthService>(context, listen: false); 

  await authService.login(emailCtrl.text.toString(), passCtrl.text.toString());
  
  

  if (!mounted) return;
  Navigator.pushReplacementNamed(context, 'loading');
}
}