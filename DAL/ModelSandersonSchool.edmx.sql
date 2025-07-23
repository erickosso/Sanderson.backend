
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 05/12/2025 11:07:29
-- Generated from EDMX file: D:\Desarrollo\Sanderson\Sanderson.backend\sanderson.backend\DAL\ModelSandersonSchool.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [DBSandersonSchool];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK__T_Alumnos__Nivel__3B75D760]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[T_Alumnos] DROP CONSTRAINT [FK__T_Alumnos__Nivel__3B75D760];
GO
IF OBJECT_ID(N'[dbo].[FK__T_BecasAl__IdAlu__4BAC3F29]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[T_BecasAlumno] DROP CONSTRAINT [FK__T_BecasAl__IdAlu__4BAC3F29];
GO
IF OBJECT_ID(N'[dbo].[FK__T_BecasAl__IdBec__4CA06362]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[T_BecasAlumno] DROP CONSTRAINT [FK__T_BecasAl__IdBec__4CA06362];
GO
IF OBJECT_ID(N'[dbo].[FK__T_Gastos__IdTipo__6FE99F9F]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[T_Gastos] DROP CONSTRAINT [FK__T_Gastos__IdTipo__6FE99F9F];
GO
IF OBJECT_ID(N'[dbo].[FK__T_Inscrip__IdAlu__5070F446]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[T_Inscripciones] DROP CONSTRAINT [FK__T_Inscrip__IdAlu__5070F446];
GO
IF OBJECT_ID(N'[dbo].[FK_C_CicloEscolar_T_Escuela]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[C_CicloEscolar] DROP CONSTRAINT [FK_C_CicloEscolar_T_Escuela];
GO
IF OBJECT_ID(N'[dbo].[FK_T_Alumno_C_CicloEscolar]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[T_Alumnos] DROP CONSTRAINT [FK_T_Alumno_C_CicloEscolar];
GO
IF OBJECT_ID(N'[dbo].[FK_T_Alumno_T_Escuela]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[T_Alumnos] DROP CONSTRAINT [FK_T_Alumno_T_Escuela];
GO
IF OBJECT_ID(N'[dbo].[FK_T_Beca_C_CicloEscolar]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[T_BecasAlumno] DROP CONSTRAINT [FK_T_Beca_C_CicloEscolar];
GO
IF OBJECT_ID(N'[dbo].[FK_T_Inscripcion_C_CicloEscolar]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[T_Inscripciones] DROP CONSTRAINT [FK_T_Inscripcion_C_CicloEscolar];
GO
IF OBJECT_ID(N'[dbo].[FK_T_Usuario_C_Rol]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[T_Usuario] DROP CONSTRAINT [FK_T_Usuario_C_Rol];
GO
IF OBJECT_ID(N'[dbo].[FK_T_Usuario_T_Escuela]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[T_Usuario] DROP CONSTRAINT [FK_T_Usuario_T_Escuela];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[C_CicloEscolar]', 'U') IS NOT NULL
    DROP TABLE [dbo].[C_CicloEscolar];
GO
IF OBJECT_ID(N'[dbo].[C_PlanesPago]', 'U') IS NOT NULL
    DROP TABLE [dbo].[C_PlanesPago];
GO
IF OBJECT_ID(N'[dbo].[C_Rol]', 'U') IS NOT NULL
    DROP TABLE [dbo].[C_Rol];
GO
IF OBJECT_ID(N'[dbo].[C_Talleres]', 'U') IS NOT NULL
    DROP TABLE [dbo].[C_Talleres];
GO
IF OBJECT_ID(N'[dbo].[C_TiposBeca]', 'U') IS NOT NULL
    DROP TABLE [dbo].[C_TiposBeca];
GO
IF OBJECT_ID(N'[dbo].[C_TiposGasto]', 'U') IS NOT NULL
    DROP TABLE [dbo].[C_TiposGasto];
GO
IF OBJECT_ID(N'[dbo].[sysdiagrams]', 'U') IS NOT NULL
    DROP TABLE [dbo].[sysdiagrams];
GO
IF OBJECT_ID(N'[dbo].[T_Alumnos]', 'U') IS NOT NULL
    DROP TABLE [dbo].[T_Alumnos];
GO
IF OBJECT_ID(N'[dbo].[T_BecasAlumno]', 'U') IS NOT NULL
    DROP TABLE [dbo].[T_BecasAlumno];
GO
IF OBJECT_ID(N'[dbo].[T_Escuela]', 'U') IS NOT NULL
    DROP TABLE [dbo].[T_Escuela];
GO
IF OBJECT_ID(N'[dbo].[T_Gastos]', 'U') IS NOT NULL
    DROP TABLE [dbo].[T_Gastos];
GO
IF OBJECT_ID(N'[dbo].[T_Inscripciones]', 'U') IS NOT NULL
    DROP TABLE [dbo].[T_Inscripciones];
GO
IF OBJECT_ID(N'[dbo].[T_NivelesAcademicos]', 'U') IS NOT NULL
    DROP TABLE [dbo].[T_NivelesAcademicos];
GO
IF OBJECT_ID(N'[dbo].[T_Usuario]', 'U') IS NOT NULL
    DROP TABLE [dbo].[T_Usuario];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'C_CicloEscolar'
CREATE TABLE [dbo].[C_CicloEscolar] (
    [IdCicloEscolar] uniqueidentifier  NOT NULL,
    [IdEscuela] uniqueidentifier  NOT NULL,
    [Nombre] nvarchar(50)  NOT NULL,
    [FechaInicio] datetime  NOT NULL,
    [FechaFin] datetime  NOT NULL,
    [Activo] bit  NOT NULL
);
GO

-- Creating table 'C_PlanesPago'
CREATE TABLE [dbo].[C_PlanesPago] (
    [IdPlan] uniqueidentifier  NOT NULL,
    [Nombre] nvarchar(50)  NULL,
    [NumMeses] int  NULL
);
GO

-- Creating table 'C_Rol'
CREATE TABLE [dbo].[C_Rol] (
    [IdRol] uniqueidentifier  NOT NULL,
    [NombreRol] nvarchar(50)  NOT NULL
);
GO

-- Creating table 'C_Talleres'
CREATE TABLE [dbo].[C_Talleres] (
    [IdTaller] uniqueidentifier  NOT NULL,
    [Nombre] nvarchar(100)  NULL,
    [CostoMensual] decimal(10,2)  NULL
);
GO

-- Creating table 'C_TiposBeca'
CREATE TABLE [dbo].[C_TiposBeca] (
    [IdBeca] uniqueidentifier  NOT NULL,
    [Nombre] nvarchar(50)  NULL,
    [PorcentajeDescuento] int  NULL
);
GO

-- Creating table 'C_TiposGasto'
CREATE TABLE [dbo].[C_TiposGasto] (
    [IdTipoGasto] uniqueidentifier  NOT NULL,
    [Nombre] nvarchar(50)  NULL
);
GO

-- Creating table 'sysdiagrams'
CREATE TABLE [dbo].[sysdiagrams] (
    [name] nvarchar(128)  NOT NULL,
    [principal_id] int  NOT NULL,
    [diagram_id] int IDENTITY(1,1) NOT NULL,
    [version] int  NULL,
    [definition] varbinary(max)  NULL
);
GO

-- Creating table 'T_Alumnos'
CREATE TABLE [dbo].[T_Alumnos] (
    [IdAlumno] uniqueidentifier  NOT NULL,
    [NombreCompleto] nvarchar(100)  NULL,
    [FechaNacimiento] datetime  NULL,
    [CURP] nvarchar(18)  NULL,
    [IdNivel] uniqueidentifier  NULL,
    [Grado] int  NULL,
    [Alergias] nvarchar(255)  NULL,
    [Observaciones] nvarchar(255)  NULL,
    [IdEscuela] uniqueidentifier  NULL,
    [IdCicloEscolar] uniqueidentifier  NOT NULL
);
GO

-- Creating table 'T_BecasAlumno'
CREATE TABLE [dbo].[T_BecasAlumno] (
    [IdAlumno] uniqueidentifier  NOT NULL,
    [IdBeca] uniqueidentifier  NOT NULL,
    [IdCicloEscolar] uniqueidentifier  NOT NULL
);
GO

-- Creating table 'T_Escuela'
CREATE TABLE [dbo].[T_Escuela] (
    [IdEscuela] uniqueidentifier  NOT NULL,
    [Nombre] nvarchar(100)  NOT NULL,
    [TipoEscuela] nvarchar(50)  NOT NULL,
    [Activa] bit  NOT NULL
);
GO

-- Creating table 'T_Gastos'
CREATE TABLE [dbo].[T_Gastos] (
    [IdGasto] uniqueidentifier  NOT NULL,
    [IdTipoGasto] uniqueidentifier  NULL,
    [Descripcion] nvarchar(255)  NULL,
    [Monto] decimal(10,2)  NULL,
    [Fecha] datetime  NULL,
    [SoloVisibleDirector] bit  NULL
);
GO

-- Creating table 'T_Inscripciones'
CREATE TABLE [dbo].[T_Inscripciones] (
    [IdInscripcion] uniqueidentifier  NOT NULL,
    [IdAlumno] uniqueidentifier  NULL,
    [AñoEscolar] int  NULL,
    [MontoBase] decimal(10,2)  NULL,
    [DescuentoAplicado] decimal(5,2)  NULL,
    [FechaInscripcion] datetime  NULL,
    [IdCicloEscolar] uniqueidentifier  NOT NULL
);
GO

-- Creating table 'T_NivelesAcademicos'
CREATE TABLE [dbo].[T_NivelesAcademicos] (
    [IdNivel] uniqueidentifier  NOT NULL,
    [Nombre] nvarchar(50)  NULL,
    [IdEscuela] uniqueidentifier  NULL
);
GO

-- Creating table 'T_Usuario'
CREATE TABLE [dbo].[T_Usuario] (
    [IdUsuario] uniqueidentifier  NOT NULL,
    [IdRol] uniqueidentifier  NOT NULL,
    [IdEscuela] uniqueidentifier  NULL,
    [Nombre] nvarchar(100)  NOT NULL,
    [Usuario] nvarchar(50)  NOT NULL,
    [ContraseñaHash] nvarchar(256)  NOT NULL,
    [Correo] nvarchar(100)  NULL,
    [Telefono] nvarchar(20)  NULL,
    [Activo] bit  NOT NULL,
    [FechaCreacion] datetime  NOT NULL,
    [Cargo] nvarchar(100)  NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [IdCicloEscolar] in table 'C_CicloEscolar'
ALTER TABLE [dbo].[C_CicloEscolar]
ADD CONSTRAINT [PK_C_CicloEscolar]
    PRIMARY KEY CLUSTERED ([IdCicloEscolar] ASC);
GO

-- Creating primary key on [IdPlan] in table 'C_PlanesPago'
ALTER TABLE [dbo].[C_PlanesPago]
ADD CONSTRAINT [PK_C_PlanesPago]
    PRIMARY KEY CLUSTERED ([IdPlan] ASC);
GO

-- Creating primary key on [IdRol] in table 'C_Rol'
ALTER TABLE [dbo].[C_Rol]
ADD CONSTRAINT [PK_C_Rol]
    PRIMARY KEY CLUSTERED ([IdRol] ASC);
GO

-- Creating primary key on [IdTaller] in table 'C_Talleres'
ALTER TABLE [dbo].[C_Talleres]
ADD CONSTRAINT [PK_C_Talleres]
    PRIMARY KEY CLUSTERED ([IdTaller] ASC);
GO

-- Creating primary key on [IdBeca] in table 'C_TiposBeca'
ALTER TABLE [dbo].[C_TiposBeca]
ADD CONSTRAINT [PK_C_TiposBeca]
    PRIMARY KEY CLUSTERED ([IdBeca] ASC);
GO

-- Creating primary key on [IdTipoGasto] in table 'C_TiposGasto'
ALTER TABLE [dbo].[C_TiposGasto]
ADD CONSTRAINT [PK_C_TiposGasto]
    PRIMARY KEY CLUSTERED ([IdTipoGasto] ASC);
GO

-- Creating primary key on [diagram_id] in table 'sysdiagrams'
ALTER TABLE [dbo].[sysdiagrams]
ADD CONSTRAINT [PK_sysdiagrams]
    PRIMARY KEY CLUSTERED ([diagram_id] ASC);
GO

-- Creating primary key on [IdAlumno] in table 'T_Alumnos'
ALTER TABLE [dbo].[T_Alumnos]
ADD CONSTRAINT [PK_T_Alumnos]
    PRIMARY KEY CLUSTERED ([IdAlumno] ASC);
GO

-- Creating primary key on [IdAlumno], [IdBeca], [IdCicloEscolar] in table 'T_BecasAlumno'
ALTER TABLE [dbo].[T_BecasAlumno]
ADD CONSTRAINT [PK_T_BecasAlumno]
    PRIMARY KEY CLUSTERED ([IdAlumno], [IdBeca], [IdCicloEscolar] ASC);
GO

-- Creating primary key on [IdEscuela] in table 'T_Escuela'
ALTER TABLE [dbo].[T_Escuela]
ADD CONSTRAINT [PK_T_Escuela]
    PRIMARY KEY CLUSTERED ([IdEscuela] ASC);
GO

-- Creating primary key on [IdGasto] in table 'T_Gastos'
ALTER TABLE [dbo].[T_Gastos]
ADD CONSTRAINT [PK_T_Gastos]
    PRIMARY KEY CLUSTERED ([IdGasto] ASC);
GO

-- Creating primary key on [IdInscripcion] in table 'T_Inscripciones'
ALTER TABLE [dbo].[T_Inscripciones]
ADD CONSTRAINT [PK_T_Inscripciones]
    PRIMARY KEY CLUSTERED ([IdInscripcion] ASC);
GO

-- Creating primary key on [IdNivel] in table 'T_NivelesAcademicos'
ALTER TABLE [dbo].[T_NivelesAcademicos]
ADD CONSTRAINT [PK_T_NivelesAcademicos]
    PRIMARY KEY CLUSTERED ([IdNivel] ASC);
GO

-- Creating primary key on [IdUsuario] in table 'T_Usuario'
ALTER TABLE [dbo].[T_Usuario]
ADD CONSTRAINT [PK_T_Usuario]
    PRIMARY KEY CLUSTERED ([IdUsuario] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [IdEscuela] in table 'C_CicloEscolar'
ALTER TABLE [dbo].[C_CicloEscolar]
ADD CONSTRAINT [FK_C_CicloEscolar_T_Escuela]
    FOREIGN KEY ([IdEscuela])
    REFERENCES [dbo].[T_Escuela]
        ([IdEscuela])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_C_CicloEscolar_T_Escuela'
CREATE INDEX [IX_FK_C_CicloEscolar_T_Escuela]
ON [dbo].[C_CicloEscolar]
    ([IdEscuela]);
GO

-- Creating foreign key on [IdCicloEscolar] in table 'T_Alumnos'
ALTER TABLE [dbo].[T_Alumnos]
ADD CONSTRAINT [FK_T_Alumno_C_CicloEscolar]
    FOREIGN KEY ([IdCicloEscolar])
    REFERENCES [dbo].[C_CicloEscolar]
        ([IdCicloEscolar])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_T_Alumno_C_CicloEscolar'
CREATE INDEX [IX_FK_T_Alumno_C_CicloEscolar]
ON [dbo].[T_Alumnos]
    ([IdCicloEscolar]);
GO

-- Creating foreign key on [IdCicloEscolar] in table 'T_BecasAlumno'
ALTER TABLE [dbo].[T_BecasAlumno]
ADD CONSTRAINT [FK_T_Beca_C_CicloEscolar]
    FOREIGN KEY ([IdCicloEscolar])
    REFERENCES [dbo].[C_CicloEscolar]
        ([IdCicloEscolar])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_T_Beca_C_CicloEscolar'
CREATE INDEX [IX_FK_T_Beca_C_CicloEscolar]
ON [dbo].[T_BecasAlumno]
    ([IdCicloEscolar]);
GO

-- Creating foreign key on [IdCicloEscolar] in table 'T_Inscripciones'
ALTER TABLE [dbo].[T_Inscripciones]
ADD CONSTRAINT [FK_T_Inscripcion_C_CicloEscolar]
    FOREIGN KEY ([IdCicloEscolar])
    REFERENCES [dbo].[C_CicloEscolar]
        ([IdCicloEscolar])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_T_Inscripcion_C_CicloEscolar'
CREATE INDEX [IX_FK_T_Inscripcion_C_CicloEscolar]
ON [dbo].[T_Inscripciones]
    ([IdCicloEscolar]);
GO

-- Creating foreign key on [IdRol] in table 'T_Usuario'
ALTER TABLE [dbo].[T_Usuario]
ADD CONSTRAINT [FK_T_Usuario_C_Rol]
    FOREIGN KEY ([IdRol])
    REFERENCES [dbo].[C_Rol]
        ([IdRol])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_T_Usuario_C_Rol'
CREATE INDEX [IX_FK_T_Usuario_C_Rol]
ON [dbo].[T_Usuario]
    ([IdRol]);
GO

-- Creating foreign key on [IdBeca] in table 'T_BecasAlumno'
ALTER TABLE [dbo].[T_BecasAlumno]
ADD CONSTRAINT [FK__T_BecasAl__IdBec__4CA06362]
    FOREIGN KEY ([IdBeca])
    REFERENCES [dbo].[C_TiposBeca]
        ([IdBeca])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK__T_BecasAl__IdBec__4CA06362'
CREATE INDEX [IX_FK__T_BecasAl__IdBec__4CA06362]
ON [dbo].[T_BecasAlumno]
    ([IdBeca]);
GO

-- Creating foreign key on [IdTipoGasto] in table 'T_Gastos'
ALTER TABLE [dbo].[T_Gastos]
ADD CONSTRAINT [FK__T_Gastos__IdTipo__6FE99F9F]
    FOREIGN KEY ([IdTipoGasto])
    REFERENCES [dbo].[C_TiposGasto]
        ([IdTipoGasto])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK__T_Gastos__IdTipo__6FE99F9F'
CREATE INDEX [IX_FK__T_Gastos__IdTipo__6FE99F9F]
ON [dbo].[T_Gastos]
    ([IdTipoGasto]);
GO

-- Creating foreign key on [IdNivel] in table 'T_Alumnos'
ALTER TABLE [dbo].[T_Alumnos]
ADD CONSTRAINT [FK__T_Alumnos__Nivel__3B75D760]
    FOREIGN KEY ([IdNivel])
    REFERENCES [dbo].[T_NivelesAcademicos]
        ([IdNivel])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK__T_Alumnos__Nivel__3B75D760'
CREATE INDEX [IX_FK__T_Alumnos__Nivel__3B75D760]
ON [dbo].[T_Alumnos]
    ([IdNivel]);
GO

-- Creating foreign key on [IdAlumno] in table 'T_BecasAlumno'
ALTER TABLE [dbo].[T_BecasAlumno]
ADD CONSTRAINT [FK__T_BecasAl__IdAlu__4BAC3F29]
    FOREIGN KEY ([IdAlumno])
    REFERENCES [dbo].[T_Alumnos]
        ([IdAlumno])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [IdAlumno] in table 'T_Inscripciones'
ALTER TABLE [dbo].[T_Inscripciones]
ADD CONSTRAINT [FK__T_Inscrip__IdAlu__5070F446]
    FOREIGN KEY ([IdAlumno])
    REFERENCES [dbo].[T_Alumnos]
        ([IdAlumno])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK__T_Inscrip__IdAlu__5070F446'
CREATE INDEX [IX_FK__T_Inscrip__IdAlu__5070F446]
ON [dbo].[T_Inscripciones]
    ([IdAlumno]);
GO

-- Creating foreign key on [IdEscuela] in table 'T_Alumnos'
ALTER TABLE [dbo].[T_Alumnos]
ADD CONSTRAINT [FK_T_Alumno_T_Escuela]
    FOREIGN KEY ([IdEscuela])
    REFERENCES [dbo].[T_Escuela]
        ([IdEscuela])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_T_Alumno_T_Escuela'
CREATE INDEX [IX_FK_T_Alumno_T_Escuela]
ON [dbo].[T_Alumnos]
    ([IdEscuela]);
GO

-- Creating foreign key on [IdEscuela] in table 'T_Usuario'
ALTER TABLE [dbo].[T_Usuario]
ADD CONSTRAINT [FK_T_Usuario_T_Escuela]
    FOREIGN KEY ([IdEscuela])
    REFERENCES [dbo].[T_Escuela]
        ([IdEscuela])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_T_Usuario_T_Escuela'
CREATE INDEX [IX_FK_T_Usuario_T_Escuela]
ON [dbo].[T_Usuario]
    ([IdEscuela]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------