import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class DropboxServiciosWeb {
  static const String _authorizeUrl =
      'https://www.dropbox.com/oauth2/authorize';
  static const String _tokenUrl = 'https://api.dropboxapi.com/oauth2/token';
  static const String _uploadUrl =
      'https://content.dropboxapi.com/2/files/upload';

  static String? _appKey;
  static String? _appSecret;

  static const _secureStorage = FlutterSecureStorage();
  static const _accessTokenKey = 'dropbox_access_token';
  static const _refreshTokenKey = 'dropbox_refresh_token';

  static void definirClaves(String appKey, String appSecret) {
    _appKey = appKey;
    _appSecret = appSecret;
  }

  static String generarUrlDeAutorizacion() {
    if (_appKey == null) {
      throw Exception('La appKey de Dropbox no fue configurada.');
    }
    return '$_authorizeUrl?client_id=$_appKey&response_type=code&token_access_type=offline';
  }

  static Future<void> autenticar(String codigoAutorizacion) async {
    if (_appKey == null || _appSecret == null) {
      throw Exception('Claves de Dropbox no configuradas.');
    }

    final response = await http.post(
      Uri.parse(_tokenUrl),
      body: {
        'code': codigoAutorizacion,
        'grant_type': 'authorization_code',
        'client_id': _appKey,
        'client_secret': _appSecret,
      },
    );

    if (response.statusCode == 200) {
      final tokenData = json.decode(response.body);
      await _secureStorage.write(
          key: _accessTokenKey, value: tokenData['access_token']);
      await _secureStorage.write(
          key: _refreshTokenKey, value: tokenData['refresh_token']);
    } else {
      throw Exception(
          'Error en autenticación: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<bool> hasStoredToken() async {
    final accessToken = await _secureStorage.read(key: _accessTokenKey);
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);

    if (accessToken != null) {
      return true;
    } else if (refreshToken != null) {
      try {
        await _renovarAccessToken();
        return true;
      } catch (_) {
        return false;
      }
    }

    return false;
  }

  static Future<void> _renovarAccessToken() async {
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);

    if (refreshToken == null || _appKey == null || _appSecret == null) {
      throw Exception('Faltan credenciales para renovar token.');
    }

    final response = await http.post(
      Uri.parse(_tokenUrl),
      body: {
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
        'client_id': _appKey,
        'client_secret': _appSecret,
      },
    );

    if (response.statusCode == 200) {
      final tokenData = json.decode(response.body);
      await _secureStorage.write(
          key: _accessTokenKey, value: tokenData['access_token']);
      await _secureStorage.write(
          key: _refreshTokenKey, value: tokenData['refresh_token']);
    } else {
      throw Exception(
          'Error al renovar token: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<void> limpiarTokens() async {
    try {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
    } catch (e) {
//      print('[Dropbox] ⚠️ Error al limpiar tokens: $e');
    } finally {}
  }

  static Future<void> _refreshAccessToken() async {
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);

    if (refreshToken == null || _appKey == null || _appSecret == null) {
      throw Exception('Faltan credenciales para renovar el token.');
    }

    final response = await http.post(
      Uri.parse(_tokenUrl),
      body: {
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
        'client_id': _appKey,
        'client_secret': _appSecret,
      },
    );

    if (response.statusCode == 200) {
      final tokenData = json.decode(response.body);
      await _secureStorage.write(
          key: _accessTokenKey, value: tokenData['access_token']);
      await _secureStorage.write(
          key: _refreshTokenKey, value: tokenData['refresh_token']);
    } else {
      throw Exception(
          'Error al renovar el token: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<String> _getValidAccessToken() async {
    final accessToken = await _secureStorage.read(key: _accessTokenKey);

    if (accessToken != null) return accessToken;

    await _refreshAccessToken();
    final newAccessToken = await _secureStorage.read(key: _accessTokenKey);

    if (newAccessToken == null) {
      throw Exception('No se pudo obtener un nuevo access_token.');
    }

    return newAccessToken;
  }

  static String _convertToDirectDropboxUrl(String sharedLink) {
    if (sharedLink.contains("www.dropbox.com")) {
      return sharedLink
          .replaceFirst("www.dropbox.com", "dl.dropboxusercontent.com")
          .replaceFirst("?dl=0", "?raw=1");
    }
    return sharedLink;
  }

  static Future<String?> createSharedLink(String privateUrl) async {
    final accessToken = await _getValidAccessToken();
    final url =
        'https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings';

    // Extraer el path de la URL privada
    final path = privateUrl.replaceFirst('https://www.dropbox.com/home', '');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'path': path}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      String sharedLink = jsonResponse['url'];

      // ✅ Transformar a enlace directo usable desde Flutter Web
      final directUrl = _convertToDirectDropboxUrl(sharedLink);

      return directUrl;
    } else if (response.statusCode == 409) {
      return await _getExistingSharedLink(path);
    } else {
      throw Exception('Error al crear enlace compartido: ${response.body}');
    }
  }

  static Future<String?> _getExistingSharedLink(String path) async {
    final accessToken = await _getValidAccessToken();
    final url = 'https://api.dropboxapi.com/2/sharing/list_shared_links';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'path': path}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['links'] != null && jsonResponse['links'].isNotEmpty) {
        final link = jsonResponse['links'][0]['url'];

        final usableLink = link
            .replaceFirst('www.dropbox.com', 'dl.dropboxusercontent.com')
            .replaceFirst('?dl=0', '');

        return usableLink;
      } else {
        throw Exception('No hay enlaces compartidos existentes para $path');
      }
    } else {
      throw Exception(
          'Error al buscar enlace existente: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<String?> uploadImageFromWeb({
    required Uint8List bytes,
    required String fileName,
    required String userId,
  }) async {
    final accessToken = await _getValidAccessToken();
    final filePath = '/Catalogo/$fileName';

    final request = http.Request('POST', Uri.parse(_uploadUrl))
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..headers['Content-Type'] = 'application/octet-stream'
      ..headers['Dropbox-API-Arg'] = json.encode({
        'path': filePath,
        'mode': 'add',
        'autorename': true,
        'mute': false,
      })
      ..bodyBytes = bytes;

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final path = json.decode(body)['path_display'];
      return await createSharedLink('https://www.dropbox.com/home$path');
    } else {
      final error = await response.stream.bytesToString();
      throw Exception('Error al subir imagen: ${response.statusCode} - $error');
    }
  }
}
