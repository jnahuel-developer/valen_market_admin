import 'dart:js_interop' as web;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_agregar_producto_bloque.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_text_field.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/services/firebase/catalogo_servicios_firebase.dart';
import 'package:valen_market_admin/services/dropbox/dropbox_servicios_web.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:web/web.dart' as web;

class WebAgregarProductoScreen extends StatefulWidget {
  const WebAgregarProductoScreen({super.key});

  @override
  State<WebAgregarProductoScreen> createState() =>
      _WebAgregarProductoScreenState();
}

class _WebAgregarProductoScreenState extends State<WebAgregarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _catalogoService = CatalogoServiciosFirebase();
  final _secureStorage = const FlutterSecureStorage();

  final _nombreController = TextEditingController();
  final _descCortaController = TextEditingController();
  final _descLargaController = TextEditingController();
  final _precioController = TextEditingController();
  final _cuotasController = TextEditingController();
  final _stockController = TextEditingController();

  bool _guardando = false;
  Uint8List? _imagenBytes;
  String? _nombreArchivo;

  Future<void> _seleccionarImagen() async {
    final input = web.document.createElement('input') as web.HTMLInputElement;
    input.type = 'file';
    input.accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.length > 0) {
        final file = files.item(0);
        if (file != null) {
          _nombreArchivo = file.name;

          final reader = web.FileReader();
          reader.readAsArrayBuffer(file);
          reader.onLoadEnd.listen((_) {
            final result = reader.result;
            if (result case final web.JSArrayBuffer buffer) {
              final dartBuffer = buffer.toDart;
              setState(() {
                _imagenBytes = Uint8List.view(dartBuffer);
              });
            }
          });
        }
      }
    });
  }

  Future<void> _guardarProducto() async {
    if (_formKey.currentState?.validate() != true || _imagenBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Todos los campos son obligatorios, incluida la imagen.')),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      final nombreProducto = _nombreController.text.trim();
      final uid = await _secureStorage.read(key: 'UID');
      final fecha = DateFormat('yyyyMMdd').format(DateTime.now());
      final nombreImagen = '${nombreProducto.replaceAll(" ", "_")}__$fecha.jpg';

      final urlImagen = await DropboxServiciosWeb.uploadImageFromWeb(
        bytes: _imagenBytes!,
        fileName: nombreImagen,
        userId: uid!,
      );

      await _catalogoService.agregarProducto(
        nombreDelProducto: nombreProducto,
        descripcionCorta: _descCortaController.text.trim(),
        descripcionLarga: _descLargaController.text.trim(),
        precio: double.parse(_precioController.text.trim()),
        cantidadDeCuotas: int.parse(_cuotasController.text.trim()),
        stock: int.parse(_stockController.text.trim()),
        linkDeLaFoto: urlImagen ?? 'No disponible',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto agregado exitosamente')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar producto: $e')),
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
            titulo: 'Agregar Producto',
            pantallaPadreRouteName: PANTALLA_WEB__Catalogo,
          ),
          const SizedBox(height: 35),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// Bloque A
                        CustomWebAgregarProductoBloque(
                          titulo: 'Información básica',
                          child: Column(
                            children: [
                              CustomTextField(
                                  label: 'Nombre del Producto',
                                  controller: _nombreController,
                                  isRequired: true),
                              const SizedBox(height: 15),
                              CustomTextField(
                                  label: 'Descripción Corta',
                                  controller: _descCortaController,
                                  isRequired: true),
                              const SizedBox(height: 15),
                              CustomTextField(
                                  label: 'Descripción Larga',
                                  controller: _descLargaController,
                                  maxLines: 3),
                            ],
                          ),
                        ),

                        const SizedBox(width: 15),

                        /// Bloque B
                        CustomWebAgregarProductoBloque(
                          titulo: 'Datos comerciales',
                          child: Column(
                            children: [
                              CustomTextField(
                                label: 'Precio',
                                controller: _precioController,
                                isRequired: true,
                                isMoney: true,
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                  label: 'Cantidad de Cuotas',
                                  controller: _cuotasController,
                                  keyboardType: TextInputType.number,
                                  isRequired: true),
                              const SizedBox(height: 15),
                              CustomTextField(
                                  label: 'Stock',
                                  controller: _stockController,
                                  keyboardType: TextInputType.number,
                                  isRequired: true),
                            ],
                          ),
                        ),

                        const SizedBox(width: 15),

                        /// Bloque C
                        CustomWebAgregarProductoBloque(
                          titulo: 'Imagen del producto',
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final anchoDisponible = constraints.maxWidth;
                              const gap = 15.0;
                              const imagenSize = 220.0; // tamaño fijo

                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  CustomGradientButton(
                                    text: _imagenBytes == null
                                        ? 'SELECCIONAR IMAGEN'
                                        : 'CAMBIAR IMAGEN',
                                    onPressed: _seleccionarImagen,
                                    width: anchoDisponible - gap * 2,
                                  ),
                                  const SizedBox(height: gap),
                                  Container(
                                    width: anchoDisponible - gap * 2,
                                    height: imagenSize,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: WebColors.bordeRosa,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: _imagenBytes != null
                                        ? FittedBox(
                                            fit: BoxFit.contain,
                                            child: Image.memory(_imagenBytes!),
                                          )
                                        : const Center(
                                            child: Text(
                                                "No hay imagen seleccionada")),
                                  ),
                                  const SizedBox(height: gap),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// Botón Confirmar
                  _guardando
                      ? const CircularProgressIndicator()
                      : CustomGradientButton(
                          text: 'CONFIRMAR',
                          onPressed: _guardarProducto,
                        ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
