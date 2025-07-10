import 'dart:developer';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/services/firebase/clientes_servicios_firebase.dart';

class ClientesServiciosGoogleSheetsWeb {
  static Future<String?> exportarClientes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      if (accessToken == null || accessToken.isEmpty) {
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

      final spreadsheet = await sheetsApi.spreadsheets.create(
        sheets.Spreadsheet(
          properties: sheets.SpreadsheetProperties(title: nombreHoja),
        ),
      );

      final spreadsheetId = spreadsheet.spreadsheetId;
      if (spreadsheetId == null) return null;

      final hojaId = spreadsheet.sheets?.first.properties?.title ?? 'Sheet1';

      final clientes =
          await ClientesServiciosFirebase.obtenerTodosLosClientes();
      if (clientes.isEmpty) return null;

      final List<List<Object>> datos = [
        ['Nombre', 'Apellido', 'Dirección', 'Teléfono'],
      ];

      for (final cliente in clientes) {
        datos.add([
          cliente['Nombre'] ?? '',
          cliente['Apellido'] ?? '',
          cliente['Dirección'] ?? '',
          cliente['Teléfono'] ?? '',
        ]);
      }

      final valueRange = sheets.ValueRange(values: datos);
      await sheetsApi.spreadsheets.values.update(
        valueRange,
        spreadsheetId,
        '$hojaId!A1',
        valueInputOption: 'RAW',
      );

      return 'https://docs.google.com/spreadsheets/d/$spreadsheetId';
    } catch (e, st) {
      log('❌ Error al exportar clientes: $e', error: e, stackTrace: st);
      return null;
    }
  }
}
