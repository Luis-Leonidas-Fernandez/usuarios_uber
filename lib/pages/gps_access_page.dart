import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/gps/gps_bloc.dart';



class GpsAccessPage extends StatelessWidget {
  const GpsAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) { 

            final gpsEnabled = state.gpsModel?.isGpsEnabled?? false;

           return gpsEnabled == false
           ? const _EnableGpsMessage()
           : const _AccessButton(); 
          }
          )
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Text('Es necesario el acceso al GPS'),
       MaterialButton(
        color: Colors.black,
        shape: const StadiumBorder(),
        elevation: 0,
        onPressed: (){
          //solicita privilegios de ubicacion
          final gpsBloc = BlocProvider.of<GpsBloc>(context);
          gpsBloc.askGpsAccess();
        },
        child:  const Text('Solicitar Acceso',
        style:  TextStyle(color: Colors.white ))
        )
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage();

  @override
  Widget build(BuildContext context) {
    return const Text('Debe habilitar el Gps',
    style: TextStyle(
      fontSize: 23, fontWeight: FontWeight.w600
    ),
    );
  }
}