import 'package:flutter/material.dart';

class AppColors {
  // Android
  static const azul = Color.fromARGB(255, 77, 0, 255);
  static const amarillo = Color.fromARGB(255, 247, 223, 7);
  static const sombra = Color.fromRGBO(0, 0, 0, 0.25);
  static const blancoTraslucido = Color.fromRGBO(255, 255, 255, 0.5);
  static const Color negroSuave = Color.fromARGB(255, 30, 30, 30);
}

class WebColors {
  /// Plata traslúcido con leve brillo (inspirado en cristales)
  static const Color plataTranslucida = Color(0xF0DDDEE3); // 94% de opacidad

  /// Rosa metálico claro (ligeramente más suave)
  static const Color rosaMetalicoClaro = Color.fromARGB(255, 255, 189, 208);

  /// Para textos en botones o títulos sobre fondo plata
  static const Color textoRosa = rosaMetalicoClaro;

  /// Borde rosa metálico
  static const Color bordeRosa = rosaMetalicoClaro;

  /// Sombras y brillos sutiles
  static const Color sombraSuave = Color(0x29000000); // negro con opacidad baja

  static const blancoTraslucido = Color.fromRGBO(255, 255, 255, 0.5);

  // Degradado plata
  static const Color plataClara = Color(0xFFEEEEEE);
  static const Color plataOscura = Color(0xFFD0D0D0);

  static const negro = Colors.black;
  static const grisClaro = Color(0xFFCCCCCC);

  static const bordeNegro = negro;
  static const bordeGrisClaro = grisClaro;
  static const blanco = Colors.white;

  // Morado
  static const morado = Color(0xFF8E24AA);

  // Rosa muy claro
  static const Color fondoEtiquetaBloque = Color(0xFFFDF2F6);

  // Bordes de controles que cambian su activación
  static const bordeControlHabilitado = negro;
  static const bordeControlDeshabilitado = grisClaro;

  // Color de los controles deshabilitados
  static const checkboxHabilitado = morado;
  static const radioButtonHabilitado = morado;
  static const iconHabilitado = morado;
  static const controlDeshabilitado = grisClaro;
}
