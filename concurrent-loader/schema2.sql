USE nyc_taxi_db;

DROP TABLE IF EXISTS Trips;

CREATE TABLE Trips (
    TripID BIGINT AUTO_INCREMENT PRIMARY KEY,
    VendorID INT,
    tpep_pickup_datetime DATETIME,
    tpep_dropoff_datetime DATETIME,
    passenger_count INT,
    trip_distance DECIMAL(10, 2),
    RateCodeID INT,
    store_and_fwd_flag CHAR(1),
    PULocationID INT,
    DOLocationID INT,
    payment_type INT,
    fare_amount DECIMAL(10, 2),
    extra DECIMAL(10, 2),
    mta_tax DECIMAL(10, 2),
    tip_amount DECIMAL(10, 2),
    tolls_amount DECIMAL(10, 2),
    improvement_surcharge DECIMAL(10, 2),
    total_amount DECIMAL(10, 2),
    congestion_surcharge DECIMAL(10, 2),
    FOREIGN KEY (VendorID) REFERENCES Ref_Vendor (VendorID),
    FOREIGN KEY (RateCodeID) REFERENCES Ref_RateCode (RateCodeID),
    FOREIGN KEY (PULocationID) REFERENCES Dim_Location (LocationID),
    FOREIGN KEY (DOLocationID) REFERENCES Dim_Location (LocationID),
    FOREIGN KEY (payment_type) REFERENCES Ref_PaymentType (PaymentTypeID)
);