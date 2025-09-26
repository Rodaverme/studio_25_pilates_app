class CheckReservation {
  final int occurrenceId;
  final String classId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int capacity;
  final int reserved;
  final int available;
  final bool isInPlan;
  final bool alreadyReserved;
  final bool canReserve;
  final int creditsRemaining;
  final DateTime planExpiresAt;
  final int reservationsRemaining;
  final int planId;

  CheckReservation({
    required this.occurrenceId,
    required this.classId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.reserved,
    required this.available,
    required this.isInPlan,
    required this.alreadyReserved,
    required this.canReserve,
    required this.creditsRemaining,
    required this.planExpiresAt,
    required this.reservationsRemaining,
    required this.planId

  });
}
