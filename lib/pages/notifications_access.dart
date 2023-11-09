import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/pages/home_page.dart';



class NotificationsAccessPage extends StatelessWidget {
  const NotificationsAccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) { 
           return state.isAllNotificationGranted
           ? const HomePage()
           : const _AccessNotificationButton(); 
          }
          )
      ),
    );
  }
}

class _AccessNotificationButton extends StatelessWidget {
  const _AccessNotificationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Text('Habilitar acceso a las Notificaciones'),
       MaterialButton(
        color: Colors.black,
        shape: const StadiumBorder(),
        elevation: 0,
        onPressed: (){
          //solicita privilegios de ubicacion
          final notificationBloc = BlocProvider.of<NotificationBloc>(context);
           
          notificationBloc.askNotificationAccess();
          
        },
        child:  const Text('Solicitar Acceso',
        style:  TextStyle(color: Colors.white ))
        )
      ],
    );
  }
}

