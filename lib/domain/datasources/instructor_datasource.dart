import 'package:studio_25_pilates_app/domain/entities/entities.dart';

abstract class InstructorDatasource {
  Future <List<Instructor>> getAllInstructor();
  Future <Instructor> getAInstructorById(String id);
  
}
