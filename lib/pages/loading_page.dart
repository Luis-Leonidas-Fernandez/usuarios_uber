
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/pages/notifications_access.dart';
import 'package:usuario_inri/routes/routes.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          
            final gpsEnabled = state.gpsModel?.isGpsEnabled?? false;
            final gpsGranted = state.gpsModel?.isGpsPermissionGranted ?? false;
            
            return gpsEnabled && gpsGranted == true
            ? const NotificationsAccessPage()
            : const GpsAccessPage();           
            
        }, 
        )
    );
  }
}