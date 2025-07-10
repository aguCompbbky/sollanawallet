abstract class AuthState {}

class InitialStateAuth extends AuthState{}

class LoadingState extends AuthState {}

class LoginedState extends AuthState{}

class RegisteredState extends AuthState{}

class LoginErrorState extends AuthState{
  LoginErrorState(this.error);
  final String error;

}

class LogOutState extends AuthState{}