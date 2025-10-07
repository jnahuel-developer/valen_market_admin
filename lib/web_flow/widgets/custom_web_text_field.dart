import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isPassword;
  final bool isMoney;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isPassword = false,
    this.isMoney = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: isMoney
          ? TextInputType.number
          : keyboardType, // fuerza numérico si es dinero
      maxLines: isPassword ? 1 : maxLines,
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      inputFormatters: isMoney
          ? [FilteringTextInputFormatter.digitsOnly, _MoneyInputFormatter()]
          : null,
      decoration: InputDecoration(
        prefixText: isMoney ? '\$ ' : null,
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        // Se definen los bordes cuando esté habilitado
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              VALUE__general_widget__campo__big_border_radius),
          borderSide: BorderSide(color: WebColors.bordeControlHabilitado),
        ),
        // Se definen los bordes cuando esté deshabilitado
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              VALUE__general_widget__campo__big_border_radius),
          borderSide: BorderSide(color: WebColors.bordeControlDeshabilitado),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              VALUE__general_widget__campo__big_border_radius),
          borderSide: BorderSide(color: WebColors.negro, width: 1.5),
        ),
      ),
      validator: isRequired
          ? (value) =>
              value == null || value.trim().isEmpty ? 'Campo requerido' : null
          : null,
    );
  }
}

class _MoneyInputFormatter extends TextInputFormatter {
  final _formatter = NumberFormat("#,##0", "es_AR");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final formatted = _formatter.format(int.tryParse(digitsOnly) ?? 0);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
