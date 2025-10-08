import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/payments_views/reservation_succes_view.dart';

class ReservationErrorView extends StatelessWidget {
  final String? ocurrenceId;
  final String? planId;

  const ReservationErrorView({super.key, this.ocurrenceId, this.planId});

  bool get isPlan => planId != null;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge;

    // 🔹 Si el error viene de una compra de plan
    if (isPlan) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: FondoPainter())),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Error en la Compra del Plan",
                      style: textStyle?.copyWith(fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromRGBO(228, 214, 188, 1),
                          width: 6,
                        ),
                      ),
                      child: ThickX(size: 150, color: Colors.red.shade700),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Tu pago del plan #$planId no pudo ser procesado.",
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text("Intenta nuevamente.", style: textStyle),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.go('/Home'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.almendra,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Ir al inicio",
                              style: textStyle?.copyWith(
                                color: AppColors.piedra,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // 👇 si quisieras redirigir al flujo de compra del plan
                              context.go('/Home/plan/$planId');
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(150, 55),
                              backgroundColor: AppColors.almendra,
                              foregroundColor: AppColors.piedra,
                              side: BorderSide(color: Colors.red.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Reintentar Compra",
                              style: textStyle?.copyWith(
                                color: AppColors.piedra,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 🔹 Si el error fue en una reserva normal
    return Scaffold(
      body: Stack(
        children: [
          /// Fondo curvado
          Positioned.fill(child: CustomPaint(painter: FondoPainter())),

          /// Contenido
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Error en la Reserva",
                      style: textStyle?.copyWith(fontSize: 25),
                    ),
                  ),

                  const SizedBox(height: 50),
                  Text(
                    "Pago Fallido",
                    style: textStyle?.copyWith(fontSize: 25, color: Colors.red),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromRGBO(228, 214, 188, 1),
                        width: 6,
                      ),
                    ),
                    child: ThickX(size: 150, color: AppColors.cafeNoir),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Tu pago no pudo\nser procesado",
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                  const SizedBox(height: 8),
                  Text("Intenta nuevamente", style: textStyle),

                  const SizedBox(height: 40),

                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.go('/Home'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.almendra,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Ir al inicio",
                            style: textStyle?.copyWith(color: AppColors.piedra),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            context.go(
                              '/Home/class/$ocurrenceId/reservation/$ocurrenceId',
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(150, 55),
                            backgroundColor: AppColors.almendra,
                            foregroundColor: AppColors.piedra,
                            side: BorderSide(color: Colors.red.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Reintentar Pago",
                            style: textStyle?.copyWith(color: AppColors.piedra),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Nuevo widget de ❌
class ThickX extends StatelessWidget {
  final double size;
  final Color color;

  const ThickX({super.key, this.size = 100, this.color = Colors.red});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _XPainter(color));
  }
}

class _XPainter extends CustomPainter {
  final Color color;

  _XPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path1 = Path()
      ..moveTo(size.width * 0.2, size.height * 0.2)
      ..lineTo(size.width * 0.8, size.height * 0.8);

    final path2 = Path()
      ..moveTo(size.width * 0.8, size.height * 0.2)
      ..lineTo(size.width * 0.2, size.height * 0.8);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
