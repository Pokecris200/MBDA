CREATE TABLE Cliente (
    tid         VARCHAR(2) NOT NULL,
    nid         NUMBER(15) NOT NULL,
    nombre      VARCHAR(20) NOT NULL,
    correo      VARCHAR(10)
);
CREATE TABLE Telefono (
    telefono    NUMBER(10) NOT NULL,
    nid         NUMBER(15) NOT NULL
);
CREATE TABLE Factura (
    numero      NUMBER(5) NOT NULL,
    fecha       DATE NOT NULL,
    total       NUMBER(12) NOT NULL,
    nid         NUMBER(15) NOT NULL
);
CREATE TABLE LineaFactura (
    cantidad    NUMBER(10) NOT NULL,
    precioventa NUMBER(12) NOT NULL,
    numero      NUMBER(5) NOT NULL,
    codigo      VARCHAR(5) NOT NULL
);
CREATE TABLE Bien (
    codigo      VARCHAR(5) NOT NULL,
    nombre      VARCHAR(20) NOT NULL,
    precioventa NUMBER(12) NOT NULL
);
CREATE TABLE Servicio (
    manodeobra  NUMBER(12) NOT NULL,
    costo       NUMBER(12) NOT NULL,
    codigo      VARCHAR(5) NOT NULL
);
CREATE TABLE Servicio (
    existencias NUMBER(4) NOT NULL,
    preciocompra NUMBER(12) NOT NULL,
    codigo      VARCHAR(5) NOT NULL
);
CREATE TABLE Puedereemplazar (
    codigoin    VARCHAR(5) NOT NULL,
    codigoout   VARCHAR(5) NOT NULL
);
CREATE TABLE Utiliza (
    cantidad    NUMBER(10) NOT NULL,
    idservicio  VARCHAR(5) NOT NULL,
    idproducto  VARCHAR(5) NOT NULL
);

/*Pk's*/

ALTER TABLE Cliente ADD CONSTRAINT pk_Cliente PRIMARY KEY ( tid,nid );
ALTER TABLE Bien ADD CONSTRAINT pk_Bien PRIMARY KEY ( codigo );

/*Fk's*/

ALTER TABLE Telefonos
    ADD CONSTRAINT FK_Telefonos_nid FOREIGN KEY ( nid )
        REFERENCES Cliente ( nid );
ALTER TABLE Factura
    ADD CONSTRAINT FK_Factura_nid FOREIGN KEY ( nid )
        REFERENCES Cliente ( nid );
ALTER TABLE LineaFactura
    ADD CONSTRAINT FK_LineaFactura_numero FOREIGN KEY ( numero )
        REFERENCES Factura ( numero );
ALTER TABLE LineaFactura
    ADD CONSTRAINT FK_LineaFactura_codigo FOREIGN KEY ( codigo )
        REFERENCES Bien ( codigo );
ALTER TABLE Servicio
    ADD CONSTRAINT FK_Servicio_codigo FOREIGN KEY ( codigo )
        REFERENCES Bien ( codigo );
ALTER TABLE Prducto
    ADD CONSTRAINT FK_Producto_codigo FOREIGN KEY ( codigo )
        REFERENCES Bien ( codigo );
ALTER TABLE Utiliza
    ADD CONSTRAINT FK_Utiliza_idservicio FOREIGN KEY ( idservicio )
        REFERENCES Servicio ( codigo );
ALTER TABLE Utiliza
    ADD CONSTRAINT FK_Utiliza_idproducto FOREIGN KEY ( idproducto )
        REFERENCES Producto ( codigo );

/*Restricciones*/

ALTER TABLE  ADD CONSTRAINT CHECK
