package com.nyctaxi;

import java.io.FileReader;
import java.io.Reader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;

public class ZoneLoader {

    // --- CONFIGURACIÓN ---
    private static final String URL = "jdbc:mysql://localhost:3306/nyc_taxi_db";
    private static final String USER = "root";
    // ¡IMPORTANTE! Pon aquí la contraseña que usaste en la extensión de base de datos
    private static final String PASSWORD = "Abunda-la-oro4"; 

    // Ruta al archivo CSV. Asegúrate de que el archivo está en esta carpeta dentro de concurrent-loader
    private static final String CSV_FILE = "Data/taxi_zone_lookup.csv";

    public static void main(String[] args) {
        System.out.println("=== Iniciando carga de zonas ===");

        String insertSQL = "INSERT INTO dim_location (LocationID, Borough, Zone, ServiceZone) VALUES (?, ?, ?, ?)";

        try (
            // 1. Conectar a la Base de Datos
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            // 2. Leer el archivo CSV
            Reader in = new FileReader(CSV_FILE);
            PreparedStatement pstmt = conn.prepareStatement(insertSQL)
        ) {
            System.out.println("Conexión a BD exitosa. Leyendo archivo...");

            // Configurar CSV (saltar cabecera)
            Iterable<CSVRecord> records = CSVFormat.DEFAULT.builder()
                .setHeader()
                .setSkipHeaderRecord(true)
                .build()
                .parse(in);

            int count = 0;
            conn.setAutoCommit(false); // Truco para ir más rápido (Batch)

            for (CSVRecord record : records) {
                // Leer datos del CSV
                int locationID = Integer.parseInt(record.get("LocationID"));
                String borough = record.get("Borough");
                String zone = record.get("Zone");
                String serviceZone = record.get("service_zone");

                // Preparar la inserción
                pstmt.setInt(1, locationID);
                pstmt.setString(2, borough);
                pstmt.setString(3, zone);
                pstmt.setString(4, serviceZone);
                
                pstmt.addBatch(); // Añadir al lote
                count++;

                // Enviar a BD cada 100 filas
                if (count % 100 == 0) {
                    pstmt.executeBatch();
                    conn.commit();
                }
            }
            
            // Insertar los últimos que queden
            pstmt.executeBatch();
            conn.commit();
            
            System.out.println("✅ ¡ÉXITO! Se han cargado " + count + " zonas en la tabla dim_location.");

        } catch (Exception e) {
            System.err.println("❌ ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}