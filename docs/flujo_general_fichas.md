# **Flujo General del Sistema de Fichas**

---

## **1. Pantalla: `web_fichas_agregar_screen`**

### **Propósito**
Permitir la creación de una nueva ficha de cliente, incluyendo los datos del cliente, las fechas de venta y próximo aviso, y los productos seleccionados.

### **Comportamiento**
- No inicializa datos.
- Su función es presentar los **tres paneles principales** (Clientes, Fechas, Productos).
- Cada panel (Widget) es responsable de inicializar sus propios datos según el estado actual del **Provider de ficha en curso**.
- Los datos iniciales se cargan en base a si existe o no una ficha válida en el Provider.

### **Estructura**
- Panel de **Cliente**
- Panel de **Fechas**
- Panel de **Productos**
- Botón principal **Agregar**

### **Lógica funcional**
- Al presionar el botón **Agregar**:
  - La ficha en curso se guarda en Firebase mediante el Provider de ficha en curso.
  - Se limpia el Provider (cliente, fechas, productos y pagos).
  - Se regresa a la pantalla principal (Home).

---

## **2. Pantalla: `web_fichas_buscar_screen`**

### **Propósito**
Permitir buscar fichas existentes almacenadas en Firebase mediante criterios de filtrado dinámicos.

### **Comportamiento**
- No inicializa datos.
- Muestra únicamente los paneles de **Clientes** y **Fechas**, que se autoinicializan según el estado del Provider.
- Ejecuta las búsquedas a través del **Provider de ficha en curso**.

### **Estructura**
- Panel de **Cliente**  
- Panel de **Fechas**  
- Botón principal **Buscar**

### **Lógica funcional**
- Al presionar **Buscar**:
  - Se muestra un **pop-up menú** con los criterios de búsqueda (cliente, fecha, zona, etc.).
  - Tras seleccionar un criterio, el Provider realiza la búsqueda en Firebase.
  - Se despliega un segundo pop-up con las fichas encontradas.
  - Al seleccionar una ficha:
    - El Provider de ficha en curso se inicializa con los datos de la ficha seleccionada.
    - Se navega a la pantalla `web_fichas_editar_screen`.

---

## **3. Pantalla: `web_fichas_editar_screen`**

### **Propósito**
Permitir modificar los datos de una ficha existente cargada en el Provider de ficha en curso.

### **Comportamiento**
- No inicializa datos.
- Carga el contenido actual del Provider en los tres paneles (Cliente, Fechas, Productos).
- Permite modificar y guardar los cambios.

### **Estructura**
- Panel de **Cliente**  
- Panel de **Fechas**  
- Panel de **Productos**  
- Botones **Editar** y **Informar pago**

### **Lógica funcional**
- **Editar:** actualiza los datos de la ficha en Firebase mediante el Provider.  
- **Informar pago:** muestra un pop-up para ingresar monto, medio y fecha; los datos se actualizan en el Provider y se guardan en Firebase.  
- Permanece en la misma pantalla tras la actualización.

---

# **Widgets principales**

---

## **1. `custom_web_ficha_cliente_section`**

### **Propósito**
Gestionar los datos del cliente asociados a la ficha en curso.

### **Comportamiento**
- **Al iniciar:**
  - Carga la lista completa de clientes desde Firebase a través del Provider (usando la caché si existe).
  - Si hay una ficha válida en el Provider, selecciona el cliente correspondiente y carga sus datos en los controles.  

### **Estructura**
- Menú desplegable con la lista completa de clientes.  
- Controles de texto para:
  - Nombre
  - Apellido
  - Zona (lista desplegable)
  - Dirección
  - Teléfono

### **Lógica funcional**
- Al seleccionar un cliente:
  - Se cargan automáticamente los datos en los controles.  
  - Se actualiza el Provider de ficha en curso.  
- Los campos de Dirección y Teléfono son de solo lectura.  
- Los campos Nombre, Apellido y Zona pueden usarse como filtros con sus respectivos checkboxes.

### **Acciones**
- Al activar un checkbox:
  - El control asociado actúa como filtro sobre la lista de clientes.  
  - Al confirmar (Enter o cambio de selección), se actualiza el Provider.

---

## **2. `custom_web_ficha_fechas_section`**

### **Propósito**
Gestionar las fechas de venta y próximo aviso de la ficha.

### **Comportamiento**
- **Al iniciar:**
  - Si hay ficha válida, carga las fechas desde el Provider.  
  - Si no hay ficha válida, configura:
    - Fecha de venta = hoy.  
    - Próximo aviso = hoy + 7 días.  

### **Estructura**
- Campo para fecha de venta:
  - Checkbox “Usar fecha actual”.
  - Campo de texto con ícono de calendario.
- Campo para próxima fecha de aviso:
  - Campo de texto y cuatro opciones:
    - 7 días  
    - 2 semanas  
    - 1 mes  
    - Libre (con calendario habilitado)

### **Lógica funcional**
- Cualquier cambio en las fechas actualiza automáticamente el Provider.  
- Si se activa “Usar fecha actual”, se deshabilita el campo de fecha manual.

---

## **3. `custom_web_ficha_productos_section`**

### **Propósito**
Mostrar y controlar los productos asociados a la ficha.

### **Comportamiento**
- **Al iniciar:**
  - Si hay ficha válida, carga los productos desde el Provider (usando la caché si existe).
  - Si no hay ficha válida, carga el catálogo completo desde Firebase.  

### **Estructura**
- Grid con ítems de tipo `custom_web_ficha_shop_item`.  

### **Lógica funcional**
- Cada ítem muestra un producto, con controles para modificar unidades y acceder al editor financiero (`custom_web_popup_editar_producto`).  
- Las modificaciones actualizan el Provider de ficha en curso.

---

## **4. `custom_web_ficha_shop_item`**

### **Propósito**
Representar un producto individual dentro del grid de productos.

### **Estructura**
- Imagen del producto  
- Nombre y precio  
- Controles de incremento y decremento  
- Botón para abrir el editor de producto (`custom_web_popup_editar_producto`)

### **Lógica funcional**
- Incrementar o decrementar unidades actualiza el Provider.  
- Al aceptar cambios desde el pop-up, el producto se actualiza en el Provider y el grid refleja los nuevos valores.

---

# **Provider de Ficha en Curso y Sub Providers**

---

## **Propósito general**
Centralizar la gestión de todos los datos que conforman una ficha (cliente, fechas, productos y pagos).

Los **Widgets** y **Pantallas** no pueden acceder directamente a los **Sub Providers** ni a **Firebase**.  
Toda comunicación y manipulación de datos debe realizarse a través del **Provider de ficha en curso**, que actúa como capa de abstracción y coordinación.

Esta separación modular permite una estructura mantenible, testable y menos propensa a errores de sincronización.

---

## **Sub Provider: ClienteFichaProvider**

### **Propósito**
Gestionar los datos del cliente asociados a la ficha en curso.

### **Estructura**
```dart
Map<String, dynamic> toMap() => {
  FIELD_NAME__cliente_ficha_model__ID: id,
  FIELD_NAME__cliente_ficha_model__Nombre: nombre,
  FIELD_NAME__cliente_ficha_model__Apellido: apellido,
  FIELD_NAME__cliente_ficha_model__Zona: zona,
  FIELD_NAME__cliente_ficha_model__Direccion: direccion,
  FIELD_NAME__cliente_ficha_model__Telefono: telefono,
};
