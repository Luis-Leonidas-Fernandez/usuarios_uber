import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:usuario_inri/blocs/searchBar/search_bar_bloc.dart';
import 'package:usuario_inri/blocs/tarifario/tarifario_bloc.dart';
import 'package:usuario_inri/pages/alarm_page.dart';

import 'package:usuario_inri/pages/notifications_access.dart';
import 'package:usuario_inri/pages/privacy_page.dart';
import 'package:usuario_inri/providers/login_form_validar.dart';
import 'package:usuario_inri/routes/routes.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/auth_service.dart';
import 'package:usuario_inri/blocs/blocs.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/number_symbols_data.dart';

import 'package:intl/number_symbols.dart';
import 'package:usuario_inri/config/namber_symbol.dart';
import 'package:usuario_inri/service/tarifario_loader.dart';
import 'package:usuario_inri/splash/splash_screen.dart';



void main() async{

   
     //proyecto final usuarios inri
     WidgetsFlutterBinding.ensureInitialized();
    
     await AndroidAlarmManager.initialize();   

     // Cargar tarifas desde assets
     final tarifas = await TarifarioLoader.cargarDesdeAssets();  
     

     HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );     
     
    

    Intl.defaultLocale = 'es_ARG';
    initializeDateFormatting('es_ARG', null);  
    final enUS = numberFormatSymbols['en_US'] as NumberSymbols;
    numberFormatSymbols['es_ARG'] = enUS.copyWith(
      currencySymbol: r'$',
    );

    
    
    
runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginFormValidar()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TarifarioBloc()..add(InitTarifarioEvent(tarifas))),
          BlocProvider(create: (context) => PrecioDistanciaBloc(tarifas: tarifas) ),
          BlocProvider(create: (context) => CronometroBloc() ),
          BlocProvider(create: (context) => AuthBloc(authService: AuthService())),
          BlocProvider(create: (context) => GpsBloc() ),
          BlocProvider(create: (context) => NotificationBloc()),
          BlocProvider(create: (context) => AlarmBloc()),                
          BlocProvider(create: (context) => LocationBloc() ),
          BlocProvider(create: (context) => AddressBloc(addressService: AddressService(),
          authBloc: BlocProvider.of<AuthBloc>(context), cronometroBloc: BlocProvider.of<CronometroBloc>(context),
          precioDistanciaBloc: BlocProvider.of<PrecioDistanciaBloc>(context))),        
          BlocProvider(create: (context) => MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context),
         addressBloc: BlocProvider.of<AddressBloc>(context),)),
         BlocProvider(create: (context) => SearchBarBloc(authBloc: BlocProvider.of<AuthBloc>(context))),
          
        ],
      
        child: const MyApp() 
        ),
    )
  );
   
 }




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'usuario inri',
      initialRoute: 'splash', //aqui poner login
      routes: {
        'login'   : (BuildContext context) => const LoginPage(),
        'privacy' : (BuildContext context) => const PrivacyPage(),
        'register': (BuildContext context) => const RegisterPage(),
        'home'    : (BuildContext context) => const HomePage(),
        'loading' : (BuildContext context) => const LoadingPage(),
        'gps'     : (BuildContext context) => const GpsAccessPage(),
        'notification': (BuildContext context) => const NotificationsAccessPage(),
        'alarm'   : (BuildContext context)     => const AlarmAccessPage(),
        'splash': (BuildContext context) => const SplashScreen(),
        
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300]
      ),

    );
  }

  
} 
