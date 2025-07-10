abstract class AuthEvent {}

class LoginWithEmailEvent extends AuthEvent{
  LoginWithEmailEvent(this.email, this.password);
  final String email;
  final String password;
  
}
class RegisterWithEmailEvent extends AuthEvent{
  RegisterWithEmailEvent(this.email, this.password, this.name, this.username);
  final String email;
  final String password;
  final String name;
  final String username;
  
}

class LoginWithGoogleEvent extends AuthEvent{}

class LogoutEvent extends AuthEvent {}