import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(const PaymentInitial());

  void selectMethod(PaymentMethod method) {
    emit(PaymentSelected(method));
  }

  void clearSelection() {
    emit(const PaymentInitial());
  }
}
