import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/constants/constants.dart';
import 'package:usuario_inri/providers/login_form_validar.dart';
import 'package:usuario_inri/widgets/alert_screen.dart';

import 'package:usuario_inri/widgets/btn_reusable.dart';

class Imputs extends StatefulWidget {
  const Imputs({super.key});

  @override
  State<Imputs> createState() => _ImputsState();
}

class _ImputsState extends State<Imputs> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authUser = BlocProvider.of<AuthBloc>(context);
    final loginFormValidar = Provider.of<LoginFormValidar>(context);

    final screenHeight = MediaQuery.of(context).size.height;

    return Form(
      key: loginFormValidar.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Container(
            width: 372,
            height: screenHeight <= 640 ? 50 : 55,
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 251, 250, 252)
                        .withOpacity(0.9),
                    width: 1.4),
                color: const Color.fromARGB(255, 2, 2, 2),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 38, minHeight: 36),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(188, 126, 124, 250)
                                .withOpacity(0.5),
                            const Color.fromARGB(188, 126, 124, 250),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      child: Icon(
                        Icons.email,
                        color: Colors.white,
                        size: screenHeight <= 380 ? 18 : 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Align(
                  alignment: const Alignment(0.0, 0.5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 277, maxHeight: 24),
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: TextFormField(
                          cursorColor: Colors.white,
                          controller: emailCtrl,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'maria@gmail.com',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenHeight <= 346 ? 10 : 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => loginFormValidar.email,
                          validator: (value) {
                            String pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regExp = RegExp(pattern);

                            return regExp.hasMatch(value ?? '')
                                ? null
                                : 'Ingrese un correo válido';
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: screenHeight <= 641 ? 6 : 10),
          Container(
            width: 372,
            height: screenHeight <= 640 ? 50 : 55,
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 250, 248, 248)
                        .withOpacity(0.9),
                    width: 1.4),
                color: const Color.fromARGB(255, 2, 2, 2),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Container(
                    width: 38,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(188, 126, 124, 250)
                                .withOpacity(0.5),
                            const Color.fromARGB(188, 126, 124, 250),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      child: Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                        size: screenHeight <= 380 ? 18 : 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenHeight <= 347 ? 2 : 4),
                Align(
                  alignment: const Alignment(0.0, 0.5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 272, maxHeight: 24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: TextFormField(
                          controller: passCtrl,
                          cursorColor: Colors.white,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Contraseña',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenHeight <= 346 ? 10 : 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => loginFormValidar.password,
                          validator: (value) {
                            return (value != null && value.length >= 8)
                                ? null
                                : 'La contraseña debe de ser de 8 caracteres';
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          ButtonReusable(
            text: 'Ingresar',
            onPressed: authUser.state.authenticando == true? (){} 
            :() async {

             
              Future.delayed(const Duration(seconds: 2));
             

              final loginOk = await authUser.initLogin(
                  emailCtrl.text.toString(), passCtrl.text.toString());

              if (!context.mounted) return;

              if (loginOk) {
                Navigator.pushReplacementNamed(context, 'loading');
              } else {
                mostrarAlerta(context, 'Login incorrecto',
                    'Revise sus credenciales nuevamente');
              }
            },
          ),
          
          Container(
            constraints: const BoxConstraints(maxHeight: 1, maxWidth: 95),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(188, 126, 124, 250).withAlpha(2),
                    AppConstants.blur.withOpacity(0.5),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
          ),
        ],
      ),
    );
  }
}
