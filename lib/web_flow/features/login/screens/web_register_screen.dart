import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_text_field.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_gradient_button.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/services/firebase/auth_servicios_firebase_web.dart';

class WebRegisterScreen extends StatefulWidget {
  const WebRegisterScreen({super.key});

  @override
  State<WebRegisterScreen> createState() => _WebRegisterScreenState();
}

class _WebRegisterScreenState extends State<WebRegisterScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _usuarioEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _cargando = false;

  Future<void> _crearCuenta() async {
    final nombre = _nombreController.text.trim();
    final apellido = _apellidoController.text.trim();
    final usuarioEmail = _usuarioEmailController.text.trim();
    final password = _passwordController.text.trim();
    final emailCompleto = "$usuarioEmail@gmail.com";

    if (nombre.isEmpty ||
        apellido.isEmpty ||
        usuarioEmail.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son obligatorios.')),
      );
      return;
    }

    setState(() => _cargando = true);

    final registroOk = await AuthServiciosFirebaseWeb.registrarUsuario(
      emailCompleto,
      password,
    );

    if (!mounted) return;

    if (registroOk) {
      final uid = await AuthServiciosFirebaseWeb.obtenerUidActual();

      if (uid != null) {
        await AuthServiciosFirebaseWeb.crearAdminEnBDD(
          uid: uid,
          email: emailCompleto,
          nombre: nombre,
          apellido: apellido,
        );

        // UID persistido en almacenamiento seguro
        const secureStorage = FlutterSecureStorage();
        await secureStorage.write(key: 'UID', value: uid);

        Navigator.pushReplacementNamed(
            context, PANTALLA_WEB__Login__Registro__EsperandoVerificacion);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo obtener el UID')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar el usuario')),
      );
    }

    if (mounted) setState(() => _cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Crear Cuenta',
            pantallaPadreRouteName: PANTALLA_WEB__Login,
          ),
          const SizedBox(height: 60),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        label: 'Nombre',
                        controller: _nombreController,
                        isRequired: true,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Apellido',
                        controller: _apellidoController,
                        isRequired: true,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'Email (sin @gmail.com)',
                              controller: _usuarioEmailController,
                              isRequired: true,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '@gmail.com',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Contraseña',
                        controller: _passwordController,
                        isPassword: true,
                        isRequired: true,
                      ),
                      const SizedBox(height: 40),
                      _cargando
                          ? const CircularProgressIndicator()
                          : CustomGradientButton(
                              text: 'CREAR CUENTA',
                              onPressed: _crearCuenta,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
