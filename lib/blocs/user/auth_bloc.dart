import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:usuario_inri/models/login.dart';
import 'package:usuario_inri/models/usuario.dart';
import 'package:usuario_inri/service/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {

  AuthService authService;  
  
  AuthBloc({required this.authService}) : super(AuthState(authenticando: false, usuario: null)) {
    
  on<OnAuthenticatingEvent>((event, emit) => emit(state.copyWith(autenticando: true)));  
  on<OnClearUserSessionEvent>((event, emit) => emit(const UserSessionInitialState()));

   on<OnAddUserSessionEvent>((event, emit) { 
    
    emit(state.copyWith(    
      usuario: event.usuario,
      autenticando: true,    
    ));
  });


  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    
      try {

      final response = json.toString();
      final usuario  = loginResponseFromJson(response).usuario;
            
      final authUserState = AuthState(
      usuario: usuario,
      authenticando: state.authenticando      
       );

        
      
      return authUserState;  

      
    } catch (e) {
      return null;
    }
  }
  
  @override
  Map<String, dynamic>? toJson(AuthState state) {
       
      if(state.usuario != null){
      final data = state.usuario!.toJson();      
     
      return data;
     }else{
      return null;
     }     
  }

  Future<bool> initRegister(String nombre, String email, String password) async {

    
    final usuario = await authService.register(nombre, email, password);   
       
    
     if(usuario.uid.isNotEmpty){

    add(OnAddUserSessionEvent(usuario));
  

      return true;
     }else{

      
      return false;
     }    

  }

  Future<bool> initLogin(String email, String password) async {

    
    final usuario = await authService.loginUser(email, password);     
    
     if(usuario.uid.isNotEmpty){

      add(OnAddUserSessionEvent(usuario));   
   
      return true;
     }else{     
      return false;
     }


    

  }

  void deleteUser(){
   add(OnClearUserSessionEvent());
  }


  @override
  Future<void> close() {
    deleteUser();
    return super.close();
  }  
  

}
