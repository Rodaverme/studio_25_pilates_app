class PilatesClass {
  final String id;
  final String nombre;
  final String descripcion;
  final DateTime date;
  final String instructor;
  final String bioInstructor;
  final int cupoMaximo;
  final String nivel;
  final int cuposOcupados;
  final String sala;
  final String price;
  final String starTime;
  final String endTime;
  final int ocurrenceId;
  final bool isInPlan;

  PilatesClass({
    required this.id,
    required this.nombre,
    required this.date,
    required this.instructor,
    required this.cupoMaximo,
    required this.nivel,
    required this.cuposOcupados,
    required this.sala,
    required this.descripcion,
    required this.price,
    required this.bioInstructor,
    required this.endTime,
    required this.starTime,
    required this.ocurrenceId,
    required this.isInPlan,
  });
}
