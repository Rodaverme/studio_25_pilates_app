import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/class_respository_impl.dart';

part 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassRespositoryImpl repository;

  ClassCubit(this.repository) : super(ClassState());

  Future<void> loadAllClasses(DateTime day) async {
    emit(state.copyWith(status: ClassStatus.loading));
    try {
      final classes = await repository.getClassesByDay(day);
      emit(
        state.copyWith(
          status: ClassStatus.loaded,
          allClasses: classes,
          selectedDate: day,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ClassStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> loadClasesById(String id) async {
    emit(state.copyWith(status: ClassStatus.loading));
    try {
      final clase = await repository.getClassesById(id);
      emit(state.copyWith(status: ClassStatus.loaded, clase: clase));
    } catch (e) {
      emit(
        state.copyWith(status: ClassStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> loadPlanClasses(int planId) async {
    emit(state.copyWith(status: ClassStatus.loading));
    try {
      final plan = await repository.getClassesByPlan(planId);
      emit(state.copyWith(status: ClassStatus.loaded, planClasses: plan));
    } catch (e) {
      emit(
        state.copyWith(status: ClassStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
