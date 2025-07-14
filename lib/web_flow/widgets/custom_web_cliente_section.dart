import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_cliente.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_con_checkbox_dropdown.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_con_checkbox_textfield.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomWebClienteSection extends StatefulWidget {
  const CustomWebClienteSection({super.key});

  @override
  State<CustomWebClienteSection> createState() =>
      _CustomWebClienteSectionState();
}

class _CustomWebClienteSectionState extends State<CustomWebClienteSection> {
  String? _clienteSeleccionado;
  final List<String> _clientesDummy = [
    'Juan Perez',
    'Maria Lopez',
    'Carlos Gomez'
  ];

  String? _zonaSeleccionada;
  final List<String> _zonasDummy = ['Zona Norte', 'Zona Sur', 'Zona Oeste'];

  bool _zonaEditable = false;
  bool _nombreEditable = false;
  bool _apellidoEditable = false;

  String nombre = '';
  String apellido = '';
  String direccion = '';
  String telefono = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: WebColors.bordeRosa, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _clienteSeleccionado,
            decoration: _inputDecoration('Seleccionar Cliente'),
            items: _clientesDummy.map((cliente) {
              return DropdownMenuItem(value: cliente, child: Text(cliente));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _clienteSeleccionado = value;
                nombre = 'NombreSimulado';
                apellido = 'ApellidoSimulado';
                direccion = 'DirecciónSimulada';
                telefono = '123456789';
              });
            },
          ),
          const SizedBox(height: 20),
          CustomWebCampoConCheckboxDropdown(
            label: 'Zona',
            items: _zonasDummy,
            editable: _zonaEditable,
            valueSeleccionado: _zonaSeleccionada,
            onChanged: (val) => setState(() => _zonaSeleccionada = val),
            onCheckboxChanged: (val) => setState(() => _zonaEditable = val),
          ),
          const SizedBox(height: 15),
          CustomWebCampoConCheckboxTextField(
            label: 'Nombre',
            value: nombre,
            editable: _nombreEditable,
            onCheckboxChanged: (val) => setState(() => _nombreEditable = val),
          ),
          const SizedBox(height: 15),
          CustomWebCampoConCheckboxTextField(
            label: 'Apellido',
            value: apellido,
            editable: _apellidoEditable,
            onCheckboxChanged: (val) => setState(() => _apellidoEditable = val),
          ),
          const SizedBox(height: 15),
          CustomWebCampoCliente(label: 'Dirección', value: direccion),
          const SizedBox(height: 15),
          CustomWebCampoCliente(label: 'Teléfono', value: telefono),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(child: Text('Recuadro blanco (placeholder)')),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }
}
