import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';

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
        FIELD_NAME__catalogo__Nombre_Del_Producto: nombreDelProducto,
        FIELD_NAME__catalogo__Descripcion_Corta: descripcionCorta,
        FIELD_NAME__catalogoDescripcionCorta__Descripcion_Larga:
            descripcionLarga,
        FIELD_NAME__catalogo__Precio: precio,
        FIELD_NAME__catalogo__Cantidad_De_Cuotas: cantidadDeCuotas,
        FIELD_NAME__catalogo__Stock: stock,
        FIELD_NAME__catalogo__Link_De_La_Foto: linkDeLaFoto,
        FIELD_NAME__catalogo__Fecha_De_Creacion: FieldValue.serverTimestamp(),
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
        data['ID'] = doc.id; // Añadir el ID del documento al map
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
        data['ID'] = docSnapshot.id;
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
