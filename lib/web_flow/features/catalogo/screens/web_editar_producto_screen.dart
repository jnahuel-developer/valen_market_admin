import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:web/web.dart' as web;
import 'package:valen_market_admin/web_flow/widgets/custom_web_text_field.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/services/firebase/catalogo_servicios_firebase.dart';
import 'package:valen_market_admin/services/dropbox/dropbox_servicios_web.dart';

class WebEditarProductoScreen extends StatefulWidget {
  final Map<String, dynamic> producto;

  const WebEditarProductoScreen({super.key, required this.producto});

  @override
  State<WebEditarProductoScreen> createState() =>
      _WebEditarProductoScreenState();
}

class _WebEditarProductoScreenState extends State<WebEditarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _catalogoService = CatalogoServiciosFirebase();
  final _secureStorage = const FlutterSecureStorage();

  final _nombreController = TextEditingController();
  final _descCortaController = TextEditingController();
  final _descLargaController = TextEditingController();
  final _precioController = TextEditingController();
  final _cuotasController = TextEditingController();
  final _stockController = TextEditingController();

  Uint8List? _imagenBytes;
  String? _nombreArchivo;
  String? _urlImagen;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final p = widget.producto;
    _nombreController.text = p[FIELD_NAME__catalogo__Nombre_Del_Producto] ?? '';
    _descCortaController.text =
        p[FIELD_NAME__catalogo__Descripcion_Corta] ?? '';
    _descLargaController.text =
        p[FIELD_NAME__catalogoDescripcionCorta__Descripcion_Larga] ?? '';
    _precioController.text =
        (p[FIELD_NAME__catalogo__Precio_Unitario] ?? 0).toString();
    _cuotasController.text =
        (p[FIELD_NAME__catalogo__Cantidad_De_Cuotas] ?? 1).toString();
    _stockController.text = (p[FIELD_NAME__catalogo__Stock] ?? 0).toString();
    _urlImagen = p[FIELD_NAME__catalogo__Link_De_La_Foto];
  }

  Future<void> _seleccionarImagen() async {
    final input = web.document.createElement('input') as web.HTMLInputElement;
    input.type = 'file';
    input.accept = 'image/*';
    input.click();

    await input.onChange.first;

    final files = input.files;
    if (files != null && files.length > 0) {
      final file = files.item(0);
      if (file != null) {
        final reader = web.FileReader();
        reader.readAsArrayBuffer(file);

        await reader.onLoadEnd.first;

        final result = reader.result;
        if (result != null) {
          final buffer = result as ByteBuffer;
          setState(() {
            _imagenBytes = buffer.asUint8List();
            _nombreArchivo = file.name;
          });
        }
      }
    }
  }

  Future<void> _actualizarProducto() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _guardando = true);

    try {
      final uid = await _secureStorage.read(key: 'UID');
      String? nuevaUrl = _urlImagen;

      if (_imagenBytes != null && _nombreArchivo != null && uid != null) {
        final fecha = DateFormat('yyyyMMdd').format(DateTime.now());
        final nombreFinal =
            '${_nombreController.text.trim().replaceAll(" ", "_")}__$fecha.jpg';

        nuevaUrl = await DropboxServiciosWeb.uploadImageFromWeb(
          bytes: _imagenBytes!,
          fileName: nombreFinal,
          userId: uid,
        );
      }

      await _catalogoService.actualizarProducto(
        productoId: widget.producto['ID'],
        nuevosDatos: {
          FIELD_NAME__catalogo__Nombre_Del_Producto:
              _nombreController.text.trim(),
          FIELD_NAME__catalogo__Descripcion_Corta:
              _descCortaController.text.trim(),
          FIELD_NAME__catalogoDescripcionCorta__Descripcion_Larga:
              _descLargaController.text.trim(),
          FIELD_NAME__catalogo__Precio_Unitario: double.parse(
              _precioController.text.replaceAll('.', '').replaceAll(',', '')),
          FIELD_NAME__catalogo__Cantidad_De_Cuotas:
              int.parse(_cuotasController.text),
          FIELD_NAME__catalogo__Stock: int.parse(_stockController.text),
          FIELD_NAME__catalogo__Link_De_La_Foto: nuevaUrl ?? 'No disponible',
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Producto actualizado')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al actualizar: $e')),
      );
    } finally {
      setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Editar Producto',
            pantallaPadreRouteName: PANTALLA_WEB__Home,
          ),
          const SizedBox(height: 60),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            label: 'Nombre del Producto',
                            controller: _nombreController,
                            isRequired: true,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: 'Descripción Corta',
                            controller: _descCortaController,
                            isRequired: true,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: 'Descripción Larga',
                            controller: _descLargaController,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: FIELD_NAME__catalogo__Precio_Unitario,
                            controller: _precioController,
                            keyboardType: TextInputType.number,
                            isRequired: true,
                            isMoney: true, // ✅ CORRECTO
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: 'Cantidad de Cuotas',
                            controller: _cuotasController,
                            keyboardType: TextInputType.number,
                            isRequired: true,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: FIELD_NAME__catalogo__Stock,
                            controller: _stockController,
                            keyboardType: TextInputType.number,
                            isRequired: true,
                          ),
                          const SizedBox(height: 30),
                          CustomGradientButton(
                            text: _imagenBytes == null
                                ? 'CAMBIAR IMAGEN'
                                : 'IMAGEN SELECCIONADA',
                            onPressed: _seleccionarImagen,
                          ),
                          if (_nombreArchivo != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('📷 $_nombreArchivo'),
                            ),
                          const SizedBox(height: 40),
                          _guardando
                              ? const CircularProgressIndicator()
                              : CustomGradientButton(
                                  text: 'GUARDAR CAMBIOS',
                                  onPressed: _actualizarProducto,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
