class ValidadorTexto {
  static bool esEntradaSegura(String input) {
    final texto = input.toLowerCase();

    // Lista básica de patrones maliciosos
    const patronesProhibidos = [
      '--',
      ';',
      'drop table',
      'select ',
      'insert ',
      'update ',
      'delete ',
      'script',
      'alert(',
      '1=1',
    ];

    for (final patron in patronesProhibidos) {
      if (texto.contains(patron)) return false;
    }

    return true;
  }
}
