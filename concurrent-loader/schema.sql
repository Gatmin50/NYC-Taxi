-- Active: 1765625144391@@127.0.0.1@3306@nyc_taxi_db
-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS nyc_taxi_db;

USE nyc_taxi_db;

-- === TABLAS DIMENSIONALES (Para cumplir 3FN) ===

-- Tabla para los Vendedores (VendorID)
-- Elimina la redundancia del nombre del proveedor
CREATE TABLE Ref_Vendor (
    VendorID INT PRIMARY KEY,
    Description VARCHAR(50)
);

-- Tabla para Tipos de Tarifa (RateCodeID)
-- Elimina la redundancia de descripciones como "JFK", "Nassau", etc.
CREATE TABLE Ref_RateCode (
    RateCodeID INT PRIMARY KEY,
    Description VARCHAR(50)
);

-- Tabla para Tipos de Pago (payment_type)
-- Elimina la redundancia de "Credit Card", "Cash", etc.
CREATE TABLE Ref_PaymentType (
    PaymentTypeID INT PRIMARY KEY,
    Description VARCHAR(50)
);

-- Tabla de Zonas (Se llenará con taxi_zone_lookup.csv)
-- Elimina la redundancia de guardar "Manhattan" o "Queens" en cada viaje
CREATE TABLE Dim_Location (
    LocationID INT PRIMARY KEY,
    Borough VARCHAR(50),
    Zone VARCHAR(100),
    ServiceZone VARCHAR(50)
);

-- === TABLA DE HECHOS (Los Viajes) ===
-- Esta tabla contiene solo IDs y números, haciéndola muy rápida
CREATE TABLE Trips (
    TripID BIGINT AUTO_INCREMENT PRIMARY KEY,
    VendorID INT,
    tpep_pickup_datetime DATETIME,
    tpep_dropoff_datetime DATETIME,
    passenger_count INT,
    trip_distance DECIMAL(10, 2),
    RateCodeID INT,
    store_and_fwd_flag CHAR(1),
    PULocationID INT, -- ID de zona de recogida
    DOLocationID INT, -- ID de zona de destino
    payment_type INT,
    fare_amount DECIMAL(10, 2),
    extra DECIMAL(10, 2),
    mta_tax DECIMAL(10, 2),
    tip_amount DECIMAL(10, 2),
    tolls_amount DECIMAL(10, 2),
    improvement_surcharge DECIMAL(10, 2),
    total_amount DECIMAL(10, 2),
    congestion_surcharge DECIMAL(10, 2),

-- Relaciones (Foreign Keys) para asegurar integridad
FOREIGN KEY (VendorID) REFERENCES Ref_Vendor(VendorID),
    FOREIGN KEY (RateCodeID) REFERENCES Ref_RateCode(RateCodeID),
    FOREIGN KEY (PULocationID) REFERENCES Dim_Location(LocationID),
    FOREIGN KEY (DOLocationID) REFERENCES Dim_Location(LocationID),
    FOREIGN KEY (payment_type) REFERENCES Ref_PaymentType(PaymentTypeID)
);