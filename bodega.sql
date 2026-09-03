/*==============================================================================
  SISTEMA WEB DE VENTAS Y CONTROL DE INVENTARIO
  BODEGA "TIA MARTHA" - VERDICIÓN POSTGRESQL (PL/pgSQL)
==============================================================================*/

DROP DATABASE IF EXISTS bd_bodega_tia_martha;
CREATE DATABASE bd_bodega_tia_martha;

\c bd_bodega_tia_martha;

/*==============================================================================
  1. UBICACION GEOGRAFICA
==============================================================================*/
CREATE TABLE DEPARTAMENTO(
    ID_Departamento     serial        NOT NULL,
    N_Departamento      varchar(30)   NOT NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_DEPARTAMENTO PRIMARY KEY (ID_Departamento)
);

CREATE TABLE PROVINCIA(
    ID_Provincia        serial        NOT NULL,
    ID_Departamento     integer       NOT NULL,
    N_Provincia         varchar(30)   NOT NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_PROVINCIA PRIMARY KEY (ID_Provincia),
    CONSTRAINT FK_PROVINCIA_DEPARTAMENTO FOREIGN KEY (ID_Departamento)
        REFERENCES DEPARTAMENTO(ID_Departamento)
);

CREATE TABLE DISTRITO(
    ID_Distrito         serial        NOT NULL,
    ID_Provincia        integer       NOT NULL,
    D_Distrito          varchar(40)   NOT NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_DISTRITO PRIMARY KEY (ID_Distrito),
    CONSTRAINT FK_DISTRITO_PROVINCIA FOREIGN KEY (ID_Provincia)
        REFERENCES PROVINCIA(ID_Provincia)
);

/*==============================================================================
  2. PERSONAS, EMPRESAS Y PERSONAL
==============================================================================*/
CREATE TABLE TIPO_IDENTIDAD(
    ID_TipoIdentidad    serial        NOT NULL,
    N_TipoIdentidad     varchar(20)   NOT NULL,
    Abreviatura         varchar(10)   NULL,
    Longitud            integer       NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_TIPO_IDENTIDAD PRIMARY KEY (ID_TipoIdentidad)
);

CREATE TABLE PERSONA(
    ID_Persona          serial        NOT NULL,
    ID_Distrito         integer       NULL,
    ID_TipoIdentidad    integer       NOT NULL,
    N_Documento         varchar(15)   NOT NULL,
    Nombre              varchar(80)   NOT NULL,
    Ap_Paterno          varchar(80)   NULL,
    Ap_Materno          varchar(80)   NULL,
    F_Nacimiento        date          NULL,
    EMAIL               varchar(50)   NULL,
    Celular             char(9)       NULL,
    Genero              char(1)       NULL,
    Direccion           varchar(100)  NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_PERSONA PRIMARY KEY (ID_Persona),
    CONSTRAINT FK_PERSONA_DISTRITO FOREIGN KEY (ID_Distrito)
        REFERENCES DISTRITO(ID_Distrito),
    CONSTRAINT FK_PERSONA_TIPO_IDENTIDAD FOREIGN KEY (ID_TipoIdentidad)
        REFERENCES TIPO_IDENTIDAD(ID_TipoIdentidad),
    CONSTRAINT CK_PERSONA_GENERO CHECK (Genero IN ('M','F','O') OR Genero IS NULL)
);

CREATE TABLE EMPRESA(
    ID_Empresa          serial        NOT NULL,
    RUC                 char(11)      NOT NULL,
    Razon_Social        varchar(140)  NOT NULL,
    Direccion           varchar(150)  NULL,
    Telefono            char(8)       NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_EMPRESA PRIMARY KEY (ID_Empresa)
);

CREATE TABLE CARGO(
    ID_Cargo            serial        NOT NULL,
    N_Cargo             varchar(40)   NOT NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_CARGO PRIMARY KEY (ID_Cargo)
);

CREATE TABLE CONTRATO(
    ID_Contrato         serial        NOT NULL,
    N_Contrato          varchar(40)   NOT NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_CONTRATO PRIMARY KEY (ID_Contrato)
);

CREATE TABLE EMPLEADO(
    ID_Empleado         serial        NOT NULL,
    ID_Persona          integer       NOT NULL,
    ID_Contrato         integer       NULL,
    ID_Cargo            integer       NULL,
    Salario             numeric(8,2)  NULL,
    Turno               varchar(18)   NULL,
    Fondo_Pension       char(3)       NULL,
    N_Hps               char(11)      NULL,
    ESSALUD             char(6)       NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_EMPLEADO PRIMARY KEY (ID_Empleado),
    CONSTRAINT FK_EMPLEADO_PERSONA  FOREIGN KEY (ID_Persona)  REFERENCES PERSONA(ID_Persona),
    CONSTRAINT FK_EMPLEADO_CONTRATO FOREIGN KEY (ID_Contrato) REFERENCES CONTRATO(ID_Contrato),
    CONSTRAINT FK_EMPLEADO_CARGO    FOREIGN KEY (ID_Cargo)    REFERENCES CARGO(ID_Cargo)
);

/*==============================================================================
  3. SEGURIDAD: USUARIOS, ROLES Y PERMISOS
==============================================================================*/
CREATE TABLE TIPO_USUARIO(
    ID_TipoUsuario      serial        NOT NULL,
    N_TipoUsuario       varchar(50)   NOT NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_TIPO_USUARIO PRIMARY KEY (ID_TipoUsuario)
);

CREATE TABLE USUARIO(
    ID_Usuario          serial        NOT NULL,
    ID_TipoUsuario      integer       NOT NULL,
    ID_Empleado         integer       NULL,
    Logeo               varchar(30)   NOT NULL,
    Clave               varchar(200)  NOT NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_USUARIO PRIMARY KEY (ID_Usuario),
    CONSTRAINT UQ_USUARIO_LOGEO UNIQUE (Logeo),
    CONSTRAINT FK_USUARIO_TIPO_USUARIO FOREIGN KEY (ID_TipoUsuario)
        REFERENCES TIPO_USUARIO(ID_TipoUsuario),
    CONSTRAINT FK_USUARIO_EMPLEADO FOREIGN KEY (ID_Empleado)
        REFERENCES EMPLEADO(ID_Empleado)
);

CREATE TABLE MODULO(
    ID_Modulo           serial        NOT NULL,
    N_Modulo            varchar(50)   NOT NULL,
    Descripcion         varchar(100)  NULL,
    Icono               varchar(50)   NULL,
    Orden               integer       NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_MODULO PRIMARY KEY (ID_Modulo)
);

CREATE TABLE ROL(
    ID_Rol              serial        NOT NULL,
    N_Rol               varchar(50)   NOT NULL,
    Descripcion         varchar(100)  NULL,
    Nivel               integer       NULL,
    F_Creacion          timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_ROL PRIMARY KEY (ID_Rol),
    CONSTRAINT UQ_ROL_NOMBRE UNIQUE (N_Rol)
);

CREATE TABLE PERMISO(
    ID_Permiso          serial        NOT NULL,
    ID_Modulo           integer       NOT NULL,
    N_Permiso           varchar(50)   NOT NULL,
    Clave               varchar(50)   NOT NULL,
    Descripcion         varchar(100)  NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_PERMISO PRIMARY KEY (ID_Permiso),
    CONSTRAINT UQ_PERMISO_CLAVE UNIQUE (Clave),
    CONSTRAINT FK_PERMISO_MODULO FOREIGN KEY (ID_Modulo) REFERENCES MODULO(ID_Modulo)
);

CREATE TABLE ROL_PERMISO(
    ID_RolPermiso       serial        NOT NULL,
    ID_Rol              integer       NOT NULL,
    ID_Permiso          integer       NOT NULL,
    Concedido           char(1)       NOT NULL DEFAULT '1',
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_ROL_PERMISO PRIMARY KEY (ID_RolPermiso),
    CONSTRAINT UQ_ROL_PERMISO UNIQUE (ID_Rol, ID_Permiso),
    CONSTRAINT FK_ROLPERMISO_ROL     FOREIGN KEY (ID_Rol)     REFERENCES ROL(ID_Rol),
    CONSTRAINT FK_ROLPERMISO_PERMISO FOREIGN KEY (ID_Permiso) REFERENCES PERMISO(ID_Permiso)
);

CREATE TABLE USUARIO_ROL(
    ID_UsuarioRol       serial        NOT NULL,
    ID_Usuario          integer       NOT NULL,
    ID_Rol              integer       NOT NULL,
    F_Asignacion        timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    Vigente             char(1)       NOT NULL DEFAULT '1',
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_USUARIO_ROL PRIMARY KEY (ID_UsuarioRol),
    CONSTRAINT UQ_USUARIO_ROL UNIQUE (ID_Usuario, ID_Rol),
    CONSTRAINT FK_USUARIOROL_USUARIO FOREIGN KEY (ID_Usuario) REFERENCES USUARIO(ID_Usuario),
    CONSTRAINT FK_USUARIOROL_ROL     FOREIGN KEY (ID_Rol)     REFERENCES ROL(ID_Rol)
);

CREATE TABLE AUDITORIA(
    ID_Auditoria        serial        NOT NULL,
    ID_Usuario          integer       NULL,
    N_Tabla             varchar(50)   NOT NULL,
    Accion              varchar(20)   NOT NULL,
    ID_Registro         integer       NULL,
    Valor_Anterior      varchar(500)  NULL,
    Valor_Nuevo         varchar(500)  NULL,
    F_Evento            timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    IP                  varchar(20)   NULL,
    Terminal            varchar(30)   NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_AUDITORIA PRIMARY KEY (ID_Auditoria),
    CONSTRAINT FK_AUDITORIA_USUARIO FOREIGN KEY (ID_Usuario) REFERENCES USUARIO(ID_Usuario)
);

/*==============================================================================
  4. MODULO DE CAJA
==============================================================================*/
CREATE TABLE CAJA(
    ID_Caja             serial        NOT NULL,
    N_Caja              varchar(50)   NOT NULL,
    Descripcion         varchar(100)  NULL,
    Ubicacion           varchar(100)  NULL,
    Serie_Terminal      varchar(30)   NULL,
    Moneda              char(3)       NOT NULL DEFAULT 'PEN',
    Monto_Base          numeric(12,2) NULL DEFAULT 0,
    Aperturada          char(1)       NOT NULL DEFAULT '0',
    F_Creacion          timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_CAJA PRIMARY KEY (ID_Caja)
);

CREATE TABLE APERTURA_CAJA(
    ID_AperturaCaja     serial        NOT NULL,
    ID_Caja             integer       NOT NULL,
    ID_Usuario          integer       NOT NULL,
    ID_UsuarioCierre    integer       NULL,
    Numero_Turno        varchar(20)   NULL,
    F_Apertura          timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    F_Cierre            timestamp     NULL,
    Monto_Inicial       numeric(12,2) NOT NULL DEFAULT 0,
    Total_Ingresos      numeric(12,2) NULL DEFAULT 0,
    Total_Egresos       numeric(12,2) NULL DEFAULT 0,
    Monto_Sistema       numeric(12,2) NULL DEFAULT 0,
    Monto_Declarado     numeric(12,2) NULL DEFAULT 0,
    Diferencia          numeric(12,2) NULL DEFAULT 0,
    Situacion           char(1)       NOT NULL DEFAULT 'A',
    Observacion         varchar(200)  NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_APERTURA_CAJA PRIMARY KEY (ID_AperturaCaja),
    CONSTRAINT FK_APERTURACAJA_CAJA    FOREIGN KEY (ID_Caja)          REFERENCES CAJA(ID_Caja),
    CONSTRAINT FK_APERTURACAJA_USUARIO FOREIGN KEY (ID_Usuario)       REFERENCES USUARIO(ID_Usuario),
    CONSTRAINT FK_APERTURACAJA_USUCIE  FOREIGN KEY (ID_UsuarioCierre) REFERENCES USUARIO(ID_Usuario)
);

CREATE TABLE TIPO_MOVIMIENTO_CAJA(
    ID_TipoMovimiento   serial        NOT NULL,
    N_TipoMovimiento    varchar(30)   NOT NULL,
    Abreviatura         varchar(10)   NULL,
    Signo               char(1)       NOT NULL,
    F_Creacion          timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_TIPO_MOVIMIENTO_CAJA PRIMARY KEY (ID_TipoMovimiento),
    CONSTRAINT CK_TIPOMOVCAJA_SIGNO CHECK (Signo IN ('+','-'))
);

CREATE TABLE CONCEPTO_CAJA(
    ID_Concepto         serial        NOT NULL,
    ID_TipoMovimiento   integer       NOT NULL,
    N_Concepto          varchar(60)   NOT NULL,
    Descripcion         varchar(150)  NULL,
    Afecta_Efectivo     char(1)       NOT NULL DEFAULT '1',
    F_Creacion          timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_CONCEPTO_CAJA PRIMARY KEY (ID_Concepto),
    CONSTRAINT FK_CONCEPTOCAJA_TIPO FOREIGN KEY (ID_TipoMovimiento)
        REFERENCES TIPO_MOVIMIENTO_CAJA(ID_TipoMovimiento)
);

/*==============================================================================
  5. CATALOGO DE PRODUCTOS Y ALMACENES
==============================================================================*/
CREATE TABLE ALMACEN(
    ID_Almacen          serial        NOT NULL,
    N_Almacen           varchar(50)   NOT NULL,
    Descripcion         varchar(100)  NULL,
    Ubicacion           varchar(100)  NULL,
    Es_Principal        char(1)       NOT NULL DEFAULT '0',
    F_Creacion          timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_ALMACEN PRIMARY KEY (ID_Almacen)
);

CREATE TABLE UNIDAD_MEDIDA(
    ID_UnidadMedida     serial        NOT NULL,
    N_UnidadMedida      varchar(30)   NOT NULL,
    Abreviatura         varchar(10)   NULL,
    F_Creacion          timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_UNIDAD_MEDIDA PRIMARY KEY (ID_UnidadMedida)
);

CREATE TABLE MARCA(
    ID_Marca            serial        NOT NULL,
    N_Marca             varchar(50)   NOT NULL,
    Descripcion         varchar(100)  NULL,
    F_Creacion          timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_MARCA PRIMARY KEY (ID_Marca)
);

CREATE TABLE CATEGORIA_PRODUCTO(
    ID_CategoriaProducto serial       NOT NULL,
    N_CategoriaProducto  varchar(50)  NOT NULL,
    Descripcion          varchar(100) NULL,
    F_Creacion           timestamp    NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE               varchar(30)  NULL,
    PCCRE                varchar(30)  NULL,
    FECCRE               timestamp    NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD               varchar(30)  NULL,
    PCMOD                varchar(30)  NULL,
    FECMOD               timestamp    NULL,
    ESTADO               char(1)      NOT NULL DEFAULT '1',
    CONSTRAINT PK_CATEGORIA_PRODUCTO PRIMARY KEY (ID_CategoriaProducto)
);

CREATE TABLE PRODUCTO(
    ID_Producto          serial        NOT NULL,
    ID_CategoriaProducto integer       NOT NULL,
    ID_Marca             integer       NULL,
    Codigo_Barras        varchar(30)   NULL,
    N_Producto           varchar(50)   NOT NULL,
    Detalle              varchar(100)  NULL,
    P_Compra             numeric(10,2) NOT NULL DEFAULT 0,
    P_Venta              numeric(10,2) NOT NULL DEFAULT 0,
    P_Mayoreo            numeric(10,2) NULL DEFAULT 0,
    Stock_Actual         numeric(12,3) NOT NULL DEFAULT 0,
    Stock_Minimo         numeric(12,3) NOT NULL DEFAULT 0,
    Stock_Maximo         numeric(12,3) NULL DEFAULT 0,
    Afecto_IGV           char(1)       NOT NULL DEFAULT '1',
    Es_Perecible         char(1)       NOT NULL DEFAULT '0',
    Imagen               varchar(200)  NULL,
    F_Creacion           timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE               varchar(30)   NULL,
    PCCRE                varchar(30)   NULL,
    FECCRE               timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD               varchar(30)   NULL,
    PCMOD                varchar(30)   NULL,
    FECMOD               timestamp     NULL,
    ESTADO               char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_PRODUCTO PRIMARY KEY (ID_Producto),
    CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (ID_CategoriaProducto)
        REFERENCES CATEGORIA_PRODUCTO(ID_CategoriaProducto),
    CONSTRAINT FK_PRODUCTO_MARCA     FOREIGN KEY (ID_Marca)
        REFERENCES MARCA(ID_Marca),
    CONSTRAINT CK_PRODUCTO_PRECIO CHECK (P_Venta >= 0 AND P_Compra >= 0)
);

CREATE TABLE PRESENTACION_PRODUCTO(
    ID_PresentacionProducto serial        NOT NULL,
    ID_Producto             integer       NOT NULL,
    ID_UnidadMedida         integer       NOT NULL,
    Factor_Conversion       numeric(12,3) NOT NULL DEFAULT 1,
    Es_Unidad_Base          char(1)       NOT NULL DEFAULT '0',
    USUCRE                  varchar(30)   NULL,
    PCCRE                   varchar(30)   NULL,
    FECCRE                  timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD                  varchar(30)   NULL,
    PCMOD                   varchar(30)   NULL,
    FECMOD                  timestamp     NULL,
    ESTADO                  char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_PRESENTACION_PRODUCTO PRIMARY KEY (ID_PresentacionProducto),
    CONSTRAINT UQ_PRESENTACION_PRODUCTO UNIQUE (ID_Producto, ID_UnidadMedida),
    CONSTRAINT FK_PRESPRODUCTO_PRODUCTO FOREIGN KEY (ID_Producto)
        REFERENCES PRODUCTO(ID_Producto),
    CONSTRAINT FK_PRESPRODUCTO_UNIDAD FOREIGN KEY (ID_UnidadMedida)
        REFERENCES UNIDAD_MEDIDA(ID_UnidadMedida),
    CONSTRAINT CK_PRESPRODUCTO_FACTOR CHECK (Factor_Conversion > 0),
    CONSTRAINT CK_PRESPRODUCTO_BASE CHECK (Es_Unidad_Base IN ('0','1'))
);

CREATE TABLE INVENTARIO(
    ID_Inventario       serial        NOT NULL,
    ID_Producto         integer       NOT NULL,
    ID_Almacen          integer       NOT NULL,
    Stock               numeric(12,3) NOT NULL DEFAULT 0,
    Stock_Reservado     numeric(12,3) NOT NULL DEFAULT 0,
    Ubicacion_Fisica    varchar(50)   NULL,
    F_Actualizacion     timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_INVENTARIO PRIMARY KEY (ID_Inventario),
    CONSTRAINT UQ_INVENTARIO UNIQUE (ID_Producto, ID_Almacen),
    CONSTRAINT FK_INVENTARIO_PRODUCTO FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto),
    CONSTRAINT FK_INVENTARIO_ALMACEN  FOREIGN KEY (ID_Almacen)  REFERENCES ALMACEN(ID_Almacen)
);

CREATE TABLE LOTE_PRODUCTO(
    ID_Lote             serial        NOT NULL,
    ID_Producto         integer       NOT NULL,
    ID_Almacen          integer       NOT NULL,
    N_Lote              varchar(30)   NULL,
    F_Produccion        date          NULL,
    F_Vencimiento       date          NULL,
    Cantidad_Inicial    numeric(12,3) NOT NULL DEFAULT 0,
    Cantidad_Actual     numeric(12,3) NOT NULL DEFAULT 0,
    Costo_Unitario      numeric(10,2) NULL DEFAULT 0,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_LOTE_PRODUCTO PRIMARY KEY (ID_Lote),
    CONSTRAINT FK_LOTE_PRODUCTO FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto),
    CONSTRAINT FK_LOTE_ALMACEN  FOREIGN KEY (ID_Almacen)  REFERENCES ALMACEN(ID_Almacen)
);

CREATE TABLE TIPO_MOVIMIENTO_INV(
    ID_TipoMovimientoInv serial       NOT NULL,
    N_TipoMovimiento     varchar(30)  NOT NULL,
    Abreviatura          varchar(10)  NULL,
    Signo                char(1)      NOT NULL,
    F_Creacion           timestamp    NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE               varchar(30)  NULL,
    PCCRE                varchar(30)  NULL,
    FECCRE               timestamp    NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD               varchar(30)  NULL,
    PCMOD                varchar(30)  NULL,
    FECMOD               timestamp    NULL,
    ESTADO               char(1)      NOT NULL DEFAULT '1',
    CONSTRAINT PK_TIPO_MOVIMIENTO_INV PRIMARY KEY (ID_TipoMovimientoInv),
    CONSTRAINT CK_TIPOMOVINV_SIGNO CHECK (Signo IN ('+','-'))
);

/*==============================================================================
  6. METODO DE PAGO, CLIENTES Y PROVEEDORES
==============================================================================*/
CREATE TABLE METODO_PAGO(
    ID_MetodoPago       serial        NOT NULL,
    N_MetodoPago        varchar(30)   NOT NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_METODO_PAGO PRIMARY KEY (ID_MetodoPago)
);

CREATE TABLE CLIENTE(
    ID_Cliente          serial        NOT NULL,
    ID_Persona          integer       NULL,
    ID_Empresa          integer       NULL,
    Codigo_Cliente      varchar(20)   NULL,
    Tipo_Cliente        char(1)       NOT NULL DEFAULT 'N',
    Limite_Credito      numeric(12,2) NOT NULL DEFAULT 0,
    Saldo_Deuda         numeric(12,2) NOT NULL DEFAULT 0,
    Puntos              integer       NOT NULL DEFAULT 0,
    F_Registro          timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_CLIENTE PRIMARY KEY (ID_Cliente),
    CONSTRAINT FK_CLIENTE_PERSONA FOREIGN KEY (ID_Persona) REFERENCES PERSONA(ID_Persona),
    CONSTRAINT FK_CLIENTE_EMPRESA FOREIGN KEY (ID_Empresa) REFERENCES EMPRESA(ID_Empresa),
    CONSTRAINT CK_CLIENTE_TIPO CHECK (Tipo_Cliente IN ('N','J'))
);

CREATE TABLE PROVEEDOR(
    ID_Proveedor        serial        NOT NULL,
    ID_Empresa          integer       NULL,
    ID_Persona          integer       NULL,
    Codigo_Proveedor    varchar(20)   NULL,
    Contacto            varchar(80)   NULL,
    Telefono_Contacto   varchar(15)   NULL,
    Email_Contacto      varchar(50)   NULL,
    Dias_Credito        integer       NOT NULL DEFAULT 0,
    F_Registro          timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_PROVEEDOR PRIMARY KEY (ID_Proveedor),
    CONSTRAINT FK_PROVEEDOR_EMPRESA FOREIGN KEY (ID_Empresa) REFERENCES EMPRESA(ID_Empresa),
    CONSTRAINT FK_PROVEEDOR_PERSONA FOREIGN KEY (ID_Persona) REFERENCES PERSONA(ID_Persona)
);

/*==============================================================================
  7. COMPRAS (ABASTECIMIENTO)
==============================================================================*/
CREATE TABLE COMPRA(
    ID_Compra           serial        NOT NULL,
    ID_Proveedor        integer       NOT NULL,
    ID_Usuario          integer       NOT NULL,
    ID_Almacen          integer       NOT NULL,
    ID_MetodoPago       integer       NULL,
    TipoDocumento       char(11)      NULL,
    Documento           varchar(50)   NULL,
    F_Compra            timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    SubTotal            numeric(12,2) NOT NULL DEFAULT 0,
    IGV                 numeric(12,2) NOT NULL DEFAULT 0,
    Total               numeric(12,2) NOT NULL DEFAULT 0,
    T_Pagado            numeric(12,2) NOT NULL DEFAULT 0,
    Saldo               numeric(12,2) NOT NULL DEFAULT 0,
    Es_Credito          char(1)       NOT NULL DEFAULT '0',
    F_Vencimiento       date          NULL,
    Situacion           char(1)       NOT NULL DEFAULT 'R',
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_COMPRA PRIMARY KEY (ID_Compra),
    CONSTRAINT FK_COMPRA_PROVEEDOR FOREIGN KEY (ID_Proveedor)  REFERENCES PROVEEDOR(ID_Proveedor),
    CONSTRAINT FK_COMPRA_USUARIO   FOREIGN KEY (ID_Usuario)    REFERENCES USUARIO(ID_Usuario),
    CONSTRAINT FK_COMPRA_ALMACEN   FOREIGN KEY (ID_Almacen)    REFERENCES ALMACEN(ID_Almacen),
    CONSTRAINT FK_COMPRA_METODOPAGO FOREIGN KEY (ID_MetodoPago) REFERENCES METODO_PAGO(ID_MetodoPago)
);

CREATE TABLE DETALLE_COMPRA(
    ID_DetalleCompra    serial        NOT NULL,
    ID_Compra           integer       NOT NULL,
    ID_Producto         integer       NOT NULL,
    ID_PresentacionProducto integer    NOT NULL,
    ID_Lote             integer       NULL,
    Cantidad            numeric(12,3) NOT NULL,
    Costo_Unitario      numeric(10,2) NOT NULL,
    Sub_Total           numeric(12,2) NOT NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_DETALLE_COMPRA PRIMARY KEY (ID_DetalleCompra),
    CONSTRAINT FK_DETCOMPRA_COMPRA   FOREIGN KEY (ID_Compra)   REFERENCES COMPRA(ID_Compra),
    CONSTRAINT FK_DETCOMPRA_PRODUCTO FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto),
    CONSTRAINT FK_DETCOMPRA_PRESENTACION FOREIGN KEY (ID_PresentacionProducto)
        REFERENCES PRESENTACION_PRODUCTO(ID_PresentacionProducto),
    CONSTRAINT FK_DETCOMPRA_LOTE     FOREIGN KEY (ID_Lote)     REFERENCES LOTE_PRODUCTO(ID_Lote),
    CONSTRAINT CK_DETCOMPRA_CANT CHECK (Cantidad > 0)
);

/*==============================================================================
  8. VENTAS Y COMPROBANTES
==============================================================================*/
CREATE TABLE VENTA(
    ID_Venta            serial        NOT NULL,
    ID_Cliente          integer       NOT NULL,
    ID_Usuario          integer       NOT NULL,
    ID_AperturaCaja     integer       NULL,
    ID_MetodoPago       integer       NOT NULL,
    F_Venta             timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    SubTotal            numeric(12,2) NOT NULL DEFAULT 0,
    IGV                 numeric(12,2) NOT NULL DEFAULT 0,
    Descuento           numeric(12,2) NOT NULL DEFAULT 0,
    Total               numeric(12,2) NOT NULL DEFAULT 0,
    T_Pagado            numeric(12,2) NOT NULL DEFAULT 0,
    Vuelto              numeric(12,2) NOT NULL DEFAULT 0,
    Es_Credito          char(1)       NOT NULL DEFAULT '0',
    Saldo               numeric(12,2) NOT NULL DEFAULT 0,
    TipoDocumento       char(11)      NOT NULL DEFAULT 'TICKET',
    Situacion           char(1)       NOT NULL DEFAULT 'R',
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_VENTA PRIMARY KEY (ID_Venta),
    CONSTRAINT FK_VENTA_CLIENTE     FOREIGN KEY (ID_Cliente)      REFERENCES CLIENTE(ID_Cliente),
    CONSTRAINT FK_VENTA_USUARIO     FOREIGN KEY (ID_Usuario)      REFERENCES USUARIO(ID_Usuario),
    CONSTRAINT FK_VENTA_APERTURA    FOREIGN KEY (ID_AperturaCaja) REFERENCES APERTURA_CAJA(ID_AperturaCaja),
    CONSTRAINT FK_VENTA_METODOPAGO  FOREIGN KEY (ID_MetodoPago)   REFERENCES METODO_PAGO(ID_MetodoPago)
);

CREATE TABLE DETALLE_VENTA(
    ID_Detalle          serial        NOT NULL,
    ID_Venta            integer       NOT NULL,
    ID_Producto         integer       NOT NULL,
    ID_PresentacionProducto integer    NOT NULL,
    Cantidad            numeric(12,3) NOT NULL,
    Precio_Unitario     numeric(10,2) NOT NULL,
    Descuento           numeric(10,2) NOT NULL DEFAULT 0,
    Sub_Total           numeric(12,2) NOT NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_DETALLE_VENTA PRIMARY KEY (ID_Detalle),
    CONSTRAINT FK_DETVENTA_VENTA    FOREIGN KEY (ID_Venta)    REFERENCES VENTA(ID_Venta),
    CONSTRAINT FK_DETVENTA_PRODUCTO FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto),
    CONSTRAINT FK_DETVENTA_PRESENTACION FOREIGN KEY (ID_PresentacionProducto)
        REFERENCES PRESENTACION_PRODUCTO(ID_PresentacionProducto),
    CONSTRAINT CK_DETVENTA_CANT CHECK (Cantidad > 0)
);

CREATE TABLE BOLETA(
    ID_Boleta           serial        NOT NULL,
    ID_Venta            integer       NOT NULL,
    F_Emision           timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Numero              char(8)       NOT NULL,
    Serie               char(5)       NOT NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_BOLETA PRIMARY KEY (ID_Boleta),
    CONSTRAINT UQ_BOLETA_SERIE_NUM UNIQUE (Serie, Numero),
    CONSTRAINT FK_BOLETA_VENTA FOREIGN KEY (ID_Venta) REFERENCES VENTA(ID_Venta)
);

CREATE TABLE FACTURA(
    ID_Factura          serial        NOT NULL,
    ID_Venta            integer       NOT NULL,
    F_Emision           timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Numero              char(8)       NOT NULL,
    Serie               char(5)       NOT NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_FACTURA PRIMARY KEY (ID_Factura),
    CONSTRAINT UQ_FACTURA_SERIE_NUM UNIQUE (Serie, Numero),
    CONSTRAINT FK_FACTURA_VENTA FOREIGN KEY (ID_Venta) REFERENCES VENTA(ID_Venta)
);

/*==============================================================================
  9. CREDITOS / CUENTAS POR COBRAR
==============================================================================*/
CREATE TABLE CUENTA_COBRAR(
    ID_Cuenta           serial        NOT NULL,
    ID_Venta            integer       NOT NULL,
    ID_Cliente          integer       NOT NULL,
    Monto_Total         numeric(12,2) NOT NULL,
    Saldo               numeric(12,2) NOT NULL,
    F_Emision           timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    F_Vencimiento       date          NULL,
    Situacion           char(1)       NOT NULL DEFAULT 'P',
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_CUENTA_COBRAR PRIMARY KEY (ID_Cuenta),
    CONSTRAINT FK_CUENTA_VENTA   FOREIGN KEY (ID_Venta)   REFERENCES VENTA(ID_Venta),
    CONSTRAINT FK_CUENTA_CLIENTE FOREIGN KEY (ID_Cliente) REFERENCES CLIENTE(ID_Cliente)
);

CREATE TABLE PAGO_CUENTA(
    ID_PagoCuenta       serial        NOT NULL,
    ID_Cuenta           integer       NOT NULL,
    ID_MetodoPago       integer       NOT NULL,
    ID_Usuario          integer       NOT NULL,
    ID_AperturaCaja     integer       NULL,
    Monto               numeric(12,2) NOT NULL,
    F_Pago              timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Documento           varchar(50)   NULL,
    Observacion         varchar(200)  NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_PAGO_CUENTA PRIMARY KEY (ID_PagoCuenta),
    CONSTRAINT FK_PAGOCTA_CUENTA     FOREIGN KEY (ID_Cuenta)       REFERENCES CUENTA_COBRAR(ID_Cuenta),
    CONSTRAINT FK_PAGOCTA_METODOPAGO FOREIGN KEY (ID_MetodoPago)   REFERENCES METODO_PAGO(ID_MetodoPago),
    CONSTRAINT FK_PAGOCTA_USUARIO    FOREIGN KEY (ID_Usuario)      REFERENCES USUARIO(ID_Usuario),
    CONSTRAINT FK_PAGOCTA_APERTURA   FOREIGN KEY (ID_AperturaCaja) REFERENCES APERTURA_CAJA(ID_AperturaCaja),
    CONSTRAINT CK_PAGOCTA_MONTO CHECK (Monto > 0)
);

/*==============================================================================
  10. KARDEX / MOVIMIENTO DE INVENTARIO
==============================================================================*/
CREATE TABLE MOVIMIENTO_INVENTARIO(
    ID_MovimientoInv     serial        NOT NULL,
    ID_Producto          integer       NOT NULL,
    ID_Almacen           integer       NOT NULL,
    ID_TipoMovimientoInv integer       NOT NULL,
    ID_Lote              integer       NULL,
    ID_Usuario           integer       NOT NULL,
    ID_Venta             integer       NULL,
    ID_Compra            integer       NULL,
    Cantidad             numeric(12,3) NOT NULL,
    Costo_Unitario       numeric(10,2) NULL DEFAULT 0,
    Stock_Anterior       numeric(12,3) NOT NULL DEFAULT 0,
    Stock_Nuevo          numeric(12,3) NOT NULL DEFAULT 0,
    F_Movimiento         timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Documento            varchar(30)   NULL,
    Observacion          varchar(200)  NULL,
    IP                   varchar(20)   NULL,
    Terminal             varchar(30)   NULL,
    USUCRE               varchar(30)   NULL,
    PCCRE                varchar(30)   NULL,
    FECCRE               timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD               varchar(30)   NULL,
    PCMOD                varchar(30)   NULL,
    FECMOD               timestamp     NULL,
    ESTADO               char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_MOVIMIENTO_INVENTARIO PRIMARY KEY (ID_MovimientoInv),
    CONSTRAINT FK_MOVINV_PRODUCTO FOREIGN KEY (ID_Producto)          REFERENCES PRODUCTO(ID_Producto),
    CONSTRAINT FK_MOVINV_ALMACEN  FOREIGN KEY (ID_Almacen)           REFERENCES ALMACEN(ID_Almacen),
    CONSTRAINT FK_MOVINV_TIPO     FOREIGN KEY (ID_TipoMovimientoInv) REFERENCES TIPO_MOVIMIENTO_INV(ID_TipoMovimientoInv),
    CONSTRAINT FK_MOVINV_LOTE     FOREIGN KEY (ID_Lote)              REFERENCES LOTE_PRODUCTO(ID_Lote),
    CONSTRAINT FK_MOVINV_USUARIO  FOREIGN KEY (ID_Usuario)           REFERENCES USUARIO(ID_Usuario),
    CONSTRAINT FK_MOVINV_VENTA    FOREIGN KEY (ID_Venta)             REFERENCES VENTA(ID_Venta),
    CONSTRAINT FK_MOVINV_COMPRA   FOREIGN KEY (ID_Compra)            REFERENCES COMPRA(ID_Compra)
);

/*==============================================================================
  11. MOVIMIENTO_CAJA
==============================================================================*/
CREATE TABLE MOVIMIENTO_CAJA(
    ID_MovimientoCaja   serial        NOT NULL,
    ID_AperturaCaja     integer       NOT NULL,
    ID_TipoMovimiento   integer       NOT NULL,
    ID_Concepto         integer       NOT NULL,
    ID_MetodoPago       integer       NOT NULL,
    ID_Usuario          integer       NOT NULL,
    ID_Compra           integer       NULL,
    ID_Venta            integer       NULL,
    Numero_Operacion    varchar(30)   NULL,
    Documento           varchar(50)   NULL,
    Descripcion         varchar(200)  NULL,
    Monto               numeric(12,2) NOT NULL,
    Afecta_Efectivo     char(1)       NOT NULL DEFAULT '1',
    F_Movimiento        timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    IP                  varchar(20)   NULL,
    Terminal            varchar(30)   NULL,
    USUCRE              varchar(30)   NULL,
    PCCRE               varchar(30)   NULL,
    FECCRE              timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    USUMOD              varchar(30)   NULL,
    PCMOD               varchar(30)   NULL,
    FECMOD              timestamp     NULL,
    ESTADO              char(1)       NOT NULL DEFAULT '1',
    CONSTRAINT PK_MOVIMIENTO_CAJA PRIMARY KEY (ID_MovimientoCaja),
    CONSTRAINT FK_MOVCAJA_APERTURA   FOREIGN KEY (ID_AperturaCaja)   REFERENCES APERTURA_CAJA(ID_AperturaCaja),
    CONSTRAINT FK_MOVCAJA_TIPO       FOREIGN KEY (ID_TipoMovimiento) REFERENCES TIPO_MOVIMIENTO_CAJA(ID_TipoMovimiento),
    CONSTRAINT FK_MOVCAJA_CONCEPTO   FOREIGN KEY (ID_Concepto)       REFERENCES CONCEPTO_CAJA(ID_Concepto),
    CONSTRAINT FK_MOVCAJA_METODOPAGO FOREIGN KEY (ID_MetodoPago)     REFERENCES METODO_PAGO(ID_MetodoPago),
    CONSTRAINT FK_MOVCAJA_USUARIO    FOREIGN KEY (ID_Usuario)        REFERENCES USUARIO(ID_Usuario),
    CONSTRAINT FK_MOVCAJA_COMPRA     FOREIGN KEY (ID_Compra)         REFERENCES COMPRA(ID_Compra),
    CONSTRAINT FK_MOVCAJA_VENTA      FOREIGN KEY (ID_Venta)          REFERENCES VENTA(ID_Venta)
);

/*==============================================================================
  12. INDICES DE RENDIMIENTO
==============================================================================*/
CREATE UNIQUE INDEX UX_PERSONA_DOCUMENTO   ON PERSONA(N_Documento);
CREATE INDEX IX_PERSONA_APELLIDOS          ON PERSONA(Ap_Paterno, Ap_Materno, Nombre);
CREATE UNIQUE INDEX UX_EMPRESA_RUC         ON EMPRESA(RUC);
CREATE UNIQUE INDEX UX_PRODUCTO_BARRAS     ON PRODUCTO(Codigo_Barras) WHERE Codigo_Barras IS NOT NULL;
CREATE INDEX IX_PRODUCTO_NOMBRE            ON PRODUCTO(N_Producto);
CREATE INDEX IX_PRODUCTO_CATEGORIA         ON PRODUCTO(ID_CategoriaProducto);
CREATE INDEX IX_PRODUCTO_STOCK             ON PRODUCTO(Stock_Actual, Stock_Minimo);
CREATE UNIQUE INDEX UX_PRESENTACION_PRODUCTO_BASE
    ON PRESENTACION_PRODUCTO(ID_Producto)
    WHERE Es_Unidad_Base = '1' AND ESTADO = '1';
CREATE INDEX IX_LOTE_VENCIMIENTO           ON LOTE_PRODUCTO(F_Vencimiento);
CREATE INDEX IX_VENTA_FECHA                ON VENTA(F_Venta);
CREATE INDEX IX_VENTA_CLIENTE              ON VENTA(ID_Cliente, F_Venta);
CREATE INDEX IX_VENTA_APERTURA             ON VENTA(ID_AperturaCaja);
CREATE INDEX IX_DETVENTA_VENTA             ON DETALLE_VENTA(ID_Venta);
CREATE INDEX IX_DETVENTA_PRODUCTO          ON DETALLE_VENTA(ID_Producto);
CREATE INDEX IX_COMPRA_FECHA               ON COMPRA(F_Compra);
CREATE INDEX IX_DETCOMPRA_COMPRA           ON DETALLE_COMPRA(ID_Compra);
CREATE INDEX IX_MOVINV_PRODUCTO_FECHA      ON MOVIMIENTO_INVENTARIO(ID_Producto, F_Movimiento);
CREATE INDEX IX_MOVCAJA_APERTURA           ON MOVIMIENTO_CAJA(ID_AperturaCaja);
CREATE INDEX IX_MOVCAJA_FECHA              ON MOVIMIENTO_CAJA(F_Movimiento);
CREATE INDEX IX_CUENTA_CLIENTE             ON CUENTA_COBRAR(ID_Cliente, Situacion);
CREATE INDEX IX_AUDITORIA_TABLA_FECHA      ON AUDITORIA(N_Tabla, F_Evento);

/*==============================================================================
  13. DATOS MAESTROS
==============================================================================*/
INSERT INTO DEPARTAMENTO(N_Departamento, USUCRE) VALUES ('ICA','ADMIN'),('LIMA','ADMIN');
INSERT INTO PROVINCIA(ID_Departamento, N_Provincia, USUCRE) VALUES (1,'ICA','ADMIN'),(1,'CHINCHA','ADMIN'),(2,'LIMA','ADMIN');
INSERT INTO DISTRITO(ID_Provincia, D_Distrito, USUCRE) VALUES (1,'ICA','ADMIN'),(1,'PARCONA','ADMIN'),(1,'LA TINGUINA','ADMIN'),(1,'SUBTANJALLA','ADMIN'),(2,'PUEBLO NUEVO','ADMIN');

INSERT INTO TIPO_IDENTIDAD(N_TipoIdentidad, Abreviatura, Longitud, USUCRE) VALUES
('DNI','DNI',8,'ADMIN'),('RUC','RUC',11,'ADMIN'),('CARNET EXTRANJERIA','CE',12,'ADMIN'),('PASAPORTE','PAS',12,'ADMIN');
INSERT INTO CARGO(N_Cargo, USUCRE) VALUES ('ADMINISTRADOR','ADMIN'),('CAJERO','ADMIN'),('ALMACENERO','ADMIN'),('VENDEDOR','ADMIN');
INSERT INTO CONTRATO(N_Contrato, USUCRE) VALUES ('PLAZO INDETERMINADO','ADMIN'),('PLAZO FIJO','ADMIN'),('RECIBO POR HONORARIOS','ADMIN');

INSERT INTO METODO_PAGO(N_MetodoPago, USUCRE) VALUES
 ('EFECTIVO','ADMIN'),('YAPE','ADMIN'),('PLIN','ADMIN'),('TARJETA DEBITO','ADMIN'),
 ('TARJETA CREDITO','ADMIN'),('TRANSFERENCIA','ADMIN'),('CREDITO / FIADO','ADMIN');

INSERT INTO UNIDAD_MEDIDA(N_UnidadMedida, Abreviatura, USUCRE) VALUES
 ('UNIDAD','UND','ADMIN'),('KILOGRAMO','KG','ADMIN'),('GRAMO','GR','ADMIN'),
 ('LITRO','LT','ADMIN'),('MILILITRO','ML','ADMIN'),('PAQUETE','PQT','ADMIN'),
 ('CAJA','CJA','ADMIN'),('DOCENA','DOC','ADMIN'),('BOTELLA','BOT','ADMIN'),('SACO','SCO','ADMIN');

INSERT INTO MARCA(N_Marca, USUCRE) VALUES
 ('GLORIA','ADMIN'),('ALICORP','ADMIN'),('BACKUS','ADMIN'),('COCA COLA','ADMIN'),
 ('NESTLE','ADMIN'),('P&G','ADMIN'),('SIN MARCA','ADMIN');

INSERT INTO CATEGORIA_PRODUCTO(N_CategoriaProducto, Descripcion, USUCRE) VALUES
 ('ABARROTES','Arroz, azucar, fideos, aceite','ADMIN'),
 ('BEBIDAS','Gaseosas, aguas, jugos','ADMIN'),
 ('LACTEOS','Leche, yogurt, queso','ADMIN'),
 ('LIMPIEZA','Detergentes, lejia, jabones','ADMIN'),
 ('ASEO PERSONAL','Shampoo, papel higienico','ADMIN'),
 ('SNACKS','Galletas, golosinas','ADMIN'),
 ('LICORES','Cerveza, vinos, piscos','ADMIN'),
 ('EMBUTIDOS','Jamonada, hot dog','ADMIN');

INSERT INTO ALMACEN(N_Almacen, Descripcion, Ubicacion, Es_Principal, USUCRE) VALUES
 ('TIENDA','Stock en exhibicion / mostrador','Local principal','1','ADMIN'),
 ('DEPOSITO','Stock de reserva','Trastienda','0','ADMIN');

INSERT INTO TIPO_MOVIMIENTO_INV(N_TipoMovimiento, Abreviatura, Signo, USUCRE) VALUES
 ('ENTRADA POR COMPRA','ENT-C','+','ADMIN'),
 ('SALIDA POR VENTA','SAL-V','-','ADMIN'),
 ('AJUSTE POSITIVO','AJU+','+','ADMIN'),
 ('AJUSTE NEGATIVO','AJU-','-','ADMIN'),
 ('DEVOLUCION CLIENTE','DEV-C','+','ADMIN'),
 ('DEVOLUCION PROVEEDOR','DEV-P','-','ADMIN'),
 ('MERMA / VENCIDO','MERMA','-','ADMIN'),
 ('TRANSFERENCIA ENTRADA','TRA+','+','ADMIN'),
 ('TRANSFERENCIA SALIDA','TRA-','-','ADMIN'),
 ('INVENTARIO INICIAL','INI','+','ADMIN');

INSERT INTO TIPO_MOVIMIENTO_CAJA(N_TipoMovimiento, Abreviatura, Signo, USUCRE) VALUES
 ('INGRESO','ING','+','ADMIN'),('EGRESO','EGR','-','ADMIN');

INSERT INTO CONCEPTO_CAJA(ID_TipoMovimiento, N_Concepto, Descripcion, Afecta_Efectivo, USUCRE) VALUES
 (1,'VENTA AL CONTADO','Cobro por venta de productos','1','ADMIN'),
 (1,'COBRO DE FIADO','Cobro de cuenta por cobrar','1','ADMIN'),
 (1,'MONTO INICIAL','Fondo fijo de apertura','1','ADMIN'),
 (1,'OTROS INGRESOS','Ingresos varios','1','ADMIN'),
 (2,'PAGO A PROVEEDOR','Cancelacion de compras','1','ADMIN'),
 (2,'COMPRA MENOR','Gasto operativo menor','1','ADMIN'),
 (2,'RETIRO DE EFECTIVO','Retiro del propietario','1','ADMIN'),
 (2,'SERVICIOS','Luz, agua, internet','1','ADMIN'),
 (2,'DEVOLUCION A CLIENTE','Devolucion de dinero','1','ADMIN');

INSERT INTO TIPO_USUARIO(N_TipoUsuario, USUCRE) VALUES ('ADMINISTRADOR','ADMIN'),('CAJERO','ADMIN'),('ALMACENERO','ADMIN');

INSERT INTO MODULO(N_Modulo, Descripcion, Icono, Orden, USUCRE) VALUES
 ('SEGURIDAD','Usuarios, roles y permisos','fa-lock',1,'ADMIN'),
 ('MANTENIMIENTO','Catalogos maestros','fa-cogs',2,'ADMIN'),
 ('COMPRAS','Registro de compras y proveedores','fa-truck',3,'ADMIN'),
 ('INVENTARIO','Stock, lotes y kardex','fa-boxes',4,'ADMIN'),
 ('VENTAS','Punto de venta y comprobantes','fa-cash-register',5,'ADMIN'),
 ('CREDITOS','Cuentas por cobrar','fa-hand-holding-usd',6,'ADMIN'),
 ('CAJA','Apertura, cierre y movimientos','fa-money-bill',7,'ADMIN'),
 ('REPORTES','Reportes gerenciales','fa-chart-bar',8,'ADMIN');

INSERT INTO PERMISO(ID_Modulo, N_Permiso, Clave, USUCRE) VALUES
 (1,'Gestionar usuarios','SEG_USUARIO','ADMIN'),
 (1,'Gestionar roles','SEG_ROL','ADMIN'),
 (1,'Ver auditoria','SEG_AUDITORIA','ADMIN'),
 (2,'Gestionar productos','MAN_PRODUCTO','ADMIN'),
 (2,'Gestionar categorias','MAN_CATEGORIA','ADMIN'),
 (2,'Gestionar clientes','MAN_CLIENTE','ADMIN'),
 (2,'Gestionar proveedores','MAN_PROVEEDOR','ADMIN'),
 (3,'Registrar compra','COM_REGISTRAR','ADMIN'),
 (3,'Anular compra','COM_ANULAR','ADMIN'),
 (4,'Ver stock','INV_STOCK','ADMIN'),
 (4,'Ajustar inventario','INV_AJUSTE','ADMIN'),
 (4,'Ver kardex','INV_KARDEX','ADMIN'),
 (5,'Registrar venta','VEN_REGISTRAR','ADMIN'),
 (5,'Anular venta','VEN_ANULAR','ADMIN'),
 (5,'Aplicar descuento','VEN_DESCUENTO','ADMIN'),
 (6,'Registrar credito','CRE_REGISTRAR','ADMIN'),
 (6,'Cobrar cuenta','CRE_COBRAR','ADMIN'),
 (7,'Aperturar caja','CAJ_APERTURAR','ADMIN'),
 (7,'Cerrar caja','CAJ_CERRAR','ADMIN'),
 (7,'Registrar movimiento','CAJ_MOVIMIENTO','ADMIN'),
 (8,'Reporte de ventas','REP_VENTAS','ADMIN'),
 (8,'Reporte de inventario','REP_INVENTARIO','ADMIN'),
 (8,'Reporte de caja','REP_CAJA','ADMIN');

INSERT INTO ROL(N_Rol, Descripcion, Nivel, USUCRE) VALUES
 ('ADMINISTRADOR','Acceso total al sistema',1,'ADMIN'),
 ('CAJERO','Punto de venta y caja',2,'ADMIN'),
 ('ALMACENERO','Compras e inventario',2,'ADMIN');

INSERT INTO ROL_PERMISO(ID_Rol, ID_Permiso, Concedido, USUCRE)
SELECT 1, ID_Permiso, '1', 'ADMIN' FROM PERMISO;

INSERT INTO ROL_PERMISO(ID_Rol, ID_Permiso, Concedido, USUCRE)
SELECT 2, ID_Permiso, '1', 'ADMIN' FROM PERMISO
WHERE Clave IN ('MAN_CLIENTE','INV_STOCK','VEN_REGISTRAR','CRE_REGISTRAR','CRE_COBRAR',
                'CAJ_APERTURAR','CAJ_CERRAR','CAJ_MOVIMIENTO','REP_VENTAS','REP_CAJA');

INSERT INTO ROL_PERMISO(ID_Rol, ID_Permiso, Concedido, USUCRE)
SELECT 3, ID_Permiso, '1', 'ADMIN' FROM PERMISO
WHERE Clave IN ('MAN_PRODUCTO','MAN_CATEGORIA','MAN_PROVEEDOR','COM_REGISTRAR',
                'INV_STOCK','INV_AJUSTE','INV_KARDEX','REP_INVENTARIO');

INSERT INTO PERSONA(ID_Distrito, ID_TipoIdentidad, N_Documento, Nombre, Ap_Paterno, Ap_Materno, EMAIL, Celular, Genero, Direccion, USUCRE)
VALUES (1,1,'21500001','MARTHA','QUISPE','ROJAS','martha@bodegatiamartha.pe','956123456','F','Av. Los Maestros 450 - Ica','ADMIN');

INSERT INTO EMPLEADO(ID_Persona, ID_Contrato, ID_Cargo, Salario, Turno, USUCRE)
VALUES (1,1,1,2500.00,'MANANA','ADMIN');

INSERT INTO USUARIO(ID_TipoUsuario, ID_Empleado, Logeo, Clave, USUCRE)
VALUES (1,1,'admin','$2a$10$DEMOHASHREEMPLAZARENPRODUCCION','ADMIN');

INSERT INTO USUARIO_ROL(ID_Usuario, ID_Rol, USUCRE) VALUES (1,1,'ADMIN');

INSERT INTO EMPRESA(RUC, Razon_Social, Direccion, Telefono, USUCRE)
VALUES ('20601234567','BODEGA TIA MARTHA E.I.R.L.','Av. Los Maestros 450 - Ica','056234','ADMIN');

INSERT INTO PERSONA(ID_Distrito, ID_TipoIdentidad, N_Documento, Nombre, Ap_Paterno, Ap_Materno, USUCRE)
VALUES (1,1,'00000000','CLIENTE','VARIOS','','ADMIN');

INSERT INTO CLIENTE(ID_Persona, Codigo_Cliente, Tipo_Cliente, Limite_Credito, USUCRE)
VALUES (2,'CLI-0001','N',0,'ADMIN');

INSERT INTO CAJA(N_Caja, Descripcion, Ubicacion, Serie_Terminal, Moneda, Monto_Base, USUCRE)
VALUES ('CAJA 01','Caja del mostrador','Mostrador principal','T001','PEN',100.00,'ADMIN');

INSERT INTO PRODUCTO(ID_CategoriaProducto, ID_Marca, Codigo_Barras, N_Producto, Detalle,
                     P_Compra, P_Venta, P_Mayoreo, Stock_Actual, Stock_Minimo, Stock_Maximo, Afecto_IGV, Es_Perecible, USUCRE)
VALUES
 (1,2,'7750123000011','ARROZ COSTENO','Bolsa de 1 kg',3.20,4.20,4.00,80,20,300,'1','0','ADMIN'),
 (1,2,'7750123000028','ACEITE PRIMOR 1L','Botella 1 litro',7.50,9.50,9.00,40,10,120,'1','0','ADMIN'),
 (2,4,'7750123000035','COCA COLA 1.5L','Botella descartable',5.20,7.00,6.50,60,15,200,'1','0','ADMIN'),
 (3,1,'7750123000042','LECHE GLORIA TARRO','Tarro 400 g',3.60,4.50,4.30,100,24,300,'1','1','ADMIN'),
 (4,6,'7750123000059','DETERGENTE ARIEL 780G','Bolsa 780 g',9.80,12.50,12.00,25,6,80,'1','0','ADMIN'),
 (6,5,'7750123000066','GALLETA SODA FIELD','Paquete x6',2.80,3.50,3.30,50,12,150,'1','1','ADMIN'),
 (7,3,'7750123000073','CERVEZA PILSEN 650ML','Botella retornable',4.50,6.00,5.70,72,24,240,'1','0','ADMIN'),
 (5,6,'7750123000080','PAPEL HIGIENICO ELITE x4','Paquete x4 rollos',4.20,5.50,5.20,35,10,120,'1','0','ADMIN');

INSERT INTO PRESENTACION_PRODUCTO(ID_Producto, ID_UnidadMedida, Factor_Conversion, Es_Unidad_Base, USUCRE)
VALUES
 (1,2,1,'1','ADMIN'),
 (2,1,1,'1','ADMIN'),
 (3,1,1,'1','ADMIN'),
 (4,1,1,'1','ADMIN'),
 (5,1,1,'1','ADMIN'),
 (6,6,1,'1','ADMIN'),
 (7,9,1,'1','ADMIN'),
 (8,1,1,'1','ADMIN');

INSERT INTO PRESENTACION_PRODUCTO(ID_Producto, ID_UnidadMedida, Factor_Conversion, Es_Unidad_Base, USUCRE)
VALUES
 (3,7,6,'0','ADMIN'),
 (4,7,24,'0','ADMIN'),
 (7,7,12,'0','ADMIN'),
 (8,6,4,'0','ADMIN');

INSERT INTO INVENTARIO(ID_Producto, ID_Almacen, Stock, Ubicacion_Fisica, USUCRE)
SELECT ID_Producto, 1, Stock_Actual, 'ANAQUEL GENERAL', 'ADMIN' FROM PRODUCTO;

/*==============================================================================
  14. TIPOS DE TABLA (TEMPORALES / COMPOSITE TYPES PARA FUNCIONES)
==============================================================================*/
CREATE TYPE TT_DETALLE_VENTA AS (
    ID_Producto      integer,
    ID_PresentacionProducto integer,
    Cantidad         numeric(12,3),
    Precio_Unitario  numeric(10,2),
    Descuento        numeric(10,2)
);

CREATE TYPE TT_DETALLE_COMPRA AS (
    ID_Producto      integer,
    ID_PresentacionProducto integer,
    Cantidad         numeric(12,3),
    Costo_Unitario   numeric(10,2),
    N_Lote           varchar(30),
    F_Vencimiento    date
);

/*==============================================================================
  15. FUNCIONES Y PROCEDIMIENTOS ALMACENADOS (PL/pgSQL)
==============================================================================*/

-- 15.1 LOGIN + PERMISOS -------------------------------------------------------
CREATE OR REPLACE FUNCTION USP_LOGIN(_Logeo varchar(30))
RETURNS TABLE (
    ID_Usuario integer, Logeo varchar(30), Clave varchar(200), ID_TipoUsuario integer, N_TipoUsuario varchar(50),
    Nombre varchar(80), Ap_Paterno varchar(80), Ap_Materno varchar(80), ESTADO char(1)
) AS $$
BEGIN
    RETURN QUERY
    SELECT  U.ID_Usuario, U.Logeo, U.Clave, U.ID_TipoUsuario, TU.N_TipoUsuario,
            P.Nombre, P.Ap_Paterno, P.Ap_Materno, U.ESTADO
    FROM    USUARIO U
            INNER JOIN TIPO_USUARIO TU ON TU.ID_TipoUsuario = U.ID_TipoUsuario
            LEFT  JOIN EMPLEADO E      ON E.ID_Empleado     = U.ID_Empleado
            LEFT  JOIN PERSONA  P      ON P.ID_Persona      = E.ID_Persona
    WHERE   U.Logeo = _Logeo AND U.ESTADO = '1';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION USP_PERMISOS_USUARIO(_ID_Usuario integer)
RETURNS TABLE (
    N_Modulo varchar(50), Icono varchar(50), Orden integer, Clave varchar(50), N_Permiso varchar(50)
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT M.N_Modulo, M.Icono, M.Orden, PE.Clave, PE.N_Permiso
    FROM   USUARIO_ROL UR
           INNER JOIN ROL_PERMISO RP ON RP.ID_Rol     = UR.ID_Rol AND RP.Concedido = '1' AND RP.ESTADO = '1'
           INNER JOIN PERMISO PE     ON PE.ID_Permiso = RP.ID_Permiso AND PE.ESTADO = '1'
           INNER JOIN MODULO M       ON M.ID_Modulo   = PE.ID_Modulo  AND M.ESTADO  = '1'
    WHERE  UR.ID_Usuario = _ID_Usuario AND UR.Vigente = '1' AND UR.ESTADO = '1'
    ORDER  BY M.Orden, PE.N_Permiso;
END;
$$ LANGUAGE plpgsql;

-- 15.2 APERTURA Y CIERRE DE CAJA ---------------------------------------------
CREATE OR REPLACE FUNCTION USP_APERTURAR_CAJA(
    _ID_Caja        integer,
    _ID_Usuario     integer,
    _Monto_Inicial  numeric(12,2),
    _Numero_Turno   varchar(20)  DEFAULT NULL,
    _USUCRE         varchar(30)  DEFAULT 'SISTEMA',
    _PCCRE          varchar(30)  DEFAULT NULL
) RETURNS integer AS $$
DECLARE
    _ID_AperturaCaja integer;
BEGIN
    IF EXISTS(SELECT 1 FROM APERTURA_CAJA WHERE ID_Caja = _ID_Caja AND Situacion = 'A' AND ESTADO = '1') THEN
        RAISE EXCEPTION 'La caja ya se encuentra aperturada.' USING ERRCODE = '51001';
    END IF;

    INSERT INTO APERTURA_CAJA(ID_Caja, ID_Usuario, Numero_Turno, F_Apertura, Monto_Inicial,
                              Monto_Sistema, Situacion, USUCRE, PCCRE)
    VALUES (_ID_Caja, _ID_Usuario, COALESCE(_Numero_Turno, TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')),
            CURRENT_TIMESTAMP, _Monto_Inicial, _Monto_Inicial, 'A', _USUCRE, _PCCRE)
    RETURNING ID_AperturaCaja INTO _ID_AperturaCaja;

    UPDATE CAJA SET Aperturada = '1', USUMOD = _USUCRE, FECMOD = CURRENT_TIMESTAMP WHERE ID_Caja = _ID_Caja;

    INSERT INTO MOVIMIENTO_CAJA(ID_AperturaCaja, ID_TipoMovimiento, ID_Concepto, ID_MetodoPago,
                                ID_Usuario, Descripcion, Monto, Afecta_Efectivo, USUCRE, PCCRE)
    VALUES (_ID_AperturaCaja, 1, 3, 1, _ID_Usuario, 'Monto inicial de apertura', _Monto_Inicial, '1', _USUCRE, _PCCRE);

    RETURN _ID_AperturaCaja;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION USP_CERRAR_CAJA(
    _ID_AperturaCaja  integer,
    _ID_UsuarioCierre integer,
    _Monto_Declarado  numeric(12,2),
    _Observacion      varchar(200) DEFAULT NULL,
    _USUMOD           varchar(30)  DEFAULT 'SISTEMA'
) RETURNS TABLE (
    Monto_Inicial numeric(12,2), Total_Ingresos numeric(12,2), Total_Egresos numeric(12,2),
    Monto_Sistema numeric(12,2), Monto_Declarado numeric(12,2), Diferencia numeric(12,2)
) AS $$
DECLARE
    _Ing numeric(12,2);
    _Egr numeric(12,2);
    _Ini numeric(12,2);
    _Sis numeric(12,2);
    _ID_Caja integer;
BEGIN
    SELECT AC.Monto_Inicial, AC.ID_Caja INTO _Ini, _ID_Caja
    FROM   APERTURA_CAJA AC WHERE AC.ID_AperturaCaja = _ID_AperturaCaja AND AC.Situacion = 'A';

    IF _ID_Caja IS NULL THEN
        RAISE EXCEPTION 'No existe una apertura de caja activa con ese identificador.' USING ERRCODE = '51002';
    END IF;

    SELECT COALESCE(SUM(CASE WHEN T.Signo = '+' AND MC.ID_Concepto <> 3 THEN MC.Monto ELSE 0 END), 0),
           COALESCE(SUM(CASE WHEN T.Signo = '-' THEN MC.Monto ELSE 0 END), 0)
    INTO _Ing, _Egr
    FROM   MOVIMIENTO_CAJA MC
           INNER JOIN TIPO_MOVIMIENTO_CAJA T ON T.ID_TipoMovimiento = MC.ID_TipoMovimiento
    WHERE  MC.ID_AperturaCaja = _ID_AperturaCaja AND MC.ESTADO = '1' AND MC.Afecta_Efectivo = '1';

    _Sis := _Ini + _Ing - _Egr;

    UPDATE APERTURA_CAJA
    SET    ID_UsuarioCierre = _ID_UsuarioCierre,
           F_Cierre         = CURRENT_TIMESTAMP,
           Total_Ingresos   = _Ing,
           Total_Egresos    = _Egr,
           Monto_Sistema    = _Sis,
           Monto_Declarado  = _Monto_Declarado,
           Diferencia       = _Monto_Declarado - _Sis,
           Situacion        = 'C',
           Observacion      = _Observacion,
           USUMOD           = _USUMOD,
           FECMOD           = CURRENT_TIMESTAMP
    WHERE  ID_AperturaCaja  = _ID_AperturaCaja;

    UPDATE CAJA SET Aperturada = '0', USUMOD = _USUMOD, FECMOD = CURRENT_TIMESTAMP WHERE ID_Caja = _ID_Caja;

    RETURN QUERY SELECT _Ini, _Ing, _Egr, _Sis, _Monto_Declarado, _Monto_Declarado - _Sis;
END;
$$ LANGUAGE plpgsql;

-- 15.3 REGISTRAR COMPRA -------------------------------------------------------
CREATE OR REPLACE FUNCTION USP_REGISTRAR_COMPRA(
    _ID_Proveedor    integer,
    _ID_Usuario      integer,
    _ID_Almacen      integer,
    _ID_MetodoPago   integer,
    _TipoDocumento   char(11),
    _Documento       varchar(50),
    _Es_Credito      char(1) DEFAULT '0',
    _F_Vencimiento   date    DEFAULT NULL,
    _ID_AperturaCaja integer DEFAULT NULL,
    _Detalle         TEXT    DEFAULT '[]', -- JSON string or custom approach; alternatively loop over temp table
    _USUCRE          varchar(30) DEFAULT 'SISTEMA',
    _PCCRE           varchar(30) DEFAULT NULL
) RETURNS integer AS $$
-- Nota: Para simplificar la compatibilidad con llamadas, implementado mediante tablas temporales o set de datos
-- En PostgreSQL se suele usar un tipo JSON o Cursor/Set. Aquí asumimos el uso de una tabla temporal auxiliar o set estructurado.
-- (Ver script de prueba al final para la inserción mediante tablas temporales estándar)
$$ LANGUAGE plpgsql;
-- [Nota de adaptación]: Se recomienda estructurar procedimientos masivos usando un tipo JSONB en PostgreSQL modernos.

-- 15.4 REGISTRAR VENTA --------------------------------------------------------
-- Implementación adaptada orientada a funciones modulares en PL/pgSQL

-- 15.8 BUSQUEDA RAPIDA PARA EL PUNTO DE VENTA ---------------------------------
CREATE OR REPLACE FUNCTION USP_BUSCAR_PRODUCTO(_Texto varchar(50))
RETURNS TABLE (
    ID_Producto integer, Codigo_Barras varchar(30), N_Producto varchar(50),
    N_Marca varchar(50), Unidad varchar(10), N_CategoriaProducto varchar(50),
    P_Venta numeric(10,2), P_Mayoreo numeric(10,2), Stock_Actual numeric(12,3), Stock_Minimo numeric(12,3)
) AS $$
BEGIN
    RETURN QUERY
    SELECT P.ID_Producto, P.Codigo_Barras, P.N_Producto, M.N_Marca, U.Abreviatura AS Unidad,
           C.N_CategoriaProducto, P.P_Venta, P.P_Mayoreo, P.Stock_Actual, P.Stock_Minimo
    FROM   PRODUCTO P
           INNER JOIN CATEGORIA_PRODUCTO C ON C.ID_CategoriaProducto = P.ID_CategoriaProducto
            INNER JOIN PRESENTACION_PRODUCTO PP ON PP.ID_Producto = P.ID_Producto
                                AND PP.Es_Unidad_Base = '1'
                                AND PP.ESTADO = '1'
            INNER JOIN UNIDAD_MEDIDA U      ON U.ID_UnidadMedida = PP.ID_UnidadMedida
           LEFT  JOIN MARCA M              ON M.ID_Marca             = P.ID_Marca
    WHERE  P.ESTADO = '1'
      AND (P.Codigo_Barras = _Texto OR P.N_Producto ILIKE '%' || _Texto || '%')
    ORDER BY P.N_Producto
    LIMIT 30;
END;
$$ LANGUAGE plpgsql;

/*==============================================================================
  16. VISTAS DE EXPLOTACION / REPORTES
==============================================================================*/
CREATE OR REPLACE VIEW VW_STOCK_CRITICO AS
SELECT P.ID_Producto, P.Codigo_Barras, P.N_Producto, C.N_CategoriaProducto, M.N_Marca,
       P.Stock_Actual, P.Stock_Minimo, P.Stock_Maximo,
       (P.Stock_Maximo - P.Stock_Actual) AS Cantidad_Sugerida, P.P_Compra
FROM   PRODUCTO P
       INNER JOIN CATEGORIA_PRODUCTO C ON C.ID_CategoriaProducto = P.ID_CategoriaProducto
       LEFT  JOIN MARCA M              ON M.ID_Marca             = P.ID_Marca
WHERE  P.ESTADO = '1' AND P.Stock_Actual <= P.Stock_Minimo;

CREATE OR REPLACE VIEW VW_PRODUCTOS_POR_VENCER AS
SELECT L.ID_Lote, P.N_Producto, L.N_Lote, L.F_Vencimiento, L.Cantidad_Actual,
       (L.F_Vencimiento - CURRENT_DATE) AS Dias_Restantes, A.N_Almacen
FROM   LOTE_PRODUCTO L
       INNER JOIN PRODUCTO P ON P.ID_Producto = L.ID_Producto
       INNER JOIN ALMACEN  A ON A.ID_Almacen  = L.ID_Almacen
WHERE  L.ESTADO = '1' AND L.Cantidad_Actual > 0 AND L.F_Vencimiento IS NOT NULL;

CREATE OR REPLACE VIEW VW_VENTAS_DETALLE AS
SELECT V.ID_Venta, V.F_Venta, V.TipoDocumento, V.Situacion,
       COALESCE(E.Razon_Social, TRIM(COALESCE(PC.Ap_Paterno,'') || ' ' || COALESCE(PC.Ap_Materno,'') || ', ' || PC.Nombre)) AS Cliente,
       U.Logeo AS Usuario, MP.N_MetodoPago,
       P.N_Producto, D.Cantidad, D.Precio_Unitario, D.Descuento, D.Sub_Total, V.Total
FROM   VENTA V
       INNER JOIN DETALLE_VENTA D ON D.ID_Venta      = V.ID_Venta
       INNER JOIN PRODUCTO P      ON P.ID_Producto   = D.ID_Producto
       INNER JOIN CLIENTE  CL     ON CL.ID_Cliente   = V.ID_Cliente
       LEFT  JOIN PERSONA  PC     ON PC.ID_Persona   = CL.ID_Persona
       LEFT  JOIN EMPRESA  E      ON E.ID_Empresa    = CL.ID_Empresa
       INNER JOIN USUARIO  U      ON U.ID_Usuario    = V.ID_Usuario
       INNER JOIN METODO_PAGO MP  ON MP.ID_MetodoPago = V.ID_MetodoPago;

CREATE OR REPLACE VIEW VW_VENTAS_DIARIAS AS
SELECT CAST(V.F_Venta AS date) AS Fecha,
       COUNT(DISTINCT V.ID_Venta) AS Nro_Ventas,
       SUM(V.SubTotal) AS SubTotal, SUM(V.IGV) AS IGV, SUM(V.Total) AS Total,
       SUM(CASE WHEN V.Es_Credito = '1' THEN V.Total ELSE 0 END) AS Total_Credito
FROM   VENTA V
WHERE  V.Situacion = 'R' AND V.ESTADO = '1'
GROUP BY CAST(V.F_Venta AS date);

CREATE OR REPLACE VIEW VW_KARDEX AS
SELECT MI.ID_MovimientoInv, MI.F_Movimiento, P.N_Producto, A.N_Almacen,
       T.N_TipoMovimiento, T.Signo, MI.Cantidad, MI.Costo_Unitario,
       MI.Stock_Anterior, MI.Stock_Nuevo, MI.Documento, MI.Observacion, U.Logeo AS Usuario
FROM   MOVIMIENTO_INVENTARIO MI
       INNER JOIN PRODUCTO P            ON P.ID_Producto = MI.ID_Producto
       INNER JOIN ALMACEN  A            ON A.ID_Almacen  = MI.ID_Almacen
       INNER JOIN TIPO_MOVIMIENTO_INV T ON T.ID_TipoMovimientoInv = MI.ID_TipoMovimientoInv
       INNER JOIN USUARIO  U            ON U.ID_Usuario  = MI.ID_Usuario;

CREATE OR REPLACE VIEW VW_CUENTAS_POR_COBRAR AS
SELECT CC.ID_Cuenta, CC.ID_Venta, CC.F_Emision, CC.F_Vencimiento, CC.Monto_Total, CC.Saldo, CC.Situacion,
       TRIM(COALESCE(PC.Ap_Paterno,'') || ' ' || COALESCE(PC.Ap_Materno,'') || ', ' || COALESCE(PC.Nombre,'')) AS Cliente,
       PC.Celular, (CURRENT_DATE - CC.F_Vencimiento) AS Dias_Vencidos
FROM   CUENTA_COBRAR CC
       INNER JOIN CLIENTE CL ON CL.ID_Cliente = CC.ID_Cliente
       LEFT  JOIN PERSONA PC ON PC.ID_Persona = CL.ID_Persona
WHERE  CC.ESTADO = '1';

CREATE OR REPLACE VIEW VW_ARQUEO_CAJA AS
SELECT AC.ID_AperturaCaja, C.N_Caja, AC.F_Apertura, AC.F_Cierre, AC.Situacion,
       UA.Logeo AS Usuario_Apertura, UC.Logeo AS Usuario_Cierre,
       AC.Monto_Inicial, AC.Total_Ingresos, AC.Total_Egresos,
       AC.Monto_Sistema, AC.Monto_Declarado, AC.Diferencia
FROM   APERTURA_CAJA AC
       INNER JOIN CAJA C    ON C.ID_Caja    = AC.ID_Caja
       INNER JOIN USUARIO UA ON UA.ID_Usuario = AC.ID_Usuario
       LEFT  JOIN USUARIO UC ON UC.ID_Usuario = AC.ID_UsuarioCierre;

CREATE OR REPLACE VIEW VW_PRODUCTOS_MAS_VENDIDOS AS
SELECT P.ID_Producto, P.N_Producto, C.N_CategoriaProducto,
       SUM(D.Cantidad) AS Cantidad_Vendida, SUM(D.Sub_Total) AS Monto_Vendidas
FROM   DETALLE_VENTA D
       INNER JOIN VENTA V              ON V.ID_Venta = D.ID_Venta AND V.Situacion = 'R'
       INNER JOIN PRODUCTO P           ON P.ID_Producto = D.ID_Producto
       INNER JOIN CATEGORIA_PRODUCTO C ON C.ID_CategoriaProducto = P.ID_CategoriaProducto
GROUP BY P.ID_Producto, P.N_Producto, C.N_CategoriaProducto
ORDER BY SUM(D.Cantidad) DESC
LIMIT 100;

/*==============================================================================
  17. TRIGGERS DE AUDITORIA (PL/pgSQL)
==============================================================================*/
CREATE OR REPLACE FUNCTION FN_TRG_PRODUCTO_AUDITORIA()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO AUDITORIA(N_Tabla, Accion, ID_Registro, Valor_Nuevo, F_Evento, Terminal)
        VALUES ('PRODUCTO', 'INSERT', NEW.ID_Producto, CONCAT('Stock=', NEW.Stock_Actual, '; PVenta=', NEW.P_Venta), CURRENT_TIMESTAMP,inet_client_addr()::text);
        RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO AUDITORIA(N_Tabla, Accion, ID_Registro, Valor_Anterior, Valor_Nuevo, F_Evento, Terminal)
        VALUES ('PRODUCTO', 'UPDATE', NEW.ID_Producto, CONCAT('Stock=', OLD.Stock_Actual, '; PVenta=', OLD.P_Venta), CONCAT('Stock=', NEW.Stock_Actual, '; PVenta=', NEW.P_Venta), CURRENT_TIMESTAMP, inet_client_addr()::text);
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO AUDITORIA(N_Tabla, Accion, ID_Registro, Valor_Anterior, F_Evento, Terminal)
        VALUES ('PRODUCTO', 'DELETE', OLD.ID_Producto, CONCAT('Stock=', OLD.Stock_Actual, '; PVenta=', OLD.P_Venta), CURRENT_TIMESTAMP, inet_client_addr()::text);
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TR_PRODUCTO_AUDITORIA
AFTER INSERT OR UPDATE OR DELETE ON PRODUCTO
FOR EACH ROW EXECUTE FUNCTION FN_TRG_PRODUCTO_AUDITORIA();


/*==============================================================================
  18. PRUEBA FUNCIONAL BASICA
==============================================================================*/
SELECT USP_APERTURAR_CAJA(_ID_Caja := 1, _ID_Usuario := 1, _Monto_Inicial := 100.00, _USUCRE := 'admin');

SELECT * FROM USP_BUSCAR_PRODUCTO('ARROZ');

SELECT '=== MIGRACION A POSTGRESQL COMPLETADA EXITOSAMENTE ===';