import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/logout/logout_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<AuthCubit>().state.client;
    // final logOutCubit = context.watch<LogoutCubit>();
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.read<AuthCubit>().logout(); // 👈 limpia el AuthCubit
          context.go('/'); // 👈 redirige al login/home
        } else if (state is LogoutError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Perfil')),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height *0.9,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/Logo6.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Informacion Cliente
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              client?.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),

                          Center(
                            child: Text(
                              client?.email ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),

                          FilledButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                AppColors.almendra,
                              ),
                              fixedSize: WidgetStatePropertyAll(Size(270, 30)),
                            ),
                            child: Text('Miembro Premium'),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsGeometry.all(10.0),

                      child: CustomCardsType1(
                        width: double.maxFinite,
                        height: 70,
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
                          CustomCardsType1(
                            width: 120,
                            height: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text('8'), Text('Reservas')],
                            ),
                          ),

                          Spacer(),

                          CustomCardsType1(
                            width: 120,
                            height: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text('18'), Text('Clases')],
                            ),
                          ),

                          Spacer(),

                          CustomCardsType1(
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
                    _PerfilOptions(Icons.class_outlined, 'Mis clases', () {}),
                    _PerfilOptions(
                      Icons.payments_outlined,
                      'Pagos y Planes',
                      () {},
                    ),

                    _PerfilOptions(Icons.logout_outlined, 'Cerrar Sesión', () {
                      context.read<LogoutCubit>().logOut();
                    }),
                  ],
                ),
              ],
            ),
          ),
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
        child: CustomCardsType1(
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
