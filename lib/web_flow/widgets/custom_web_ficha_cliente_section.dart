import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_con_checkbox_dropdown.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_con_checkbox_textfield.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_sin_checkbox_textfield.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_dropdown_clientes.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/clientes_mock.dart';
import 'package:valen_market_admin/constants/zonas_disponibles.dart';

class CustomWebClienteSection extends StatefulWidget {
  const CustomWebClienteSection({super.key});

  @override
  State<CustomWebClienteSection> createState() =>
      _CustomWebClienteSectionState();
}

class _CustomWebClienteSectionState extends State<CustomWebClienteSection> {
  String? _clienteSeleccionado;
  String? _zonaSeleccionada;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  bool _nombreEditable = false;
  bool _apellidoEditable = false;
  bool _zonaEditable = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: WebColors.blanco,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: WebColors.bordeRosa, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWebDropdownClientes(
                clientes: clientesMock
                    .map((c) => '${c['nombre']} ${c['apellido']}')
                    .toList(),
                clienteSeleccionado: _clienteSeleccionado,
                onChanged: (value) {
                  setState(() {
                    _clienteSeleccionado = value;
                    final cliente = clientesMock.firstWhere(
                      (c) => '${c['nombre']} ${c['apellido']}' == value,
                      orElse: () => {},
                    );

                    _nombreController.text = cliente['nombre'] ?? '';
                    _apellidoController.text = cliente['apellido'] ?? '';
                    _zonaSeleccionada = cliente['zona'];
                    _direccionController.text = cliente['direccion'] ?? '';
                    _telefonoController.text = cliente['telefono'] ?? '';
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomWebCampoConCheckboxTextField(
                label: 'Nombre',
                controller: _nombreController,
                isEditable: _nombreEditable,
                onCheckboxChanged: (value) {
                  setState(() => _nombreEditable = value);
                },
              ),
              const SizedBox(height: 20),
              CustomWebCampoConCheckboxTextField(
                label: 'Apellido',
                controller: _apellidoController,
                isEditable: _apellidoEditable,
                onCheckboxChanged: (value) {
                  setState(() => _apellidoEditable = value);
                },
              ),
              const SizedBox(height: 20),
              CustomWebCampoConCheckboxDropdown(
                label: 'Zona',
                options: zonasDisponibles,
                selectedOption: _zonaSeleccionada,
                isEditable: _zonaEditable,
                onCheckboxChanged: (value) {
                  setState(() => _zonaEditable = value);
                },
                onChanged: (value) {
                  setState(() => _zonaSeleccionada = value);
                },
              ),
              const SizedBox(height: 20),
              CustomWebCampoSinCheckboxTextField(
                label: 'Dirección',
                controller: _direccionController,
              ),
              const SizedBox(height: 20),
              CustomWebCampoSinCheckboxTextField(
                label: 'Teléfono',
                controller: _telefonoController,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Contenedor para los botones en formato grilla 2x2
        LayoutBuilder(
          builder: (context, constraints) {
            final double buttonWidth = (constraints.maxWidth / 2) - 20;

            return Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                CustomGradientButton(
                  text: 'Agregar',
                  width: buttonWidth,
                  onPressed: () {},
                ),
                CustomGradientButton(
                  text: 'Buscar',
                  width: buttonWidth,
                  onPressed: () {},
                ),
                CustomGradientButton(
                  text: 'Editar',
                  width: buttonWidth,
                  onPressed: () {},
                ),
                CustomGradientButton(
                  text: 'Eliminar',
                  width: buttonWidth,
                  onPressed: () {},
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
