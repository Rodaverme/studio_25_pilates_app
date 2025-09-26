import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';
import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';
import 'package:studio_25_pilates_app/domain/entities/plan.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/ocurrence/ocurrences_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/credit_card/credit_card_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/payment_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/payment/payment_state.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/plan/plan_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/reservation/reservation_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type2.dart';

enum ReservationType { classReservation, planPurchase }

class ReservationView extends StatelessWidget {
  final ReservationType type;
  final String? classId;
  final String? planId;

  const ReservationView({
    super.key,
    this.classId,
    required this.type,
    this.planId,
  }) : assert(
         type == ReservationType.classReservation || planId != null,
         'planId es requerido cuando el tipo es planPurchase',
       );

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final statePay = context.watch<PaymentCubit>().state;
    final creditCards = context.watch<CreditCardCubit>().state.creditCard;
    final currencyFormatter = NumberFormat.currency(
      locale: 'es_CO',
      name: '',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmar Pago', style: textStyle.titleLarge),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 👉 Resumen dinámico
                        _buildSummary(textStyle, context, currencyFormatter),

                        const SizedBox(height: 40),
                        Text('Método de Pago', style: textStyle.titleLarge),
                        const SizedBox(height: 10),
                        PaymentMethodSelector(
                          creditCards: creditCards,
                          type: type,
                        ),

                        const SizedBox(height: 20),

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

                // 👉 Total a pagar + botón de confirmar
                _TotalPay(
                  textStyle: textStyle,
                  statePay: statePay,
                  currencyFormatter: currencyFormatter,
                  type: type,
                  ocurrenceId: classId,
                  planId: planId,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(
    TextTheme textStyle,
    BuildContext context,
    final NumberFormat currencyFormatter,
  ) {
    switch (type) {
      case ReservationType.classReservation:
        final ocurrenceState = context.watch<OcurrencesCubit>().state;
        if (ocurrenceState.status == OcurrenceStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ocurrenceState.ocurrenceById == null) {
          return Text("No se encontró la clase", style: textStyle.bodyLarge);
        }
        return _SumaryClass(
          textStyle: textStyle,
          ocurrence: ocurrenceState.ocurrenceById!,
        );

      case ReservationType.planPurchase:
        final planState = context.watch<PlanCubit>().state;
        if (planState.status == PlanStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (planState.planById == null) {
          return Text("No se encontró el plan", style: textStyle.bodyLarge);
        }
        return _SummaryPlan(
          textStyle: textStyle,
          plan: planState.planById!,
          currencyFormatter: currencyFormatter,
        );
    }
  }
}

class _TotalPay extends StatelessWidget {
  const _TotalPay({
    required this.textStyle,
    required this.statePay,
    required this.currencyFormatter,
    required this.type,
    this.ocurrenceId,
    this.planId,
  });

  final TextTheme textStyle;
  final PaymentState statePay;
  final NumberFormat currencyFormatter;
  final ReservationType type;
  final String? ocurrenceId;
  final String? planId;

  @override
  Widget build(BuildContext context) {
    String total = switch (statePay) {
      PaymentSelected(method: final m) => switch (m.type) {
        PaymentMethodType.credit => '1 Crédito',
        PaymentMethodType.card =>
          type == ReservationType.classReservation
              ? '\$${currencyFormatter.format(int.parse(context.read<OcurrencesCubit>().state.ocurrenceById!.price))}'
              : '\$${currencyFormatter.format(int.parse(context.read<PlanCubit>().state.planById!.price))}',
        PaymentMethodType.newCard => 'Ingrese tarjeta',
        PaymentMethodType.cash =>
          '\$${currencyFormatter.format(int.parse(context.read<OcurrencesCubit>().state.ocurrenceById!.price))}',
      },
      _ => 'Metodo de pago',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
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
                total,
                style: textStyle.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // 👉 Confirmar pago
          ConfirmPayButton(
            type: type,
            ocurrenceId: ocurrenceId,
            planId: planId,
          ),
        ],
      ),
    );
  }
}

class _SumaryClass extends StatelessWidget {
  const _SumaryClass({required this.textStyle, required this.ocurrence});

  final TextTheme textStyle;
  final Ocurrence ocurrence;

  @override
  Widget build(BuildContext context) {
    final fechaFormateada = DateFormat(
      "d MMMM ",
      'es_ES',
    ).format(ocurrence.date);
    final horaInicio = DateFormat("HH:mm").format(ocurrence.startTime);
    final horaFinal = DateFormat("HH:mm").format(ocurrence.endTime);
    final duracion = ocurrence.endTime.difference(ocurrence.startTime);
    final horas = duracion.inHours;
    final minutos = duracion.inMinutes.remainder(60);
    final duracionFormateada =
        "${horas > 0 ? "$horas Hora " : ""}${minutos > 0 ? "$minutos minuntos" : ""}";

    return CustomCardsType1(
      height: 250,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Columna izquierda
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumen de la Clase', style: textStyle.titleLarge),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ocurrence.classSession.nombre,
                        style: textStyle.titleMedium,
                      ),
                      Text(
                        ocurrence.classSession.instructor,
                        style: textStyle.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text('Fecha', style: textStyle.titleLarge),
                      Text(fechaFormateada, style: textStyle.titleMedium),
                      const SizedBox(height: 10),
                      Text('Duración', style: textStyle.titleLarge),
                      Text(duracionFormateada, style: textStyle.titleMedium),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Columna derecha
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: FilledButton(
                    onPressed: () {},
                    child: Text(
                      ocurrence.classSession.nivel,
                      style: textStyle.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 44),
                Text('Hora', style: textStyle.titleLarge),
                Text('$horaInicio - $horaFinal', style: textStyle.titleMedium),
                const SizedBox(height: 10),
                Text('Ubicación', style: textStyle.titleLarge),
                Text(ocurrence.classSession.sala, style: textStyle.titleMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodSelector extends StatelessWidget {
  final ReservationType type;
  final List<CreditCard> creditCards;

  const PaymentMethodSelector({
    super.key,
    required this.creditCards,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, resState) {
        // Manejo rápido de loading / error (ajusta UX según dónde esté este widget)
        if (resState.status == ReservationStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (resState.status == ReservationStatus.error) {
          return Center(child: Text('Error cargando la reserva'));
        }

        final check = resState.checkReservation;
        final inPlan = check?.isInPlan;
        final creditsRemaining = check?.reservationsRemaining ?? 0;

        return BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, payState) {
            PaymentMethod? selectedMethod;
            if (payState is PaymentSelected) {
              selectedMethod = payState.method;
            }

            return Column(
              children: [
                // Créditos de clase (solo si está en plan)
                if (type == ReservationType.classReservation && inPlan!)
                  CustomCardsType2(
                    height: 70,
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: RadioListTile<PaymentMethod>(
                        value: const PaymentMethod.credit(),
                        groupValue: selectedMethod,
                        // si no hay créditos, onChanged = null => deshabilitado
                        onChanged: creditsRemaining > 0
                            ? (value) {
                                if (value != null) {
                                  context.read<PaymentCubit>().selectMethod(
                                    value,
                                  );
                                }
                              }
                            : null,
                        title: const Text('Créditos de clase'),
                        controlAffinity: ListTileControlAffinity.trailing,
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            '$creditsRemaining disponibles',
                            style: textStyle.titleMedium,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // Tarjetas guardadas
                if (creditCards.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
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
                                    context.read<PaymentCubit>().selectMethod(
                                      value,
                                    );
                                  }
                                },
                                title: Text(
                                  '${card.brand} •••• ${card.lastFour}',
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
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

                // Pago en efectivo
                if (type == ReservationType.classReservation)
                  CustomCardsType2(
                    height: 70,
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: RadioListTile<PaymentMethod>(
                        value: const PaymentMethod.cash(),
                        groupValue: selectedMethod,
                        onChanged: (value) {
                          if (value != null) {
                            context.read<PaymentCubit>().selectMethod(value);
                          }
                        },
                        title: const Text('Pago en efectivo'),
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // Nueva tarjeta
                GestureDetector(
                  onTap: () {
                    context.push('/new_card');
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
      },
    );
  }
}

class ConfirmPayButton extends StatelessWidget {
  final ReservationType type;
  final String? ocurrenceId;
  final String? planId;

  const ConfirmPayButton({
    super.key,
    required this.type,
    this.ocurrenceId,
    this.planId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // 👇 Escucha reservas de clases
        BlocListener<ReservationCubit, ReservationState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == ReservationStatus.reserved) {
              context.go('/Home/succesPay');
            } else if (state.status == ReservationStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.errorMessage} ❌')),
              );
            }
          },
        ),

        // 👇 Escucha compras de planes
        BlocListener<PlanCubit, PlanState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == PlanStatus.purchase) {
              context.go('/Home/succesPay');
            } else if (state.status == PlanStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.errorMessage} ❌')),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<ReservationCubit, ReservationState>(
        builder: (context, state) {
          final isLoading =
              state.status == ReservationStatus.loading ||
              context.watch<PlanCubit>().state.status == PlanStatus.loading;

          return FilledButton(
            onPressed: isLoading
                ? null
                : () {
                    final paymentState = context.read<PaymentCubit>().state;

                    if (paymentState is PaymentSelected) {
                      final method = paymentState.method;
                      final reservationState = context
                          .read<ReservationCubit>()
                          .state;
                      final aplanId = reservationState.checkReservation?.planId;

                      if (type == ReservationType.classReservation) {
                        if (method.type == PaymentMethodType.credit) {
                          // 👉 Caso pago con créditos
                          context.read<ReservationCubit>().createReservation(
                            ocurrenceId: int.parse(ocurrenceId!),
                            paymentMethod: "plan", // 👈 forzado
                            planId: aplanId, // 👈 obligatorio
                          );
                        } else if (method.type == PaymentMethodType.card ||
                            method.type == PaymentMethodType.newCard) {
                          // 👉 Caso tarjeta
                          final cardId = method.card?.id;
                          if (cardId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Selecciona una tarjeta ⚠️'),
                              ),
                            );
                            return;
                          }
                          context.read<ReservationCubit>().createReservation(
                            ocurrenceId: int.parse(ocurrenceId!),
                            paymentMethod: method.type.name,
                            cardId: cardId,
                          );
                        } else {
                          // 👉 Caso efectivo
                          context.read<ReservationCubit>().createReservation(
                            ocurrenceId: int.parse(ocurrenceId!),
                            paymentMethod: method.type.name,
                          );
                        }
                      } else if (type == ReservationType.planPurchase) {
                        // 👉 Compra de plan
                        final cardId = method.card?.id;
                        if (cardId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Selecciona una tarjeta ⚠️'),
                            ),
                          );
                          return;
                        }
                        context.read<PlanCubit>().planPurchase(
                          int.parse(planId!),
                          cardId,
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecciona un método de pago ⚠️'),
                        ),
                      );
                    }
                  },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.almendra),
            ),
            child: isLoading
                ? const CircularProgressIndicator(strokeWidth: 2)
                : const Text('Confirmar Pago'),
          );
        },
      ),
    );
  }
}

class _SummaryPlan extends StatelessWidget {
  final TextTheme textStyle;
  final Plan plan;
  final NumberFormat currencyFormatter;

  const _SummaryPlan({
    required this.textStyle,
    required this.plan,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardsType1(
      height: 250,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Columna izquierda con info principal
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumen del Plan', style: textStyle.titleLarge),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.name, style: textStyle.titleMedium),
                      const SizedBox(height: 10),
                      Text('Creditos', style: textStyle.titleLarge),
                      Text(
                        '${plan.classLimit} Créditos',
                        style: textStyle.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text('Precio', style: textStyle.titleLarge),
                      Text(
                        '\$${currencyFormatter.format(int.parse(context.read<PlanCubit>().state.planById!.price))}',
                        style: textStyle.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Columna derecha con descripción
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  plan.description,
                  style: textStyle.bodyMedium,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
