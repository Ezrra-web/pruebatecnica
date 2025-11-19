# 📜 Guía de Scripts SQL - Sistema de Gestión

Este documento explica los diferentes scripts SQL disponibles para la instalación del sistema.

## 📁 Scripts Disponibles

### 1. `pruebatecnica.sql` - Script Base
**Contenido:**
- ✅ Creación de la base de datos `pruebatecnica`
- ✅ 5 tablas del sistema:
  - usuarios
  - permisos
  - registros
  - config_impresion
  - historico
- ✅ 32 stored procedures organizados por módulo
- ✅ Definición de claves primarias y foráneas
- ✅ Restricciones y valores por defecto

**Uso:**
```sql
-- Ejecutar en SQL Server Management Studio
-- Este script SOLO crea la estructura, sin datos iniciales
```

**Cuándo usarlo:**
- Cuando solo necesitas la estructura de la base de datos
- En entornos de producción donde quieres controlar los datos iniciales manualmente
- Para desarrollo cuando ya tienes datos de prueba

---

### 2. `datos_iniciales.sql` - Script de Datos Iniciales
**Contenido:**
- ✅ Usuario administrador con credenciales por defecto
- ✅ Permisos completos para el administrador (todos los módulos)
- ✅ Configuración de impresión por defecto
- ✅ Registro de auditoría inicial
- ✅ Verificaciones de seguridad (no duplica datos si ya existen)

**Datos insertados:**

#### Usuario Administrador
```
Usuario: admin
Contraseña: admin123
Estado: cambiarpassword (forzará cambio en primer login)
Horario de acceso: 00:00:00 - 23:59:59 (24/7)
```

#### Permisos (todos en modo "Permitido")
- Módulo: Usuarios
- Módulo: Registro
- Módulo: Impresiones
- Módulo: Permisos

#### Configuración de Impresión
```
Tamaño de hoja: A4
Tipo de letra: Helvetica
Tamaño de fuente: 12
Imagen de fondo: Ninguna
```

**Uso:**
```sql
-- Ejecutar DESPUÉS de pruebatecnica.sql
-- Requiere que la estructura de base de datos ya exista
```

**Cuándo usarlo:**
- Después de ejecutar `pruebatecnica.sql`
- Para restaurar datos iniciales en una base de datos existente
- Cuando necesitas recrear el usuario administrador

---

### 3. `pruebatecnica_completo.sql` - Script Completo (⭐ RECOMENDADO)
**Contenido:**
- ✅ Todo de `pruebatecnica.sql` (estructura completa)
- ✅ Todo de `datos_iniciales.sql` (datos por defecto)
- ✅ Instalación en un solo paso
- ✅ Mensajes informativos durante la ejecución
- ✅ Verificación automática al final

**Uso:**
```sql
-- Ejecutar en SQL Server Management Studio
-- Instalación completa en un solo paso
```

**Cuándo usarlo:**
- ✅ **Instalaciones nuevas** (RECOMENDADO)
- ✅ Para desarrollo local
- ✅ Para pruebas y demos
- ✅ Cuando quieres empezar a usar el sistema inmediatamente

---

## 🚀 Guía de Instalación Rápida

### Para Usuarios Nuevos (Recomendado)

```bash
1. Abrir SQL Server Management Studio (SSMS)
2. Conectarse al servidor SQL Server
3. Abrir el archivo: pruebatecnica_completo.sql
4. Presionar F5 para ejecutar
5. Esperar a que aparezca el mensaje de finalización con las credenciales
6. ¡Listo! El sistema está configurado
```

**Resultado esperado:**
```
================================================
INSTALACIÓN COMPLETADA EXITOSAMENTE
================================================

CREDENCIALES DE ACCESO:
  Usuario: admin
  Contraseña: admin123

IMPORTANTE:
  ⚠ Se le solicitará cambiar la contraseña en el primer login
  ⚠ El usuario admin tiene acceso a todos los módulos del sistema
  ⚠ Asegúrese de cambiar las credenciales por defecto

================================================
```

### Para Usuarios Avanzados (Control Manual)

```bash
1. Ejecutar: pruebatecnica.sql
   - Crea toda la estructura de base de datos
   
2. Ejecutar: datos_iniciales.sql
   - Inserta datos iniciales
   
3. O crear tus propios datos iniciales manualmente
```

---

## 📋 Comparación de Scripts

| Característica | pruebatecnica.sql | datos_iniciales.sql | pruebatecnica_completo.sql |
|----------------|-------------------|---------------------|---------------------------|
| Crea base de datos | ✅ | ❌ | ✅ |
| Crea tablas | ✅ | ❌ | ✅ |
| Crea stored procedures | ✅ | ❌ | ✅ |
| Inserta usuario admin | ❌ | ✅ | ✅ |
| Inserta permisos | ❌ | ✅ | ✅ |
| Config. impresión | ❌ | ✅ | ✅ |
| Registro de auditoría | ❌ | ✅ | ✅ |
| Verificaciones | ❌ | ✅ | ✅ |
| Mensajes informativos | Básicos | Detallados | Detallados |
| **Instalación en 1 paso** | ❌ | ❌ | ✅ |

---

## 🔒 Seguridad de Datos Iniciales

### Credenciales Por Defecto

```
⚠️ IMPORTANTE: Las credenciales por defecto son:
Usuario: admin
Contraseña: admin123
```

### Recomendaciones de Seguridad

1. **Cambiar la contraseña inmediatamente**
   - El sistema forzará el cambio en el primer login
   - Usar contraseña segura (mínimo 8 caracteres, mayúsculas, minúsculas, números)

2. **En producción:**
   - Cambiar las credenciales antes de desplegar
   - Considerar usar autenticación de Windows
   - Implementar políticas de contraseñas fuertes

3. **Auditoría:**
   - Todas las acciones del admin quedan registradas en la tabla `historico`
   - Revisar periódicamente el histórico de acciones

---

## ✅ Verificación Post-Instalación

Después de ejecutar cualquier script, verificar:

### 1. Verificar Tablas Creadas
```sql
USE pruebatecnica;
GO

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- Resultado esperado: 5 tablas
-- config_impresion, historico, permisos, registros, usuarios
```

### 2. Verificar Stored Procedures
```sql
SELECT ROUTINE_NAME 
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
ORDER BY ROUTINE_NAME;
GO

-- Resultado esperado: 32 stored procedures
```

### 3. Verificar Usuario Admin (si se insertaron datos)
```sql
SELECT 
    usuario,
    status,
    horarioInicio,
    horarioFin
FROM usuarios 
WHERE usuario = 'admin';
GO

-- Debe mostrar el usuario admin con status 'cambiarpassword'
```

### 4. Verificar Permisos del Admin
```sql
SELECT 
    u.usuario,
    p.modulo,
    CASE WHEN p.acceso = 1 THEN 'Permitido' ELSE 'Denegado' END AS acceso
FROM permisos p
INNER JOIN usuarios u ON p.idUsuario = u.idUsuario
WHERE u.usuario = 'admin'
ORDER BY p.modulo;
GO

-- Debe mostrar 4 módulos con acceso permitido
```

---

## 🔧 Solución de Problemas

### "Database already exists"

Si recibes este error:
```sql
-- Opción 1: Eliminar la base de datos existente
USE master;
GO
DROP DATABASE pruebatecnica;
GO

-- Opción 2: Usar la base de datos existente
USE pruebatecnica;
GO
-- Y ejecutar solo las secciones que faltan
```

### "El usuario 'admin' ya existe"

El script `datos_iniciales.sql` tiene verificaciones:
```sql
-- No se insertará duplicado, mostrará mensaje de advertencia
-- ⚠ El usuario admin ya existe, omitiendo inserción...
```

### Errores de permisos

```sql
-- Asegurarse de tener permisos de sysadmin o db_owner
-- Conectarse con un usuario que tenga permisos suficientes
```

---

## 📞 Soporte

Para problemas con los scripts:

1. Revisar los mensajes de error en SSMS
2. Consultar el log de ejecución (si usaste sqlcmd con -o)
3. Verificar la [Guía de Instalación de Base de Datos](INSTALACION_BASE_DATOS.md)
4. Abrir un issue en GitHub
5. Contactar: mijail.salazar@mccollect.mx

---

## 📝 Historial de Versiones

### Versión 2.0 (19/11/2025)
- ✅ Agregado script `pruebatecnica_completo.sql`
- ✅ Agregado script `datos_iniciales.sql`
- ✅ Documentación completa de scripts
- ✅ Mejoras en verificaciones de seguridad

### Versión 1.0 (Inicial)
- ✅ Script base `pruebatecnica.sql`

---

**Autor**: Ezrra Salazar  
**Fecha**: 19 de Noviembre de 2025  
**Proyecto**: Sistema de Gestión de Usuarios y Registros
