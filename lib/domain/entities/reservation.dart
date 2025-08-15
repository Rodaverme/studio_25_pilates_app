class Reservation {
  final String id;
  final String clienteId;
  final String clasePilatesId;
  final DateTime fechaReserva;
  final bool pagada;

  Reservation({
    required this.id,
    required this.clienteId,
    required this.clasePilatesId,
    required this.fechaReserva,
    required this.pagada,
  });
}
