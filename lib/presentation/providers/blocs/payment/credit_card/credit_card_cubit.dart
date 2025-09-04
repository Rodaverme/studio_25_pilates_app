import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/credit_card_datasource_impl.dart';

part 'credit_card_state.dart';

class CreditCardCubit extends Cubit<CreditCardState> {
  final CreditCardDatasourceImpl datasource;
  CreditCardCubit(this.datasource) : super(CreditCardState());

  Future<void> loadMyCard() async {
    emit(state.copyWith(status: CreditCardStatus.loading));
    try {
      final myCreditCard = await datasource.getMycreditCard();
      emit(
        state.copyWith(
          status: CreditCardStatus.loaded,
          creditCard: myCreditCard,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreditCardStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
