

class PilatesClass {
  final String id;
  final String nombre;
  final String descripcion;
  final DateTime fechaHora;
  final Duration duracion;
  final String instructor;
  final String bioInstructor;
  final int cupoMaximo;
  final String nivel;
  final int cuposOcupados;
  final String sala;
  final String price;
  

  PilatesClass( {
    required this.id,
    required this.nombre,
    required this.fechaHora,
    required this.duracion,
    required this.instructor,
    required this.cupoMaximo,
    required this.nivel,
    required this.cuposOcupados,
    required this.sala,
    required this.descripcion,
    required this.price,
    required this.bioInstructor
  });
}
