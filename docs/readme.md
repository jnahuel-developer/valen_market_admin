# 📌 Reglas de diseño y desarrollo de la app ValenMarket Admin

Este documento resume todas las directrices acordadas durante el desarrollo, para mantener coherencia en el código, consistencia en la experiencia de usuario y facilitar el mantenimiento futuro.

------------------------------------------------------------------------------------------

## 🔐 Seguridad y estructura de Firebase

- Todos los métodos de lectura deben validar la existencia del campo antes de acceder a él.
- Se debe asumir que un documento puede estar incompleto o tener claves mal formateadas.
- Si un documento no cumple con los requisitos estructurales esperados, debe ignorarse silenciosamente (no lanzar errores).
- Todos los documentos deben seguir la estructura validada por la app al insertarse.
- Se prohíbe la inserción manual sin la app.

------------------------------------------------------------------------------------------

## 🎨 Manejo de colores

- Prohibido el uso de `.withOpacity()` o manipulaciones inline de colores.
- Todos los colores deben definirse en `app_colors.dart` y referenciarse por nombres legibles como:
- Se deben crear colores translúcidos como constantes independientes.

------------------------------------------------------------------------------------------

## 🧱 Estructura del código y reutilización

- Widgets reutilizables deben:
  - Estar bien nombrados según su función (ej: `CustomSimpleInformation`, `CustomInfoCard`).
  - Estar desacoplados de pantallas específicas.
  - Ubicarse en carpetas compartidas como `widgets/` si se reutilizan en varias pantallas.
- Los valores como `width`, `height`, `label`, `controller`, etc., deben ser **parámetros configurables** del widget, nunca hardcodeados internamente.
- Los parámetros opcionales deben tener valores por defecto razonables (ejemplo: `width = 400`).

------------------------------------------------------------------------------------------

## 🧪 Validaciones de entrada

- Toda entrada que el usuario complete y que se use en Firebase debe validarse con `ValidadorTexto.esEntradaSegura`.
- En caso de datos inseguros, debe notificarse al usuario mediante un `SnackBar` claro y legible.

------------------------------------------------------------------------------------------

## 🧭 Navegación y comportamiento

- Menús superior e inferior deben ser widgets reutilizables con comportamiento uniforme en toda la app.
- Se debe evitar que una pantalla se pueda re-llamar a sí misma desde el menú inferior (se recomienda comprobar la ruta actual).

------------------------------------------------------------------------------------------

## 🔡 Formato de texto en Firebase

- **Al guardar cualquier texto (String)** en Firestore → convertirlo a minúsculas con `toLowerCase()`.
- **Al mostrar cualquier texto** → formatear con la primera letra en mayúscula usando una función centralizada (por ejemplo, `capitalize()`).
- Esto aplica a todos los campos visibles por el usuario: nombres, apellidos, direcciones, zonas, etc.

------------------------------------------------------------------------------------------

## 📝 Textos

- Prohibido usar textos hardcodeados directamente en widgets.
- Todos los textos visibles para el usuario deben definirse en un archivo de constantes, por ejemplo: `constants/textos.dart`.
- Las claves de los textos deben seguir el formato: TEXTO__nombre_de_la_pantalla__tipo_de_widget__funcion

Ejemplo en el archivo de constantes:
```dart
const String TEXTO__clientes_screen__boton__agregar_cliente = 'Agregar cliente';

Y en el widget:
```dart
Text(TEXTO__clientes_screen__boton__agregar_cliente)

------------------------------------------------------------------------------------------

## 🗺️ Rutas y nombres de pantallas

- Prohibido el uso de rutas o nombres de pantallas hardcodeados en la navegación.
- Todas las rutas deben definirse en un archivo centralizado, siguiendo el formato: PANTALLA__NombreDeLaPantalla

Ejemplo:
```dart
const String PANTALLA__AgregarCliente = '/agregar_cliente';

Y al navegar:
```dart
Navigator.pushNamed(context, PANTALLA__AgregarCliente);

------------------------------------------------------------------------------------------

## 🔑 Claves (Keys) de widgets

- Todos los widgets interactivos o relevantes deben tener una `Key`.
- Las claves deben seguir el formato: KEY__nombre_de_la_pantalla__tipo_de_widget__funcion

Ejemplo:
```dart
Key('KEY__clientes_screen__boton__agregar_cliente')

------------------------------------------------------------------------------------------

## ✅ Flujo de tests de CRUD con clientes

Se debe testear de extremo a extremo:
1. Eliminar todos los clientes.
2. Leer todos los clientes y verificar que la lista quede vacía.
3. Agregar un registro nuevo.
4. Leer el registro agregado por nombre y apellido.
5. Actualizar el registro por ID.
6. Leer el registro actualizado y verificar los nuevos valores.
7. Eliminar el registro por ID.
8. Leer todos los clientes y verificar que esté vacío nuevamente.

------------------------------------------------------------------------------------------

## 🚫 Otras reglas

- Ningún texto, color, ruta o clave debe quedar hardcodeado dentro de widgets o servicios.
- Evitar dependencias circulares entre archivos.
- La convención de nombres debe mantenerse consistente en todo el proyecto.

------------------------------------------------------------------------------------------