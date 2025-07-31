import 'package:firebase_auth/firebase_auth.dart';
import 'package:walletsolana/models/user_model.dart';

abstract class ProfileState {

  final user = FirebaseAuth.instance.currentUser;

}

class InitialStateProfile extends ProfileState{}

class SuccessfulPhotoState extends ProfileState{
  final String photoUrl;

  SuccessfulPhotoState({required this.photoUrl});

  @override
  List<Object?> get props => [photoUrl];
}

class ErrorPhotoState extends ProfileState{
  final String error;
  ErrorPhotoState({required this.error});
}

class WalletChangedState extends ProfileState {
  WalletChangedState(this.newPublicKey, this.newMnemonic);
  final newPublicKey;
  final newMnemonic;
  
}

class WalletsLoading extends ProfileState {}

class WalletsLoaded extends ProfileState {
  // final List<Map<String, dynamic>> wallets;

  // WalletsLoaded(this.wallets);
}

class WalletsError extends ProfileState {
  final String message;

  WalletsError(this.message);
}

class WalletAddedSuccess extends ProfileState {}


class UserLoadingState extends ProfileState {}

class UserLoadedState extends ProfileState {
  final UserModel mainUser;
  final dynamic currUser; // UserModel veya SubUserModel olabilir
  UserLoadedState({required this.mainUser, required this.currUser});
}

class ProfileErrorState extends ProfileState {
  String error;
  ProfileErrorState({required this.error});
  
}


