import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:studio_25_pilates_app/domain/entities/entities.dart';

import 'package:studio_25_pilates_app/infrastructure/repositories/level_repository_impl.dart';

part 'level_state.dart';

class LevelCubit extends Cubit<LevelState> {
  final LevelRepositoryImpl datasource;

  LevelCubit(this.datasource) : super(const LevelState());

  Future<void> loadLevels() async {
    emit(state.copyWith(status: LevelStatus.loading));
    try {
      final levels = await datasource.getAllLevels();
      emit(state.copyWith(status: LevelStatus.loaded, levels: levels));
    } catch (e) {
      emit(state.copyWith(
        status: LevelStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
