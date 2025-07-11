

abstract class WalletState {
  
}

class InitialStateWallet extends WalletState {
  
}

class GetPKState extends WalletState {
  final String? pk;

  GetPKState({required this.pk});
  
}

class WalletErrorState extends WalletState {
  final String error;
  WalletErrorState(this.error);
  
}
class WalletConnectedState extends WalletState{
  final String health;

  WalletConnectedState({required this.health});
}
class PhantomWalletConnectedState extends WalletState{

  
}