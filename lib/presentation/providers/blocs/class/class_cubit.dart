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
      final classes = await repository.getClassesByDay(day);
      emit(ClassLoaded(classes, day));
    } catch (e) {
      emit(ClassError(message: 'Error cargando clases'));
    }
  }

  Future<void> loadClassesById(String id) async {
    emit(ClassLoading());
    try {
      final classes = await repository.getClassesById(id);
      emit(ClassByIdLoaded(clase: classes));
    } catch (e) {
      emit(ClassError(message: 'Error encontrando la clase'));
    }
  }
}
