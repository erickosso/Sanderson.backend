-- Procedimiento para registrar pagos en corte activo
CREATE PROCEDURE [dbo].[SP_RegistrarPagoEnCorte]
    @pago_id UNIQUEIDENTIFIER,
    @escuela_id UNIQUEIDENTIFIER,
    @fecha_pago DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @fecha_pago IS NULL
        SET @fecha_pago = CAST(GETDATE() AS DATE)
    
    DECLARE @corte_id UNIQUEIDENTIFIER
    
    -- Buscar corte activo para la fecha y escuela
    SELECT @corte_id = corte_id 
    FROM CortesCaja 
    WHERE escuela_id = @escuela_id 
    AND fecha_corte = @fecha_pago 
    AND estado = 'Abierto'
    
    -- Si no hay corte activo, crear uno nuevo
    IF @corte_id IS NULL
    BEGIN
        DECLARE @usuario_sistema UNIQUEIDENTIFIER
        SELECT TOP 1 @usuario_sistema = usuario_id FROM Usuarios WHERE activo = 1
        
        EXEC SP_CrearNuevoCorte 
            @escuela_id = @escuela_id,
            @usuario_id = @usuario_sistema,
            @fecha_corte = @fecha_pago,
            @corte_id = @corte_id OUTPUT
    END
    
    -- Insertar el pago en el corte
    INSERT INTO CorteCajaIngresos (
        corte_id, pago_id, alumno_id, concepto_id,
        alumno_nombre, concepto_nombre, monto_original,
        descuento, recargo, monto_pagado, metodo_pago,
        periodo, referencia, fecha_pago
    )
    SELECT 
        @corte_id,
        p.pago_id,
        p.alumno_id,
        p.concepto_id,
        CONCAT(a.nombre, ' ', a.apellido_paterno, ' ', ISNULL(a.apellido_materno, '')),
        cp.nombre,
        p.monto,
        ISNULL(p.descuento, 0),
        ISNULL(p.recargo, 0),
        ISNULL(p.monto_pagado, p.monto),
        ISNULL(p.metodo_pago, 'Efectivo'),
        p.periodo,
        p.referencia,
        ISNULL(p.fecha_pago, GETDATE())
    FROM Pagos p
    INNER JOIN Alumnos a ON p.alumno_id = a.alumno_id
    INNER JOIN ConceptosPago cp ON p.concepto_id = cp.concepto_id
    WHERE p.pago_id = @pago_id
    AND p.escuela_id = @escuela_id
    
    SELECT @corte_id as corte_id
END
GO

-- Procedimiento para registrar gastos en corte activo
CREATE PROCEDURE [dbo].[SP_RegistrarGastoEnCorte]
    @gasto_id UNIQUEIDENTIFIER,
    @escuela_id UNIQUEIDENTIFIER,
    @fecha_gasto DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @fecha_gasto IS NULL
        SET @fecha_gasto = CAST(GETDATE() AS DATE)
    
    DECLARE @corte_id UNIQUEIDENTIFIER
    
    -- Buscar corte activo para la fecha y escuela
    SELECT @corte_id = corte_id 
    FROM CortesCaja 
    WHERE escuela_id = @escuela_id 
    AND fecha_corte = @fecha_gasto 
    AND estado = 'Abierto'
    
    -- Si no hay corte activo, crear uno nuevo
    IF @corte_id IS NULL
    BEGIN
        DECLARE @usuario_sistema UNIQUEIDENTIFIER
        SELECT TOP 1 @usuario_sistema = usuario_id FROM Usuarios WHERE activo = 1
        
        EXEC SP_CrearNuevoCorte 
            @escuela_id = @escuela_id,
            @usuario_id = @usuario_sistema,
            @fecha_corte = @fecha_gasto,
            @corte_id = @corte_id OUTPUT
    END
    
    -- Insertar el gasto en el corte
    INSERT INTO CorteCajaGastos (
        corte_id, gasto_id, concepto, monto, tipo_gasto,
        justificacion, es_gasto_general, fecha_gasto, usuario_registro
    )
    SELECT 
        @corte_id,
        g.IdGasto,
        g.Concepto,
        g.Monto,
        CASE g.IdTipoGasto
            WHEN 1 THEN 'Material Didáctico'
            WHEN 2 THEN 'Servicios'
            WHEN 3 THEN 'Mantenimiento'
            WHEN 4 THEN 'Administrativo'
            ELSE 'Otros'
        END,
        g.Justificacion,
        g.EsGastoGeneral,
        ISNULL(g.FechaGasto, g.FechaRegistro),
        g.UsuarioRegistro
    FROM Gastos g
    WHERE g.IdGasto = @gasto_id
    AND (g.IdEscuela = @escuela_id OR g.EsGastoGeneral = 1)
    
    SELECT @corte_id as corte_id
END
GO

-- Procedimiento para reporte financiero por período
CREATE PROCEDURE [dbo].[SP_ReporteFinancieroPeriodo]
    @escuela_id UNIQUEIDENTIFIER,
    @fecha_inicio DATE,
    @fecha_fin DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Resumen general del período
    SELECT 
        @fecha_inicio as fecha_inicio,
        @fecha_fin as fecha_fin,
        e.nombre as escuela_nombre,
        COUNT(DISTINCT cc.corte_id) as total_cortes,
        SUM(cc.total_ingresos) as total_ingresos_periodo,
        SUM(cc.total_gastos) as total_gastos_periodo,
        SUM(cc.total_ingresos) - SUM(cc.total_gastos) as saldo_neto_periodo,
        AVG(cc.total_ingresos) as promedio_ingresos_diario,
        AVG(cc.total_gastos) as promedio_gastos_diario
    FROM CortesCaja cc
    INNER JOIN Escuelas e ON cc.escuela_id = e.escuela_id
    WHERE cc.escuela_id = @escuela_id
    AND cc.fecha_corte BETWEEN @fecha_inicio AND @fecha_fin
    AND cc.estado IN ('Cerrado', 'Revisado')
	group by e.nombre
    
    -- Ingresos por método de pago
    SELECT 
        cci.metodo_pago,
        COUNT(*) as cantidad_transacciones,
        SUM(cci.monto_pagado) as total_monto,
        AVG(cci.monto_pagado) as promedio_transaccion
    FROM CorteCajaIngresos cci
    INNER JOIN CortesCaja cc ON cci.corte_id = cc.corte_id
    WHERE cc.escuela_id = @escuela_id
    AND cc.fecha_corte BETWEEN @fecha_inicio AND @fecha_fin
    GROUP BY cci.metodo_pago
    ORDER BY total_monto DESC
    
    -- Ingresos por concepto
    SELECT 
        cci.concepto_nombre,
        COUNT(*) as cantidad_pagos,
        SUM(cci.monto_pagado) as total_monto,
        SUM(cci.descuento) as total_descuentos,
        SUM(cci.recargo) as total_recargos
    FROM CorteCajaIngresos cci
    INNER JOIN CortesCaja cc ON cci.corte_id = cc.corte_id
    WHERE cc.escuela_id = @escuela_id
    AND cc.fecha_corte BETWEEN @fecha_inicio AND @fecha_fin
    GROUP BY cci.concepto_nombre
    ORDER BY total_monto DESC
    
    -- Gastos por tipo
    SELECT 
        ccg.tipo_gasto,
        COUNT(*) as cantidad_gastos,
        SUM(ccg.monto) as total_monto,
        AVG(ccg.monto) as promedio_gasto
    FROM CorteCajaGastos ccg
    INNER JOIN CortesCaja cc ON ccg.corte_id = cc.corte_id
    WHERE cc.escuela_id = @escuela_id
    AND cc.fecha_corte BETWEEN @fecha_inicio AND @fecha_fin
    GROUP BY ccg.tipo_gasto
    ORDER BY total_monto DESC
    
    -- Evolución diaria
    SELECT 
        cc.fecha_corte,
        SUM(cc.total_ingresos) as ingresos_dia,
        SUM(cc.total_gastos) as gastos_dia,
        SUM(cc.total_ingresos) - SUM(cc.total_gastos) as saldo_neto_dia,
        COUNT(cc.corte_id) as numero_cortes
    FROM CortesCaja cc
    WHERE cc.escuela_id = @escuela_id
    AND cc.fecha_corte BETWEEN @fecha_inicio AND @fecha_fin
    AND cc.estado IN ('Cerrado', 'Revisado')
    GROUP BY cc.fecha_corte
    ORDER BY cc.fecha_corte
END
GO

-- ====================================
-- 11. FUNCIONES ÚTILES
-- ====================================

-- Función para obtener el capital actual de una escuela
CREATE FUNCTION [dbo].[FN_CapitalActual](@escuela_id UNIQUEIDENTIFIER)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @capital DECIMAL(18,2)
    
    SELECT TOP 1 @capital = total_disponible
    FROM CapitalDisponible
    WHERE escuela_id = @escuela_id
    ORDER BY fecha DESC
    
    RETURN ISNULL(@capital, 0)
END
GO

-- Función para verificar si hay corte abierto
CREATE FUNCTION [dbo].[FN_CorteAbierto](@escuela_id UNIQUEIDENTIFIER, @fecha DATE)
RETURNS BIT
AS
BEGIN
    DECLARE @existe BIT = 0
    
    IF EXISTS (SELECT 1 FROM CortesCaja 
               WHERE escuela_id = @escuela_id 
               AND fecha_corte = @fecha 
               AND estado = 'Abierto')
        SET @existe = 1
    
    RETURN @existe
END
GO

-- ====================================
-- 12. DATOS DE EJEMPLO Y CONFIGURACIÓN INICIAL
-- ====================================

-- Insertar tipos de gasto si no existen (ajustar según tu tabla original)
--IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'TiposGasto')
--BEGIN
--    CREATE TABLE [dbo].[TiposGasto](
--        [tipo_gasto_id] [int] IDENTITY(1,1) NOT NULL,
--        [nombre] [nvarchar](50) NOT NULL,
--        [descripcion] [nvarchar](200) NULL,
--        [activo] [bit] NOT NULL DEFAULT (1),
--        CONSTRAINT [PK_TiposGasto] PRIMARY KEY CLUSTERED ([tipo_gasto_id] ASC)
--    )
    
--    INSERT INTO TiposGasto (nombre, descripcion) VALUES
--    ('Material Didáctico', 'Libros, cuadernos, material educativo'),
--    ('Servicios', 'Luz, agua, teléfono, internet'),
--    ('Mantenimiento', 'Reparaciones, limpieza, jardinería'),
--    ('Administrativo', 'Papelería, copias, documentos'),
--    ('Alimentación', 'Desayunos escolares, eventos'),
--    ('Otros', 'Gastos varios no clasificados')
--END
--GO

-- ====================================
-- 13. SCRIPT DE EJEMPLO PARA USAR EL SISTEMA
-- ====================================

/*
-- EJEMPLO DE USO DEL SISTEMA DE CORTE DE CAJA

-- 1. Crear un nuevo corte de caja
DECLARE @corte_id UNIQUEIDENTIFIER
DECLARE @escuela_id UNIQUEIDENTIFIER = 'tu-escuela-id-aqui'
DECLARE @usuario_id UNIQUEIDENTIFIER = 'tu-usuario-id-aqui'

EXEC SP_CrearNuevoCorte 
    @escuela_id = @escuela_id,
    @usuario_id = @usuario_id,
    @fecha_corte = '2025-06-17',
    @saldo_inicial = 5000.00,
    @efectivo_inicial = 2000.00,
    @observaciones = 'Apertura de corte diario',
    @corte_id = @corte_id OUTPUT

PRINT 'Corte creado con ID: ' + CAST(@corte_id AS VARCHAR(50))

-- 2. Registrar pagos en el corte (esto se haría automáticamente cuando se registren pagos)
-- EXEC SP_RegistrarPagoEnCorte @pago_id = 'pago-id', @escuela_id = @escuela_id

-- 3. Cerrar el corte al final del día
EXEC SP_CerrarCorte 
    @corte_id = @corte_id,
    @efectivo_final = 2500.00,
    @observaciones_cierre = 'Cierre normal del día'

-- 4. Generar reporte del corte
EXEC SP_ReporteCorte @corte_id = @corte_id

-- 5. Consultar capital actual
SELECT dbo.FN_CapitalActual(@escuela_id) as capital_actual

-- 6. Reporte financiero del mes
EXEC SP_ReporteFinancieroPeriodo 
    @escuela_id = @escuela_id,
    @fecha_inicio = '2025-06-01',
    @fecha_fin = '2025-06-30'
*/-- ====================================
-- SISTEMA DE CORTE DE CAJA
-- Escuelas Sanderson Satori
-- ====================================

USE [EscuelasSandersonSatori]
GO

-- ====================================
-- 9. VISTAS ÚTILES PARA CONSULTAS
-- ====================================

-- Vista resumen de cortes por escuela
CREATE VIEW [dbo].[VW_ResumenCortes] AS
SELECT 
    cc.corte_id,
    e.nombre as escuela_nombre,
    cc.fecha_corte,
    u.nombre as usuario_nombre,
    cc.total_ingresos,
    cc.total_gastos,
    cc.saldo_inicial,
    cc.saldo_final,
    cc.diferencia,
    cc.estado,
    -- Contadores
    (SELECT COUNT(*) FROM CorteCajaIngresos WHERE corte_id = cc.corte_id) as num_ingresos,
    (SELECT COUNT(*) FROM CorteCajaGastos WHERE corte_id = cc.corte_id) as num_gastos
FROM CortesCaja cc
INNER JOIN Escuelas e ON cc.escuela_id = e.escuela_id
INNER JOIN Usuarios u ON cc.usuario_id = u.usuario_id
GO

-- Vista detalle completo de ingresos
CREATE VIEW [dbo].[VW_DetalleIngresos] AS
SELECT 
    cci.detalle_id,
    cc.fecha_corte,
    e.nombre as escuela_nombre,
    cci.alumno_nombre,
    cci.concepto_nombre,
    cci.monto_original,
    cci.descuento,
    cci.recargo,
    cci.monto_pagado,
    cci.metodo_pago,
    cci.periodo,
    cci.referencia,
    cci.fecha_pago,
    cc.estado as estado_corte
FROM CorteCajaIngresos cci
INNER JOIN CortesCaja cc ON cci.corte_id = cc.corte_id
INNER JOIN Escuelas e ON cc.escuela_id = e.escuela_id
GO

-- Vista capital actual por escuela
CREATE VIEW [dbo].[VW_CapitalActual] AS
SELECT 
    e.nombre as escuela_nombre,
    cd.efectivo_disponible,
    cd.bancos_disponible,
    cd.total_disponible,
    cd.fecha,
    cd.fecha_actualizacion,
    u.nombre as usuario_actualizacion
FROM CapitalDisponible cd
INNER JOIN Escuelas e ON cd.escuela_id = e.escuela_id
INNER JOIN Usuarios u ON cd.usuario_actualizacion = u.usuario_id
WHERE cd.fecha = (
    SELECT MAX(fecha) 
    FROM CapitalDisponible cd2 
    WHERE cd2.escuela_id = cd.escuela_id
)
GO

-- ====================================
-- 10. PROCEDIMIENTOS ALMACENADOS
-- ====================================

-- Procedimiento para crear un nuevo corte de caja
CREATE PROCEDURE [dbo].[SP_CrearNuevoCorte]
    @escuela_id UNIQUEIDENTIFIER,
    @usuario_id UNIQUEIDENTIFIER,
    @fecha_corte DATE,
    @saldo_inicial DECIMAL(18,2) = 0,
    @efectivo_inicial DECIMAL(18,2) = 0,
    @observaciones NVARCHAR(MAX) = NULL,
    @corte_id UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar que no exista un corte abierto para la misma fecha y escuela
    IF EXISTS (SELECT 1 FROM CortesCaja 
               WHERE escuela_id = @escuela_id 
               AND fecha_corte = @fecha_corte 
               AND estado = 'Abierto')
    BEGIN
        RAISERROR('Ya existe un corte abierto para esta fecha y escuela', 16, 1)
        RETURN
    END
    
    SET @corte_id = NEWID()
    
    INSERT INTO CortesCaja (
        corte_id, escuela_id, fecha_corte, usuario_id, 
        saldo_inicial, efectivo_inicial, observaciones,
        hora_inicio
    )
    VALUES (
        @corte_id, @escuela_id, @fecha_corte, @usuario_id,
        @saldo_inicial, @efectivo_inicial, @observaciones,
        CAST(GETDATE() AS TIME)
    )
    
    SELECT @corte_id as corte_id
END
GO

-- Procedimiento para cerrar un corte de caja
CREATE PROCEDURE [dbo].[SP_CerrarCorte]
    @corte_id UNIQUEIDENTIFIER,
    @efectivo_final DECIMAL(18,2),
    @observaciones_cierre NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @total_ingresos DECIMAL(18,2)
    DECLARE @total_gastos DECIMAL(18,2)
    DECLARE @saldo_inicial DECIMAL(18,2)
    DECLARE @efectivo_inicial DECIMAL(18,2)
    DECLARE @efectivo_ingresos DECIMAL(18,2)
    DECLARE @efectivo_gastos DECIMAL(18,2)
    DECLARE @saldo_teorico DECIMAL(18,2)
    DECLARE @diferencia DECIMAL(18,2)
    DECLARE @escuela_id UNIQUEIDENTIFIER
    DECLARE @fecha_corte DATE
    
    -- Obtener datos del corte
    SELECT 
        @total_ingresos = total_ingresos,
        @total_gastos = total_gastos,
        @saldo_inicial = saldo_inicial,
        @efectivo_inicial = efectivo_inicial,
        @efectivo_ingresos = efectivo_ingresos,
        @efectivo_gastos = efectivo_gastos,
        @escuela_id = escuela_id,
        @fecha_corte = fecha_corte
    FROM CortesCaja 
    WHERE corte_id = @corte_id
    
    -- Calcular saldo teórico y diferencia
    SET @saldo_teorico = @saldo_inicial + @total_ingresos - @total_gastos
    SET @diferencia = @efectivo_final - (@efectivo_inicial + @efectivo_ingresos - @efectivo_gastos)
    
    -- Actualizar el corte
    UPDATE CortesCaja 
    SET 
        efectivo_final = @efectivo_final,
        saldo_final = @saldo_teorico,
        diferencia = @diferencia,
        estado = 'Cerrado',
        fecha_cierre = GETDATE(),
        hora_fin = CAST(GETDATE() AS TIME),
        observaciones = ISNULL(observaciones, '') + CHAR(13) + CHAR(10) + ISNULL(@observaciones_cierre, '')
    WHERE corte_id = @corte_id
    
    -- Actualizar capital disponible
    EXEC SP_ActualizarCapitalDisponible @escuela_id, @fecha_corte, @corte_id
END
GO

-- Procedimiento para actualizar capital disponible
CREATE PROCEDURE [dbo].[SP_ActualizarCapitalDisponible]
    @escuela_id UNIQUEIDENTIFIER,
    @fecha DATE,
    @corte_id UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @efectivo_total DECIMAL(18,2)
    DECLARE @total_disponible DECIMAL(18,2)
    DECLARE @usuario_actualizacion UNIQUEIDENTIFIER
    
    -- Calcular totales del día
    SELECT 
        @efectivo_total = ISNULL(SUM(efectivo_final), 0),
        @total_disponible = ISNULL(SUM(saldo_final), 0),
        @usuario_actualizacion = MAX(usuario_id)
    FROM CortesCaja 
    WHERE escuela_id = @escuela_id 
    AND fecha_corte = @fecha
    AND estado = 'Cerrado'
    
    -- Insertar o actualizar capital disponible
    IF EXISTS (SELECT 1 FROM CapitalDisponible WHERE escuela_id = @escuela_id AND fecha = @fecha)
    BEGIN
        UPDATE CapitalDisponible 
        SET 
            efectivo_disponible = @efectivo_total,
            total_disponible = @total_disponible,
            ultimo_corte_id = ISNULL(@corte_id, ultimo_corte_id),
            fecha_actualizacion = GETDATE(),
            usuario_actualizacion = @usuario_actualizacion
        WHERE escuela_id = @escuela_id AND fecha = @fecha
    END
    ELSE
    BEGIN
        INSERT INTO CapitalDisponible (
            escuela_id, fecha, efectivo_disponible, total_disponible,
            ultimo_corte_id, usuario_actualizacion
        )
        VALUES (
            @escuela_id, @fecha, @efectivo_total, @total_disponible,
            @corte_id, @usuario_actualizacion
        )
    END
END
GO

-- Procedimiento para obtener reporte de corte específico
CREATE PROCEDURE [dbo].[SP_ReporteCorte]
    @corte_id UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Información general del corte
    SELECT 
        cc.*,
        e.nombre as escuela_nombre,
        u.nombre as usuario_nombre,
        ur.nombre as revisado_por_nombre
    FROM CortesCaja cc
    INNER JOIN Escuelas e ON cc.escuela_id = e.escuela_id
    INNER JOIN Usuarios u ON cc.usuario_id = u.usuario_id
    LEFT JOIN Usuarios ur ON cc.revisado_por = ur.usuario_id
    WHERE cc.corte_id = @corte_id
    
    -- Detalle de ingresos
    SELECT * FROM CorteCajaIngresos 
    WHERE corte_id = @corte_id
    ORDER BY fecha_pago, alumno_nombre
    
    -- Detalle de gastos
    SELECT * FROM CorteCajaGastos 
    WHERE corte_id = @corte_id
    ORDER BY fecha_gasto, concepto
    
    -- Resumen por método de pago
    SELECT 
        metodo_pago,
        COUNT(*) as cantidad_pagos,
        SUM(monto_pagado) as total_monto
    FROM CorteCajaIngresos 
    WHERE corte_id = @corte_id
    GROUP BY metodo_pago
    
    -- Resumen por concepto
    SELECT 
        concepto_nombre,
        COUNT(*) as cantidad_pagos,
        SUM(monto_pagado) as total_monto
    FROM CorteCajaIngresos 
    WHERE corte_id = @corte_id
    GROUP BY concepto_nombre
END
GO

-- ====================================
-- 1. TABLA PRINCIPAL DE CORTES DE CAJA
-- ====================================
CREATE TABLE [dbo].[CortesCaja](
    [corte_id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
    [escuela_id] [uniqueidentifier] NOT NULL,
    [fecha_corte] [date] NOT NULL,
    [hora_inicio] [time] NULL,
    [hora_fin] [time] NULL,
    [usuario_id] [uniqueidentifier] NOT NULL, -- Usuario que realizó el corte
    
    -- TOTALES DEL CORTE
    [total_ingresos] [decimal](18, 2) NOT NULL DEFAULT (0),
    [total_gastos] [decimal](18, 2) NOT NULL DEFAULT (0),
    [saldo_inicial] [decimal](18, 2) NOT NULL DEFAULT (0),
    [saldo_final] [decimal](18, 2) NOT NULL DEFAULT (0),
    [diferencia] [decimal](18, 2) NOT NULL DEFAULT (0), -- saldo_final - (saldo_inicial + ingresos - gastos)
    
    -- DESGLOSE POR MÉTODO DE PAGO
    [efectivo_inicial] [decimal](18, 2) NULL DEFAULT (0),
    [efectivo_ingresos] [decimal](18, 2) NULL DEFAULT (0),
    [efectivo_gastos] [decimal](18, 2) NULL DEFAULT (0),
    [efectivo_final] [decimal](18, 2) NULL DEFAULT (0),
    
    [tarjeta_ingresos] [decimal](18, 2) NULL DEFAULT (0),
    [transferencia_ingresos] [decimal](18, 2) NULL DEFAULT (0),
    [cheque_ingresos] [decimal](18, 2) NULL DEFAULT (0),
    
    -- INFORMACIÓN ADICIONAL
    [observaciones] [nvarchar](max) NULL,
    [estado] [nvarchar](20) NOT NULL DEFAULT ('Abierto'), -- Abierto, Cerrado, Revisado
    [fecha_creacion] [datetime] NOT NULL DEFAULT (getdate()),
    [fecha_cierre] [datetime] NULL,
    [revisado_por] [uniqueidentifier] NULL,
    [fecha_revision] [datetime] NULL,
    
    CONSTRAINT [PK_CortesCaja] PRIMARY KEY CLUSTERED ([corte_id] ASC),
    CONSTRAINT [FK_CortesCaja_Escuelas] FOREIGN KEY([escuela_id]) REFERENCES [dbo].[Escuelas] ([escuela_id]),
    CONSTRAINT [FK_CortesCaja_Usuarios] FOREIGN KEY([usuario_id]) REFERENCES [dbo].[Usuarios] ([usuario_id]),
    CONSTRAINT [FK_CortesCaja_Revisado] FOREIGN KEY([revisado_por]) REFERENCES [dbo].[Usuarios] ([usuario_id])
)
GO

-- ====================================
-- 2. DETALLE DE INGRESOS POR CORTE
-- ====================================
CREATE TABLE [dbo].[CorteCajaIngresos](
    [detalle_id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
    [corte_id] [uniqueidentifier] NOT NULL,
    [pago_id] [uniqueidentifier] NOT NULL,
    [alumno_id] [uniqueidentifier] NOT NULL,
    [concepto_id] [uniqueidentifier] NOT NULL,
    
    -- INFORMACIÓN DEL PAGO
    [alumno_nombre] [nvarchar](300) NOT NULL, -- Nombre completo para consulta rápida
    [concepto_nombre] [nvarchar](100) NOT NULL,
    [monto_original] [decimal](18, 2) NOT NULL,
    [descuento] [decimal](18, 2) NOT NULL DEFAULT (0),
    [recargo] [decimal](18, 2) NOT NULL DEFAULT (0),
    [monto_pagado] [decimal](18, 2) NOT NULL,
    [metodo_pago] [nvarchar](20) NOT NULL,
    [periodo] [nvarchar](20) NULL,
    [referencia] [nvarchar](100) NULL,
    [fecha_pago] [datetime] NOT NULL,
    
    CONSTRAINT [PK_CorteCajaIngresos] PRIMARY KEY CLUSTERED ([detalle_id] ASC),
    CONSTRAINT [FK_CorteCajaIngresos_Corte] FOREIGN KEY([corte_id]) REFERENCES [dbo].[CortesCaja] ([corte_id]),
    CONSTRAINT [FK_CorteCajaIngresos_Pago] FOREIGN KEY([pago_id]) REFERENCES [dbo].[Pagos] ([pago_id]),
    CONSTRAINT [FK_CorteCajaIngresos_Alumno] FOREIGN KEY([alumno_id]) REFERENCES [dbo].[Alumnos] ([alumno_id]),
    CONSTRAINT [FK_CorteCajaIngresos_Concepto] FOREIGN KEY([concepto_id]) REFERENCES [dbo].[ConceptosPago] ([concepto_id])
)
GO

-- ====================================
-- 3. DETALLE DE GASTOS POR CORTE
-- ====================================
CREATE TABLE [dbo].[CorteCajaGastos](
    [detalle_id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
    [corte_id] [uniqueidentifier] NOT NULL,
    [gasto_id] [uniqueidentifier] NOT NULL,
    
    -- INFORMACIÓN DEL GASTO
    [concepto] [nvarchar](200) NOT NULL,
    [monto] [decimal](18, 2) NOT NULL,
    [tipo_gasto] [nvarchar](50) NOT NULL, -- Basado en IdTipoGasto de la tabla original
    [justificacion] [nvarchar](500) NULL,
    [es_gasto_general] [bit] NOT NULL DEFAULT (0),
    [fecha_gasto] [datetime] NOT NULL,
    [usuario_registro] [nvarchar](100) NOT NULL,
    
    CONSTRAINT [PK_CorteCajaGastos] PRIMARY KEY CLUSTERED ([detalle_id] ASC),
    CONSTRAINT [FK_CorteCajaGastos_Corte] FOREIGN KEY([corte_id]) REFERENCES [dbo].[CortesCaja] ([corte_id]),
    CONSTRAINT [FK_CorteCajaGastos_Gasto] FOREIGN KEY([gasto_id]) REFERENCES [dbo].[Gastos] ([IdGasto])
)
GO

-- ====================================
-- 4. TABLA DE CAPITAL DISPONIBLE
-- ====================================
CREATE TABLE [dbo].[CapitalDisponible](
    [capital_id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
    [escuela_id] [uniqueidentifier] NOT NULL,
    [fecha] [date] NOT NULL,
    
    -- SALDOS POR MÉTODO
    [efectivo_disponible] [decimal](18, 2) NOT NULL DEFAULT (0),
    [bancos_disponible] [decimal](18, 2) NOT NULL DEFAULT (0), -- Suma de cuentas bancarias
    [total_disponible] [decimal](18, 2) NOT NULL DEFAULT (0),
    
    -- DESGLOSE BANCARIO (puedes expandir según necesites)
    [cuenta_principal] [decimal](18, 2) NULL DEFAULT (0),
    [cuenta_secundaria] [decimal](18, 2) NULL DEFAULT (0),
    
    -- INFORMACIÓN DE CONTROL
    [ultimo_corte_id] [uniqueidentifier] NULL, -- Último corte que actualizó este registro
    [fecha_actualizacion] [datetime] NOT NULL DEFAULT (getdate()),
    [usuario_actualizacion] [uniqueidentifier] NOT NULL,
    
    CONSTRAINT [PK_CapitalDisponible] PRIMARY KEY CLUSTERED ([capital_id] ASC),
    CONSTRAINT [FK_CapitalDisponible_Escuela] FOREIGN KEY([escuela_id]) REFERENCES [dbo].[Escuelas] ([escuela_id]),
    CONSTRAINT [FK_CapitalDisponible_Usuario] FOREIGN KEY([usuario_actualizacion]) REFERENCES [dbo].[Usuarios] ([usuario_id]),
    CONSTRAINT [FK_CapitalDisponible_Corte] FOREIGN KEY([ultimo_corte_id]) REFERENCES [dbo].[CortesCaja] ([corte_id]),
    CONSTRAINT [UQ_CapitalDisponible_Escuela_Fecha] UNIQUE ([escuela_id], [fecha])
)
GO

-- ====================================
-- 5. TABLA DE RESUMEN DIARIO (Para consultas rápidas)
-- ====================================
CREATE TABLE [dbo].[ResumenDiario](
    [resumen_id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
    [escuela_id] [uniqueidentifier] NOT NULL,
    [fecha] [date] NOT NULL,
    
    -- TOTALES DEL DÍA
    [total_ingresos] [decimal](18, 2) NOT NULL DEFAULT (0),
    [total_gastos] [decimal](18, 2) NOT NULL DEFAULT (0),
    [saldo_neto] [decimal](18, 2) NOT NULL DEFAULT (0),
    
    -- INGRESOS POR MÉTODO
    [ingresos_efectivo] [decimal](18, 2) NOT NULL DEFAULT (0),
    [ingresos_tarjeta] [decimal](18, 2) NOT NULL DEFAULT (0),
    [ingresos_transferencia] [decimal](18, 2) NOT NULL DEFAULT (0),
    [ingresos_cheque] [decimal](18, 2) NOT NULL DEFAULT (0),
    
    -- INGRESOS POR CONCEPTO
    [ingresos_colegiatura] [decimal](18, 2) NOT NULL DEFAULT (0),
    [ingresos_inscripcion] [decimal](18, 2) NOT NULL DEFAULT (0),
    [ingresos_uniformes] [decimal](18, 2) NOT NULL DEFAULT (0),
    [ingresos_talleres] [decimal](18, 2) NOT NULL DEFAULT (0),
    [ingresos_otros] [decimal](18, 2) NOT NULL DEFAULT (0),
    
    -- CONTADORES
    [numero_pagos] [int] NOT NULL DEFAULT (0),
    [numero_gastos] [int] NOT NULL DEFAULT (0),
    [numero_cortes] [int] NOT NULL DEFAULT (0),
    
    [fecha_actualizacion] [datetime] NOT NULL DEFAULT (getdate()),
    
    CONSTRAINT [PK_ResumenDiario] PRIMARY KEY CLUSTERED ([resumen_id] ASC),
    CONSTRAINT [FK_ResumenDiario_Escuela] FOREIGN KEY([escuela_id]) REFERENCES [dbo].[Escuelas] ([escuela_id]),
    CONSTRAINT [UQ_ResumenDiario_Escuela_Fecha] UNIQUE ([escuela_id], [fecha])
)
GO

-- ====================================
-- 6. ÍNDICES PARA OPTIMIZAR CONSULTAS
-- ====================================

-- Índices para CortesCaja
CREATE NONCLUSTERED INDEX [IX_CortesCaja_Escuela_Fecha] ON [dbo].[CortesCaja] ([escuela_id], [fecha_corte])
CREATE NONCLUSTERED INDEX [IX_CortesCaja_Estado] ON [dbo].[CortesCaja] ([estado])
CREATE NONCLUSTERED INDEX [IX_CortesCaja_Usuario] ON [dbo].[CortesCaja] ([usuario_id])

-- Índices para CorteCajaIngresos
CREATE NONCLUSTERED INDEX [IX_CorteCajaIngresos_Corte] ON [dbo].[CorteCajaIngresos] ([corte_id])
CREATE NONCLUSTERED INDEX [IX_CorteCajaIngresos_Fecha] ON [dbo].[CorteCajaIngresos] ([fecha_pago])
CREATE NONCLUSTERED INDEX [IX_CorteCajaIngresos_Metodo] ON [dbo].[CorteCajaIngresos] ([metodo_pago])

-- Índices para CorteCajaGastos
CREATE NONCLUSTERED INDEX [IX_CorteCajaGastos_Corte] ON [dbo].[CorteCajaGastos] ([corte_id])
CREATE NONCLUSTERED INDEX [IX_CorteCajaGastos_Fecha] ON [dbo].[CorteCajaGastos] ([fecha_gasto])
CREATE NONCLUSTERED INDEX [IX_CorteCajaGastos_Tipo] ON [dbo].[CorteCajaGastos] ([tipo_gasto])

-- Índices para CapitalDisponible
CREATE NONCLUSTERED INDEX [IX_CapitalDisponible_Escuela_Fecha] ON [dbo].[CapitalDisponible] ([escuela_id], [fecha])

-- Índices para ResumenDiario
CREATE NONCLUSTERED INDEX [IX_ResumenDiario_Escuela_Fecha] ON [dbo].[ResumenDiario] ([escuela_id], [fecha])

-- ====================================
-- 7. RESTRICCIONES ADICIONALES
-- ====================================

-- Restricciones para estado del corte
ALTER TABLE [dbo].[CortesCaja] 
ADD CONSTRAINT [CK_CortesCaja_Estado] 
CHECK ([estado] IN ('Abierto', 'Cerrado', 'Revisado', 'Cancelado'))

-- Restricción para métodos de pago
ALTER TABLE [dbo].[CorteCajaIngresos] 
ADD CONSTRAINT [CK_CorteCajaIngresos_MetodoPago] 
CHECK ([metodo_pago] IN ('Efectivo', 'Tarjeta', 'Transferencia', 'Cheque'))

-- ====================================
-- 8. TRIGGERS PARA MANTENER CONSISTENCIA
-- ====================================

-- Trigger para actualizar totales en CortesCaja cuando se agregan ingresos
CREATE TRIGGER [TR_CorteCajaIngresos_Insert]
ON [dbo].[CorteCajaIngresos]
AFTER INSERT
AS
BEGIN
    UPDATE cc
    SET 
        total_ingresos = (
            SELECT ISNULL(SUM(monto_pagado), 0) 
            FROM CorteCajaIngresos 
            WHERE corte_id = cc.corte_id
        ),
        efectivo_ingresos = (
            SELECT ISNULL(SUM(monto_pagado), 0) 
            FROM CorteCajaIngresos 
            WHERE corte_id = cc.corte_id AND metodo_pago = 'Efectivo'
        ),
        tarjeta_ingresos = (
            SELECT ISNULL(SUM(monto_pagado), 0) 
            FROM CorteCajaIngresos 
            WHERE corte_id = cc.corte_id AND metodo_pago = 'Tarjeta'
        ),
        transferencia_ingresos = (
            SELECT ISNULL(SUM(monto_pagado), 0) 
            FROM CorteCajaIngresos 
            WHERE corte_id = cc.corte_id AND metodo_pago = 'Transferencia'
        ),
        cheque_ingresos = (
            SELECT ISNULL(SUM(monto_pagado), 0) 
            FROM CorteCajaIngresos 
            WHERE corte_id = cc.corte_id AND metodo_pago = 'Cheque'
        )
    FROM CortesCaja cc
    INNER JOIN inserted i ON cc.corte_id = i.corte_id
END
GO

-- Trigger para actualizar totales en CortesCaja cuando se agregan gastos
CREATE TRIGGER [TR_CorteCajaGastos_Insert]
ON [dbo].[CorteCajaGastos]
AFTER INSERT
AS
BEGIN
    UPDATE cc
    SET 
        total_gastos = (
            SELECT ISNULL(SUM(monto), 0) 
            FROM CorteCajaGastos 
            WHERE corte_id = cc.corte_id
        ),
        efectivo_gastos = (
            SELECT ISNULL(SUM(monto), 0) 
            FROM CorteCajaGastos 
            WHERE corte_id = cc.corte_id 
            -- Aquí puedes agregar lógica para identificar gastos en efectivo
        )
    FROM CortesCaja cc
    INNER JOIN inserted i ON cc.corte_id = i.corte_id
END
GO

CREATE PROCEDURE [dbo].[SP_ActualizarCorte]
    @corte_id UNIQUEIDENTIFIER,
    @efectivo_final DECIMAL(18,2),
    @saldo_final DECIMAL(18,2),
    @diferencia DECIMAL(18,2),
    @observaciones NVARCHAR(MAX),
    @usuario_cierre UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Actualizar el corte
        UPDATE CortesCaja 
        SET 
            efectivo_final = @efectivo_final,
            saldo_final = @saldo_final,
            diferencia = @diferencia,
            estado = 'Cerrado',
            fecha_cierre = GETDATE(),
            hora_fin = CAST(GETDATE() AS TIME),
            observaciones = ISNULL(observaciones, '') + CHAR(13) + CHAR(10) + @observaciones,
            usuario_cierre = @usuario_cierre
        WHERE corte_id = @corte_id;
        
        -- Actualizar capital disponible
        DECLARE @escuela_id UNIQUEIDENTIFIER;
        DECLARE @fecha_corte DATE;
        
        SELECT @escuela_id = escuela_id, @fecha_corte = fecha_corte
        FROM CortesCaja 
        WHERE corte_id = @corte_id;
        
        EXEC SP_ActualizarCapitalDisponible 
            @escuela_id = @escuela_id,
            @fecha = @fecha_corte,
            @corte_id = @corte_id;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        THROW;
    END CATCH
END
GO