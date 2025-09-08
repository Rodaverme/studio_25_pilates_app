part of 'transaction_cubit.dart';

enum TransactionStatus { initial, loading, loaded, error }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final String? errorMessage;
  const TransactionState({
    this.status = TransactionStatus.initial,
    this.errorMessage,
  });

  TransactionState copyWith({TransactionStatus? status, String? errorMessage}) {
    return TransactionState(
      status: status ?? this.status,

      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, ?errorMessage];
}
