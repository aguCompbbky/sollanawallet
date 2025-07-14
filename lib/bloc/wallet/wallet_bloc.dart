import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:walletsolana/bloc/wallet/wallet_event.dart';
import 'package:walletsolana/bloc/wallet/wallet_state.dart';
import 'package:walletsolana/services/wallet_services.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletService walletService = WalletService();
  final user = FirebaseAuth.instance.currentUser;

  WalletBloc(this.walletService) : super(InitialStateWallet(publicKey:"")) {


    on<ShowPKEvent>((event, emit) async {

      try {
        String email = FirebaseAuth.instance.currentUser?.email ?? '';
        final pk = await walletService.getAddress(email);
        

        emit(GetPKState(pk: pk));
      } catch (e) {
        emit(WalletErrorState(e.toString()));
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }
    });

    on<ConnectPhantomEvent>((event, emit) async {
      emit(InitialStateWallet(publicKey: event.publicKey.toString()));
      try {
        walletService.setupSolanaClient(isMainnet: false);

        emit(PhantomWalletConnectedState(publicKey: event.publicKey.toString()));

        await walletService.authorizeWallet(event.authToken, event.publicKey);
      } catch (e) {
        emit(WalletErrorState(e.toString()));
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }
    });

    on<GetSolBalanceEvent>((event, emit) async {
     
      emit(InitialStateWallet(publicKey: event.publicKey));
      try {
       
        walletService.requestAirdrop(event.publicKey);
        print("Airdrop için kullanilan adres: ${event.publicKey}");
        await Future.delayed(const Duration(seconds: 2));

        final balanceResult = await walletService.getSolBalance(
          event.publicKey,
        );
        final lamports = balanceResult;
        emit(GetSolBalanceState(publicKey: event.publicKey, balance: lamports));
      } catch (e) {
        emit(WalletErrorState(e.toString()));
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }
    });
  }
}
