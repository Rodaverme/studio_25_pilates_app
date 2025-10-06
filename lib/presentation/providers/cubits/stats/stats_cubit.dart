import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/domain/entities/stats.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/stats_datasource_impl.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
   final StatsDatasourceImpl datasource;
  StatsCubit(this.datasource) : super(StatsState());

Future<void> loadStats(DateTime from, DateTime to) async {
    emit(state.copyWith(status: StatsStatus.loading));
    try {
      final stats = await datasource.getStats(from, to);
      emit(
        state.copyWith(status: StatsStatus.loaded, stats: stats),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StatsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

}
