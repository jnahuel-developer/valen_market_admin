🧾 Descripción General
Valen Market Admin es una aplicación web (con soporte para Flutter Android) diseñada para gestionar operaciones internas de una tienda minorista o autoservicio. Está desarrollada con Flutter y ofrece una interfaz adaptada tanto a dispositivos móviles como a entornos de escritorio (navegadores).

Esta plataforma permite administrar datos esenciales del negocio, incluyendo clientes, fichas de venta, productos del catálogo y planillas de cobros. Además, incorpora integraciones con Google Sheets, brindando la posibilidad de exportar la base de datos a hojas de cálculo en la nube de forma rápida y segura.

🚀 Objetivos del Proyecto
✅ Gestionar clientes: agregar, buscar, editar y eliminar clientes almacenados en Firebase.

✅ Administrar fichas: registrar fichas de cobros vinculadas a clientes (en desarrollo).

✅ Mantener actualizado el catálogo de productos.

✅ Registrar y volcar información a planillas de cobros.

✅ Exportar todos los datos relevantes a Google Sheets, con estructura organizada y ordenada.

✅ Ofrecer una experiencia simple, eficiente y adaptable a diferentes dispositivos y tamaños de pantalla.

🧰 Tecnologías Utilizadas
Área	Herramienta/Framework
Frontend Web & App	Flutter
Backend/DB	Firebase Firestore
Autenticación	Google Sign-In + Firebase Auth
Exportaciones	Google Sheets API
Almacenamiento local	SharedPreferences
Navegación Web	Flutter Web Router (Navigator)

🔐 Autenticación Web
El sistema de autenticación web está completamente integrado con Firebase y Google Sign-In:

Al iniciar sesión, el token de acceso (access_token) de Google se guarda de forma segura en SharedPreferences.

En visitas posteriores, si el token sigue siendo válido, el usuario es redirigido automáticamente a la pantalla principal sin tener que volver a autenticarse.

Un botón de "Cerrar sesión" está disponible en todas las pantallas, y al activarse:

Se borra el token local de SharedPreferences.

Se cierra la sesión activa de Firebase y Google.

Se redirige al login, borrando todo el stack de navegación para evitar accesos posteriores no deseados.

Este comportamiento garantiza una experiencia fluida y segura para el usuario.

📦 Estructura del Proyecto
La aplicación está organizada por flows para separar claramente la navegación y comportamiento entre versiones:

java
Copiar
Editar
lib/
├── Android_flow/    → Pantallas y widgets exclusivos de Android.
├── Web_flow/        → Pantallas y widgets específicos para Web.
├── services/        → Lógica compartida entre flujos (Firebase, Google, Auth).
├── constants/       → Colores, rutas, textos reutilizables.
├── config/          → Configuración del entorno (Dev / Prod).
├── utils/           → Validadores y helpers.
└── main_*.dart      → Archivos de entrada según entorno (dev/prod).
Además, incluye un sistema de nombres de pantallas centralizado (pantallas.dart) para garantizar consistencia en las rutas.

🔁 Navegación Jerárquica Web
Se implementó un sistema jerárquico de navegación exclusivo para la versión Web. Cada pantalla conoce su "pantalla padre", y al presionar la flecha "⬆️", el usuario es llevado a dicha pantalla.

Características:

Se utiliza pushNamedAndRemoveUntil para evitar acumular pantallas en el stack.

Si la pantalla padre es la misma que la actual, no se realiza navegación.

Las pantallas de login no presentan el top bar ni acciones de retroceso.

Ejemplo de jerarquía implementada:

nginx
Copiar
Editar
web_home_screen
│── web_clientes_screen
│   ├── web_agregar_cliente_screen
│   └── web_buscar_cliente_screen
│── web_catalogo_screen
│   ├── web_agregar_producto_screen
│   └── web_buscar_producto_screen
│── web_fichas_screen
│   ├── web_agregar_fichas_screen
│   └── web_buscar_fichas_screen
└── web_planilla_de_cobros
    └── web_volcar_planilla_screen
📤 Exportación a Google Sheets
Desde la interfaz Web, los datos (por ejemplo, de la colección de clientes) pueden ser exportados automáticamente a una hoja de cálculo en Google Drive.

Proceso:

El usuario presiona el botón "Pasar a Excel".

Se muestra un CircularProgressIndicator mientras se realiza la exportación.

Si fue exitoso:

Se genera una URL única de Google Sheets.

Se muestra un SnackBar con botón para abrir la hoja creada directamente.

En caso de error:

Se muestra un mensaje descriptivo sin interrumpir el flujo.

Esta funcionalidad está desacoplada de la UI y se encuentra en el servicio clientes_servicios_google_sheets_web.dart.

🧪 Tests Automáticos
El proyecto incluye tests automáticos de flujo de cliente en integration_test/agregar_cliente_flow_test.dart, utilizando el driver de integración estándar de Flutter.

🧭 Cómo correr la aplicación
bash
Copiar
Editar
# Para entorno de desarrollo web
flutter run -d chrome --dart-define=FLAVOR=dev

# Para entorno de producción web
flutter build web --dart-define=FLAVOR=prod
📝 Documentación adicional
Las reglas de diseño visual, colores y estilos personalizados estarán detalladas en un archivo complementario:
📄 Design_Rules.md