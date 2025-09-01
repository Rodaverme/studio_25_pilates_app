import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:studio_25_pilates_app/domain/entities/entities.dart';

import 'package:studio_25_pilates_app/infrastructure/repositories/instructor_repository_impl.dart';

part 'instructor_state.dart';

class InstructorCubit extends Cubit<InstructorState> {
  final InstructorRepositoryImpl datasource;

  InstructorCubit(this.datasource) : super(const InstructorState());

  Future<void> loadInstructors() async {
    emit(state.copyWith(status: InstructorStatus.loading));
    try {
      final instructors = await datasource.getAllInstructor();
      emit(state.copyWith(
        status: InstructorStatus.loaded,
        instructors: instructors,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: InstructorStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
