import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';

class ReservationSuccessView extends StatelessWidget {
  const ReservationSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final textSytle = Theme.of(context).textTheme.titleLarge;

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

                  /// Títulos
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
                        color: Color.fromRGBO(228, 214, 188, 1),
                        width: 6,
                      ),
                    ),
                    child: ThickCheck(size: 150, color: AppColors.almendra),
                  ),

                  const SizedBox(height: 30),

                  /// Mensaje
                  Text(
                    "Tu lugar en\nNOMBRE DE LA CLASE\nestá reservado",
                    textAlign: TextAlign.center,
                    style: textSytle,
                  ),
                  const SizedBox(height: 8),
                  Text("¡Nos vemos pronto!", style: textSytle),

                  const SizedBox(height: 40),

                  /// Detalle clase
                  Column(
                    children: [
                      Text("Nombre de la Clase", style: textSytle),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("10:30", style: TextStyle(color: Colors.brown)),
                          Text("25/09", style: TextStyle(color: Colors.brown)),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 100),

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
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(150, 55),
                            backgroundColor: AppColors.almendra,
                            foregroundColor: AppColors.piedra,
                            side: BorderSide(color: Colors.brown.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Invitar Acompañante",
                            style: textSytle?.copyWith(color: AppColors.piedra),
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
