import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:walletsolana/bloc/profile/profile_event.dart';
import 'package:walletsolana/bloc/profile/profile_state.dart';
import 'package:walletsolana/services/pp_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  PpService photo = PpService();

  ProfileBloc(this.photo) : super(InitialStateProfile()) {
    on<SavePPEvent>((event, emit) async {
      print("SavePPEvent triggered");
      emit(InitialStateProfile());
      try {
        print("photoService: $photo");
        final String url = await photo.savePhotos(event.image);
        emit(SuccessfulState(photoUrl: url));
      } catch (e, stackTrace) {
        emit(ErrorPhotoState(error: e.toString()));
        print("STACK: $stackTrace");
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());

      }
    });
  }
}
