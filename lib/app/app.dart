import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/features/clientes/screens/web_clientes_screen.dart';
import 'package:valen_market_admin/Web_flow/features/login/screens/web_login.dart';
import '../Android_flow/features/home/screens/home_screen.dart';
import '../Android_flow/features/catalogo/screens/catalogo_screen.dart';
import '../Android_flow/features/clientes/screens/clientes_screen.dart';
import '../Android_flow/features/clientes/screens/agregar_cliente_screen.dart';
import '../Android_flow/features/clientes/screens/buscar_cliente_screen.dart';
import '../Android_flow/features/fichas/screens/fichas_screen.dart';
import '../Android_flow/features/recorrido/screens/recorrido_screen.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import '../Web_flow/features/home/screens/web_home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valen Market Admin',
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
        PANTALLA_WEB__Home: (context) => const WebHomeScreen(),
        PANTALLA_WEB__Login: (_) => const WebLoginScreen(),
        PANTALLA_WEB__Clientes: (_) => const WebClientesScreen(),
      },
    );
  }
}
