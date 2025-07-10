import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:solana/solana.dart';
import 'package:walletsolana/bloc/wallet/wallet_event.dart';
import 'package:walletsolana/bloc/wallet/wallet_state.dart';
import 'package:walletsolana/services/wallet_services.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  
  WalletService walletService = WalletService();
  final user = FirebaseAuth.instance.currentUser;
  late SolanaClient solanaClient;
  
  WalletBloc() : super(InitialStateWallet()) {
    on<ShowPKEvent>((event, emit) {
      emit(InitialStateWallet());

      try {
        walletService.getAddress(user!.email).toString();
        emit(GetPKState());
      } catch (e) {
        emit(WalletErrorState(e.toString()));
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }
    });





    on<ConnectPhantomEvent>((event, emit) async {


      setupSolanaClient(isMainnet: false);

      await authorizeWallet();



      //Solana Mobile Client bir cubit yapısı kullanan bir şey olduğundan onu direkt UI da kullanmalıyım
    });
  }
  void setupSolanaClient({bool isMainnet = false}) {
    solanaClient = SolanaClient(
      rpcUrl: Uri.parse(
        isMainnet
            ? 'https://api.mainnet-beta.solana.com'
            : 'https://api.testnet.solana.com',
      ),
      websocketUrl: Uri.parse(
        isMainnet
            ? 'wss://api.mainnet-beta.solana.com'
            : 'wss://api.testnet.solana.com',
      ),
    );
    print("fonksiyon1");
  }

  String? authToken;
  Uint8List? publicKey;

  Future<void> authorizeWallet() async {
   
    final session = await LocalAssociationScenario.create();
    await session.startActivityForResult(null);

    final client = await session.start();
    final result = await client.authorize(
      identityUri: Uri.parse('http://localhost'),
      identityName: 'Your Dapp Name',
      cluster: 'devnet', // or 'mainnet-beta'
    );
    if (result != null) {
      authToken = result.authToken;
      publicKey = result.publicKey;
      // Save these in your state
    }
    print("object");
    await session.close();
  }
}
