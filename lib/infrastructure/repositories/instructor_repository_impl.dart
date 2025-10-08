
import 'package:studio_25_pilates_app/domain/entities/instructor.dart';
import 'package:studio_25_pilates_app/domain/repositories/instructor_repository.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/instructor_datasource_impl.dart';

class InstructorRepositoryImpl extends InstructorRepository {
  final InstructorDatasourceImpl datasource;

  InstructorRepositoryImpl({required this.datasource});
  @override
  Future<Instructor> getAInstructorById(String id) {
    return datasource.getAInstructorById(id);
  }

  @override
  Future<List<Instructor>> getAllInstructor() {
    return datasource.getAllInstructor();
  }
}
