import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/ocurrence/ocurrences_cubit.dart';

class ReservationSuccessView extends StatelessWidget {
  final String occurrenceId;
  const ReservationSuccessView({super.key, required this.occurrenceId});

  @override
  Widget build(BuildContext context) {
    final textSytle = Theme.of(context).textTheme.titleLarge;

    // Accedemos al estado del cubit
    final ocurrencesState = context.watch<OcurrencesCubit>().state;
    final ocurrences = ocurrencesState.occurrencesDay;

    // Buscar la ocurrencia con el id recibido
    final occurrence = ocurrences.firstWhere(
      (o) => o.id.toString() == occurrenceId,
      orElse: () => throw Exception("No se encontro la clase"),
    );

    final horaInicio = DateFormat("HH:mm").format(occurrence.startTime);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: FondoPainter())),

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
                      "Reserva Realizada",
                      style: textSytle?.copyWith(fontSize: 25),
                    ),
                  ),

                  const SizedBox(height: 50),
                  Text(
                    "Pago Exitoso",
                    style: textSytle?.copyWith(fontSize: 25),
                  ),
                  const SizedBox(height: 20),

                  /// Check circular
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
                    child: ThickCheck(size: 150, color: AppColors.almendra),
                  ),

                  const SizedBox(height: 30),

                  /// Mensaje dinámico
                  Text(
                    "Tu lugar en\n${occurrence.classSession?.nombre}\nestá reservado",
                    textAlign: TextAlign.center,
                    style: textSytle,
                  ),
                  const SizedBox(height: 8),
                  Text("¡Nos vemos pronto!", style: textSytle),

                  const SizedBox(height: 40),

                  /// Detalle clase dinámico
                  Column(
                    children: [
                      Text(occurrence.classSession!.nombre, style: textSytle),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            horaInicio, // o formatea el DateTime
                            style: const TextStyle(color: Colors.brown),
                          ),
                          Text(
                            "${occurrence.date.day}/${occurrence.date.month}",
                            style: const TextStyle(color: Colors.brown),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// Botones
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
                            style: textSytle?.copyWith(color: AppColors.piedra),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                     
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

/// Painter para el fondo curvado
class FondoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          Color.fromRGBO(228, 214, 188, 1) // Beige
      ..style = PaintingStyle.fill;

    // ---- Forma superior (diagonal curva) ----
    final pathTop = Path();
    pathTop.moveTo(0, 0);
    pathTop.lineTo(0, size.height * 0.40);
    pathTop.quadraticBezierTo(
      size.width * 1,
      size.height * 0.21, // punto de control
      size.width,
      size.height * 0.26, // punto final
    );
    pathTop.lineTo(size.width, 0);
    pathTop.close();

    // ---- Forma inferior (diagonal curva) ----
    final pathBottom = Path();
    pathBottom.moveTo(size.width, size.height);
    pathBottom.lineTo(size.width, size.height * 0.85);
    pathBottom.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.99, // punto de control
      0,
      size.height * 0.97, // punto final
    );
    pathBottom.lineTo(0, size.height);
    pathBottom.close();

    // Pintar ambas
    canvas.drawPath(pathTop, paint);
    canvas.drawPath(pathBottom, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ThickCheck extends StatelessWidget {
  final double size;
  final Color color;

  const ThickCheck({super.key, this.size = 100, this.color = Colors.brown});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _CheckPainter(color));
  }
}

class _CheckPainter extends CustomPainter {
  final Color color;

  _CheckPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth =
          size.width *
          0.22 // controla el grosor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.55);
    path.lineTo(size.width * 0.45, size.height * 0.8);
    path.lineTo(size.width * 0.8, size.height * 0.3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
