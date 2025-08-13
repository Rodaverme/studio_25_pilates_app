// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/auth_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/auth_respository_impl.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/login/login_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/forms/forms_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/notifications/notifications_bloc.dart';

import 'package:studio_25_pilates_app/presentation/utils/input_decorations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FormsCubit()),
        BlocProvider(
          create: (context) => LoginCubit(
            authCubit: context.read<AuthCubit>(),
            authRepository: AuthRespositoryImpl(
              datasource: AuthDatasourceImpl(),
            ),
          ),
        ),
       
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Login'), centerTitle: true),
        body: SafeArea(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                context.go('/home-screen/0');
              }
              if (state is LoginError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
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
                            children: [
                              const SizedBox(height: 30),
                              Text('Bienvenida', style: textStyle.titleLarge),
                              const SizedBox(height: 8),
                              const Text('Inicia sesión para continuar'),
                              const SizedBox(height: 70),
                              Expanded(
                                child: _LoginForm(
                                  textStyle: textStyle,
                                  isLoading: state is LoginLoading,
                                ),
                              ),
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
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({required this.textStyle, required this.isLoading});

  final TextTheme textStyle;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    
    final formsCubit = context.watch<FormsCubit>();
    final password = formsCubit.state.password;
    final email = formsCubit.state.email;
    return Form(
      child: Column(
        children: [
          TextFormField(
            onChanged: formsCubit.emailChange,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Correoelectrónico@dominio.com',
              labelText: 'Ingrese su correo',
              errorText: email.errorMessage,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onChanged: formsCubit.passwordChange,
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*********',
              labelText: 'Ingrese su contraseña',
              errorText: password.errorMessage,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                formsCubit.onSubmit();
                if (!email.isValid || !password.isValid) return;
                context.read<LoginCubit>().login(email.value, password.value);
                context.read<NotificationsBloc>().requestPermission();
              },
              style: ButtonStyle(
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
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Continuar', style: TextStyle(fontSize: 15)),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => context.push('/resetPassword'),
            child: const Text('¿Olvidaste tu contraseña?'),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Aun no tienes cuenta?'),
              TextButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await Future.delayed(Duration(milliseconds: 1));
                  context.push('/register');
                },
                child: Text(
                  'Registrate',
                  style: textStyle.titleMedium?.copyWith(fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
