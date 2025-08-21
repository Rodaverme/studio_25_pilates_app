import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';

final List<PilatesClass> listClass = [
  PilatesClass(
    id: '1',
    nombre: 'Enrollamiento de espalda',
    fechaHora: DateTime(2025, 08, 19, 17, 30),
    duracion: Duration(minutes: 30),
    instructor: 'Raul Jimenez',
    cupoMaximo: 10,
    nivel: 'Principiante',
    cuposOcupados: 4,
    descripcion: '',
    price: '15.000',
    sala: 'Salas 5'
  ),
  
];
