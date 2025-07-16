import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:walletsolana/bloc/auth/auth_event.dart';
import 'package:walletsolana/bloc/auth/auth_state.dart';
import 'package:walletsolana/services/firestore_service.dart';
import 'package:walletsolana/services/wallet_services.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState> {
  WalletService walletService = WalletService();
  FireStoreService db;
  AuthBloc(this.db):super(InitialStateAuth()){

    on<RegisterWithEmailEvent>((event, emit) async {
        emit(LoadingState());
        try {
          await db.signUp(name: event.name, email: event.email, username: event.username, password: event.password);
          emit(RegisteredState());

          //await walletService.createAndStoreNewWallet();//HER KAYITTA YENİ WALLET OLUŞSUN DİYE

        } on FirebaseAuthException catch (e) {
          emit(LoginErrorState(e.toString()));
          Fluttertoast.showToast(msg: e.message!);
          print(e.toString());
        }
     

    });

    on<LoginWithEmailEvent>((event, emit) async {
      
      emit(LoadingState());
      try {
         
        await db.loginUser(email: event.email, password: event.password);
        emit(LoginedState(email: event.email));
        
      } on FirebaseAuthException catch (e) {
        emit(LoginErrorState(e.toString()));
        print(e.toString());
        Fluttertoast.showToast(msg: e.message!);
        
      }
    });



    on<LoginWithGoogleEvent>((event, emit) async {
      emit(LoadingState());
      try {
        await db.loginWithGoogle();
        emit(LoginedGoogleState());
        
      } on FirebaseAuthException catch (e) {
        emit(LoginErrorState(e.toString()));
        Fluttertoast.showToast(msg: e.message!);
        print(e.toString());
      }
    });



  }

  
}