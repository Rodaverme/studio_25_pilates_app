import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/domain/entities/merchants.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/merchants_datasource_impl.dart';

part 'merchants_state.dart';

class MerchantsCubit extends Cubit<MerchantsState> {
  final MerchantsDatasourceImpl datasource;
  MerchantsCubit(this.datasource) : super(MerchantsState());



   Future<void> loadMerchants() async {
    emit(state.copyWith(status: MerchansStatus.loading));
    try {
      final merchants = await datasource.getTokenPermalink();
      emit(
        state.copyWith(
          status: MerchansStatus.loaded,
          merchants: merchants,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MerchansStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
