import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:solana/solana.dart';
import 'package:walletsolana/bloc/wallet/wallet_event.dart';
import 'package:walletsolana/bloc/wallet/wallet_state.dart';
import 'package:walletsolana/services/wallet_services.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletService walletService = WalletService();
  

  WalletBloc(this.walletService) : super(InitialStateWallet(publicKey: "")) {
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
        final phantomPublicKey = await walletService.authorizeWallet(event.authToken);

         
        emit(
          PhantomWalletConnectedState(publicKey: phantomPublicKey.toString()),
        );

        
      } catch (e) {
        emit(WalletErrorState(e.toString()));
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }
    });

    on<GetSolBalanceEvent>((event, emit) async {
      
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

    on<TransferSOLEvent>((event, emit) async {
      

      try {
        // Gönderen cüzdanı yükle
        final senderWallet = await walletService.loadWallet();
        if (senderWallet == null) {
          throw Exception("Gönderen cüzdan bulunmadi.");
        }

        print("Transfer sender: ${event.senderPubKey}");
        print("Transfer receiver: ${event.reciverPubKey}");

        // Transfer işlemi
        await walletService.transferSOL(
          sender: senderWallet,
          lamports: event.amount,//1 milyar 
          reciverPubKey: event.reciverPubKey, 
        );

        print(
          "Transfer yapıldı: ${event.amount} lamports: ${event.reciverPubKey}",
        );

        // Yeni bakiyeyi çek
        final updatedBalance = await walletService.getSolBalance(
          senderWallet.publicKey.toBase58(),
        );

        // State güncelle
        emit(TransferState(reciverPubKey: event.reciverPubKey));
        emit(
          GetSolBalanceState(
            publicKey: senderWallet.publicKey.toBase58(),
            balance: updatedBalance,
          ),
        );
        //emit(GetPKState(pk: senderWallet.publicKey.toBase58()));
      } catch (e) {
        emit(WalletErrorState(e.toString()));
        Fluttertoast.showToast(msg: "Transfer hatası: $e");
        print("Transfer hatası: $e");
      }
    });
  }
}
