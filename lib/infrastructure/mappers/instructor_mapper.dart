import 'package:studio_25_pilates_app/domain/entities/instructor.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/instructor/instructor_response.dart';

class InstructorMapper {
  static Instructor instructorApitoEntity(InstructorResponse instructor) => Instructor(
    id: instructor.id ?? 1,
    name: instructor.name ?? '',
    email: instructor.email ?? '',
    bio: instructor.bio ?? ''   , 
    photoUrl: instructor.photoUrl ?? ''

    
  );
}
