import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:studio_25_pilates_app/infrastructure/inputs/credit_card.dart';
import 'package:studio_25_pilates_app/infrastructure/inputs/date_expired.dart';

import 'package:studio_25_pilates_app/infrastructure/inputs/owner_card.dart';
import 'package:studio_25_pilates_app/infrastructure/inputs/security_code.dart';

part 'form_credit_card_state.dart';

class FormsCreditCardCubit extends Cubit<FormsCreditCardState> {
  FormsCreditCardCubit() : super(FormsCreditCardState());

  void onSubmit() {
    emit(
      state.copyWith(
        formStauts: FormStauts.validating,
        formCreditCard: FormCreditCard.dirty(state.formCreditCard.value),
        securityCode: SecurityCode.dirty(state.securityCode.value),
        dateExpired: DateExpired.dirty(state.dateExpired.value),
        ownerCard: OwnerCard.dirty(state.ownerCard.value),
        isValid: Formz.validate([
          state.formCreditCard,
          state.securityCode,
          state.dateExpired,
          state.ownerCard,
        ]),
      ),
    );

    print('Cubit Submit :$state');
  }

  void creditCardChange(String value) {
    final formCreditCard = FormCreditCard.dirty(value);

    emit(
      state.copyWith(
        formCreditCard: formCreditCard,
        isValid: Formz.validate([
          formCreditCard,
          state.securityCode,
          state.dateExpired,
          state.ownerCard,
        ]),
      ),
    );
  }

  void dateExpiredChange(String value) {
    final dateExpired = DateExpired.dirty(value);
    emit(
      state.copyWith(
        dateExpired: dateExpired,
        isValid: Formz.validate([
          dateExpired,
          state.formCreditCard,
          state.securityCode,
          state.ownerCard,
        ]),
      ),
    );
  }

  void securityCodeChange(String value) {
    final securityCode = SecurityCode.dirty(value);
    emit(
      state.copyWith(
        securityCode: securityCode,
        isValid: Formz.validate([
          securityCode,
          state.formCreditCard,
          state.dateExpired,
          state.ownerCard,
        ]),
      ),
    );
  }

  void ownerCardChange(String value) {
    final ownerCard = OwnerCard.dirty(value);
    emit(
      state.copyWith(
        ownerCard: ownerCard,
        isValid: Formz.validate([
          ownerCard,
          state.formCreditCard,
          state.dateExpired,
          state.securityCode,
        ]),
      ),
    );
  }
}
