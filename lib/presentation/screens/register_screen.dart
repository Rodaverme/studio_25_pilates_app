// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/auth_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/auth_respository_impl.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/forms/forms_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/login/login_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/register/register_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/utils/input_decorations.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Regístrate'), centerTitle: true),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
          ),
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => FormsCubit()),
              BlocProvider(
                create: (_) => RegisterCubit(
                  authRespository: AuthRespositoryImpl(
                    datasource: AuthDatasourceImpl(),
                  ),
                ),
              ),
              // 🔹 Agregamos también el LoginCubit, igual que en LoginScreen
              BlocProvider(
                create: (_) => LoginCubit(
                  authCubit: context.read<AuthCubit>(),
                  authRepository: AuthRespositoryImpl(
                    datasource: AuthDatasourceImpl(),
                  ),
                ),
              ),
            ],
            child: SafeArea(
              child: BlocConsumer<RegisterCubit, RegisterState>(
                listener: (context, state) async {
                  if (state is RegisterSuccess) {
                    final formsCubit = context.read<FormsCubit>();
                    final email = formsCubit.state.email.value;
                    final password = formsCubit.state.password.value;

                    // 🔹 Luego del registro, hacer login automáticamente
                    await context.read<LoginCubit>().login(email, password);
                    context.read<NotificationsBloc>().requestPermission();

                    // 🔹 Redirigir al Home
                    context.go('/Home');
                  }

                  if (state is RegisterError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        content: Text(
                          'Error al realizar el registro, vuelve a intentarlo ${state.message}',
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Únete a nuestra comunidad',
                                    style: textStyle.titleLarge,
                                  ),
                                  const SizedBox(height: 60),

                                  _RegisterForm(
                                    isLoading: state is RegisterLoading,
                                  ),

                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('¿Ya tienes cuenta?'),
                                      TextButton(
                                        onPressed: () {
                                          context.go('/');
                                        },
                                        child: const Text('Login'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Términos de servicio y Política de privacidad',
                                      style: textStyle.titleMedium?.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final formsCubit = context.watch<FormsCubit>();
    final username = formsCubit.state.username;
    final password = formsCubit.state.password;
    final confirmedPassword = formsCubit.state.confirmedPassword;
    final email = formsCubit.state.email;

    return Form(
      child: Column(
        children: [
          TextFormField(
            onChanged: formsCubit.usernameChange,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Nombre',
              labelText: 'Ingrese su nombre',
              errorText: username.errorMessage,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onChanged: formsCubit.emailChange,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Correo electrónico',
              labelText: 'Ingrese su correo',
              errorText: email.errorMessage,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onChanged: formsCubit.passwordChange,
            obscureText: true,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*********',
              labelText: 'Ingrese su contraseña',
              errorText: password.errorMessage,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onChanged: formsCubit.confirmedPasswordChange,
            obscureText: true,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*********',
              labelText: 'Confirmar contraseña',
              errorText: confirmedPassword.errorMessage,
            ),
          ),
          const SizedBox(height: 60),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (!username.isValid ||
                          !email.isValid ||
                          !password.isValid ||
                          !confirmedPassword.isValid) {
                        return;
                      }

                      context.read<RegisterCubit>().register(
                            username.value,
                            email.value,
                            password.value,
                            confirmedPassword.value,
                          );
                    },
              style: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll(AppColors.almendra),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 20),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              child: isLoading
                  ? const Text('Creando cuenta...', style: TextStyle(fontSize: 15))
                  : const Text('Crear Cuenta', style: TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
