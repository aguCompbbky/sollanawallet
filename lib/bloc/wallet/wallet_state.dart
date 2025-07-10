abstract class WalletState {
  
}

class InitialStateWallet extends WalletState {
  
}

class GetPKState extends WalletState {
  
}

class WalletErrorState extends WalletState {
  final String error;
  WalletErrorState(this.error);
  
}
class WalletConnectedState extends WalletState{
  final String health;

  WalletConnectedState({required this.health});
}