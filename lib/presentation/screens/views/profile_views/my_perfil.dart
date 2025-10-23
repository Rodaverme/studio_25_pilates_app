import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/auth/auth_cubit.dart';

class MyPerfil extends StatefulWidget {
  const MyPerfil({super.key});

  @override
  State<MyPerfil> createState() => _MyPerfilState();
}

class _MyPerfilState extends State<MyPerfil> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _pathologyController = TextEditingController();
  final _birthdateController = TextEditingController();

  String? _selectedDocumentType;
  String? _selectedPersonType;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>();
    authCubit.getCurrentClient();
    authCubit.loadDocumentTypes();
    authCubit.loadGenderTypes();
    authCubit.loadOrganizationTypes();
  }

  void _showChangePasswordDialog() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña actual'),
            ),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nueva contraseña'),
            ),
            TextField(
              controller: confirmPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar nueva contraseña',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPassController.text == confirmPassController.text &&
                  newPassController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contraseña cambiada con éxito'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Las contraseñas no coinciden')),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _guardarCambios() {
    if (_formKey.currentState!.validate()) {
      final payload = {
        "name": _nameController.text,
        "email": _emailController.text,
        "avatar_url": "",
        "language": "es",
        "birthdate": _birthdateController.text,
        "gender": _selectedGender ?? "1",
        "phone": _phoneController.text,
        "document_type": _selectedDocumentType ?? "3",
        "document_number": _documentNumberController.text,
        "business_name": _businessNameController.text,
        "pathology": _pathologyController.text,
        "person_type": _selectedPersonType ?? "2",
      };

      context.read<AuthCubit>().updateUser(
        name: payload["name"]!,
        email: payload["email"]!,
        avatarUrl: payload["avatar_url"]!,
        language: payload["language"]!,
        birthdate: payload["birthdate"]!,
        gender: payload["gender"]!,
        phone: payload["phone"]!,
        documentType: payload["document_type"]!,
        documentNumber: payload["document_number"]!,
        businessName: payload["business_name"]!,
        pathology: payload["pathology"]!,
        personType: payload["person_type"]!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se actualizó su perfil con éxito')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.vpn_key),
            tooltip: 'Cambiar contraseña',
            onPressed: _showChangePasswordDialog,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Logo6.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            final client = state.client;

            if (state.isLoading && client == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (client != null && _nameController.text.isEmpty) {
              _nameController.text = client.name ?? '';
              _emailController.text = client.email ?? '';
              _phoneController.text = client.phone ?? '';
              _documentNumberController.text = client.documentNumber ?? '';
              _businessNameController.text = client.businessName ?? '';
              _pathologyController.text = client.pathology ?? '';
              _birthdateController.text =
                  client.birthdate?.toString().split('T').first ?? '';

              _selectedDocumentType = client.documentType?.toString();
              _selectedGender = client.gender?.toString();
              _selectedPersonType = client.personType?.toString();
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- DATOS BÁSICOS ---
                            const Text(
                              'Datos básicos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre completo',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Teléfono',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _birthdateController,
                              decoration: const InputDecoration(
                                labelText: 'Fecha de nacimiento (YYYY-MM-DD)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.datetime,
                            ),
                            const SizedBox(height: 12),

                            DropdownButtonFormField<String>(
                              value: _selectedGender,
                              decoration: const InputDecoration(
                                labelText: 'Género',
                                border: OutlineInputBorder(),
                              ),
                              items: state.genderTypes.entries
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.key,
                                      child: Text(e.value),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _selectedGender = value),
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _pathologyController,
                              decoration: const InputDecoration(
                                labelText: 'Patología y/o condición',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 24),

                            // --- DATOS DE FACTURACIÓN ---
                            const Text(
                              'Datos de facturación',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            DropdownButtonFormField<String>(
                              value: _selectedPersonType,
                              decoration: const InputDecoration(
                                labelText: 'Tipo de persona',
                                border: OutlineInputBorder(),
                              ),
                              items: state.organizationTypes.entries
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.key,
                                      child: Text(e.value),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedPersonType = value;
                                  if (value == '1') {
                                    _businessNameController.text =
                                        _nameController.text;
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _businessNameController,
                              decoration: const InputDecoration(
                                labelText: 'Razón social',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),

                            DropdownButtonFormField<String>(
                              value: _selectedDocumentType,
                              decoration: const InputDecoration(
                                labelText: 'Tipo de documento',
                                border: OutlineInputBorder(),
                              ),
                              items: state.documentTypes.entries
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.key,
                                      child: Text(e.value),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _selectedDocumentType = value),
                            ),
                            const SizedBox(height: 12),

                            TextFormField(
                              controller: _documentNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Número de documento',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 24),

                            const Spacer(),

                            // --- BOTÓN GUARDAR ---
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: state.isLoading
                                    ? null
                                    : _guardarCambios,
                                child: state.isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text('Guardar cambios'),
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
    );
  }
}
