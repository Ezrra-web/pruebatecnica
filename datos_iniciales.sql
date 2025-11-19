-- ================================================
-- Script de Datos Iniciales - Sistema de Gestión
-- Fecha: 19/11/2025
-- Autor: Ezrra Salazar
-- Descripción: Inserta datos iniciales necesarios para el funcionamiento del sistema
-- ================================================

USE [pruebatecnica]
GO

PRINT '================================================'
PRINT 'Iniciando inserción de datos iniciales...'
PRINT '================================================'

-- ================================================
-- 1. INSERTAR USUARIO ADMINISTRADOR
-- ================================================
PRINT ''
PRINT 'Insertando usuario administrador...'

-- Verificar si el usuario admin ya existe
IF NOT EXISTS (SELECT 1 FROM usuarios WHERE usuario = 'admin')
BEGIN
    INSERT INTO usuarios (usuario, password, status, horarioInicio, horarioFin)
    VALUES ('admin', 'admin123', 'cambiarpassword', '00:00:00', '23:59:59');
    
    PRINT '✓ Usuario administrador creado correctamente'
    PRINT '  Usuario: admin'
    PRINT '  Contraseña: admin123'
    PRINT '  IMPORTANTE: Cambiar la contraseña en el primer login'
END
ELSE
BEGIN
    PRINT '⚠ El usuario admin ya existe, omitiendo inserción...'
END
GO

-- ================================================
-- 2. INSERTAR PERMISOS PARA ADMINISTRADOR
-- ================================================
PRINT ''
PRINT 'Asignando permisos al administrador...'

-- Obtener el ID del usuario admin
DECLARE @idUsuarioAdmin INT;
SELECT @idUsuarioAdmin = idUsuario FROM usuarios WHERE usuario = 'admin';

-- Verificar si ya tiene permisos
IF NOT EXISTS (SELECT 1 FROM permisos WHERE idUsuario = @idUsuarioAdmin)
BEGIN
    -- Insertar permisos completos para todos los módulos
    INSERT INTO permisos (idUsuario, modulo, acceso)
    VALUES 
        (@idUsuarioAdmin, 'Usuarios', 1),
        (@idUsuarioAdmin, 'Registro', 1),
        (@idUsuarioAdmin, 'Impresiones', 1),
        (@idUsuarioAdmin, 'Permisos', 1);
    
    PRINT '✓ Permisos asignados correctamente:'
    PRINT '  - Usuarios: Acceso completo'
    PRINT '  - Registro: Acceso completo'
    PRINT '  - Impresiones: Acceso completo'
    PRINT '  - Permisos: Acceso completo'
END
ELSE
BEGIN
    PRINT '⚠ El usuario admin ya tiene permisos asignados, omitiendo inserción...'
END
GO

-- ================================================
-- 3. INSERTAR CONFIGURACIÓN DE IMPRESIÓN POR DEFECTO
-- ================================================
PRINT ''
PRINT 'Configurando impresión por defecto...'

-- Verificar si ya existe configuración
IF NOT EXISTS (SELECT 1 FROM config_impresion)
BEGIN
    INSERT INTO config_impresion (tamanoHoja, tipoLetra, tamanoLetra, imagenFondo)
    VALUES ('A4', 'Helvetica', 12, NULL);
    
    PRINT '✓ Configuración de impresión creada:'
    PRINT '  - Tamaño de hoja: A4'
    PRINT '  - Tipo de letra: Helvetica'
    PRINT '  - Tamaño de letra: 12'
    PRINT '  - Imagen de fondo: Ninguna'
END
ELSE
BEGIN
    PRINT '⚠ Ya existe configuración de impresión, omitiendo inserción...'
END
GO

-- ================================================
-- 4. INSERTAR REGISTRO DE AUDITORÍA INICIAL (OPCIONAL)
-- ================================================
PRINT ''
PRINT 'Registrando inicialización del sistema en auditoría...'

-- Obtener el ID del usuario admin
DECLARE @idAdmin INT;
SELECT @idAdmin = idUsuario FROM usuarios WHERE usuario = 'admin';

INSERT INTO historico (idUsuario, modulo, accion, descripcion, fecha)
VALUES (@idAdmin, 'Sistema', 'Inicialización', 'Sistema inicializado con datos por defecto', GETDATE());

PRINT '✓ Registro de auditoría creado'
GO

-- ================================================
-- 5. VERIFICACIÓN DE DATOS
-- ================================================
PRINT ''
PRINT '================================================'
PRINT 'VERIFICANDO DATOS INSERTADOS...'
PRINT '================================================'

PRINT ''
PRINT '--- USUARIOS ---'
SELECT 
    idUsuario AS ID,
    usuario AS Usuario,
    status AS Estado,
    CONVERT(VARCHAR(5), horarioInicio, 108) AS HorarioInicio,
    CONVERT(VARCHAR(5), horarioFin, 108) AS HorarioFin
FROM usuarios
ORDER BY idUsuario;

PRINT ''
PRINT '--- PERMISOS ---'
SELECT 
    p.idPermiso AS ID,
    u.usuario AS Usuario,
    p.modulo AS Modulo,
    CASE WHEN p.acceso = 1 THEN 'Permitido' ELSE 'Denegado' END AS Acceso
FROM permisos p
INNER JOIN usuarios u ON p.idUsuario = u.idUsuario
ORDER BY u.usuario, p.modulo;

PRINT ''
PRINT '--- CONFIGURACIÓN DE IMPRESIÓN ---'
SELECT 
    idConfig AS ID,
    tamanoHoja AS TamañoHoja,
    tipoLetra AS TipoLetra,
    tamanoLetra AS TamañoLetra,
    ISNULL(imagenFondo, 'Sin imagen') AS ImagenFondo
FROM config_impresion;

PRINT ''
PRINT '--- HISTÓRICO ---'
SELECT TOP 5
    h.idHistorico AS ID,
    u.usuario AS Usuario,
    h.modulo AS Modulo,
    h.accion AS Accion,
    h.descripcion AS Descripcion,
    h.fecha AS Fecha
FROM historico h
LEFT JOIN usuarios u ON h.idUsuario = u.idUsuario
ORDER BY h.fecha DESC;

PRINT ''
PRINT '================================================'
PRINT 'DATOS INICIALES INSERTADOS CORRECTAMENTE'
PRINT '================================================'
PRINT ''
PRINT 'CREDENCIALES DE ACCESO:'
PRINT '  Usuario: admin'
PRINT '  Contraseña: admin123'
PRINT ''
PRINT 'IMPORTANTE:'
PRINT '  ⚠ Se le solicitará cambiar la contraseña en el primer login'
PRINT '  ⚠ El usuario admin tiene acceso a todos los módulos'
PRINT '  ⚠ Asegúrese de cambiar las credenciales por defecto'
PRINT ''
PRINT '================================================'
GO
