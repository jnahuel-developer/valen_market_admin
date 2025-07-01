import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/catalogo/screens/catalogo_screen.dart';
import '../features/clientes/screens/clientes_screen.dart';
import '../features/clientes/screens/agregar_cliente_screen.dart';
import '../features/clientes/screens/buscar_cliente_screen.dart';
import '../features/fichas/screens/fichas_screen.dart';
import '../features/recorrido/screens/recorrido_screen.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valen Market Admin',
      home: const HomeScreen(), // ← Home directamente
      routes: {
        PANTALLA__Home: (_) => const HomeScreen(),
        PANTALLA__Clientes: (_) => const ClientesScreen(),
        PANTALLA__Fichas: (_) => const FichasScreen(),
        PANTALLA__Catalogo: (_) => const CatalogoScreen(),
        PANTALLA__Recorrido: (_) => const RecorridoScreen(),
        PANTALLA__Clientes__AgregarCliente: (_) => const AgregarClienteScreen(),
        PANTALLA__Clientes__BuscarCliente: (context) =>
            const BuscarClienteScreen(),
      },
    );
  }
}
