import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/domain/entities/payment.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/payment_datasource_impl.dart';

part 'my_payments_state.dart';

class MyPaymentsCubit extends Cubit<MyPaymentsState> {
  final PaymentDatasourceImpl datasource;
  MyPaymentsCubit(this.datasource) : super(MyPaymentsState());

  Future<void> loadpayments() async {
    emit(state.copyWith(status: MyPaymentsStatus.loading));
    try {
      final payments = await datasource.getAllPayments();
      emit(
        state.copyWith(status: MyPaymentsStatus.loaded, myPayments: payments),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MyPaymentsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
