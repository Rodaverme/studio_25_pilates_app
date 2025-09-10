import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/reservation_datasource_impl.dart';

part 'reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  final ReservationDatasourceImpl datasource;
  ReservationCubit(this.datasource) : super(ReservationState());

  Future<void> createReservation({
    required int ocurrenceId,
    required String paymentMethod,
    required int cardId,
  }) async {
    emit(state.copyWith(status: ReservationStatus.loading));
    try {
      await datasource.createReservation(ocurrenceId, paymentMethod, cardId);

      emit(state.copyWith(status: ReservationStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          status: ReservationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
