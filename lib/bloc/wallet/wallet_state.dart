abstract class WalletState {
  
}

class InitialStateWallet extends WalletState {
  
}

class GetBalanceState extends WalletState {
  
}

class WalletErrorState extends WalletState {
  final String error;
  WalletErrorState(this.error);
  
}