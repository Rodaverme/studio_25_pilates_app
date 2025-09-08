part of 'merchants_cubit.dart';

enum MerchansStatus { initial, loading, loaded, error }

 class MerchantsState extends Equatable {
  final MerchansStatus status;
  final Merchants? merchants; 
  final String? errorMessage;
  const MerchantsState({
    this.status = MerchansStatus.initial,
    this.merchants,
    this.errorMessage,
  });


  MerchantsState copyWith({
    MerchansStatus? status,
    Merchants? merchants,
    String? errorMessage,
  }) {
    return MerchantsState(
      status: status ?? this.status,
      merchants: merchants ?? this.merchants,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status,?merchants,?errorMessage];
}


