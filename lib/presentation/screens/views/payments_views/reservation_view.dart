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

/// 🔹 Overlay de carga con fondo de imagen
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  const LoadingOverlay({super.key, required this.child});

  bool _isLoading(BuildContext context) {
    final reservation = context.watch<ReservationCubit>().state.status;
    final plan = context.watch<PlanCubit>().state.status;
    final ocurrence = context.watch<OcurrencesCubit>().state.status;
    return reservation == ReservationStatus.loading ||
        plan == PlanStatus.loading ||
        ocurrence == OcurrenceStatus.loading;
    // ignore: unrelated_type_equality_checks
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _isLoading(context);
    if (!isLoading) return child;
    return Stack(
      fit: StackFit.expand,
      children: [
        // ✅ Fondo con la imagen
        Positioned.fill(
          child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
        ),
        // ✅ Indicador de carga centrado
        const Center(
          child: CircularProgressIndicator(
            color: AppColors.cafeNoir,
            strokeWidth: 3,
          ),
        ),
      ],
    );
  }
}

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

  void _navigate(BuildContext context, String route) {
    ScaffoldMessenger.of(context).clearSnackBars();
    Future.microtask(() => context.go(route));
  }

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

    return MultiBlocListener(
      listeners: [
        // 👂 Escucha reservas de clases
        BlocListener<ReservationCubit, ReservationState>(
          listener: (context, state) {
            switch (state.status) {
              case ReservationStatus.reserved:
                _navigate(context, '/Home/succesPay/$classId');
                break;
              case ReservationStatus.error:
                _navigate(context, '/Home/errorPay/$classId');
                break;
              default:
                break;
            }
          },
        ),

        // 👂 Escucha compras de planes
        BlocListener<PlanCubit, PlanState>(
          listener: (context, state) {
            switch (state.status) {
              case PlanStatus.purchase:
                _navigate(context, '/Home/succesPayPlan/$planId');
                break;
              case PlanStatus.error:
                _navigate(context, '/Home/errorPayPlan/$planId');
                break;
              default:
                break;
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Confirmar Pago', style: textStyle.titleLarge),
        ),
        body: LoadingOverlay(
          child: Stack(
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
                            const SizedBox(height: 10),
                            _buildSummary(
                              textStyle,
                              context,
                              currencyFormatter,
                            ),
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
                                child: const Text('Términos y condiciones'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
        ),
      ),
    );
  }

  Widget _buildSummary(
    TextTheme textStyle,
    BuildContext context,
    NumberFormat currencyFormatter,
  ) {
    switch (type) {
      case ReservationType.classReservation:
        final ocurrenceState = context.watch<OcurrencesCubit>().state;
        if (ocurrenceState.status == OcurrenceStatus.loading) {
          return const SizedBox.shrink();
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
          return const SizedBox.shrink();
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
        PaymentMethodType.credit => '1 Clase',
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
    final fechaFormateada = DateFormat("d MMMM", 'es_ES').format(ocurrence.date);
    final horaInicio = DateFormat("HH:mm").format(ocurrence.startTime);
    final horaFinal = DateFormat("HH:mm").format(ocurrence.endTime);
    final duracion = ocurrence.endTime.difference(ocurrence.startTime);
    final horas = duracion.inHours;
    final minutos = duracion.inMinutes.remainder(60);
    final duracionFormateada =
        "${horas > 0 ? "$horas Horas " : ""}${minutos > 0 ? "$minutos minutos" : ""}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen de la Clase',
          style: textStyle.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        CustomCardsType1(
          height: 230,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: IntrinsicHeight( // 🔹 Igualar altura entre columnas
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// 🧩 Columna Izquierda
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ocurrence.classSession!.nombre,
                          style: textStyle.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.cafeNoir,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          ocurrence.classSession!.instructor,
                          style: textStyle.titleMedium?.copyWith(
                            color: AppColors.cafeNoir.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('Fecha', style: textStyle.titleLarge),
                        Text(fechaFormateada, style: textStyle.titleMedium),
                        const SizedBox(height: 10),
                        Text('Duración', style: textStyle.titleLarge),
                        Text(duracionFormateada, style: textStyle.titleMedium),
                      ],
                    ),
                  ),

                  /// 🧩 Separador horizontal
                  const SizedBox(width: 30),

                  /// 🧩 Columna Derecha
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: FilledButton.tonal(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              
                            ),
                            onPressed: () {},
                            child: Text(
                              ocurrence.classSession!.nivel,
                              style: textStyle.bodySmall?.copyWith(
                                color: AppColors.cafeNoir,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Hora', style: textStyle.titleLarge),
                        Text('$horaInicio - $horaFinal',
                            style: textStyle.titleMedium),
                        const SizedBox(height: 10),
                        Text('Ubicación', style: textStyle.titleLarge),
                        Text(
                          ocurrence.classSession!.sala,
                          style: textStyle.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
                        title: const Text('Plan'),
                        controlAffinity: ListTileControlAffinity.trailing,
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            '$creditsRemaining Clases disponibles',
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
    final isLoading =
        context.watch<ReservationCubit>().state.status ==
            ReservationStatus.loading ||
        context.watch<PlanCubit>().state.status == PlanStatus.loading;

    return FilledButton(
      onPressed: isLoading
          ? null
          : () {
              final paymentState = context.read<PaymentCubit>().state;

              if (paymentState is PaymentSelected) {
                final method = paymentState.method;
                final reservationState = context.read<ReservationCubit>().state;
                final aplanId = reservationState.checkReservation?.planId;

                if (type == ReservationType.classReservation) {
                  if (method.type == PaymentMethodType.credit) {
                    context.read<ReservationCubit>().createReservation(
                      ocurrenceId: int.parse(ocurrenceId!),
                      paymentMethod: "plan",
                      planId: aplanId,
                    );
                  } else if (method.type == PaymentMethodType.card ||
                      method.type == PaymentMethodType.newCard) {
                    final cardId = method.card?.id;
                    if (cardId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selecciona una tarjeta')),
                      );
                      return;
                    }
                    context.read<ReservationCubit>().createReservation(
                      ocurrenceId: int.parse(ocurrenceId!),
                      paymentMethod: method.type.name,
                      cardId: cardId,
                    );
                  } else {
                    context.read<ReservationCubit>().createReservation(
                      ocurrenceId: int.parse(ocurrenceId!),
                      paymentMethod: method.type.name,
                    );
                  }
                } else if (type == ReservationType.planPurchase) {
                  final cardId = method.card?.id;
                  if (cardId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Selecciona una tarjeta')),
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
                  const SnackBar(content: Text('Selecciona un método de pago')),
                );
              }
            },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.almendra),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Confirmar Pago'),
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
    // Función para limpiar etiquetas HTML del texto
    String cleanHtml(String html) {
      final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
      return html.replaceAll(regex, '').trim();
    }

    final descriptionText = cleanHtml(plan.description);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen del plan',
          style: textStyle.titleLarge?.copyWith(
            color: AppColors.cafeNoir,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        /// Card principal
        CustomCardsType1(
          height: 220,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// 👉 Nombre del plan y descripción
                Column(
                  children: [
                    Text(
                      plan.name,
                      style: textStyle.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.cafeNoir,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 60, // 🔹 Límite visual de altura para la descripción
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          descriptionText,
                          textAlign: TextAlign.center,
                          style: textStyle.bodyMedium?.copyWith(
                            color: AppColors.cafeNoir.withOpacity(0.8),
                          ),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ],
                ),

                const Divider(height: 25, thickness: 1),

                /// 👉 Fila con los tres datos principales
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _PlanInfoItem(
                      label: 'Clases',
                      value: '${plan.classLimit}',
                      textStyle: textStyle,
                    ),
                    _PlanInfoItem(
                      label: 'Precio',
                      value:
                          '\$${currencyFormatter.format(int.parse(context.read<PlanCubit>().state.planById!.price))}',
                      textStyle: textStyle,
                    ),
                    _PlanInfoItem(
                      label: 'Invitados',
                      value: '${plan.classLimit}',
                      textStyle: textStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget auxiliar
class _PlanInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final TextTheme textStyle;

  const _PlanInfoItem({
    required this.label,
    required this.value,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: textStyle.titleLarge?.copyWith(
            color: AppColors.cafeNoir,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textStyle.bodyMedium?.copyWith(
            color: AppColors.cafeNoir.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

