part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class OnAddUserSessionEvent extends AuthEvent{ 
  
  final Usuario? usuario;
 
 const OnAddUserSessionEvent(this.usuario);
}

class OnAuthenticatingEvent extends AuthEvent{ 
   
 const OnAuthenticatingEvent();
}

class OnClearUserSessionEvent extends AuthEvent{ 
   
 const  OnClearUserSessionEvent();
}

