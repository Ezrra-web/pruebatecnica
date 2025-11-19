# 🗄️ Guía de Instalación de Base de Datos - Sistema de Gestión

Esta guía proporciona instrucciones paso a paso para instalar y configurar la base de datos del Sistema de Gestión de Usuarios y Registros.

## 📋 Tabla de Contenidos

1. [Requisitos Previos](#requisitos-previos)
2. [Descarga e Instalación de SQL Server](#descarga-e-instalación-de-sql-server)
3. [Creación de la Base de Datos](#creación-de-la-base-de-datos)
4. [Ejecución del Script SQL](#ejecución-del-script-sql)
5. [Verificación de la Instalación](#verificación-de-la-instalación)
6. [Configuración de Permisos](#configuración-de-permisos)
7. [Datos Iniciales (Opcional)](#datos-iniciales-opcional)
8. [Solución de Problemas](#solución-de-problemas)
9. [Mantenimiento y Respaldos](#mantenimiento-y-respaldos)

---

## 🎯 Requisitos Previos

### Software Necesario

- **SQL Server 2016** o superior
  - SQL Server Express (Gratuito)
  - SQL Server Developer (Gratuito)
  - SQL Server Standard/Enterprise

- **SQL Server Management Studio (SSMS) 18.0** o superior
  - [Descargar SSMS](https://docs.microsoft.com/sql/ssms/download-sql-server-management-studio-ssms)

### Requisitos del Sistema

- **Sistema Operativo**: Windows 10/11, Windows Server 2016 o superior
- **Memoria RAM**: Mínimo 2 GB (Recomendado 4 GB o más)
- **Espacio en Disco**: Mínimo 6 GB libres
- **Procesador**: x64 compatible

---

## 📥 Descarga e Instalación de SQL Server

### Opción 1: SQL Server Express (Recomendado para desarrollo)

1. **Descargar SQL Server Express**
   - Ir a: https://www.microsoft.com/sql-server/sql-server-downloads
   - Descargar "Express Edition"

2. **Ejecutar el instalador**
   - Hacer doble clic en el archivo descargado
   - Seleccionar "Basic" para instalación básica
   - Aceptar términos de licencia
   - Elegir ubicación de instalación
   - Hacer clic en "Install"

3. **Esperar la instalación**
   - El proceso puede tardar 10-20 minutos
   - Anotar el nombre de instancia mostrado (por defecto: `localhost\SQLEXPRESS`)

4. **Instalar SQL Server Management Studio (SSMS)**
   - Al finalizar la instalación, hacer clic en "Install SSMS"
   - O descargar desde: https://aka.ms/ssmsfullsetup
   - Ejecutar el instalador de SSMS
   - Seguir el asistente de instalación

### Opción 2: SQL Server Developer (Completo y gratuito)

1. Descargar desde el enlace oficial de Microsoft
2. Seleccionar instalación personalizada
3. Elegir características necesarias:
   - Database Engine Services ✓
   - Management Tools ✓
4. Configurar instancia (usar predeterminada)
5. Configurar autenticación (Modo mixto recomendado)

---

## 🏗️ Creación de la Base de Datos

### Paso 1: Conectarse a SQL Server

1. **Abrir SQL Server Management Studio (SSMS)**

2. **Ventana de conexión**:
   - **Server type**: Database Engine
   - **Server name**: 
     - Para Express: `localhost\SQLEXPRESS`
     - Para instancia por defecto: `localhost` o `(local)`
   - **Authentication**: Windows Authentication (o SQL Server Authentication)
   - Hacer clic en **Connect**

### Paso 2: Verificar Conexión

```sql
-- Ejecutar en una nueva ventana de consulta
SELECT @@VERSION;
-- Esto debe mostrar la versión de SQL Server instalada
```

### Paso 3: Crear la Base de Datos

Hay dos formas de crear la base de datos:

#### Opción A: Ejecutar el script completo (Recomendado)

El script `pruebatecnica.sql` incluye la creación de la base de datos automáticamente.

#### Opción B: Crear manualmente antes de ejecutar el script

```sql
-- Crear la base de datos
CREATE DATABASE pruebatecnica;
GO

-- Verificar creación
SELECT name FROM sys.databases WHERE name = 'pruebatecnica';
GO
```

---

## 🚀 Ejecución del Script SQL

### Método 1: Usando SSMS (Recomendado)

1. **Abrir el archivo SQL**
   - En SSMS, ir a: `File` → `Open` → `File...`
   - Navegar a la ubicación de `pruebatecnica.sql`
   - Seleccionar y abrir el archivo

2. **Verificar la conexión**
   - Asegurarse de estar conectado al servidor correcto
   - Ver la barra de herramientas: debe mostrar el nombre del servidor

3. **Ejecutar el script**
   - Hacer clic en el botón **Execute** (F5)
   - O ir a: `Query` → `Execute`

4. **Monitorear la ejecución**
   - La ventana de mensajes mostrará el progreso
   - Esperar a que aparezca "Command completed successfully"

5. **Verificar resultados**
   - Verificar que no haya errores en la ventana de mensajes
   - Deben aparecer mensajes de creación de tablas y procedimientos

### Método 2: Usando línea de comandos (sqlcmd)

```batch
sqlcmd -S localhost\SQLEXPRESS -i "ruta\al\archivo\pruebatecnica.sql" -o "log_instalacion.txt"
```

Donde:
- `-S`: Nombre del servidor
- `-i`: Archivo de entrada (script SQL)
- `-o`: Archivo de salida (log de ejecución)

---

## ✅ Verificación de la Instalación

### 1. Verificar la Base de Datos

```sql
-- Cambiar a la base de datos creada
USE pruebatecnica;
GO

-- Listar todas las tablas
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
```

**Resultado esperado: 5 tablas**
- config_impresion
- historico
- permisos
- registros
- usuarios

### 2. Verificar Stored Procedures

```sql
-- Listar todos los stored procedures
SELECT 
    ROUTINE_NAME AS 'Stored Procedure',
    ROUTINE_TYPE AS 'Tipo'
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
ORDER BY ROUTINE_NAME;
GO
```

**Resultado esperado: 32 stored procedures**

#### Autenticación y Seguridad (3)
- SP_CambiarPassword
- SP_GetPermisosUsuario
- SP_ValidarLogin

#### Usuarios (7)
- SP_Usuario_Actualizar
- SP_Usuario_Buscar
- SP_Usuario_Editar
- SP_Usuario_Eliminar
- SP_Usuario_Insertar
- SP_Usuario_Listar
- SP_Usuarios_ListarBasico

#### Permisos (6)
- SP_Permiso_Actualizar
- SP_Permiso_Listar
- SP_Permisos_Actualizar
- SP_Permisos_EliminarPorUsuario
- SP_Permisos_Insertar
- SP_Permisos_ListarPorUsuario

#### Registros (5)
- SP_Registro_Actualizar
- SP_Registro_Buscar
- SP_Registro_Eliminar
- SP_Registro_Insertar
- SP_Registro_Listar

#### Configuración de Impresión (5)
- SP_Impresion_Actualizar
- SP_Impresion_Guardar
- SP_Impresion_Insertar
- SP_Impresion_Obtener
- SP_Impresion_ObtenerConfig

#### Auditoría (2)
- SP_Historico_Insertar
- SP_Historico_Listar

### 3. Verificar Estructura de Tablas

```sql
-- Verificar estructura de cada tabla

-- Tabla usuarios
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'usuarios'
ORDER BY ORDINAL_POSITION;

-- Tabla permisos
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'permisos'
ORDER BY ORDINAL_POSITION;

-- Tabla registros
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'registros'
ORDER BY ORDINAL_POSITION;

-- Tabla config_impresion
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'config_impresion'
ORDER BY ORDINAL_POSITION;

-- Tabla historico
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'historico'
ORDER BY ORDINAL_POSITION;
```

### 4. Probar Stored Procedures

```sql
-- Probar que los stored procedures funcionan

-- Test: Listar usuarios (debe estar vacío inicialmente)
EXEC SP_Usuario_Listar;

-- Test: Obtener configuración de impresión (debe estar vacío inicialmente)
EXEC SP_Impresion_Obtener;

-- Test: Listar histórico (debe estar vacío inicialmente)
EXEC SP_Historico_Listar;
```

---

## 🔐 Configuración de Permisos

### Crear Usuario de Base de Datos para la Aplicación

```sql
-- Cambiar a la base de datos master
USE master;
GO

-- Crear login (para autenticación SQL Server)
CREATE LOGIN pruebatecnica_app 
WITH PASSWORD = 'TuPassword_Seguro123!';
GO

-- Cambiar a la base de datos del proyecto
USE pruebatecnica;
GO

-- Crear usuario en la base de datos
CREATE USER pruebatecnica_app FOR LOGIN pruebatecnica_app;
GO

-- Otorgar permisos completos al usuario
ALTER ROLE db_owner ADD MEMBER pruebatecnica_app;
GO

-- O permisos específicos (más seguro):
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO pruebatecnica_app;
GRANT EXECUTE ON SCHEMA::dbo TO pruebatecnica_app;
GO
```

### Actualizar la Cadena de Conexión

Después de crear el usuario, actualizar `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "MiConexion": "Server=localhost\\SQLEXPRESS;Database=pruebatecnica;User Id=pruebatecnica_app;Password=TuPassword_Seguro123!;TrustServerCertificate=True;"
  }
}
```

---

## 📊 Datos Iniciales (Opcional)

### Insertar Usuario Administrador

```sql
USE pruebatecnica;
GO

-- Insertar usuario admin con contraseña "admin123"
INSERT INTO usuarios (usuario, password, status, horarioInicio, horarioFin)
VALUES ('admin', 'admin123', 'cambiarpassword', '00:00:00', '23:59:59');
GO

-- Obtener el ID del usuario insertado
DECLARE @idUsuario INT;
SELECT @idUsuario = idUsuario FROM usuarios WHERE usuario = 'admin';

-- Insertar permisos completos para el admin
INSERT INTO permisos (idUsuario, modulo, acceso)
VALUES 
    (@idUsuario, 'Usuarios', 1),
    (@idUsuario, 'Registro', 1),
    (@idUsuario, 'Impresiones', 1),
    (@idUsuario, 'Permisos', 1);
GO

-- Insertar configuración de impresión por defecto
INSERT INTO config_impresion (tamanoHoja, tipoLetra, tamanoLetra, imagenFondo)
VALUES ('A4', 'Helvetica', 12, NULL);
GO

-- Verificar datos insertados
SELECT * FROM usuarios;
SELECT * FROM permisos;
SELECT * FROM config_impresion;
GO
```

### Insertar Datos de Prueba

```sql
-- Insertar registros de prueba
INSERT INTO registros (nombre, contrato, saldo, fecha, telefono)
VALUES 
    ('Juan Pérez', 'CONT-001', 15000.50, '2025-01-15', '555-1234'),
    ('María García', 'CONT-002', 25000.00, '2025-02-20', '555-5678'),
    ('Carlos López', 'CONT-003', 8500.75, '2025-03-10', '555-9012');
GO

-- Verificar
SELECT * FROM registros;
GO
```

---

## 🛠️ Solución de Problemas

### Error: "No se puede conectar al servidor"

**Causa**: SQL Server no está ejecutándose o el nombre del servidor es incorrecto.

**Solución**:
1. Verificar que el servicio SQL Server esté iniciado:
   - Abrir "Servicios" de Windows (services.msc)
   - Buscar "SQL Server (SQLEXPRESS)" o "SQL Server (MSSQLSERVER)"
   - Estado debe ser "En ejecución"
   - Si no está iniciado, hacer clic derecho → Iniciar

2. Verificar el nombre del servidor:
   ```sql
   -- En SSMS, intentar conectarse con:
   -- localhost\SQLEXPRESS
   -- (local)\SQLEXPRESS
   -- .\SQLEXPRESS
   -- nombre_computadora\SQLEXPRESS
   ```

### Error: "Login failed for user"

**Causa**: Problema de autenticación.

**Solución**:
1. Usar Windows Authentication en lugar de SQL Server Authentication
2. O verificar que SQL Server esté configurado en modo mixto:
   - En SSMS, clic derecho en el servidor → Properties
   - Security → "SQL Server and Windows Authentication mode"
   - Reiniciar el servicio de SQL Server

### Error: "Database already exists"

**Causa**: La base de datos ya fue creada anteriormente.

**Solución**:
```sql
-- Eliminar la base de datos existente
USE master;
GO

-- Cerrar todas las conexiones a la base de datos
ALTER DATABASE pruebatecnica SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Eliminar la base de datos
DROP DATABASE pruebatecnica;
GO

-- Ahora ejecutar el script nuevamente
```

### Error: "There is already an object named..."

**Causa**: Intentando crear una tabla o procedimiento que ya existe.

**Solución**:
```sql
-- Para tablas
IF OBJECT_ID('nombre_tabla', 'U') IS NOT NULL
    DROP TABLE nombre_tabla;
GO

-- Para stored procedures
IF OBJECT_ID('nombre_sp', 'P') IS NOT NULL
    DROP PROCEDURE nombre_sp;
GO
```

### Error: "Invalid column name"

**Causa**: Falta una columna en la tabla o error de tipeo.

**Solución**:
1. Verificar la estructura de la tabla:
```sql
EXEC sp_help 'nombre_tabla';
```

2. Recrear la tabla si es necesario

### Problemas de Rendimiento

**Síntomas**: Consultas muy lentas.

**Solución**:
```sql
-- Actualizar estadísticas
USE pruebatecnica;
GO
EXEC sp_updatestats;
GO

-- Reorganizar índices
ALTER INDEX ALL ON usuarios REORGANIZE;
ALTER INDEX ALL ON permisos REORGANIZE;
ALTER INDEX ALL ON registros REORGANIZE;
GO
```

---

## 💾 Mantenimiento y Respaldos

### Crear Respaldo de la Base de Datos

```sql
-- Respaldo completo
BACKUP DATABASE pruebatecnica
TO DISK = 'C:\Backups\pruebatecnica_backup.bak'
WITH FORMAT, INIT,
NAME = 'Respaldo Completo de pruebatecnica';
GO
```

### Restaurar desde Respaldo

```sql
-- Restaurar base de datos
USE master;
GO

RESTORE DATABASE pruebatecnica
FROM DISK = 'C:\Backups\pruebatecnica_backup.bak'
WITH REPLACE;
GO
```

### Script de Respaldo Automático (Tarea de SQL Server Agent)

```sql
-- Crear job de respaldo diario
USE msdb;
GO

EXEC sp_add_job 
    @job_name = 'Respaldo Diario pruebatecnica',
    @enabled = 1;
GO

EXEC sp_add_jobstep 
    @job_name = 'Respaldo Diario pruebatecnica',
    @step_name = 'Realizar Respaldo',
    @subsystem = 'TSQL',
    @command = 'BACKUP DATABASE pruebatecnica TO DISK = ''C:\Backups\pruebatecnica_backup.bak'' WITH INIT;',
    @retry_attempts = 3,
    @retry_interval = 5;
GO

-- Programar para ejecutarse diariamente a las 2:00 AM
EXEC sp_add_schedule 
    @schedule_name = 'Diario 2AM',
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_time = 020000;
GO

EXEC sp_attach_schedule 
    @job_name = 'Respaldo Diario pruebatecnica',
    @schedule_name = 'Diario 2AM';
GO
```

### Mantenimiento Regular

```sql
-- Ejecutar mensualmente para optimizar
USE pruebatecnica;
GO

-- Reorganizar índices
ALTER INDEX ALL ON usuarios REBUILD;
ALTER INDEX ALL ON permisos REBUILD;
ALTER INDEX ALL ON registros REBUILD;
ALTER INDEX ALL ON historico REBUILD;
GO

-- Actualizar estadísticas
UPDATE STATISTICS usuarios;
UPDATE STATISTICS permisos;
UPDATE STATISTICS registros;
UPDATE STATISTICS historico;
GO

-- Liberar espacio no utilizado
DBCC SHRINKDATABASE(pruebatecnica, 10);
GO
```

---

## 📊 Monitoreo de la Base de Datos

### Verificar Tamaño de la Base de Datos

```sql
EXEC sp_spaceused;
GO

-- Tamaño de cada tabla
EXEC sp_MSforeachtable 'EXEC sp_spaceused ''?''';
GO
```

### Consultas de Auditoría

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
GO
```

---

## 📝 Checklist de Instalación

Usar este checklist para verificar que todos los pasos se completaron:

- [ ] SQL Server instalado y ejecutándose
- [ ] SQL Server Management Studio instalado
- [ ] Conexión exitosa a SQL Server
- [ ] Script `pruebatecnica.sql` ejecutado sin errores
- [ ] 5 tablas creadas correctamente
- [ ] 32 stored procedures creados correctamente
- [ ] Usuario de base de datos creado (opcional)
- [ ] Permisos configurados
- [ ] Datos iniciales insertados (opcional)
- [ ] Cadena de conexión actualizada en `appsettings.json`
- [ ] Aplicación conectada exitosamente a la base de datos
- [ ] Pruebas básicas realizadas

---

## 📞 Soporte

Si encuentras problemas durante la instalación:

1. Revisar la sección "Solución de Problemas" de este documento
2. Consultar logs de SQL Server en: `C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\Log\`
3. Abrir un issue en GitHub: https://github.com/Ezrra-web/pruebatecnica/issues
4. Contactar al autor: mijail.salazar@mccollect.mx

---

## 📚 Referencias

- [Documentación de SQL Server](https://docs.microsoft.com/sql/sql-server)
- [Guía de instalación de SQL Server](https://docs.microsoft.com/sql/database-engine/install-windows/install-sql-server)
- [SQL Server Management Studio](https://docs.microsoft.com/sql/ssms/sql-server-management-studio-ssms)
- [Transact-SQL Reference](https://docs.microsoft.com/sql/t-sql/language-reference)

---

**Última actualización**: 19 de Noviembre de 2025  
**Versión**: 2.0  
**Autor**: Ezrra Salazar

---

✅ **¡Instalación completada!** Ahora puedes continuar con la configuración de la aplicación siguiendo el [README.md](README.md)
