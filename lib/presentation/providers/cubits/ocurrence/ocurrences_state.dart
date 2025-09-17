part of 'ocurrences_cubit.dart';

enum OcurrenceStatus { initial, loading, loaded, error }

class OcurrencesState extends Equatable {
  final List<Ocurrence> occurrencesDay;
  final Ocurrence? ocurrenceById;
  final OcurrenceStatus status;
  final List<Ocurrence> ocurrences;
  final String? errorMessage;
  final DateTime? selectedDate;

  const OcurrencesState({
    this.status = OcurrenceStatus.initial,
    this.ocurrences = const [],
    this.errorMessage,
    this.occurrencesDay = const [],
    this.selectedDate,
    this.ocurrenceById
  });

  OcurrencesState copyWith({
    OcurrenceStatus? status,
    List<Ocurrence>? ocurrences,
    String? errorMessage,
    List<Ocurrence>? occurrencesDay,
    DateTime? selectedDate,
    Ocurrence? ocurrenceById
  }) {
    return OcurrencesState(
      status: status ?? this.status,
      ocurrences: ocurrences ?? this.ocurrences,
      errorMessage: errorMessage ?? this.errorMessage,
      occurrencesDay: occurrencesDay ?? this.occurrencesDay,
      selectedDate: selectedDate ?? this.selectedDate,
      ocurrenceById: ocurrenceById ?? this.ocurrenceById
    );
  }

  @override
  List<Object> get props => [status, ocurrences, ?errorMessage, occurrencesDay,?ocurrenceById];
}
