import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/class_respository_impl.dart';

part 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassRespositoryImpl repository;

  ClassCubit(this.repository) : super(ClassInitial());

  Future<void> loadClasses(DateTime day) async {
    emit(ClassLoading());
    try {
      final classes = await repository.getClassesByDay(
        day,
      ); // usa getAllClasses+filter
      emit(ClassLoaded(classes, day));
    } catch (e, st) {
      // Log útil en debug
      // ignore: avoid_print
      print('❌ loadClasses error: $e\n$st');
      emit(const ClassError(message: 'Error cargando clases'));
    }
  }

  Future<void> loadClassesById(String id) async {
    emit(ClassLoading());
    try {
      final clase = await repository.getClassesById(id);
      emit(ClassByIdLoaded(clase: clase));
    } catch (e, st) {
      // ignore: avoid_print
      print('❌ loadClassesById error: $e\n$st');
      emit(const ClassError(message: 'Error encontrando la clase'));
    }
  }
}
