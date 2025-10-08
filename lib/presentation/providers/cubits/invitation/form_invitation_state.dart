part of 'form_invitation_cubit.dart';


enum FormInvitationStauts { invalid, valid, validating, posting }



class FormsInvitationState extends Equatable {
  final bool isValid;
  final FormInvitationStauts formStauts;
  final NameInvitation username;
  final Email email;
  final IdentificationInvitation identificationInvitation;
  final Phone phone;

  const FormsInvitationState({
    this.formStauts = FormInvitationStauts.invalid,
    this.username = const NameInvitation.pure(),
    this.email = const Email.pure(),
    this.identificationInvitation = const IdentificationInvitation.pure(),
    this.phone = const Phone.pure(),
    this.isValid = false,
  });

  FormsInvitationState copyWith({
    FormInvitationStauts? formStauts,
    bool? isValid,
    NameInvitation? username,
    Email? email,
    IdentificationInvitation? identificationInvitation,
    Phone? phone,
  }) => FormsInvitationState(
    isValid: isValid ?? this.isValid,
    formStauts: formStauts ?? this.formStauts,
    username: username ?? this.username,
    email: email ?? this.email,
    identificationInvitation: identificationInvitation ?? this.identificationInvitation,
    phone: phone ?? this.phone,
  );

  @override
  List<Object?> get props => [
    formStauts,
    username,
    email,
   identificationInvitation,
    isValid,
    phone,
  ];
}