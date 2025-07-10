import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_gradient_button.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_text_field.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/services/firebase/catalogo_servicios_firebase.dart';

class WebAgregarProductoScreen extends StatefulWidget {
  const WebAgregarProductoScreen({super.key});

  @override
  State<WebAgregarProductoScreen> createState() =>
      _WebAgregarProductoScreenState();
}

class _WebAgregarProductoScreenState extends State<WebAgregarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _catalogoService = CatalogoServiciosFirebase();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descCortaController = TextEditingController();
  final TextEditingController _descLargaController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _cuotasController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  bool _guardando = false;

  Future<void> _guardarProducto() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _guardando = true);

    try {
      await _catalogoService.agregarProducto(
        nombreDelProducto: _nombreController.text.trim(),
        descripcionCorta: _descCortaController.text.trim(),
        descripcionLarga: _descLargaController.text.trim(),
        precio: double.parse(_precioController.text.trim()),
        cantidadDeCuotas: int.parse(_cuotasController.text.trim()),
        stock: int.parse(_stockController.text.trim()),
        linkDeLaFoto: 'No disponible actualmente',
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
                            label: 'Precio',
                            controller: _precioController,
                            keyboardType: TextInputType.number,
                            isRequired: true,
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
                            label: 'Stock',
                            controller: _stockController,
                            keyboardType: TextInputType.number,
                            isRequired: true,
                          ),
                          const SizedBox(height: 40),
                          _guardando
                              ? const CircularProgressIndicator()
                              : CustomGradientButton(
                                  text: 'CONFIRMAR',
                                  onPressed: _guardarProducto,
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
