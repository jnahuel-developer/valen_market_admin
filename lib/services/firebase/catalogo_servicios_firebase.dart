import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogoServiciosFirebase {
  final CollectionReference _catalogoCollection =
      FirebaseFirestore.instance.collection('BDD_Catalogo');

  /* ---------------------------------------------------------------------------------------- */
  //                            METODOS PARA AGREGAR REGISTROS                                */
  /* ---------------------------------------------------------------------------------------- */

  /// Agrega un nuevo producto al catálogo con un ID automático.
  Future<void> agregarProducto({
    required String nombreDelProducto,
    required String descripcionCorta,
    required String descripcionLarga,
    required double precio,
    required int cantidadDeCuotas,
    required int stock,
    required String linkDeLaFoto,
  }) async {
    try {
      await _catalogoCollection.add({
        'NombreDelProducto': nombreDelProducto,
        'DescripcionCorta': descripcionCorta,
        'DescripcionLarga': descripcionLarga,
        'Precio': precio,
        'CantidadDeCuotas': cantidadDeCuotas,
        'Stock': stock,
        'LinkDeLaFoto': linkDeLaFoto,
        'FechaDeCreacion': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al agregar el producto: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                               METODOS PARA LEER REGISTROS                                */
  /* ---------------------------------------------------------------------------------------- */

  /// Obtiene todos los productos del catálogo.
  Future<List<Map<String, dynamic>>> obtenerTodosLosProductos() async {
    try {
      final querySnapshot = await _catalogoCollection.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Añadir el ID del documento al map
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener los productos: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */

  /// Obtiene los datos de un producto por su ID.
  Future<Map<String, dynamic>?> obtenerProductoPorId(String productoId) async {
    try {
      final docSnapshot = await _catalogoCollection.doc(productoId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        data['id'] = docSnapshot.id;
        return data;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error al obtener el producto por ID: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                              METODOS PARA EDITAR REGISTROS                               */
  /* ---------------------------------------------------------------------------------------- */

  /// Actualiza un producto existente en el catálogo.
  Future<void> actualizarProducto({
    required String productoId,
    required Map<String, dynamic> nuevosDatos,
  }) async {
    try {
      await _catalogoCollection.doc(productoId).update(nuevosDatos);
    } catch (e) {
      throw Exception('Error al actualizar el producto: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                           METODOS PARA ELIMINAR REGISTROS                                */
  /* ---------------------------------------------------------------------------------------- */

  /// Elimina un producto del catálogo.
  Future<void> eliminarProducto(String productoId) async {
    try {
      await _catalogoCollection.doc(productoId).delete();
    } catch (e) {
      throw Exception('Error al eliminar el producto: $e');
    }
  }
}
