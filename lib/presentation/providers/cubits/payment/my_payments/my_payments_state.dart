part of 'my_payments_cubit.dart';

enum MyPaymentsStatus { initial, loading, loaded, error }

class MyPaymentsState extends Equatable {
  final MyPaymentsStatus status;
  final List<Payment> myPayments;
  final String? errorMessage;
  const MyPaymentsState({
    this.myPayments = const [],
    this.errorMessage,
    this.status = MyPaymentsStatus.initial,
  });

  MyPaymentsState copyWith({
    MyPaymentsStatus? status,
    List<Payment>? myPayments,
    String? errorMessage,
  }) {
    return MyPaymentsState(
      status: status ?? this.status,
      myPayments: myPayments ?? this.myPayments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, myPayments, ?errorMessage];
}
