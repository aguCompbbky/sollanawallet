import 'dart:typed_data';

abstract class WalletEvent {}

class ShowPKEvent extends WalletEvent {}

class ConnectPhantomEvent extends WalletEvent {
  final String? authToken;
  final Uint8List? publicKey;

  ConnectPhantomEvent({required this.authToken, required this.publicKey});
}

class GetSolBalanceEvent extends WalletEvent {
  GetSolBalanceEvent({required this.publicKey});
  final String publicKey;
}

class TransferSOLEvent extends WalletEvent {
  TransferSOLEvent({required this.reciverPubKey, required this.amount,required this.senderPubKey});
  final String senderPubKey;
  final String reciverPubKey;
  final int amount;
}
