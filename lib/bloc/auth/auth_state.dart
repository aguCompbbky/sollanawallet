abstract class AuthState {}

class InitialStateAuth extends AuthState{}

class LoadingState extends AuthState {}

class LoginedState extends AuthState{
LoginedState({required this.email});
late final String email;

}
class LoginedGoogleState extends AuthState{


}


class RegisteredState extends AuthState{}

class LoginErrorState extends AuthState{
  LoginErrorState(this.error);
  final String error;

}

class LogOutState extends AuthState{}