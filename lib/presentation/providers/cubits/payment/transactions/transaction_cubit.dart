import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/transactions_datasource_impl.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionsDatasourceImpl datasource;
  TransactionCubit(this.datasource) : super(TransactionState());

  Future<void> dotransaction({
    required String type,
    required String typeId,
    required int amount,
    required String currency,
    required String method,
    required String paymentSourceId,
  }) async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      await datasource.doTransaction(
        type,
        typeId,
        amount,
        currency,
        method,
        paymentSourceId,
      );
        emit(state.copyWith(status: TransactionStatus.loaded));

    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
