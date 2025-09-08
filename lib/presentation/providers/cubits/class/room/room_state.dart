part of 'room_cubit.dart';

enum RoomStatus { initial, loading, loaded, error }

class RoomState extends Equatable {
  final RoomStatus status;
  final List<Room> rooms;
  final String? errorMessage;

  const RoomState({
    this.status = RoomStatus.initial,
    this.rooms = const [],
    this.errorMessage,
  });

  RoomState copyWith({
    RoomStatus? status,
    List<Room>? rooms,
    String? errorMessage,
  }) {
    return RoomState(
      status: status ?? this.status,
      rooms: rooms ?? this.rooms,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, rooms, errorMessage];
}