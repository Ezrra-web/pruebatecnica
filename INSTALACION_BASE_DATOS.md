# 🗄️ Guía de Instalación de Base de Datos

## Sistema de Gestión de Usuarios y Registros

Esta guía te ayudará a configurar la base de datos SQL Server necesaria para el sistema.

---

## 📋 Requisitos Previos

- SQL Server 2016 o superior (Express, Developer o Enterprise)
- SQL Server Management Studio (SSMS) 18 o superior
- Permisos de administrador en SQL Server

---

## 🚀 Pasos de Instalación

### 1. Crear la Base de Datos

Abre SQL Server Management Studio y ejecuta:

```sql
CREATE DATABASE pruebatecnica;
GO

USE pruebatecnica;
GO
```

### 2. Ejecutar el Script Completo

Utiliza el archivo `BaseDatos_Script.sql` incluido en este repositorio. Este script contiene:

- ✅ Creación de todas las tablas
- ✅ Definición de claves primarias y foráneas
- ✅ Creación de índices
- ✅ Definición de restricciones (CHECK, DEFAULT)
- ✅ Todos los Stored Procedures necesarios

**Opción A: Desde SSMS**
1. Abrir SQL Server Management Studio
2. Conectarse al servidor
3. Archivo → Abrir → Archivo
4. Seleccionar `BaseDatos_Script.sql`
5. Presionar F5 para ejecutar

**Opción B: Desde línea de comandos**
```cmd
sqlcmd -S localhost -d pruebatecnica -i BaseDatos_Script.sql
```

---

## 📊 Estructura de la Base de Datos

### Tablas Principales

#### 1. **usuarios**
```sql
- idUsuario (INT, PK, IDENTITY)
- usuario (NVARCHAR(100), NOT NULL)
- password (NVARCHAR(100), NOT NULL)
- status (NVARCHAR(25), NOT NULL)
- horarioInicio (TIME, NOT NULL)
- horarioFin (TIME, NOT NULL)
```

**Propósito**: Almacena información de usuarios del sistema con control de horarios de acceso.

#### 2. **permisos**
```sql
- idPermiso (INT, PK, IDENTITY)
- idUsuario (INT, FK → usuarios.idUsuario, NOT NULL)
- modulo (NVARCHAR(50), NOT NULL)
- acceso (BIT, NOT NULL, DEFAULT 0)
```

**Propósito**: Sistema de permisos modulares. Cada registro indica si un usuario tiene acceso a un módulo específico.

**Módulos disponibles:**
- `Usuarios` - Gestión de usuarios
- `Registro` - CRUD de registros de clientes
- `Impresiones` - Configuración de PDFs
- `Permisos` - Administración de permisos

#### 3. **registros**
```sql
- idRegistro (INT, PK, IDENTITY)
- nombre (NVARCHAR(100), NOT NULL)
- contrato (NVARCHAR(20), NOT NULL)
- saldo (DECIMAL(10,2), NOT NULL, DEFAULT 0.00)
- fecha (DATE, NOT NULL)
- telefono (NVARCHAR(15), NULL)
```

**Propósito**: Almacena registros de clientes con información de contratos y saldos.

#### 4. **config_impresion**
```sql
- idConfig (INT, PK, IDENTITY)
- tamanoHoja (NVARCHAR(20), NOT NULL)
- tipoLetra (NVARCHAR(50), NOT NULL)
- tamanoLetra (INT, NOT NULL)
- imagenFondo (NVARCHAR(100), NULL)
```

**Propósito**: Configuración global para la generación de PDFs.

**Valores permitidos para tamanoHoja:**
- `A4`
- `Carta`
- `Oficio`
- `Legal`
- `A5`
- `Ticket`

---

## 🔧 Stored Procedures Incluidos

### Autenticación
- `SP_ValidarLogin` - Valida credenciales y horarios de acceso
- `SP_CambiarPassword` - Actualiza contraseña de usuario

### Gestión de Usuarios
- `SP_Usuario_Listar` - Lista todos los usuarios
- `SP_Usuario_Insertar` - Crea nuevo usuario
- `SP_Usuario_Buscar` - Busca usuario por ID
- `SP_Usuario_Editar` - Actualiza información de usuario
- `SP_Usuario_Eliminar` - Cambia estatus a 'Baja'
- `SP_Usuarios_ListarBasico` - Lista usuarios activos (para permisos)

### Sistema de Permisos
- `SP_Permisos_ListarPorUsuario` - Obtiene permisos de un usuario
- `SP_Permiso_Actualizar` - Actualiza acceso a un módulo

### Gestión de Registros
- `SP_Registro_Listar` - Lista todos los registros
- `SP_Registro_Insertar` - Crea nuevo registro
- `SP_Registro_Buscar` - Busca registro por ID
- `SP_Registro_Actualizar` - Actualiza registro existente
- `SP_Registro_Eliminar` - Elimina registro físicamente

### Configuración de Impresión
- `SP_Impresion_Obtener` - Obtiene configuración actual
- `SP_Impresion_Guardar` - Guarda/actualiza configuración
- `SP_Impresion_ObtenerConfig` - Obtiene config para generación de PDFs

---

## 🧪 Datos de Prueba (Opcional)

Para probar el sistema, puedes insertar estos datos iniciales:

```sql
-- Usuario administrador
INSERT INTO usuarios (usuario, password, status, horarioInicio, horarioFin)
VALUES ('admin', 'admin123', 'Activo', '00:00:00', '23:59:59');

-- Obtener el ID del usuario creado
DECLARE @adminId INT = SCOPE_IDENTITY();

-- Asignar todos los permisos al admin
INSERT INTO permisos (idUsuario, modulo, acceso)
VALUES 
    (@adminId, 'Usuarios', 1),
    (@adminId, 'Registro', 1),
    (@adminId, 'Impresiones', 1),
    (@adminId, 'Permisos', 1);

-- Configuración de impresión por defecto
INSERT INTO config_impresion (tamanoHoja, tipoLetra, tamanoLetra, imagenFondo)
VALUES ('A4', 'Helvetica', 12, NULL);

-- Registro de prueba
INSERT INTO registros (nombre, contrato, saldo, fecha, telefono)
VALUES ('Juan Pérez', 'CTR-001', 15000.00, GETDATE(), '555-1234');

SELECT 'Datos de prueba insertados correctamente' AS Resultado;
```

**Credenciales de prueba:**
- Usuario: `admin`
- Contraseña: `admin123`

---

## 🔐 Configuración de Seguridad

### Crear Usuario de Base de Datos (Recomendado)

Para producción, crea un usuario específico para la aplicación:

```sql
-- Crear login
CREATE LOGIN appUser WITH PASSWORD = 'Tu_Contraseña_Segura_123!';

-- Crear usuario en la base de datos
USE pruebatecnica;
CREATE USER appUser FOR LOGIN appUser;

-- Asignar permisos
ALTER ROLE db_datareader ADD MEMBER appUser;
ALTER ROLE db_datawriter ADD MEMBER appUser;

-- Permiso para ejecutar stored procedures
GRANT EXECUTE TO appUser;
```

**Cadena de conexión con usuario SQL:**
```
Server=localhost;Database=pruebatecnica;User Id=appUser;Password=Tu_Contraseña_Segura_123!;TrustServerCertificate=True;
```

---

## ✅ Verificación de la Instalación

Ejecuta estos comandos para verificar que todo se instaló correctamente:

```sql
-- Verificar tablas
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';

-- Verificar stored procedures
SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE';

-- Verificar foreign keys
SELECT 
    FK.name AS ForeignKey,
    OBJECT_NAME(FK.parent_object_id) AS TableName
FROM sys.foreign_keys FK;

-- Verificar restricciones CHECK
SELECT 
    CC.name AS ConstraintName,
    OBJECT_NAME(CC.parent_object_id) AS TableName
FROM sys.check_constraints CC;
```

**Resultado esperado:**
- ✅ 4 tablas creadas
- ✅ 18 stored procedures
- ✅ 1 foreign key (permisos → usuarios)
- ✅ 1 restricción CHECK (config_impresion.tamanoHoja)

---

## 🛠️ Mantenimiento

### Respaldo de Base de Datos

**Respaldo completo:**
```sql
BACKUP DATABASE pruebatecnica
TO DISK = 'C:\Backups\pruebatecnica_full.bak'
WITH FORMAT, COMPRESSION, STATS = 10;
```

**Respaldo diferencial:**
```sql
BACKUP DATABASE pruebatecnica
TO DISK = 'C:\Backups\pruebatecnica_diff.bak'
WITH DIFFERENTIAL, COMPRESSION, STATS = 10;
```

### Restauración

```sql
-- Restaurar desde respaldo
RESTORE DATABASE pruebatecnica
FROM DISK = 'C:\Backups\pruebatecnica_full.bak'
WITH REPLACE, RECOVERY, STATS = 10;
```

### Mantenimiento de Índices

```sql
-- Reconstruir todos los índices
USE pruebatecnica;
ALTER INDEX ALL ON usuarios REBUILD;
ALTER INDEX ALL ON permisos REBUILD;
ALTER INDEX ALL ON registros REBUILD;
ALTER INDEX ALL ON config_impresion REBUILD;
```

### Actualizar Estadísticas

```sql
-- Actualizar estadísticas de todas las tablas
EXEC sp_updatestats;
```

---

## 🐛 Solución de Problemas

### Error: Base de datos ya existe
```sql
-- Eliminar base de datos existente (¡CUIDADO! Se pierden todos los datos)
USE master;
DROP DATABASE pruebatecnica;
GO
```

### Error: Permiso denegado
- Verifica que tu usuario tiene permisos de `sysadmin` o `db_owner`
- Ejecuta SSMS como administrador

### Error al crear foreign keys
- Asegúrate de ejecutar el script completo en orden
- Las tablas padre deben crearse antes que las tablas hijo

### Error: Stored procedure ya existe
```sql
-- Eliminar stored procedures existentes
DROP PROCEDURE IF EXISTS SP_ValidarLogin;
DROP PROCEDURE IF EXISTS SP_CambiarPassword;
-- ... etc
```

---

## 📞 Soporte

Para reportar problemas con la base de datos:

1. Verifica los logs de SQL Server
2. Ejecuta el script de verificación completo
3. Revisa permisos de usuario
4. Contacta al desarrollador: israel.martinez.vargas@gmail.com

---

## 📝 Notas Importantes

⚠️ **Seguridad:**
- Nunca uses `sa` en producción
- Cambia las contraseñas de prueba antes de desplegar
- Habilita encriptación SSL para conexiones remotas
- Considera usar Azure SQL o SQL Server Always Encrypted para datos sensibles

⚠️ **Rendimiento:**
- Configura índices adicionales según patrones de consulta
- Monitorea el plan de ejecución de stored procedures
- Considera particionar tablas si el volumen de datos es muy alto

⚠️ **Respaldos:**
- Configura respaldos automáticos diarios
- Prueba la restauración periódicamente
- Guarda respaldos en ubicación segura y externa

---

**Desarrollado por Israel Martinez**  
GitHub: [@Ezrra-web](https://github.com/Ezrra-web)  
Email: israel.martinez.vargas@gmail.com
