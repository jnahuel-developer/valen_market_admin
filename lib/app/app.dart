import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:valen_market_admin/web_flow/features/catalogo/screens/web_agregar_producto_screen.dart';
import 'package:valen_market_admin/web_flow/features/catalogo/screens/web_catalogo_screen.dart';
import 'package:valen_market_admin/web_flow/features/catalogo/screens/web_ver_catalogo_screen.dart';
import 'package:valen_market_admin/web_flow/features/clientes/screens/web_agregar_cliente_screen.dart';
import 'package:valen_market_admin/web_flow/features/dropbox/screens/web_dropbox_auth_screen.dart';
import 'package:valen_market_admin/web_flow/features/dropbox/screens/web_dropbox_check_screen.dart';
import 'package:valen_market_admin/web_flow/features/fichas/screens/web_fichas_agregar_buscar_screen.dart';
import 'package:valen_market_admin/web_flow/features/fichas/screens/web_fichas_editar_eliminar_screen.dart';
import 'package:valen_market_admin/web_flow/features/login/screens/web_login_email_password_screen.dart';
import 'package:valen_market_admin/web_flow/features/login/screens/web_login_screen.dart';
import 'package:valen_market_admin/web_flow/features/login/screens/web_register_screen.dart';
import 'package:valen_market_admin/web_flow/features/login/screens/web_registration_waiting_screen.dart';
import '../Android_flow/features/home/screens/home_screen.dart';
import '../Android_flow/features/catalogo/screens/catalogo_screen.dart';
import '../Android_flow/features/clientes/screens/clientes_screen.dart';
import '../Android_flow/features/clientes/screens/agregar_cliente_screen.dart';
import '../Android_flow/features/clientes/screens/buscar_cliente_screen.dart';
import '../Android_flow/features/fichas/screens/fichas_screen.dart';
import '../Android_flow/features/recorrido/screens/recorrido_screen.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import '../web_flow/features/home/screens/web_home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valen Market Admin',

      debugShowCheckedModeBanner: false,
      // Configuración de localización global
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''), // Español
      ],
      locale: const Locale('es', ''), // Fuerza idioma español

      home: kIsWeb ? const WebLoginScreen() : const HomeScreen(),
      routes: {
        PANTALLA__Home: (_) => const HomeScreen(),
        PANTALLA__Clientes: (_) => const ClientesScreen(),
        PANTALLA__Fichas: (_) => const FichasScreen(),
        PANTALLA__Catalogo: (_) => const CatalogoScreen(),
        PANTALLA__Recorrido: (_) => const RecorridoScreen(),
        PANTALLA__Clientes__AgregarCliente: (_) => const AgregarClienteScreen(),
        PANTALLA__Clientes__BuscarCliente: (context) =>
            const BuscarClienteScreen(),

        // Pantallas web de Logueo
        PANTALLA_WEB__Login: (_) => const WebLoginScreen(),
        PANTALLA_WEB__Login__ConEmail: (_) =>
            const WebLoginEmailPasswordScreen(),
        PANTALLA_WEB__Login__CrearUsuario: (_) => const WebRegisterScreen(),
        PANTALLA_WEB__Login__Registro__EsperandoVerificacion: (_) =>
            const WebRegistrationWaitingScreen(),

        // Pantallas web de Home
        PANTALLA_WEB__Home: (context) => const WebHomeScreen(),

        // Pantallas web de Clientes
        PANTALLA_WEB__Clientes__AgregarCliente: (_) =>
            const WebAgregarClienteScreen(),

        // Pantallas web de Catálogo
        PANTALLA_WEB__Catalogo: (_) => const WebCatalogoScreen(),
        PANTALLA_WEB__Catalogo__AgregarProducto: (_) =>
            const WebAgregarProductoScreen(),
        PANTALLA_WEB__Catalogo__VerCatalogo: (_) =>
            const WebVerCatalogoScreen(),

        // Pantallas web de Acceso a Dropbox
        PANTALLA_WEB__Dropbox__Auth: (_) => const WebDropboxAuthScreen(),
        PANTALLA_WEB__Dropbox__Check: (_) => const WebDropboxCheckScreen(),

        // Pantallas web de Fichas
        PANTALLA_WEB__Fichas__Agregar_Buscar: (_) =>
            const WebFichasAgregarBuscarScreen(),
        PANTALLA_WEB__Fichas__Editar_Eliminar: (_) =>
            const WebFichasEditarEliminarScreen(),
      },
    );
  }
}
