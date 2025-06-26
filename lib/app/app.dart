import 'package:flutter/material.dart';
import '../features/auth/screens/home_screen.dart';
import '../features/catalogo/screens/catalogo_screen.dart';
import '../features/clientes/screens/clientes_screen.dart';
import '../features/clientes/screens/agregar_cliente_screen.dart';
import '../features/clientes/screens/buscar_cliente_screen.dart';
import '../features/fichas/screens/fichas_screen.dart';
import '../features/recorrido/screens/recorrido_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valen Market Admin',
      home: const HomeScreen(), // ← Home directamente
      routes: {
        '/home': (_) => const HomeScreen(),
        '/clientes': (_) => const ClientesScreen(),
        '/fichas': (_) => const FichasScreen(),
        '/catalogo': (_) => const CatalogoScreen(),
        '/recorrido': (_) => const RecorridoScreen(),
        '/agregar_cliente': (_) => const AgregarClienteScreen(),
        'BuscarCliente': (context) => const BuscarClienteScreen(),
      },
    );
  }
}
