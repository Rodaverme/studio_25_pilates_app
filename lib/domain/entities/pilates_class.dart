class PilatesClass {
  final String id;
  final String nombre;
  final DateTime fechaHora;
  final Duration duracion;
  final String instructor;
  final int cupoMaximo;
  final String nivel;
  final int cuposOcupados;
  

  PilatesClass({
    required this.id,
    required this.nombre,
    required this.fechaHora,
    required this.duracion,
    required this.instructor,
    required this.cupoMaximo,
    required this.nivel,
    required this.cuposOcupados,
  });
}
