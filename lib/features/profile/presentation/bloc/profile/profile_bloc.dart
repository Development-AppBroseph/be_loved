import 'dart:async';
import 'dart:io';
import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/domain/usecases/post_number.dart';
import 'package:be_loved/features/home/domain/usecases/put_code.dart';
import 'package:be_loved/features/profile/domain/usecases/connect_vk.dart';
import 'package:be_loved/features/profile/domain/usecases/edit_profile.dart';
import 'package:be_loved/features/profile/domain/usecases/edit_relation.dart';
import 'package:be_loved/features/profile/domain/usecases/notifications.dart';
import 'package:be_loved/features/profile/domain/usecases/send_files_to_mail.dart';
import 'package:be_loved/locator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/get_status_sub.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final EditProfile editProfile;
  final PostNumber postNumber;
  final PutCode putCode;
  final EditRelation editRelation;
  final ConnectVK connectVK;
  final SendFilesToMail sendFilesToMail;
  final GetStatusSub getStatusSub;
  final Notification notification;
  ProfileBloc(this.editProfile, this.postNumber, this.putCode,
      this.editRelation, this.connectVK, this.sendFilesToMail, this.getStatusSub, this.notification)
      : super(ProfileInitialState()) {
    on<EditProfileEvent>(_editProfile);
    on<PostPhoneNumberEvent>(_postPhone);
    on<PutUserCodeEvent>(_putCode);
    on<EditRelationNameEvent>(_editRelationName);
    on<ConnectVKEvent>(_connectVK);
    on<PartingOrSendFilesEvent>(_partingOrSendFiles);
    on<NotificationEvent>(_notificationSend);
  }
  // void _notificationSend(EditProfileEvent event, Emitter<ProfileState> emit) async {}
  void _notificationSend(NotificationEvent event, Emitter<ProfileState> emit) async {
    final data = await notification.call(NoParams());
    ProfileState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        sl<AuthConfig>().user = data;
        return ProfileEditedSuccessState();
      },
    );
     await MySharedPrefs()
        .updateUser(sl<AuthConfig>().user!);
    emit(state);
  }
  String? newPhone;
  void _editProfile(EditProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final data = await editProfile
        .call(EditProfileParams(user: event.user, file: event.avatar));
    ProfileState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        sl<AuthConfig>().user!.me = data;
        return ProfileEditedSuccessState();
      },
    );
    await MySharedPrefs()
        .setUser(sl<AuthConfig>().token!, sl<AuthConfig>().user!);
    emit(state);
  }
  void _postPhone(PostPhoneNumberEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    newPhone = event.phone;
    final data =
        await postNumber.call(PhoneNumberParams(phoneNumber: event.phone));
    ProfileState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        sl<AuthConfig>().user!.me.phoneNumber = newPhone!;
        return ProfileSentCodeState();
      },
    );
    emit(state);
  }

  //VK
  void _connectVK(ConnectVKEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final data = await connectVK.call(ConnectVKParams(code: event.code));
    ProfileState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        print('VK CONNECT: $data');
        if (data.contains('Выйдите')) {
          return ProfileErrorState(
              message: 'Этот аккаунт в VK уже привязан к другому пользователю');
        }
        return ProfileVKConnectedState();
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
        if (newPhone != null) {
          sl<AuthConfig>().user!.me.phoneNumber = newPhone!;
        }
        return ProfileConfirmedSuccessState();
      },
    );
    await MySharedPrefs()
        .setUser(sl<AuthConfig>().token!, sl<AuthConfig>().user!);
    emit(state);
  }

  void _editRelationName(
      EditRelationNameEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final data = await editRelation.call(EditRelationParams(
        relationId: sl<AuthConfig>().user!.relationId!,
        nameRelation: event.name,
        // theme: event.theme == null
        //   ? (sl<AuthConfig>().idx == 0 ? 'light' : 'dark')
        //   : (event.theme == 0 ? 'light' : 'dark')
        date: event.date ?? sl<AuthConfig>().user!.date!));
    ProfileState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        sl<AuthConfig>().user!.name = data;
        return ProfileRelationNameChangedState();
      },
    );
    await MySharedPrefs()
        .setUser(sl<AuthConfig>().token!, sl<AuthConfig>().user!);
    emit(state);
  }

  void _partingOrSendFiles(
      PartingOrSendFilesEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final data = await sendFilesToMail.call(
        SendFilesToMailParams(email: event.email, isParting: event.isParting));
    ProfileState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        return FilesSentState(isParting: event.isParting);
      },
    );
    emit(state);
  }

  ProfileState errorCheck(Failure failure) {
    print('FAIL: $failure');
    if (failure == ConnectionFailure() || failure == NetworkFailure()) {
      return ProfileInternetErrorState();
    } else if (failure is ServerFailure) {
      return ProfileErrorState(
          message: failure.message.length < 100
              ? failure.message
              : 'Ошибка сервера');
    } else {
      return ProfileErrorState(message: 'Повторите попытку');
    }
  }

  
}
