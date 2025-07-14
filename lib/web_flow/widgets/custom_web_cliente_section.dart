import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_con_checkbox_textfield.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_con_checkbox_dropdown.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_sin_checkbox_textfield.dart';

class CustomWebClienteSection extends StatefulWidget {
  const CustomWebClienteSection({super.key});

  @override
  State<CustomWebClienteSection> createState() =>
      _CustomWebClienteSectionState();
}

class _CustomWebClienteSectionState extends State<CustomWebClienteSection> {
  String? _clienteSeleccionado;

  final List<Map<String, dynamic>> _clientes = [
    {
      'id': '1',
      'nombre': 'Juan',
      'apellido': 'Perez',
      'zona': 'Norte',
      'direccion': 'Calle Falsa 123',
      'telefono': '123456789'
    },
    {
      'id': '2',
      'nombre': 'Maria',
      'apellido': 'Gomez',
      'zona': 'Sur',
      'direccion': 'Av Siempre Viva 742',
      'telefono': '987654321'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.pink, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdownClientes(),
          const SizedBox(height: 20),
          CustomWebCampoConCheckboxTextField(label: 'Nombre'),
          const SizedBox(height: 15),
          CustomWebCampoConCheckboxTextField(label: 'Apellido'),
          const SizedBox(height: 15),
          CustomWebCampoConCheckboxDropdown(label: 'Zona'),
          const SizedBox(height: 15),
          CustomWebCampoSinCheckboxTextField(label: 'Dirección'),
          const SizedBox(height: 15),
          CustomWebCampoSinCheckboxTextField(label: 'Teléfono'),
        ],
      ),
    );
  }

  Widget _buildDropdownClientes() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: _clienteSeleccionado,
        hint: const Text('Seleccionar cliente'),
        underline: const SizedBox(),
        items: _clientes.map((cliente) {
          return DropdownMenuItem<String>(
            value: cliente['id'],
            child: Text('${cliente['nombre']} ${cliente['apellido']}'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _clienteSeleccionado = value;
          });
        },
      ),
    );
  }
}
