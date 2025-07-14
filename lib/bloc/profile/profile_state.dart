abstract class ProfileState {}

class InitialStateProfile extends ProfileState{}

class SuccessfulState extends ProfileState{
  final String photoUrl;

  SuccessfulState({required this.photoUrl});

  @override
  List<Object?> get props => [photoUrl];
}

class ErrorPhotoState extends ProfileState{
  final String error;
  ErrorPhotoState({required this.error});
  

}

