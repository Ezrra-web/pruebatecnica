# 📋 Sistema de Gestión de Usuarios y Registros

Sistema web desarrollado en **ASP.NET Core MVC** para la administración de usuarios, permisos, registros de clientes y generación de documentos PDF personalizados con auditoría completa de acciones.

## 🚀 Características Principales

- **Autenticación y Autorización**: Sistema de login con validación de credenciales, horarios de acceso y cambio obligatorio de contraseña
- **Gestión de Usuarios**: CRUD completo de usuarios con control de horarios de acceso (entrada/salida)
- **Sistema de Permisos**: Asignación granular de permisos por módulo (Usuarios, Registro, Impresiones, Permisos)
- **Gestión de Registros**: Administración de registros de clientes con información de contratos, saldos y contacto
- **Generación de PDFs**: Creación de documentos PDF individuales o masivos con configuración personalizable
- **Configuración de Impresión**: Personalización de tamaño de hoja, tipo de letra, tamaño de fuente e imagen de fondo
- **Auditoría en Base de Datos**: Registro completo de todas las acciones realizadas por los usuarios a nivel de base de datos

## 🛠️ Tecnologías Utilizadas

- **Framework**: ASP.NET Core MVC 6.0+
- **Lenguaje**: C# 10.0+
- **Base de Datos**: SQL Server
- **ORM/Acceso a Datos**: ADO.NET con Stored Procedures
- **Generación PDF**: iTextSharp
- **Autenticación**: Cookie Authentication
- **Frontend**: Razor Views, HTML5, CSS3, JavaScript

## 📋 Requisitos Previos

- [.NET 6.0 SDK](https://dotnet.microsoft.com/download) o superior
- [SQL Server 2016](https://www.microsoft.com/sql-server) o superior (Express, Developer o Enterprise)
- [Visual Studio 2022](https://visualstudio.microsoft.com/) o Visual Studio Code
- Navegador web moderno (Chrome, Firefox, Edge)

## ⚙️ Configuración del Proyecto

### 1. Clonar el Repositorio

```bash
git clone https://github.com/Ezrra-web/pruebatecnica.git
cd pruebatecnica
```

### 2. Configurar la Base de Datos

1. Abrir SQL Server Management Studio (SSMS)
2. Crear una nueva base de datos llamada `pruebatecnica`
3. Ejecutar el script completo `pruebatecnica.sql` que incluye:
   - Creación de todas las tablas
   - Definición de claves primarias y foráneas
   - Todos los Stored Procedures necesarios
   - Restricciones y valores por defecto

### 3. Configurar la Cadena de Conexión

Editar el archivo `appsettings.json` y actualizar la cadena de conexión:

```json
{
  "ConnectionStrings": {
    "MiConexion": "Server=localhost;Database=pruebatecnica;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

**Nota**: Ajustar según tu configuración de SQL Server:
- Para autenticación SQL: `Server=localhost;Database=pruebatecnica;User Id=tu_usuario;Password=tu_contraseña;TrustServerCertificate=True;`

### 4. Restaurar Dependencias

```bash
dotnet restore
```

### 5. Ejecutar la Aplicación

```bash
dotnet run
```

O desde Visual Studio: presionar `F5` o hacer clic en el botón "Iniciar"

### 6. Acceder al Sistema

Abrir el navegador en: `https://localhost:5001` o `http://localhost:5000`

**Credenciales por defecto** (si se ejecutó el script de datos iniciales):
- Usuario: `admin`
- Contraseña: `admin123`

## 📁 Estructura del Proyecto

```
pruebatecnica/
│
├── Controllers/              # Controladores MVC
│   ├── AuthController.cs     # Autenticación y login
│   ├── HomeController.cs     # Página principal
│   ├── UsuariosController.cs # Gestión de usuarios
│   ├── PermisosController.cs # Administración de permisos
│   ├── RegistrosController.cs # CRUD de registros y PDFs
│   └── ImpresionesController.cs # Configuración de impresión
│
├── Models/                   # Modelos de datos
│   ├── Usuario.cs            # Modelo de usuario
│   ├── Registro.cs           # Modelo de registro
│   ├── Permiso.cs            # Modelo de permisos
│   ├── ConexionBD.cs         # Clase de acceso a datos
│   └── ErrorViewModel.cs     # Modelo de errores
│
├── Views/                    # Vistas Razor
│   ├── Auth/                 # Vistas de autenticación
│   ├── Home/                 # Página principal
│   ├── Usuarios/             # Vistas de usuarios
│   ├── Permisos/             # Vistas de permisos
│   ├── Registros/            # Vistas de registros
│   └── Impresiones/          # Vistas de configuración
│
├── wwwroot/                  # Archivos estáticos
│   ├── css/                  # Hojas de estilo
│   ├── js/                   # Scripts JavaScript
│   ├── lib/                  # Librerías frontend
│   └── uploads/              # Imágenes de fondo para PDFs
│
├── appsettings.json          # Configuración general
└── Program.cs                # Punto de entrada de la aplicación
```

## 📚 Módulos del Sistema

### 1. Autenticación (Auth)
- Login de usuarios
- Validación de credenciales
- Control de horarios de acceso
- Cambio obligatorio de contraseña para nuevos usuarios
- Cierre de sesión

### 2. Gestión de Usuarios
- Listar todos los usuarios
- Crear nuevos usuarios
- Editar información de usuarios
- Dar de baja usuarios
- Configurar horarios de entrada y salida
- Buscar usuarios específicos

### 3. Sistema de Permisos
- Visualizar usuarios del sistema
- Asignar permisos por módulo:
  - Usuarios
  - Registro
  - Impresiones
  - Permisos
- Activar/desactivar acceso a módulos específicos
- Listar permisos por usuario

### 4. Gestión de Registros
- Listar registros de clientes
- Crear nuevos registros (nombre, contrato, saldo, fecha, teléfono)
- Editar registros existentes
- Eliminar registros
- Buscar registros específicos
- Generar PDF individual
- Generar múltiples PDFs en archivo ZIP

### 5. Configuración de Impresión
- Seleccionar tamaño de hoja (A4, Carta, Oficio, A5, Ticket)
- Elegir tipo de letra (Helvetica, Times, Courier)
- Configurar tamaño de fuente
- Subir imagen de fondo personalizada para PDFs
- Guardar y actualizar configuración de impresión



## 🗄️ Base de Datos

### Tablas Principales

#### usuarios
Almacena la información de los usuarios del sistema.
```sql
- idUsuario (PK, INT, IDENTITY)
- usuario (NVARCHAR(100), UNIQUE)
- password (NVARCHAR(100))
- status (NVARCHAR(25)) -- 'Activo', 'Baja', o 'cambiarpassword'
- horarioInicio (TIME)
- horarioFin (TIME)
```

#### permisos
Gestiona los permisos de acceso de usuarios a diferentes módulos.
```sql
- idPermiso (PK, INT, IDENTITY)
- idUsuario (FK -> usuarios.idUsuario)
- modulo (NVARCHAR(50)) -- 'Usuarios', 'Registro', 'Impresiones', 'Permisos'
- acceso (BIT) -- 1: Permitido, 0: Denegado
```

#### registros
Almacena los registros de clientes o contratos.
```sql
- idRegistro (PK, INT, IDENTITY)
- nombre (NVARCHAR(100))
- contrato (NVARCHAR(50))
- saldo (DECIMAL(18,2))
- fecha (DATE)
- telefono (NVARCHAR(20))
```

#### config_impresion
Configuración para la generación de documentos PDF.
```sql
- idConfig (PK, INT, IDENTITY)
- tamanoHoja (NVARCHAR(20)) -- 'A4', 'Carta', 'Oficio', 'A5', 'Ticket'
- tipoLetra (NVARCHAR(50)) -- 'Helvetica', 'Times', 'Courier'
- tamanoLetra (INT) -- Tamaño de fuente en puntos
- imagenFondo (NVARCHAR(100), NULLABLE) -- Ruta de imagen de fondo
```

#### historico - **NUEVA**
Tabla de auditoría que registra todas las acciones realizadas en el sistema.
```sql
- idHistorico (PK, INT, IDENTITY)
- idUsuario (INT, NULLABLE, FK -> usuarios.idUsuario)
- modulo (NVARCHAR(50)) -- Módulo donde se realizó la acción
- accion (NVARCHAR(100)) -- Tipo de acción realizada
- descripcion (NVARCHAR(4000), NULLABLE) -- Detalles de la acción
- fecha (DATETIME) -- Fecha y hora de la acción
```

### Stored Procedures

#### Autenticación y Seguridad
- `SP_ValidarLogin` - Autenticación de usuarios con validación de horarios
- `SP_CambiarPassword` - Cambio de contraseña del usuario
- `SP_GetPermisosUsuario` - Obtener permisos de un usuario específico

#### Gestión de Usuarios
- `SP_Usuario_Listar` - Listar todos los usuarios
- `SP_Usuarios_ListarBasico` - Listar usuarios activos (básico)
- `SP_Usuario_Insertar` - Crear nuevo usuario
- `SP_Usuario_Actualizar` - Actualizar información de usuario
- `SP_Usuario_Editar` - Editar usuario existente
- `SP_Usuario_Eliminar` - Dar de baja a un usuario (baja lógica)
- `SP_Usuario_Buscar` - Buscar usuario por ID

#### Gestión de Permisos
- `SP_Permisos_ListarPorUsuario` - Listar permisos de un usuario
- `SP_Permiso_Listar` - Listar todos los permisos
- `SP_Permiso_Actualizar` - Actualizar permiso específico
- `SP_Permisos_Actualizar` - Actualizar múltiples permisos
- `SP_Permisos_Insertar` - Insertar nuevos permisos
- `SP_Permisos_EliminarPorUsuario` - Eliminar permisos de un usuario

#### Gestión de Registros
- `SP_Registro_Listar` - Listar todos los registros
- `SP_Registro_Insertar` - Crear nuevo registro
- `SP_Registro_Actualizar` - Actualizar registro existente
- `SP_Registro_Eliminar` - Eliminar registro
- `SP_Registro_Buscar` - Buscar registro por ID

#### Configuración de Impresión
- `SP_Impresion_Obtener` - Obtener configuración actual de impresión
- `SP_Impresion_ObtenerConfig` - Obtener configuración de impresión
- `SP_Impresion_Guardar` - Guardar nueva configuración de impresión
- `SP_Impresion_Insertar` - Insertar configuración de impresión
- `SP_Impresion_Actualizar` - Actualizar configuración existente

#### Auditoría (Histórico) - **NUEVOS**
- `SP_Historico_Insertar` - Registrar nueva acción en el histórico
- `SP_Historico_Listar` - Listar el histórico de acciones del sistema

## 🔒 Seguridad Implementada

- **Autenticación basada en cookies** con `CookieAuthenticationDefaults`
- **Autorización por políticas** usando Claims
- **Validación de horarios** de acceso por usuario
- **Control de estados** de usuario (Activo/Baja/cambiarpassword)
- **Cambio obligatorio de contraseña** para usuarios nuevos
- **Sesiones con expiración** de 8 horas
- **Protección de rutas** mediante `[Authorize]` attribute
- **Auditoría completa** de todas las operaciones del sistema

## 📝 Uso del Sistema

### Primer Acceso

1. Iniciar sesión con credenciales de administrador
2. Si es primera vez, cambiar la contraseña
3. Navegar al módulo de Usuarios para crear nuevos usuarios
4. Asignar permisos desde el módulo de Permisos

### Gestión de Registros

1. Acceder al módulo "Registro"
2. Hacer clic en "Crear Nuevo Registro"
3. Completar el formulario con los datos del cliente
4. Guardar el registro
5. Desde la lista, se puede:
   - Editar registros existentes
   - Eliminar registros
   - Generar PDF individual
   - Seleccionar múltiples registros y descargar en ZIP

### Personalización de PDFs

1. Acceder al módulo "Impresiones"
2. Configurar:
   - Tamaño de hoja deseado
   - Tipo de letra
   - Tamaño de fuente
   - Imagen de fondo (opcional)
3. Guardar la configuración
4. Los PDFs generados usarán esta configuración

## 🧪 Testing

Para probar la aplicación localmente:

```bash
# Ejecutar en modo desarrollo
dotnet run --environment Development

# Ejecutar pruebas (si están implementadas)
dotnet test
```

## 📦 Despliegue en Producción

### IIS (Internet Information Services)

1. Publicar la aplicación:
```bash
dotnet publish -c Release -o ./publish
```

2. Configurar el Application Pool en IIS con .NET CLR Version: "No Managed Code"

3. Configurar la cadena de conexión en `appsettings.json` para el servidor de producción

4. Asegurar que el directorio `wwwroot/uploads` tiene permisos de escritura

### Azure App Service

1. Crear un Azure App Service con runtime .NET 6
2. Configurar la cadena de conexión en Application Settings
3. Desplegar desde Visual Studio o usando Azure CLI

## 🛠 Solución de Problemas

### Error de conexión a la base de datos
- Verificar que SQL Server esté en ejecución
- Revisar la cadena de conexión en `appsettings.json`
- Verificar credenciales y permisos de usuario SQL

### No se pueden subir imágenes
- Verificar permisos de escritura en `wwwroot/uploads`
- Verificar que el directorio existe

### Error al generar PDFs
- Verificar que el paquete iTextSharp esté instalado
- Verificar que la ruta de la imagen de fondo sea correcta

## 📊 Auditoría en Base de Datos

El sistema cuenta con una tabla `historico` en la base de datos que permite registrar todas las acciones realizadas:

- **Creación de registros**: Fecha, usuario y detalles del registro creado
- **Modificaciones**: Cambios realizados en usuarios, permisos y registros
- **Eliminaciones**: Registro de elementos eliminados del sistema
- **Accesos**: Login y logout de usuarios
- **Cambios de configuración**: Modificaciones en configuración de impresión

Cada entrada de auditoría en la tabla incluye:
- Usuario que realizó la acción (idUsuario)
- Módulo afectado
- Tipo de acción
- Descripción detallada
- Fecha y hora exacta

**Nota**: La tabla `historico` está disponible para consultas directas en SQL o para futura implementación de un módulo de visualización en la aplicación.

### Consulta de Ejemplo

```sql
-- Ver últimas 10 acciones registradas
SELECT TOP 10 
    h.fecha,
    u.usuario,
    h.modulo,
    h.accion,
    h.descripcion
FROM historico h
LEFT JOIN usuarios u ON h.idUsuario = u.idUsuario
ORDER BY h.fecha DESC;
```

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/NuevaCaracteristica`)
3. Commit tus cambios (`git commit -m 'Agregar nueva característica'`)
4. Push a la rama (`git push origin feature/NuevaCaracteristica`)
5. Abrir un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 👤 Autor

**Ezrra Salazar**
- GitHub: [@Ezrra-web](https://github.com/Ezrra-web)
- Email: mijail.salazar@mccollect.mx

## 📞 Soporte

Para reportar bugs o solicitar nuevas características, por favor abrir un issue en el repositorio de GitHub.

---

**Desarrollado con ❤️ usando ASP.NET Core MVC**
