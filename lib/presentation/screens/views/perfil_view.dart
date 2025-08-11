import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Informacion Cliente
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomCards(
                width: double.maxFinite,
                height: 150,
                child: Row(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset(
                        'assets/images/EjercicioP.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ronald Vera'),
                        Text('ronald15043@gmail.com'),

                        CustomCards(
                          width: 250,
                          height: 30,
                          child: Center(child: Text('Miembro Premium')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsetsGeometry.all(10.0),

              child: CustomCards(
                width: double.maxFinite,
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_outlined, size: 50),
                      SizedBox(width: 20),
                      Text('Inivitaciones'),
                      Spacer(),
                      Text('3'),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CustomCards(
                    width: 120,
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('8'), Text('Reservas')],
                    ),
                  ),

                  Spacer(),

                  CustomCards(
                    width: 120,
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('18'), Text('Clases')],
                    ),
                  ),

                  Spacer(),

                  CustomCards(
                    width: 120,
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('38'), Text('Horas')],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            _PerfilOptions(Icons.class_outlined, 'Mis clases',(){}),
            _PerfilOptions(Icons.payments_outlined, 'Pagos y Planes',(){}),
            _PerfilOptions(
              Icons.privacy_tip_outlined,
              'Politicas y Privacidad',(){}
            ),
            _PerfilOptions(Icons.contact_support_outlined, 'Ayuda y Soporte',(){}),
            _PerfilOptions(Icons.logout_outlined, 'Cerrar Sesión',(){context.go('/');}),
          ],
        ),
      ),
    );
  }
}

class _PerfilOptions extends StatelessWidget {
  const _PerfilOptions(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: CustomCards(
          width: double.maxFinite,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(icon, size: 50),
                SizedBox(width: 10),
                Text(label),
                Spacer(),
                Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
