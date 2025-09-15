part of 'class_cubit.dart';

enum ClassStatus { initial, loading, loaded, error }

class ClassState extends Equatable {
  final ClassStatus status;
  final List<PilatesClass> allClasses;
  final List<PilatesClass>classes;
  final List<PilatesClass> planClasses;
  final List<PilatesClass> reservedClasses;
  final PilatesClass? clase;
  final DateTime? selectedDate;
  final String? errorMessage;

  const ClassState({
    this.classes = const[],
    this.clase,
    this.status = ClassStatus.initial,
    this.allClasses = const [],
    this.planClasses = const [],
    this.reservedClasses = const [],
    this.selectedDate,
    this.errorMessage,
  });
  ClassState copyWith({
    
    ClassStatus? status,
    PilatesClass? clase,
    List<PilatesClass>? allClasses,
    List<PilatesClass>? reservedClasses,
    List<PilatesClass>? planClasses,
    DateTime? selectedDate,
    String? errorMessage,
  }) {
    return ClassState(
      
      clase: clase ?? this.clase,
      status: status ?? this.status,
      allClasses: allClasses ?? this.allClasses,
      reservedClasses: reservedClasses ?? this.reservedClasses,
      planClasses: planClasses ?? this.planClasses,
      selectedDate: selectedDate ?? this.selectedDate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
   
    status,
    allClasses,
    reservedClasses,
    planClasses,
    selectedDate,
    errorMessage,
  ];
}
