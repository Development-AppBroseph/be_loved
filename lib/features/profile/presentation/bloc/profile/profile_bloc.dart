import 'dart:io';
import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/domain/usecases/post_number.dart';
import 'package:be_loved/features/home/domain/usecases/put_code.dart';
import 'package:be_loved/features/profile/domain/usecases/edit_profile.dart';
import 'package:be_loved/features/profile/domain/usecases/edit_relation.dart';
import 'package:be_loved/locator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final EditProfile editProfile;
  final PostNumber postNumber;
  final PutCode putCode;
  final EditRelation editRelation;
  ProfileBloc(this.editProfile, this.postNumber, this.putCode, this.editRelation) : super(ProfileInitialState()) {
    on<EditProfileEvent>(_editProfile);
    on<PostPhoneNumberEvent>(_postPhone);
    on<PutUserCodeEvent>(_putCode);
    on<EditRelationNameEvent>(_editRelationName);
  }
  String? newPhone;
  void _editProfile(EditProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final data = await editProfile.call(EditProfileParams(user: event.user, file: event.avatar));
    ProfileState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        sl<AuthConfig>().user!.me = data;
        return ProfileEditedSuccessState();
      },
    );
    await MySharedPrefs().setUser(sl<AuthConfig>().token!, sl<AuthConfig>().user!);
    emit(state);
  }

  void _postPhone(PostPhoneNumberEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    newPhone = event.phone;
    final data = await postNumber.call(PhoneNumberParams(phoneNumber: event.phone));
    ProfileState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        return ProfileSentCodeState();
      },
    );
    emit(state);
  }


  void _putCode(PutUserCodeEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final data = await putCode.call(CodeParams(code: event.code));
    ProfileState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        print('NEW PHONE SETTING: $newPhone');
        if(newPhone != null){
          sl<AuthConfig>().user!.me.phoneNumber = newPhone!;
        }
        return ProfileConfirmedSuccessState();
      },
    );
    await MySharedPrefs().setUser(sl<AuthConfig>().token!, sl<AuthConfig>().user!);
    emit(state);
  }






  void _editRelationName(EditRelationNameEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final data = await editRelation.call(EditRelationParams(
      relationId: sl<AuthConfig>().user!.relationId!,
      nameRelation: event.name,
      theme: event.theme == null 
        ? (sl<AuthConfig>().idx == 0 ? 'light' : 'dark')
        : (event.theme == 0 ? 'light' : 'dark')
    ));
    ProfileState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        sl<AuthConfig>().user!.name = data;
        return ProfileRelationNameChangedState();
      },
    );
    await MySharedPrefs().setUser(sl<AuthConfig>().token!, sl<AuthConfig>().user!);
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
