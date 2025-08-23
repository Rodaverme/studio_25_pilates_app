import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:studio_25_pilates_app/infrastructure/datasource/plan_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/plan_respoitory_impl.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/plan/plan_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards.dart';

class PlanesView extends StatelessWidget {
  const PlanesView({super.key});

  @override
  Widget build(BuildContext context) {
   return BlocProvider(
  create: (_) => PlanCubit(
    PlanRespoitoryImpl(datasource: PlanDatasourceImpl()),
  )..getMyPlan(),
  child: Scaffold(
    appBar: AppBar(title: const Text('Planes'), centerTitle: true),
    body: BlocBuilder<PlanCubit, PlanState>(
      builder: (context, state) {
        if (state is PlanLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PlanError) {
          return Center(child: Text("Error: ${state.message}"));
        }

        if (state is PlanLoaded) {
          final plan = state.plan;
          print('Este es el plan: ${plan.name}');

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _CustomPlanes(
                        textStyle: Theme.of(context).textTheme,
                        current: 7,
                        total: 30,
                        isActive: true,
                        plan: plan.name,
                        price: plan.price,
                        subtitle: "Se renueva el ${plan.name}",
                      ),
                    ),

                    // 🔹 Otros planes que puede elegir
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _CustomPlanes(
                        textStyle: Theme.of(context).textTheme,
                        current: 0,
                        total: 0,
                        isActive: false,
                        plan: plan.name,
                        price: '${plan.price}/mes',
                        subtitle: 'Perfecto para comenzar',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _CustomPlanes(
                        textStyle: Theme.of(context).textTheme,
                        current: 0,
                        total: 0,
                        isActive: false,
                        plan: 'Plan Super',
                        price: '90.000/mes',
                        subtitle: 'El mas popular',
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text("No hay información del plan "));
          },
        ),
      ),
    );
  }
}

class _CustomPlanes extends StatelessWidget {
  const _CustomPlanes({
    required this.textStyle,
    required this.current,
    required this.total,
    required this.plan,
    required this.isActive,

    required this.subtitle,
    required this.price,
  });

  final TextTheme textStyle;
  final int current;
  final int total;
  final String plan;
  final String subtitle;
  final bool isActive;

  final String? price;

  @override
  Widget build(BuildContext context) {
    return CustomCards(
      width: double.maxFinite,
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan, style: textStyle.titleLarge),
                    Text(subtitle, style: textStyle.bodyLarge),
                  ],
                ),

                // Spacer(),
                isActive != false
                    ? Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black,
                        ),
                        child: Center(
                          child: Text(
                            'Activo',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : Text(price!, style: textStyle.titleLarge),
              ],
            ),
            SizedBox(height: 30),
            isActive != false
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Clases utilizadas'),
                          Text("$current/$total"),
                        ],
                      ),

                      LinearProgressIndicator(
                        value: current / total,
                        minHeight: 6,
                        color: Colors.green,
                        backgroundColor: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  )
                : SizedBox(height: 1),
            SizedBox(height: 30),
            Text(' Acceso a clases privadas'),
            Text(' Reserva prioritaria'),
            Text(' Cancelacion Gratiuta'),
            SizedBox(height: 10),
            isActive != false
                ? SizedBox(height: 10)
                : Center(
                    child: Container(
                      height: 60,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          'Selecionar Plan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
