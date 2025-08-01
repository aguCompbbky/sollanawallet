

import 'package:firebase_auth/firebase_auth.dart';
import 'package:walletsolana/models/wallet_model.dart';

abstract class WalletState {
final String publicKey;
final user = FirebaseAuth.instance.currentUser;

  WalletState({required this.publicKey});
  
}

class InitialStateWallet extends WalletState {
  InitialStateWallet({required super.publicKey});
  
}

class GetPKState extends WalletState {
  final String? pk;

  GetPKState({required this.pk}) : super(publicKey: '');
  
}

class WalletErrorState extends WalletState {
  final String error;
  WalletErrorState(this.error) : super(publicKey: '');
  
}
class WalletConnectedState extends WalletState{
  final String health;

  WalletConnectedState({required this.health}) : super(publicKey: '');
}
class PhantomWalletConnectedState extends WalletState{
  PhantomWalletConnectedState({required super.publicKey});

  
}
class GetSolBalanceState extends WalletState {
  final String publicKey;
  final int balance;
  GetSolBalanceState({required this.publicKey,required this.balance}) : super(publicKey: publicKey);
}

class TransferState extends WalletState{
  final String reciverPubKey;
  TransferState({required this.reciverPubKey}) : super(publicKey: '');
}

class AddWalletSuccessState extends WalletState {
  AddWalletSuccessState({required super.publicKey});
}

class WalletsLoadedState extends WalletState {
  final List<WalletModel> wallets;

  WalletsLoadedState({required this.wallets, required super.publicKey});
}

class ActiveWalletSwitchedState extends WalletState {
  ActiveWalletSwitchedState({required super.publicKey});
}