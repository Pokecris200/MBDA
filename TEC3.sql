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
    total       NUMBER(10,2) NOT NULL,
    nid         NUMBER(15) NOT NULL
);
CREATE TABLE LineaFactura (
    cantidad    NUMBER(10) NOT NULL,
    precioventa NUMBER(10,2) NOT NULL,
    numero      NUMBER(5) NOT NULL,
    codigo      VARCHAR(5) NOT NULL
);
CREATE TABLE Bien (
    codigo      VARCHAR(5) NOT NULL,
    nombre      VARCHAR(20) NOT NULL,
    precioventa NUMBER(10,2) NOT NULL
);
CREATE TABLE Servicio (
    manodeobra  NUMBER(10,2) NOT NULL,
    costo       NUMBER(10,2) NOT NULL,
    codigo      VARCHAR(5) NOT NULL
);
CREATE TABLE Servicio (
    existencias NUMBER(4) NOT NULL,
    preciocompra NUMBER(10,2) NOT NULL,
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
);.

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

ALTER TABLE Bien ADD CONSTRAINT ck_Bien_moneda CHECK((precioventa AS NUMERIC(8))-precioventa = 0.00 OR (precioventa AS NUMERIC(8))-precioventa = 0.50 );
ALTER TABLE Factura ADD CONSTRAINT ck_Factura_moneda CHECK((total AS NUMERIC(8))-total = 0.00 OR (total AS NUMERIC(8))-total = 0.50 );
ALTER TABLE LineaFactura ADD CONSTRAINT ck_LineaFactura_moneda CHECK((precioventa AS NUMERIC(8))-precioventa = 0.00 OR (precioventa AS NUMERIC(8))-precioventa = 0.50 );
ALTER TABLE Producto ADD CONSTRAINT ck_Producto_moneda CHECK((preciocompra AS NUMERIC(8))-preciocompra = 0.00 OR (preciocompra AS NUMERIC(8))-preciocompra = 0.50 );
ALTER TABLE Servicio ADD CONSTRAINT ck_Servicio_moneda_1 CHECK((manodeobra AS NUMERIC(8))-manodeobra = 0.00 OR (manodeobra AS NUMERIC(8))-manodeobra = 0.50 );
ALTER TABLE Servicio ADD CONSTRAINT ck_Servicio_moneda_2 CHECK((costo AS NUMERIC(8))-costo = 0.00 OR (costo AS NUMERIC(8))-costo = 0.50 );
                                                                                               
/*Triggers*/
CREATE OR REPLACE TRIGGER Eliminar_Factura
BEFORE DELETE ON Bien
BEGIN
    IF (EXISTS(SELECT *
                FROM Servicio
                JOIN Bien ON Bien.codigo = Servicio.codigo) 
        OR EXISTS(SELECT *
                  FROM Factura
                  JOIN LineaFactura ON Factura.numero = LineaFactura.numero
                  JOIN Bien ON LineaFactura.codigo = Bien.codigo))THEN
    RAISE 'No se puede borrar el bien ';
    END IF;
END;

CREATE OR REPLACE TRIGGER Nuevo_Codigo
AFTER INSERT ON Bien
BEGIN
    IF new.codigo = NULL THEN
        new.codigo := SUBSTR(new.nombre,0,5)
    END IF;
END;



CREATE OR REPLACE TRIGGER Eliminar_Cliente
BEFORE DELETE ON Cliente
BEGIN
    IF(EXISTS(SELECT *
              FROM Factura
              JOIN Cliente ON Cliente.nid = Factura.nid))THEN
    RAISE 'No se puede borrar el cliente ';
    END IF;
END;

CREATE OR REPLACE TRIGGER Nuevo_Correo
AFTER INSERT ON Bien
BEGIN
    IF new.correo = NULL THEN
        new.correo := TO_CHAR(new.nid)||'@vendemmos.com.co'
END;
