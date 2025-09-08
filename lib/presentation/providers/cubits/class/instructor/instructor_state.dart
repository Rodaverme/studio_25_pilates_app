part of 'instructor_cubit.dart';

enum InstructorStatus { initial, loading, loaded, error }

class InstructorState extends Equatable {
  final InstructorStatus status;
    final List<Instructor> instructors;
      final String? errorMessage;
        const InstructorState({
            this.status = InstructorStatus.initial,
                this.instructors = const [],
                    this.errorMessage,
                      });

                        InstructorState copyWith({
                            InstructorStatus? status,
                                List<Instructor>? instructors,
                                    String? errorMessage,
                                      }) {
                                          return InstructorState(
                                                status: status ?? this.status,
                                                      instructors: instructors ?? this.instructors,
                                                            errorMessage: errorMessage ?? this.errorMessage,
                                                                );
                                                                  }





                                                                    @override
                                                                      List<Object> get props => [status,instructors,?errorMessage];
                                                                      }

                                                                      