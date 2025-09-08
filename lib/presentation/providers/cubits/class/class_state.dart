part of 'class_cubit.dart';

abstract class ClassState extends Equatable {
  const ClassState();

  @override
  List<Object?> get props => [];
}

final class ClassInitial extends ClassState {}

final class ClassLoading extends ClassState {}

class ClassLoaded extends ClassState {
  final List<PilatesClass> classes;
  final DateTime selectedDate;
  const ClassLoaded(this.classes, this.selectedDate);

  @override
  List<Object?> get props => [classes, selectedDate];
}

class ClassByIdLoaded extends ClassState {
  final PilatesClass clase;
  const ClassByIdLoaded({required this.clase});

  @override
  List<Object?> get props => [clase];
}

class ClassError extends ClassState {
  final String message;
  const ClassError({required this.message});

  @override
  List<Object?> get props => [message];
}
