import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ClientesServiciosGoogleSheets {
  static final _scopes = [
    sheets.SheetsApi.spreadsheetsScope,
    'https://www.googleapis.com/auth/drive.file',
  ];

  static final _jsonKeyPath =
      'lib/secrets/valen_market_admin_dev_service_account.json';

  static Future<void> exportarClientes(BuildContext context) async {
    try {
      final serviceAccount = File(_jsonKeyPath);
      if (!await serviceAccount.exists()) {
        if (context.mounted) {
          _mostrarSnackBar(
              context, 'Error: Archivo de credenciales no encontrado.');
        }
        return;
      }

      final credentials = ServiceAccountCredentials.fromJson(
        serviceAccount.readAsStringSync(),
      );

      final authClient = await clientViaServiceAccount(credentials, _scopes);
      final sheetsApi = sheets.SheetsApi(authClient);

      final clientesSnapshot =
          await FirebaseFirestore.instance.collection('clientes').get();
      final clientes = clientesSnapshot.docs;

      if (clientes.isEmpty) {
        if (context.mounted) {
          _mostrarSnackBar(context, 'No hay clientes para exportar.');
        }
        authClient.close();
        return;
      }

      final ahora = DateTime.now();
      final nombreHoja = 'Clientes_${DateFormat('yyyy_MM').format(ahora)}';

      final spreadsheet = await sheetsApi.spreadsheets.create(
        sheets.Spreadsheet(
          properties: sheets.SpreadsheetProperties(title: nombreHoja),
        ),
      );

      final spreadsheetId = spreadsheet.spreadsheetId;

      final List<List<Object>> valores = [
        ['Nombre', 'Apellido', 'Dirección', 'Teléfono']
      ];

      for (final doc in clientes) {
        final data = doc.data();
        valores.add([
          _capitalize(data['nombre'] ?? ''),
          _capitalize(data['apellido'] ?? ''),
          _capitalize(data['direccion'] ?? ''),
          data['telefono'] ?? '',
        ]);
      }

      final valueRange = sheets.ValueRange(values: valores);
      await sheetsApi.spreadsheets.values.update(
        valueRange,
        spreadsheetId!,
        'Clientes!A1',
        valueInputOption: 'RAW',
      );

      if (context.mounted) {
        _mostrarSnackBar(
            context, '✅ Clientes exportados a Google Sheets correctamente');
      }

      authClient.close();
    } catch (e) {
      if (context.mounted) {
        _mostrarSnackBar(context, '❌ Error al exportar: ${e.toString()}');
      }
    }
  }

  static void _mostrarSnackBar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  static String _capitalize(String texto) {
    if (texto.isEmpty) return '';
    return texto[0].toUpperCase() + texto.substring(1).toLowerCase();
  }
}
