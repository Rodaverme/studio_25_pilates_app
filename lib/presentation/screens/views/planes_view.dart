import 'package:flutter/material.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards.dart';

class PlanesView extends StatelessWidget {
  const PlanesView({super.key});

  @override
  Widget build(BuildContext context) {
    final int current = 22;
    final int total = 30;
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Planes'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _CustomPlanes(
                textStyle: textStyle,
                current: current,
                total: total,
                isActive: true,
                plan: 'Plan Premium',
                price: '0',
                subtitle: 'Se renueva el 15 de agosto',
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _CustomPlanes(
                textStyle: textStyle,
                current: current,
                total: total,
                isActive: false,
                plan: 'Plan Basico',
                price: '50.000/mes',
                subtitle: 'Perfecto para comenzar',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _CustomPlanes(
                textStyle: textStyle,
                current: current,
                total: total,
                isActive: false,
                plan: 'Plan Super',
                price: '90.000/mes',
                subtitle: 'El mas popular',
              ),
            ),
          ],
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
