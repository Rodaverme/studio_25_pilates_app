import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:studio_25_pilates_app/domain/entities/room.dart';

import 'package:studio_25_pilates_app/infrastructure/repositories/room_repository_impl.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  final RoomRepositoryImpl datasource;

  RoomCubit(this.datasource) : super(const RoomState());

  Future<void> loadRooms() async {
    emit(state.copyWith(status: RoomStatus.loading));
    try {
      final rooms = await datasource.getAllRoom();
      emit(state.copyWith(status: RoomStatus.loaded, rooms: rooms));
    } catch (e) {
      emit(state.copyWith(
        status: RoomStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
