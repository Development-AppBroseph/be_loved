part of 'create_virtual_partner_bloc.dart';

sealed class CreateVirtualPartnerEvent extends Equatable {
  const CreateVirtualPartnerEvent();

  @override
  List<Object> get props => [];
}

class CreatePartner extends CreateVirtualPartnerEvent {
  final String name;
  final File? photo;

  const CreatePartner({required this.name, this.photo});
}

class EditVirtualPartner extends CreateVirtualPartnerEvent {
  final String name;
  final File? photo;

  const EditVirtualPartner({required this.name, this.photo});
}
