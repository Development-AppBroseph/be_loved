part of 'create_virtual_partner_bloc.dart';

sealed class CreateVirtualPartnerState extends Equatable {
  const CreateVirtualPartnerState();

  @override
  List<Object> get props => [];
}

final class CreateVirtualPartnerInitial extends CreateVirtualPartnerState {}

class CreateVirtualPartnerLoading extends CreateVirtualPartnerState {}

class CreateVirtualPartnerLoaded extends CreateVirtualPartnerState {
  final UserAnswer model;

  const CreateVirtualPartnerLoaded({required this.model});
}

class CreateVirtualPartnerError extends CreateVirtualPartnerState {
  final String errorText;

  const CreateVirtualPartnerError({required this.errorText});
}
