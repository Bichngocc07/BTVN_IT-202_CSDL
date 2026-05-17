-- =========================================================================
-- STEP 1: KHỞI TẠO CƠ SỞ DỮ LIỆU VÀ NẠP DỮ LIỆU MẪU (RIKKEI_CLINIC_DB)
-- =========================================================================
CREATE DATABASE IF NOT EXISTS rikkei_clinic_db;
USE rikkei_clinic_db;

-- Dọn dẹp hệ thống: Xóa cấu trúc cũ để tránh lỗi dữ liệu khi bấm chạy lại nhiều lần
DROP VIEW IF EXISTS department_revenue_view;
DROP TABLE IF EXISTS vitals_logs;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS pharmacy_inventory;
DROP TABLE IF EXISTS medical_records;

-- 1. Tạo bảng lưu trữ thông tin khoa
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- 2. Tạo bảng lưu trữ thông tin bệnh nhân 
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

-- 3. Tạo bảng lưu trữ hóa đơn
CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY,
    patient_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- 4. Chèn dữ liệu mẫu chuẩn để thực hiện kiểm thử bài tập
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


-- =========================================================================
-- PHẦN B: TRIỂN KHAI CODE & KIỂM THỬ THEO YÊU CẦU BÀI TẬP
-- =========================================================================

-- 1. Triển khai: Viết mã SQL tạo View mang tên department_revenue_view
-- Giúp ẩn toàn bộ thông tin nhạy cảm của bệnh nhân, chỉ hiển thị dữ liệu tổng hợp
CREATE VIEW department_revenue_view AS
SELECT 
    d.department_id,
    d.department_name,
    COUNT(DISTINCT p.patient_id) AS total_patients,
    IFNULL(SUM(i.amount), 0.00) AS total_revenue
FROM 
    departments d
LEFT JOIN 
    patients p ON d.department_id = p.department_id
LEFT JOIN 
    invoices i ON p.patient_id = i.patient_id
GROUP BY 
    d.department_id, 
    d.department_name;


-- 2. Kiểm thử luồng chuẩn: Viết lệnh SELECT truy vấn trên View vừa tạo để hiển thị báo cáo
-- (Kết quả hiện ra dữ liệu tổng hợp của từng khoa cực kỳ gọn gàng và an toàn)
SELECT * FROM department_revenue_view;


-- 3. Kiểm thử bẫy dữ liệu: Viết lệnh UPDATE cố tình thay đổi trực tiếp cột total_revenue
-- (Mục đích chứng minh: Hệ thống sẽ tự động CHẶN ĐỨNG và văng lỗi 'is not updatable' 
-- để bảo vệ biến thùng tổng doanh thu không bị sửa đổi tùy tiện)
UPDATE department_revenue_view
SET total_revenue = 999999.99
WHERE department_id = 1;