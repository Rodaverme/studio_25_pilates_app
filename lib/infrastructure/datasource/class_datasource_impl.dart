import 'package:studio_25_pilates_app/domain/clases.dart';
import 'package:studio_25_pilates_app/domain/datasources/class_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';

class ClassDatasourceImpl extends ClassDatasource {
  @override
  Future<List<PilatesClass>> getAllClasses() {
    // TODO: implement getAllClasses
    throw UnimplementedError();
  }

  @override
  Future<List<PilatesClass>> getClassesByDay(DateTime day) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final selectedDate = DateTime(day.year, day.month, day.day);

    final filteredClasses = listClass.where((c) {
      final classDate = DateTime(
        c.fechaHora.year,
        c.fechaHora.month,
        c.fechaHora.day,
      );
      return classDate == selectedDate;
    }).toList();

    return filteredClasses;
  }
}
