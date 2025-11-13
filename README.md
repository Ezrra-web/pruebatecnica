# 📋 Sistema de Gestión de Usuarios y Registros

Sistema web desarrollado en **ASP.NET Core MVC** para la administración de usuarios, permisos, registros de clientes y generación de documentos PDF personalizados.

## 🚀 Características Principales

- **Autenticación y Autorización**: Sistema de login con validación de credenciales, horarios de acceso y cambio obligatorio de contraseña
- **Gestión de Usuarios**: CRUD completo de usuarios con control de horarios de acceso (entrada/salida)
- **Sistema de Permisos**: Asignación granular de permisos por módulo (Usuarios, Registro, Impresiones, Permisos)
- **Gestión de Registros**: Administración de registros de clientes con información de contratos, saldos y contacto
- **Generación de PDFs**: Creación de documentos PDF individuales o masivos con configuración personalizable
- **Configuración de Impresión**: Personalización de tamaño de hoja, tipo de letra, tamaño de fuente e imagen de fondo

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
3. Ejecutar el script completo `BaseDatos_Script.sql` que incluye:
   - Creación de todas las tablas
   - Definición de claves primarias y foráneas
   - Todos los Stored Procedures necesarios
   - Restricciones y valores por defecto

**Ver guía detallada**: `INSTALACION_BASE_DATOS.md`

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

## 🔐 Módulos del Sistema

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

### 3. Sistema de Permisos
- Visualizar usuarios del sistema
- Asignar permisos por módulo:
  - Usuarios
  - Registro
  - Impresiones
  - Permisos
- Activar/desactivar acceso a módulos específicos

### 4. Gestión de Registros
- Listar registros de clientes
- Crear nuevos registros (nombre, contrato, saldo, fecha, teléfono)
- Editar registros existentes
- Eliminar registros
- Generar PDF individual
- Generar múltiples PDFs en archivo ZIP

### 5. Configuración de Impresión
- Seleccionar tamaño de hoja (A4, Carta, Oficio, A5, Ticket)
- Elegir tipo de letra (Helvetica, Times, Courier)
- Configurar tamaño de fuente
- Subir imagen de fondo personalizada para PDFs

## 🗄️ Base de Datos

### Tablas Principales

#### usuarios
```sql
- idUsuario (PK, INT, IDENTITY)
- usuario (VARCHAR(50), UNIQUE)
- password (VARCHAR(255))
- status (VARCHAR(20)) -- 'Activo' o 'Baja'
- horarioInicio (TIME)
- horarioFin (TIME)
```

#### permisos
```sql
- idPermiso (PK, INT, IDENTITY)
- idUsuario (FK -> usuarios.idUsuario)
- modulo (VARCHAR(50)) -- 'Usuarios', 'Registro', 'Impresiones', 'Permisos'
- acceso (BIT) -- 1: Permitido, 0: Denegado
```

#### registros
```sql
- idRegistro (PK, INT, IDENTITY)
- nombre (VARCHAR(100))
- contrato (VARCHAR(50))
- saldo (DECIMAL(18,2))
- fecha (DATE)
- telefono (VARCHAR(20))
```

#### impresiones
```sql
- idImpresion (PK, INT, IDENTITY)
- tamanoHoja (VARCHAR(20))
- tipoLetra (VARCHAR(50))
- tamanoLetra (INT)
- imagenFondo (VARCHAR(255), NULLABLE)
```

### Stored Procedures Principales

- `SP_ValidarLogin` - Autenticación de usuarios
- `SP_CambiarPassword` - Cambio de contraseña
- `SP_Usuario_Listar`, `SP_Usuario_Insertar`, `SP_Usuario_Actualizar`, `SP_Usuario_Eliminar` - CRUD Usuarios
- `SP_Permisos_ListarPorUsuario`, `SP_Permiso_Actualizar` - Gestión de permisos
- `SP_Registro_Listar`, `SP_Registro_Insertar`, `SP_Registro_Actualizar`, `SP_Registro_Eliminar` - CRUD Registros
- `SP_Impresion_Obtener`, `SP_Impresion_Guardar` - Configuración de impresión

## 🔒 Seguridad Implementada

- **Autenticación basada en cookies** con `CookieAuthenticationDefaults`
- **Autorización por políticas** usando Claims
- **Validación de horarios** de acceso por usuario
- **Control de estados** de usuario (Activo/Baja)
- **Cambio obligatorio de contraseña** para usuarios nuevos
- **Sesiones con expiración** de 8 horas
- **Protección de rutas** mediante `[Authorize]` attribute

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

## 🐛 Solución de Problemas

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

**Desarrollado  usando ASP.NET Core MVC**
