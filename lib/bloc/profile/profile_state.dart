abstract class ProfileState {}

class InitialStateProfile extends ProfileState{}

class SuccessfulPhotoState extends ProfileState{
  final String photoUrl;

  SuccessfulPhotoState({required this.photoUrl});

  @override
  List<Object?> get props => [photoUrl];
}

class ErrorPhotoState extends ProfileState{
  final String error;
  ErrorPhotoState({required this.error});
}



