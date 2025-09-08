import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/class/class_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/credit_card/credit_card_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/payment_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/payment_state.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type2.dart';

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
          final textStyle = Theme.of(context).textTheme;

          final statePay = context.watch<PaymentCubit>().state;

          final currencyFormatter = NumberFormat.currency(
            locale: 'es_CO',
            name: '',

            decimalDigits: 0,
          );

          return Scaffold(
            appBar: AppBar(
              title: Text('Confirmar Reserva', style: textStyle.titleLarge),
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/Logo6.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 👉 Resumen
                              CustomCardsType1(
                                height: 250,
                                width: double.maxFinite,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Columna izquierda
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Resumen de la Clase',
                                            style: textStyle.titleLarge,
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  classe.nombre,
                                                  style: textStyle.titleMedium,
                                                ),
                                                Text(
                                                  classe.instructor,
                                                  style: textStyle.titleMedium,
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Fecha',
                                                  style: textStyle.titleLarge,
                                                ),
                                                Text(
                                                  classe.fechaHora.day
                                                      .toString(),
                                                  style: textStyle.titleMedium,
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Duración',
                                                  style: textStyle.titleLarge,
                                                ),
                                                Text(
                                                  '${classe.duracion.inMinutes} minutos',
                                                  style: textStyle.titleMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      // 👇 Spacer empuja hacia la derecha
                                      Spacer(),

                                      // Columna derecha
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 35,
                                            ),
                                            child: FilledButton(
                                              onPressed: () {},
                                              child: Text(
                                                classe.nivel,
                                                style: textStyle.bodySmall,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 44),
                                          Text(
                                            'Hora',
                                            style: textStyle.titleLarge,
                                          ),
                                          Text(
                                            '09 : 15 - 10:00',
                                            style: textStyle.titleMedium,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Ubicación',
                                            style: textStyle.titleLarge,
                                          ),
                                          Text(
                                            classe.sala,
                                            style: textStyle.titleMedium,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 40),

                              Text(
                                'Método de Pago',
                                style: textStyle.titleLarge,
                              ),
                              const SizedBox(height: 10),
                              const PaymentMethodSelector(),

                              const SizedBox(height: 20),

                              // 👉 Enlaces
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Políticas de Cancelación'),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Términos y condiciones'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 👉 Footer con total y botón
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total a Pagar',
                                  style: textStyle.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  switch (statePay) {
                                    PaymentSelected(method: final m) => switch (m
                                        .type) {
                                      PaymentMethodType.credit => '1 Crédito',
                                      PaymentMethodType.card =>
                                        '\$${currencyFormatter.format(int.parse(classe.price))}',
                                      PaymentMethodType.newCard =>
                                        'Ingrese tarjeta',
                                    },
                                    _ => 'Selecciona un método',
                                  },
                                  style: textStyle.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            FilledButton(
                              onPressed: () {
                                final state = context
                                    .read<PaymentCubit>()
                                    .state;
                                if (state is PaymentSelected) {
                                  // Aquí haces la reserva con el método elegido
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Reserva realizada con ${state.method} ✅',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Selecciona un método de pago',
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  AppColors.cafeNoir,
                                ),
                              ),
                              child: const Text('Reservar'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is ClassError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final creditCards = context
        .watch<CreditCardCubit>()
        .state
        .creditCard; // 👈 ahora es lista

    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
      

        PaymentMethod? selectedMethod;
        if (state is PaymentSelected) {
          selectedMethod = state.method;
        }

        return Column(
          children: [
            // 👉 Créditos de clase
            CustomCardsType2(
              height: 70,
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: RadioListTile<PaymentMethod>(
                  value: const PaymentMethod.credit(),
                  groupValue: selectedMethod,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<PaymentCubit>().selectMethod(value);
                    }
                  },
                  title: const Text('Créditos de clase'),
                  controlAffinity: ListTileControlAffinity.trailing,
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('15 disponibles', style: textStyle.titleMedium),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 👉 Tarjetas guardadas
            if (creditCards.isNotEmpty)
              ListView.builder(
                shrinkWrap:
                    true, // 👈 evita problemas de scroll dentro de Column
                physics: const NeverScrollableScrollPhysics(),
                itemCount: creditCards.length,
                itemBuilder: (context, index) {
                  final card = creditCards[index];
                  return FadeInLeft(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomCardsType2(
                        height: 70,
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: RadioListTile<PaymentMethod>(
                            value: PaymentMethod.card(card),
                            groupValue: selectedMethod,
                            onChanged: (value) {
                              if (value != null) {
                                context.read<PaymentCubit>().selectMethod(value);
                              }
                            },
                            title: Text('${card.brand} •••• ${card.lastFour}'),
                            controlAffinity: ListTileControlAffinity.trailing,
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Text(
                                'Expira el ${card.expMonth}/${card.expYear}',
                                style: textStyle.titleMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 10),

            // 👉 Nueva tarjeta
            GestureDetector(
              onTap: () {
                context.push('/new_card');
                // Acción para agregar nueva tarjeta
              },
              child: CustomCardsType2(
                height: 60,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Center(
                    child: Text(
                      'Agregar Nueva Tarjeta',
                      style: textStyle.titleLarge,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
