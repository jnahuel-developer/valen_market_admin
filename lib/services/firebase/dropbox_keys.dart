import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene las claves de Dropbox para el admin autenticado.
  /// Retorna null si no existen claves válidas.
  static Future<Map<String, String>?> getDropboxAdminKeys(
      String adminId) async {
    try {
      final DocumentReference adminRef =
          _db.collection('BDD_Admins').doc(adminId);
      final DocumentSnapshot snapshot = await adminRef.get();

      if (snapshot.exists) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;

        if (data.containsKey('appKey') && data.containsKey('appSecret')) {
          return {
            'appKey': data['appKey'],
            'appSecret': data['appSecret'],
          };
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
