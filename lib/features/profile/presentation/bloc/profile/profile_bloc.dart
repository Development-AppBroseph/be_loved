import 'dart:io';
import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/profile/domain/usecases/edit_profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final EditProfile editProfile;
  ProfileBloc(this.editProfile) : super(ProfileInitialState()) {
    on<EditProfileEvent>(_editProfile);
  }

  void _editProfile(EditProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final data = await editProfile.call(EditProfileParams(user: event.user, file: event.avatar));
    ProfileState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        return ProfileEditedSuccessState();
      },
    );
    emit(state);
  }


  ProfileState errorCheck(Failure failure){
    print('FAIL: $failure');
    if(failure == ConnectionFailure() || failure == NetworkFailure()){
      return ProfileInternetErrorState();
    }else if(failure is ServerFailure){
      return ProfileErrorState(message: failure.message.length < 100 ? failure.message : 'Ошибка сервера');
    }else{
      return ProfileErrorState(message: 'Повторите попытку');
    }
  }
} 
