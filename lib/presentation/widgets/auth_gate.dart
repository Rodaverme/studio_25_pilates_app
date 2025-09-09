
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/auth/auth_cubit.dart';

import 'package:studio_25_pilates_app/presentation/providers/cubits/plan/plan_cubit.dart';


class AuthGate extends StatelessWidget {
  final Widget child;
  const AuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, next) => prev.isAuthenticated != next.isAuthenticated,
      listener: (context, state) async {
        final plan = context.read<PlanCubit>();
       

        // siempre deja todo limpio primero
       
        plan.getAllPlans();
       
        if (state.isAuthenticated) {
          // ya hay token nuevo en SecureStorage -> pedimos datos frescos
          await plan.getAllPlans();
         
        }
      },
      child: child,
    );
  }
}
