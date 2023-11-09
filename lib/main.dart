import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



import 'package:provider/provider.dart';

import 'package:usuario_inri/pages/notifications_access.dart';
import 'package:usuario_inri/routes/routes.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/auth_service.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/service/background_service.dart';


import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/number_symbols_data.dart';

import 'package:intl/number_symbols.dart';
import 'package:usuario_inri/config/namber_symbol.dart';





void main() async{
     
     //proyecto final usuarios inri
     WidgetsFlutterBinding.ensureInitialized();     
     
    await BackgroundService.instance.initializeService();

    Intl.defaultLocale = 'es_ARG';

    initializeDateFormatting('es_ARG', null);
  
    final enUS = numberFormatSymbols['en_US'] as NumberSymbols;

    numberFormatSymbols['es_ARG'] = enUS.copyWith(
      currencySymbol: r'$',
    );
    
    
runApp(

    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc() ),
        BlocProvider(create: (context) => NotificationBloc()),        
        BlocProvider(create: (context) => LocationBloc() ),
        BlocProvider(create: (context) => AddressBloc(addressService: AddressService()) ),        
        BlocProvider(create: (context) => MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context),
       addressBloc: BlocProvider.of<AddressBloc>(context),)),
       
        
      ],

      child: const MyApp() 
      )
  );
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'usuario inri',
        initialRoute: 'login',
        routes: {
          'login'   : (BuildContext context) => const LoginPage(),
          'register': (BuildContext context) => const RegisterPage(),
          'home': (BuildContext context) => const HomePage(),
          'loading': (BuildContext context) => const LoadingPage(),
          'gps'           : (BuildContext context) => const GpsAccessPage(),
          'notification': (BuildContext context) => const NotificationsAccessPage(),
        },
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300]
        ),
      ),
    );
  }
}

