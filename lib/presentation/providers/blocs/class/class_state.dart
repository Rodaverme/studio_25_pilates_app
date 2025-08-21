part of 'class_cubit.dart';

abstract class ClassState extends Equatable {
  const ClassState();

  @override
  List<Object> get props => [];
}

final class ClassInitial extends ClassState {}

final class ClassLoading extends ClassState {}

class ClassLoaded extends ClassState {
  final List<PilatesClass> classes;
  final DateTime selectedDate;
  const ClassLoaded(this.classes, this.selectedDate);
}

class ClassByIdLoaded extends ClassState {
  final PilatesClass clase;
  const ClassByIdLoaded({required this.clase});
}

class ClassError extends ClassState {
  final String message;
  const ClassError({required this.message});
}
