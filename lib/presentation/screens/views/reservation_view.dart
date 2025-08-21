import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/class/class_cubit.dart';

class ReservationView extends StatelessWidget {
  final String classId;
  const ReservationView({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassCubit, ClassState>(
      builder: (context, state) {
        if (state is ClassLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ClassByIdLoaded) {
          final PilatesClass classe = state.clase;

          return Scaffold(
            appBar: AppBar(title: Text(classe.nombre)),
            body: const Placeholder(),
          );
        } else if (state is ClassError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}


