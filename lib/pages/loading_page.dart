
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/pages/notifications_access.dart';
import 'package:usuario_inri/routes/routes.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
            return state.isAllGranted
            ? const NotificationsAccessPage()
            : const GpsAccessPage();           
            
        }, 
        )
    );
  }
}