import 'dart:io';

import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/profile/domain/entities/virtual_joker_entity.dart';
import 'package:be_loved/features/profile/domain/usecases/create_virtual_partner_use_case.dart';
import 'package:be_loved/locator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_virtual_partner_event.dart';
part 'create_virtual_partner_state.dart';

class CreateVirtualPartnerBloc
    extends Bloc<CreateVirtualPartnerEvent, CreateVirtualPartnerState> {
  final CreateVirtualPartnerUseCase useCase;

  CreateVirtualPartnerBloc(this.useCase)
      : super(CreateVirtualPartnerInitial()) {
    on<CreatePartner>(createVirtualPartner);
    on<EditVirtualPartner>(editVirtualPartner);
  }

  Future<void> createVirtualPartner(
      CreatePartner event, Emitter<CreateVirtualPartnerState> emit) async {
    emit(CreateVirtualPartnerLoading());
    try {
      final model = await useCase.createVirtualCall(event.name, event.photo);
      sl<AuthConfig>().user = model;
      emit(
        CreateVirtualPartnerLoaded(model: model),
      );
      await MySharedPrefs()
          .setUser(sl<AuthConfig>().token!, sl<AuthConfig>().user!);
    } catch (e) {
      emit(CreateVirtualPartnerError(errorText: e.toString()));
    }
  }

  Future<void> editVirtualPartner(
      EditVirtualPartner event, Emitter<CreateVirtualPartnerState> emit) async {
    emit(CreateVirtualPartnerLoading());
    try {
      final model = await useCase.editVirtualCall(event.name, event.photo);

      sl<AuthConfig>().user = model;
      emit(
        CreateVirtualPartnerLoaded(model: model),
      );
      await MySharedPrefs()
          .setUser(sl<AuthConfig>().token!, sl<AuthConfig>().user!);
    } catch (e) {
      emit(CreateVirtualPartnerError(errorText: e.toString()));
    }
  }
}
