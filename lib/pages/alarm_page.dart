import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/pages/home_page.dart';
import 'package:flutter/material.dart';

class AlarmAccessPage extends StatelessWidget {
  const AlarmAccessPage({super.key});

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      body: Center(
        child: BlocBuilder<AlarmBloc, AlarmState>(
          builder: (context, state) { 

           final alarmEnabled = state.alarmModel?.isAlarmPermissionGranted?? false;   

           return alarmEnabled == true 
           ? const HomePage()
           : const _AccessAlarmButton(); 
          }
          )
      ),
    );
  }
}

class _AccessAlarmButton extends StatelessWidget {
  const _AccessAlarmButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Text('Habilitar acceso a las Alarmas'),
       MaterialButton(
        color: Colors.black,
        shape: const StadiumBorder(),
        elevation: 0,
        onPressed: (){
          //solicita privilegios de alarma
          final alarmBloc = BlocProvider.of<AlarmBloc>(context);
           
          alarmBloc.askAlarmAccess();
          
        },
        child:  const Text('Solicitar Acceso',
        style:  TextStyle(color: Colors.white ))
        )
      ],
    );
  }
}