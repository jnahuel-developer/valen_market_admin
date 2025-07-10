import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/Android_flow/widgets/custom_big_button.dart';
import 'package:valen_market_admin/Android_flow/widgets/custom_bottom_navbar.dart';
import 'package:valen_market_admin/Android_flow/widgets/custom_info_card.dart';
import 'package:valen_market_admin/Android_flow/widgets/custom_simple_information.dart';
import 'package:valen_market_admin/Android_flow/widgets/custom_top_bar.dart';
import 'package:valen_market_admin/services/firebase/clientes_servicios_firebase.dart';

class BuscarClienteScreen extends StatefulWidget {
  const BuscarClienteScreen({super.key});

  @override
  State<BuscarClienteScreen> createState() => _BuscarClienteScreenState();
}

class _BuscarClienteScreenState extends State<BuscarClienteScreen> {
  final TextEditingController nombreBusquedaController =
      TextEditingController();
  final TextEditingController numeroBusquedaController =
      TextEditingController();

  final TextEditingController nombreClienteController = TextEditingController();
  final TextEditingController apellidoClienteController =
      TextEditingController();
  final TextEditingController direccionClienteController =
      TextEditingController();
  final TextEditingController telefonoClienteController =
      TextEditingController();
  final TextEditingController zonaClienteController = TextEditingController();

  List<Map<String, String>> clientes = [];
  String? idSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarNombresClientes();
  }

  Future<void> cargarNombresClientes() async {
    try {
      final data =
          await ClientesServiciosFirebase.obtenerNombresCompletosConId();
      if (!mounted) return;
      setState(() {
        clientes = data
            .map((e) => {
                  'id': e['id'].toString(),
                  'nombreCompleto': e['nombreCompleto'].toString(),
                })
            .toList();
      });
    } catch (e) {
      debugPrint('❌ Error al cargar nombres: $e');
    }
  }

  Future<void> cargarDatosClientePorId(String id) async {
    try {
      final datos = await ClientesServiciosFirebase.obtenerClientePorId(id);
      if (!mounted || datos == null) return;

      setState(() {
        nombreClienteController.text = datos['Nombre'];
        apellidoClienteController.text = datos['Apellido'];
        direccionClienteController.text = datos['Dirección'];
        telefonoClienteController.text = datos['Teléfono'];
        zonaClienteController.text = datos['Zona'] ?? '';
      });
    } catch (e) {
      debugPrint('❌ Error al cargar cliente por ID: $e');
    }
  }

  Future<void> _handleEditar() async {
    if (idSeleccionado == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Debe seleccionar un cliente para editar.')),
      );
      return;
    }

    final nombre = nombreClienteController.text.trim().toLowerCase();
    final apellido = apellidoClienteController.text.trim().toLowerCase();
    final direccion = direccionClienteController.text.trim().toLowerCase();
    final telefono = telefonoClienteController.text.trim().toLowerCase();

    if ([nombre, apellido, direccion, telefono].any((e) => e.isEmpty)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Todos los campos deben estar completos.')),
      );
      return;
    }

    try {
      await ClientesServiciosFirebase.actualizarClientePorId(
        idSeleccionado!,
        nombre: nombre,
        apellido: apellido,
        direccion: direccion,
        telefono: telefono,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente actualizado correctamente.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el cliente: $e')),
      );
    }
  }

  Future<void> _handleEliminar() async {
    if (idSeleccionado == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Debe seleccionar un cliente para eliminar.')),
      );
      return;
    }

    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text(
          '¿Está seguro que desea eliminar este cliente? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (!mounted || confirmacion != true) return;

    try {
      await ClientesServiciosFirebase.eliminarClientePorId(idSeleccionado!);
      if (!mounted) return;

      setState(() {
        idSeleccionado = null;
        nombreClienteController.clear();
        apellidoClienteController.clear();
        direccionClienteController.clear();
        telefonoClienteController.clear();
        zonaClienteController.clear();
      });

      await cargarNombresClientes();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente eliminado correctamente.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el cliente: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppAssets.bgClientes,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            color: AppColors.blancoTraslucido,
            colorBlendMode: BlendMode.srcOver,
          ),
          const CustomTopBar(title: 'BUSCAR CLIENTES'),
          Padding(
            padding: const EdgeInsets.only(top: 130, bottom: 80),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: CustomInfoCard(
                      title: 'Datos para buscar',
                      width: 400,
                      height: 200,
                      children: [
                        CustomSimpleInformation(
                          label: 'Nombre',
                          controller: nombreBusquedaController,
                        ),
                        const SizedBox(height: 5),
                        _buildDropdown(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: CustomInfoCard(
                      title: 'Datos del cliente',
                      width: 400,
                      height: 300,
                      children: [
                        CustomSimpleInformation(
                          label: 'Nombre',
                          controller: nombreClienteController,
                        ),
                        CustomSimpleInformation(
                          label: 'Apellido',
                          controller: apellidoClienteController,
                        ),
                        CustomSimpleInformation(
                          label: 'Dirección',
                          controller: direccionClienteController,
                        ),
                        CustomSimpleInformation(
                          label: 'Teléfono',
                          controller: telefonoClienteController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                      child: CustomBigButton(
                          text: 'Modificar', onTap: _handleEditar)),
                  const SizedBox(height: 10),
                  Center(
                      child: CustomBigButton(
                          text: 'Eliminar', onTap: _handleEliminar)),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      width: 350,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.negroSuave,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: idSeleccionado,
          isExpanded: true,
          hint: const Text('Seleccionar cliente...',
              style: TextStyle(color: Colors.white)),
          dropdownColor: AppColors.negroSuave,
          iconEnabledColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          onChanged: (String? newId) {
            if (newId != null) {
              setState(() => idSeleccionado = newId);
              cargarDatosClientePorId(newId);
            }
          },
          items: clientes.map((cliente) {
            return DropdownMenuItem<String>(
              value: cliente['id'],
              child: Center(
                child: Text(
                  cliente['nombreCompleto']!.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
