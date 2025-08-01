
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletsolana/bloc/profile/profile_event.dart';
import 'package:walletsolana/bloc/profile/profile_state.dart';



class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
 


  ProfileBloc() : super(UserLoadingState()) {

    on<ShowSubWalletsEvent>((event, emit) {
      //buradada repo layerınındaki fonksiyonları kullanacağız amacımız wallet değişince getPKeventteki pk nın değişmesi
      
    });
  }
}
