import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/features/clientes/services/clientes_servicios_firebase.dart';
import '../../../config/environment.dart';

class ClientesServiciosGoogleSheetsWeb {
  static Future<String?> exportarClientes(BuildContext context) async {
    try {
      print('▶️ Iniciando exportación...');

      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        _mostrarSnackBar(context, '⚠️ No hay sesión iniciada en Firebase.');
        return null;
      }

      final googleSignIn = GoogleSignIn(
        clientId: GOOGLE_SIGN_IN_CLIENT_ID_DEV,
        scopes: [
          'email',
          'profile',
          'openid',
          'https://www.googleapis.com/auth/drive.file',
          'https://www.googleapis.com/auth/spreadsheets',
        ],
      );

      final googleUser =
          await googleSignIn.signInSilently() ?? await googleSignIn.signIn();
      if (googleUser == null) {
        _mostrarSnackBar(
            context, '⚠️ No se pudo recuperar la sesión de Google.');
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;

      print('🟡 googleUser: $googleUser');
      print('🟡 accessToken: $accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        _mostrarSnackBar(context, '⚠️ Token de acceso no disponible.');
        return null;
      }

      final credentials = AccessCredentials(
        AccessToken('Bearer', accessToken,
            DateTime.now().toUtc().add(const Duration(hours: 1))),
        null,
        [
          sheets.SheetsApi.spreadsheetsScope,
          'https://www.googleapis.com/auth/drive.file',
        ],
      );

      final client = authenticatedClient(http.Client(), credentials);
      final sheetsApi = sheets.SheetsApi(client);

      final nombreHoja =
          'Clientes_${DateFormat('yyyy_MM_dd_HHmmss').format(DateTime.now())}';

      print('📝 Creando hoja de cálculo con nombre: $nombreHoja');

      final spreadsheet = await sheetsApi.spreadsheets.create(
        sheets.Spreadsheet(
          properties: sheets.SpreadsheetProperties(title: nombreHoja),
        ),
      );

      final spreadsheetId = spreadsheet.spreadsheetId;
      if (spreadsheetId == null) {
        _mostrarSnackBar(context, '❌ Error al obtener ID de la hoja.');
        return null;
      }

      print('📄 Hoja creada con ID: $spreadsheetId');

      // Obtener nombre real de la hoja por defecto (ej: Sheet1)
      final hojaId = spreadsheet.sheets?.first.properties?.title ?? 'Sheet1';
      print('📃 Nombre real de la hoja: $hojaId');

      print('🔍 Cargando clientes desde Firestore...');
      final clientes =
          await ClientesServiciosFirebase.obtenerTodosLosClientes();
      print('📦 Cantidad de clientes: ${clientes.length}');

      if (clientes.isEmpty) {
        _mostrarSnackBar(context, '⚠️ No hay clientes para exportar.');
        return null;
      }

      final List<List<Object>> datos = [
        ['Nombre', 'Apellido', 'Dirección', 'Teléfono'],
      ];

      for (final cliente in clientes) {
        final nombre = _capitalizar(cliente['Nombre']?.toString() ?? '');
        final apellido = _capitalizar(cliente['Apellido']?.toString() ?? '');
        final direccion = _capitalizar(cliente['Dirección']?.toString() ?? '');
        final telefono = cliente['Teléfono']?.toString() ?? '';

        print('👤 Cliente: $nombre $apellido - $telefono');
        datos.add([nombre, apellido, direccion, telefono]);
      }

      final valueRange = sheets.ValueRange(values: datos);

      // ✅ Ahora usamos el nombre correcto de la hoja
      await sheetsApi.spreadsheets.values.update(
        valueRange,
        spreadsheetId,
        '$hojaId!A1',
        valueInputOption: 'RAW',
      );

      final url = 'https://docs.google.com/spreadsheets/d/$spreadsheetId';
      print('✅ Exportación exitosa. URL: $url');

      _mostrarSnackBar(context, '✅ Clientes exportados correctamente.');
      return url;
    } catch (e, st) {
      print('❌ Error inesperado al exportar: $e');
      print(st);
      _mostrarSnackBar(context, '❌ Error inesperado: $e');
      return null;
    }
  }

  static void _mostrarSnackBar(BuildContext context, String mensaje) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje), duration: const Duration(seconds: 4)),
      );
    }
  }

  static String _capitalizar(String texto) {
    if (texto.isEmpty) return '';
    return texto[0].toUpperCase() + texto.substring(1).toLowerCase();
  }
}
