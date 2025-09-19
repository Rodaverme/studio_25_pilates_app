import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/ocurrence_datasource_impl.dart';

part 'ocurrences_state.dart';

class OcurrencesCubit extends Cubit<OcurrencesState> {
  final OcurrenceDatasourceImpl datasource;
  OcurrencesCubit(this.datasource) : super(OcurrencesState());

  Future<void> loadOcurrence(DateTime from, DateTime to) async {
    emit(state.copyWith(status: OcurrenceStatus.loading));
    try {
      final ocurrences = await datasource.getAllOcurrence(from, to);
      emit(
        state.copyWith(status: OcurrenceStatus.loaded, ocurrences: ocurrences),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OcurrenceStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadOcurrenceDay(DateTime day) async {
    emit(state.copyWith(status: OcurrenceStatus.loading));
    try {
      final occurrencesDay = await datasource.getAllOcurrenceByDay(day);
      emit(
        state.copyWith(
          status: OcurrenceStatus.loaded,
          occurrencesDay: occurrencesDay,
          selectedDate: day,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OcurrenceStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadOcurrenceById(int id) async {
    emit(state.copyWith(status: OcurrenceStatus.loading));
    try {
      final ocurrence = await datasource.getOcurrencesById(id);
      emit(
        state.copyWith(
          status: OcurrenceStatus.loaded,
          ocurrenceById: ocurrence,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OcurrenceStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadAvailableOcurrence() async {
    emit(state.copyWith(status: OcurrenceStatus.loading));
    try {
      final ocurrences = await datasource.getAvailableOcurrences();
      emit(
        state.copyWith(
          status: OcurrenceStatus.loaded,
          ocurrencesAvalible: ocurrences,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OcurrenceStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
