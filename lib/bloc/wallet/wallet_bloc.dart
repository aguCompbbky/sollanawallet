import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:walletsolana/bloc/wallet/wallet_event.dart';
import 'package:walletsolana/bloc/wallet/wallet_state.dart';
import 'package:walletsolana/services/wallet_services.dart';

class WalletBloc extends Bloc<WalletEvent,WalletState> {

  WalletService walletService = WalletService();
  final user = FirebaseAuth.instance.currentUser;

  WalletBloc():super(InitialStateWallet()){

    on<ShowPKEvent>((event, emit) {
      emit(InitialStateWallet());

      try {
        
        walletService.getAddress(user!.email).toString();
        emit(GetBalanceState());
        
        
      } catch (e) {
        emit(WalletErrorState(e.toString()));
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      }

    });


  }
  
}