
CREATE DATABASE IF NOT EXISTS rikkei_clinic_db;
USE rikkei_clinic_db;

DROP TABLE IF EXISTS vitals_logs;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS pharmacy_inventory;
DROP TABLE IF EXISTS medical_records;
DROP VIEW IF EXISTS reception_patient_view;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    phone VARCHAR(15) NOT NULL,
    room_number VARCHAR(10),
    hiv_status VARCHAR(20),
    mental_health_history TEXT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 4. Tạo bảng lưu trữ hóa đơn
CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY,
    patient_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

INSERT INTO departments (department_id, department_name) VALUES 
(1, 'Khoa Noi'), 
(2, 'Khoa Ngoai');

INSERT INTO patients (patient_id, full_name, age, phone, room_number, hiv_status, mental_health_history, department_id) VALUES
(1, 'Nguyen Van A', 45, '0901234567', '101A', 'Negative', 'None', 1),
(2, 'Tran Thi B', 30, '0912345678', '102B', 'Positive', 'Depression 2020', 1),
(3, 'Le Hoang C', 50, '0923456789', '103A', 'Negative', 'Anxiety', 2);

INSERT INTO invoices (invoice_id, patient_id, amount) VALUES 
(101, 1, 500000), 
(102, 2, 300000), 
(103, 3, 1000000);



CREATE VIEW reception_patient_view AS
SELECT patient_id, full_name, age, room_number, hiv_status, mental_health_history
FROM patients;

SELECT * FROM reception_patient_view;

UPDATE reception_patient_view
SET age = -5
WHERE patient_id = 1;

SELECT * FROM patients WHERE patient_id = 1;

DROP VIEW IF EXISTS reception_patient_view;

CREATE VIEW reception_patient_view AS
SELECT 
    patient_id, 
    full_name, 
    age, 
    room_number
FROM 
    patients
WHERE 
    age > 0
WITH CHECK OPTION;



SELECT * FROM reception_patient_view;

UPDATE reception_patient_view
SET age = -10
WHERE patient_id = 2;
