USE [master]
GO
/****** Object:  Database [pruebatecnica]    Script Date: 19/11/2025 10:03:42 a. m. ******/
CREATE DATABASE [pruebatecnica]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'pruebatecnica', FILENAME = N'C:\Users\MijailEzrraDavidSala\pruebatecnica.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'pruebatecnica_log', FILENAME = N'C:\Users\MijailEzrraDavidSala\pruebatecnica_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [pruebatecnica] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [pruebatecnica].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [pruebatecnica] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [pruebatecnica] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [pruebatecnica] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [pruebatecnica] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [pruebatecnica] SET ARITHABORT OFF 
GO
ALTER DATABASE [pruebatecnica] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [pruebatecnica] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [pruebatecnica] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [pruebatecnica] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [pruebatecnica] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [pruebatecnica] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [pruebatecnica] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [pruebatecnica] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [pruebatecnica] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [pruebatecnica] SET  ENABLE_BROKER 
GO
ALTER DATABASE [pruebatecnica] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [pruebatecnica] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [pruebatecnica] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [pruebatecnica] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [pruebatecnica] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [pruebatecnica] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [pruebatecnica] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [pruebatecnica] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [pruebatecnica] SET  MULTI_USER 
GO
ALTER DATABASE [pruebatecnica] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [pruebatecnica] SET DB_CHAINING OFF 
GO
ALTER DATABASE [pruebatecnica] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [pruebatecnica] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [pruebatecnica] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [pruebatecnica] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [pruebatecnica] SET QUERY_STORE = OFF
GO
USE [pruebatecnica]
GO
/****** Object:  Table [dbo].[config_impresion]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[config_impresion](
	[idConfig] [int] IDENTITY(1,1) NOT NULL,
	[tamanoHoja] [nvarchar](20) NOT NULL,
	[tipoLetra] [nvarchar](50) NOT NULL,
	[tamanoLetra] [int] NOT NULL,
	[imagenFondo] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[idConfig] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[historico]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[historico](
	[idHistorico] [int] IDENTITY(1,1) NOT NULL,
	[idUsuario] [int] NULL,
	[modulo] [nvarchar](50) NOT NULL,
	[accion] [nvarchar](100) NOT NULL,
	[descripcion] [nvarchar](4000) NULL,
	[fecha] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idHistorico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[permisos]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[permisos](
	[idPermiso] [int] IDENTITY(1,1) NOT NULL,
	[idUsuario] [int] NOT NULL,
	[modulo] [nvarchar](50) NOT NULL,
	[acceso] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idPermiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[registros]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[registros](
	[idRegistro] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) NOT NULL,
	[contrato] [nvarchar](20) NOT NULL,
	[saldo] [decimal](10, 2) NOT NULL,
	[fecha] [date] NOT NULL,
	[telefono] [nvarchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[idRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuarios]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuarios](
	[idUsuario] [int] IDENTITY(1,1) NOT NULL,
	[usuario] [nvarchar](100) NOT NULL,
	[password] [nvarchar](100) NOT NULL,
	[status] [nvarchar](25) NOT NULL,
	[horarioInicio] [time](7) NOT NULL,
	[horarioFin] [time](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_permisos_idUsuario]    Script Date: 19/11/2025 10:03:42 a. m. ******/
CREATE NONCLUSTERED INDEX [IX_permisos_idUsuario] ON [dbo].[permisos]
(
	[idUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_permisos_usuario_modulo]    Script Date: 19/11/2025 10:03:42 a. m. ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_permisos_usuario_modulo] ON [dbo].[permisos]
(
	[idUsuario] ASC,
	[modulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_registros_contrato]    Script Date: 19/11/2025 10:03:42 a. m. ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_registros_contrato] ON [dbo].[registros]
(
	[contrato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_registros_fecha]    Script Date: 19/11/2025 10:03:42 a. m. ******/
CREATE NONCLUSTERED INDEX [IX_registros_fecha] ON [dbo].[registros]
(
	[fecha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_registros_nombre]    Script Date: 19/11/2025 10:03:42 a. m. ******/
CREATE NONCLUSTERED INDEX [IX_registros_nombre] ON [dbo].[registros]
(
	[nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_usuarios_usuario]    Script Date: 19/11/2025 10:03:42 a. m. ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_usuarios_usuario] ON [dbo].[usuarios]
(
	[usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[historico] ADD  DEFAULT (getdate()) FOR [fecha]
GO
ALTER TABLE [dbo].[permisos] ADD  DEFAULT ((0)) FOR [acceso]
GO
ALTER TABLE [dbo].[registros] ADD  DEFAULT ((0.00)) FOR [saldo]
GO
ALTER TABLE [dbo].[historico]  WITH CHECK ADD  CONSTRAINT [FK_historico_usuarios] FOREIGN KEY([idUsuario])
REFERENCES [dbo].[usuarios] ([idUsuario])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[historico] CHECK CONSTRAINT [FK_historico_usuarios]
GO
ALTER TABLE [dbo].[permisos]  WITH CHECK ADD  CONSTRAINT [FK_permisos_usuarios] FOREIGN KEY([idUsuario])
REFERENCES [dbo].[usuarios] ([idUsuario])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[permisos] CHECK CONSTRAINT [FK_permisos_usuarios]
GO
ALTER TABLE [dbo].[config_impresion]  WITH CHECK ADD  CONSTRAINT [CK_config_impresion_tamanoHoja] CHECK  (([tamanoHoja]='Ticket' OR [tamanoHoja]='A5' OR [tamanoHoja]='Legal' OR [tamanoHoja]='Oficio' OR [tamanoHoja]='Carta' OR [tamanoHoja]='A4'))
GO
ALTER TABLE [dbo].[config_impresion] CHECK CONSTRAINT [CK_config_impresion_tamanoHoja]
GO
ALTER TABLE [dbo].[config_impresion]  WITH CHECK ADD  CONSTRAINT [CK_config_impresion_tamanoLetra] CHECK  (([tamanoLetra]>=(6) AND [tamanoLetra]<=(72)))
GO
ALTER TABLE [dbo].[config_impresion] CHECK CONSTRAINT [CK_config_impresion_tamanoLetra]
GO
ALTER TABLE [dbo].[usuarios]  WITH CHECK ADD  CONSTRAINT [CK_usuarios_status] CHECK  (([status]='cambiarpassword' OR [status]='Baja' OR [status]='Activo'))
GO
ALTER TABLE [dbo].[usuarios] CHECK CONSTRAINT [CK_usuarios_status]
GO
/****** Object:  StoredProcedure [dbo].[SP_CambiarPassword]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CambiarPassword]
    @idUsuario INT,
    @nuevaPass NVARCHAR(100)
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Usuarios WHERE idUsuario = @idUsuario)
    BEGIN
        SELECT 'Usuario no encontrado' AS Resultado;
        RETURN;
    END

    UPDATE Usuarios 
    SET password = @nuevaPass,
        status = 'activo'
    WHERE idUsuario = @idUsuario;

    SELECT 'OK' AS Resultado;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GetPermisosUsuario]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetPermisosUsuario]
    @usuario NVARCHAR(100)
AS
BEGIN
    SELECT p.modulo
    FROM permisos p
    INNER JOIN usuarios u ON u.idUsuario = p.idUsuario
    WHERE u.usuario = @usuario AND p.acceso = 1;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Historico_Insertar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Historico_Insertar]
    @idUsuario INT = NULL,
    @modulo NVARCHAR(50),
    @accion NVARCHAR(100),
    @descripcion NVARCHAR(4000) = NULL
AS
BEGIN
    INSERT INTO historico (idUsuario, modulo, accion, descripcion)
    VALUES (@idUsuario, @modulo, @accion, @descripcion);
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Historico_Listar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Historico_Listar]
AS
BEGIN
    SELECT h.idHistorico, u.usuario, h.modulo, h.accion, h.descripcion, h.fecha
    FROM historico h
    LEFT JOIN usuarios u ON h.idUsuario = u.idUsuario
    ORDER BY h.fecha DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Impresion_Actualizar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Impresion_Actualizar]
    @idConfig INT,
    @tamanoHoja NVARCHAR(20),
    @tipoLetra NVARCHAR(50),
    @tamanoLetra INT,
    @imagenFondo NVARCHAR(100)
AS
BEGIN
    UPDATE config_impresion
    SET tamanoHoja = @tamanoHoja,
        tipoLetra = @tipoLetra,
        tamanoLetra = @tamanoLetra,
        imagenFondo = @imagenFondo
    WHERE idConfig = @idConfig;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Impresion_Guardar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_Impresion_Guardar]
  @tamanoHoja NVARCHAR(20),
  @tipoLetra NVARCHAR(50),
  @tamanoLetra INT,
  @imagenFondo NVARCHAR(100) = NULL
AS
BEGIN
    IF EXISTS (SELECT 1 FROM config_impresion)
    BEGIN
        UPDATE config_impresion
        SET tamanoHoja = @tamanoHoja,
            tipoLetra = @tipoLetra,
            tamanoLetra = @tamanoLetra,
            imagenFondo = ISNULL(@imagenFondo, imagenFondo)
    END
    ELSE
    BEGIN
        INSERT INTO config_impresion (tamanoHoja, tipoLetra, tamanoLetra, imagenFondo)
        VALUES (@tamanoHoja, @tipoLetra, @tamanoLetra, @imagenFondo)
    END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Impresion_Insertar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Impresion_Insertar]
    @tamanoHoja NVARCHAR(20),
    @tipoLetra NVARCHAR(50),
    @tamanoLetra INT,
    @imagenFondo NVARCHAR(100)
AS
BEGIN
    INSERT INTO config_impresion (tamanoHoja, tipoLetra, tamanoLetra, imagenFondo)
    VALUES (@tamanoHoja, @tipoLetra, @tamanoLetra, @imagenFondo);
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Impresion_Obtener]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Impresion_Obtener]
AS
BEGIN
    SELECT TOP 1 * FROM config_impresion ORDER BY idConfig DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Impresion_ObtenerConfig]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_Impresion_ObtenerConfig]
AS
BEGIN
    SELECT TOP 1 *
    FROM config_impresion
    ORDER BY idConfig DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Permiso_Actualizar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_Permiso_Actualizar]
    @idUsuario INT,
    @modulo NVARCHAR(50),
    @acceso BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM permisos WHERE idUsuario = @idUsuario AND modulo = @modulo)
    BEGIN
        UPDATE permisos
        SET acceso = @acceso
        WHERE idUsuario = @idUsuario AND modulo = @modulo;
    END
    ELSE
    BEGIN
        INSERT INTO permisos (idUsuario, modulo, acceso)
        VALUES (@idUsuario, @modulo, @acceso);
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Permiso_Listar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_Permiso_Listar]
    @idUsuario INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Modulos TABLE (modulo NVARCHAR(50));
    INSERT INTO @Modulos (modulo)
    VALUES ('Usuarios'), ('Registro'), ('Impresiones'), ('Permisos');

    SELECT 
        m.modulo,
        ISNULL(p.acceso, 0) AS acceso
    FROM @Modulos m
    LEFT JOIN permisos p ON p.modulo = m.modulo AND p.idUsuario = @idUsuario;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Permisos_Actualizar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_Permisos_Actualizar]
    @idUsuario INT,
    @modulo NVARCHAR(50),
    @acceso BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM permisos WHERE idUsuario = @idUsuario AND modulo = @modulo)
    BEGIN
        UPDATE permisos
        SET acceso = @acceso
        WHERE idUsuario = @idUsuario AND modulo = @modulo;
    END
    ELSE
    BEGIN
        INSERT INTO permisos (idUsuario, modulo, acceso)
        VALUES (@idUsuario, @modulo, @acceso);
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Permisos_EliminarPorUsuario]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Eliminar todos los permisos de un usuario
CREATE PROCEDURE [dbo].[SP_Permisos_EliminarPorUsuario]
    @idUsuario INT
AS
BEGIN
    DELETE FROM permisos WHERE idUsuario = @idUsuario;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Permisos_Insertar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Insertar un permiso
CREATE PROCEDURE [dbo].[SP_Permisos_Insertar]
    @idUsuario INT,
    @modulo NVARCHAR(50),
    @acceso BIT
AS
BEGIN
    INSERT INTO permisos (idUsuario, modulo, acceso)
    VALUES (@idUsuario, @modulo, @acceso);
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Permisos_ListarPorUsuario]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_Permisos_ListarPorUsuario]
    @idUsuario INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Lista base de módulos
    DECLARE @modulos TABLE (modulo NVARCHAR(50));
    INSERT INTO @modulos (modulo)
    VALUES ('Usuarios'), ('Registro'), ('Impresiones'),('Permisos');

    SELECT 
        m.modulo,
        ISNULL(p.acceso, 0) AS acceso
    FROM @modulos m
    LEFT JOIN permisos p 
        ON p.modulo = m.modulo AND p.idUsuario = @idUsuario;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Registro_Actualizar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Registro_Actualizar]
    @idRegistro INT,
    @nombre NVARCHAR(100),
    @contrato NVARCHAR(50),
    @saldo DECIMAL(18,2),
    @fecha DATE,
    @telefono NVARCHAR(20)
AS
BEGIN
    UPDATE registros
    SET nombre = @nombre,
        contrato = @contrato,
        saldo = @saldo,
        fecha = @fecha,
        telefono = @telefono
    WHERE idRegistro = @idRegistro;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Registro_Buscar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Registro_Buscar]
    @idRegistro INT
AS
BEGIN
    SELECT * FROM registros WHERE idRegistro = @idRegistro;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Registro_Eliminar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Registro_Eliminar]
    @idRegistro INT
AS
BEGIN
    DELETE FROM registros WHERE idRegistro = @idRegistro;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Registro_Insertar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Registro_Insertar]
    @nombre NVARCHAR(100),
    @contrato NVARCHAR(50),
    @saldo DECIMAL(18,2),
    @fecha DATE,
    @telefono NVARCHAR(20)
AS
BEGIN
    INSERT INTO registros (nombre, contrato, saldo, fecha, telefono)
    VALUES (@nombre, @contrato, @saldo, @fecha, @telefono);
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Registro_Listar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Registro_Listar]
AS
BEGIN
    SELECT * FROM registros;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Usuario_Actualizar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_Usuario_Actualizar]
    @idUsuario INT,
    @usuario NVARCHAR(100),
    @password NVARCHAR(100),        -- si es NULL o '' -> no se actualiza contraseña
    @status NVARCHAR(25),
    @horarioInicio TIME,
    @horarioFin TIME
AS
BEGIN
    SET NOCOUNT ON;

    -- 1) Validar que el usuario existe
    IF NOT EXISTS (SELECT 1 FROM usuarios WHERE idUsuario = @idUsuario)
    BEGIN
        SELECT 'Usuario no encontrado' AS Resultado;
        RETURN;
    END

    -- 2) Validar duplicado de nombre de usuario (otro id)
    IF EXISTS (SELECT 1 FROM usuarios WHERE usuario = @usuario AND idUsuario <> @idUsuario)
    BEGIN
        SELECT 'Nombre de usuario ya existe' AS Resultado;
        RETURN;
    END

    -- 3) Actualizar con o sin contraseña
    IF @password IS NULL OR LTRIM(RTRIM(@password)) = ''
    BEGIN
        UPDATE usuarios
        SET
            usuario = @usuario,
            status = @status,
            horarioInicio = @horarioInicio,
            horarioFin = @horarioFin
        WHERE idUsuario = @idUsuario;
    END
    ELSE
    BEGIN
        UPDATE usuarios
        SET
            usuario = @usuario,
            password = @password,
            status = @status,
            horarioInicio = @horarioInicio,
            horarioFin = @horarioFin
        WHERE idUsuario = @idUsuario;
    END

    SELECT 'OK' AS Resultado;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Usuario_Buscar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Usuario_Buscar]
    @idUsuario INT
AS
BEGIN
    SELECT 
        idUsuario,
        usuario,
        password,
        status,
        horarioInicio,
        horarioFin
    FROM usuarios
    WHERE idUsuario = @idUsuario;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Usuario_Editar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Usuario_Editar]
    @idUsuario INT,
    @usuario NVARCHAR(100),
    @password NVARCHAR(100),
    @status NVARCHAR(25),
    @horarioInicio TIME,
    @horarioFin TIME
AS
BEGIN
    UPDATE usuarios SET
        usuario = @usuario,
        password = @password,
        status = @status,
        horarioInicio = @horarioInicio,
        horarioFin = @horarioFin
    WHERE idUsuario = @idUsuario;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Usuario_Eliminar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SP_Usuario_Eliminar]
    @idUsuario INT
AS
BEGIN
    UPDATE usuarios
    SET status = 'Baja'
    WHERE idUsuario = @idUsuario;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Usuario_Insertar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[SP_Usuario_Insertar]
    @usuario NVARCHAR(100),
    @password NVARCHAR(100),
    @status NVARCHAR(25),
    @horarioInicio TIME,
    @horarioFin TIME
AS
BEGIN
    INSERT INTO usuarios(usuario, password, status, horarioInicio, horarioFin)
    VALUES (@usuario, @password, @status, @horarioInicio, @horarioFin);

    SELECT SCOPE_IDENTITY() AS idUsuario;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Usuario_Listar]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[SP_Usuario_Listar]
AS
BEGIN
    SELECT idUsuario, usuario, status, horarioInicio, horarioFin
    FROM usuarios
    ORDER BY usuario;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Usuarios_ListarBasico]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Usuarios_ListarBasico]
AS
BEGIN
    SELECT idUsuario, usuario FROM usuarios WHERE status = 'Activo';
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ValidarLogin]    Script Date: 19/11/2025 10:03:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ValidarLogin] 
    @usuario NVARCHAR(50), 
    @contrasena NVARCHAR(100) 
AS 
BEGIN 
    DECLARE @estatus NVARCHAR(25), @inicio TIME, @fin TIME, @horaActual TIME, @idUsuario INT;
    SET @horaActual = CONVERT(TIME, GETDATE()); 
    
    SELECT 
        @idUsuario = idUsuario,
        @estatus = status, 
        @inicio = horarioInicio, 
        @fin = horarioFin
    FROM 
        usuarios 
    WHERE 
        usuario = @usuario 
        AND password = @contrasena;

    IF @idUsuario IS NULL
    BEGIN
        SELECT 
            'Usuario o contraseña incorrectos' AS Resultado,
            NULL AS idUsuario,
            NULL AS status,
            NULL AS horarioInicio,
            NULL AS horarioFin;
        RETURN;
    END

    IF @estatus = 'Baja'
    BEGIN
        SELECT 
            'Usuario inactivo' AS Resultado,
            @idUsuario AS idUsuario,
            @estatus AS status,
            @inicio AS horarioInicio,
            @fin AS horarioFin;
        RETURN;
    END

    IF @estatus = 'cambiarpassword'
    BEGIN
        SELECT 
            'Cambiar contraseña' AS Resultado,
            @idUsuario AS idUsuario,
            @estatus AS status,
            @inicio AS horarioInicio,
            @fin AS horarioFin;
        RETURN;
    END

    IF @horaActual NOT BETWEEN @inicio AND @fin
    BEGIN
        SELECT 
            'Fuera de horario permitido' AS Resultado,
            @idUsuario AS idUsuario,
            @estatus AS status,
            @inicio AS horarioInicio,
            @fin AS horarioFin;
        RETURN;
    END

    -- ✅ Acceso permitido
    SELECT 
        'Acceso permitido' AS Resultado,
        @idUsuario AS idUsuario,
        @estatus AS status,
        @inicio AS horarioInicio,
        @fin AS horarioFin;
END;
GO
USE [master]

-- ================================================
-- SECCIÓN: DATOS INICIALES DEL SISTEMA
-- ================================================

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
-- 4. INSERTAR REGISTRO DE AUDITORÍA INICIAL
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
-- VERIFICACIÓN DE DATOS
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
PRINT '================================================'
PRINT 'INSTALACIÓN COMPLETADA EXITOSAMENTE'
PRINT '================================================'
PRINT ''
PRINT 'CREDENCIALES DE ACCESO:'
PRINT '  Usuario: admin'
PRINT '  Contraseña: admin123'
PRINT ''
PRINT 'IMPORTANTE:'
PRINT '  ⚠ Se le solicitará cambiar la contraseña en el primer login'
PRINT '  ⚠ El usuario admin tiene acceso a todos los módulos del sistema'
PRINT '  ⚠ Asegúrese de cambiar las credenciales por defecto'
PRINT ''
PRINT '================================================'
GO

USE [master]
GO
ALTER DATABASE [pruebatecnica] SET  READ_WRITE 
GO
