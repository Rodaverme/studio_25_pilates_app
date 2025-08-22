import 'package:flutter/material.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';

class LessonsToday extends StatelessWidget {
  const LessonsToday({
    super.key,
    required this.textStyle,
    required this.onTap,
    required this.pilatesClass,
  });

  final TextTheme textStyle;
  final void Function()? onTap;
  final PilatesClass pilatesClass;

  @override
  Widget build(BuildContext context) {
    final horaInicio =
        "${pilatesClass.fechaHora.hour.toString().padLeft(2, '0')}:${pilatesClass.fechaHora.minute.toString().padLeft(2, '0')}";
    final horaFin =
        "${pilatesClass.fechaHora.add(pilatesClass.duracion).hour.toString().padLeft(2, '0')}:"
        "${pilatesClass.fechaHora.add(pilatesClass.duracion).minute.toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            /// 👉 Parte izquierda (info de la clase)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        pilatesClass.nombre,
                        style: textStyle.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      pilatesClass.instructor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text('$horaInicio - $horaFin'),
                    Text(
                      '${pilatesClass.cuposOcupados}/${pilatesClass.cupoMaximo} Cupos',
                    ),
                  ],
                ),
              ),
            ),

            /// 👉 Parte derecha (botones)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        pilatesClass.nivel,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: onTap,
                      child: const Text(
                        'Reservar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
