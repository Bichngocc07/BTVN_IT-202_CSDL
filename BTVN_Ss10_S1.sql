-- =========================================================================
-- STEP 1: KHỞI TẠO CƠ SỞ DỮ LIỆU VÀ CHÈN DỮ LIỆU MẪU (RIKKEI_CLINIC_DB)
-- =========================================================================
CREATE DATABASE IF NOT EXISTS rikkei_clinic_db;
USE rikkei_clinic_db;

-- 1. Xóa các bảng cũ nếu đã tồn tại để làm sạch dữ liệu
DROP TABLE IF EXISTS vitals_logs;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS pharmacy_inventory;
DROP TABLE IF EXISTS medical_records;
DROP VIEW IF EXISTS reception_patient_view;

-- 2. Tạo bảng lưu trữ thông tin khoa
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- 3. Tạo bảng lưu trữ thông tin bệnh nhân 
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

-- 5. Chèn dữ liệu mẫu vào các bảng
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
-- PHẦN A: TÁI HIỆN LỖI (MÃ NGUỒN CŨ BỊ LỖI BẢO MẬT & TOÀN VẸN)
-- =========================================================================

-- 1. Tạo View ban đầu theo đúng hiện trạng giả định (Bị lỗi lộ thông tin)
CREATE VIEW reception_patient_view AS
SELECT patient_id, full_name, age, room_number, hiv_status, mental_health_history
FROM patients;

-- LỆNH THỰC THI 1: Truy vấn View hiện tại để chỉ ra các cột vi phạm bảo mật
-- (Chạy lệnh này sẽ thấy lộ cột hiv_status và mental_health_history)
SELECT * FROM reception_patient_view;

-- LỆNH THỰC THI 2: Cố tình hack tuổi thành số âm để chứng minh hệ thống thiếu kiểm soát
UPDATE reception_patient_view
SET age = -5
WHERE patient_id = 1;

-- Kiểm tra lại bảng gốc xem dữ liệu có bị phá hoại thành công không
-- (Kết quả: Tuổi của Nguyen Van A đã bị đổi thành -5 -> Lỗi toàn vẹn dữ liệu)
SELECT * FROM patients WHERE patient_id = 1;


-- =========================================================================
-- PHẦN B: SỬA CHỮA MÃ NGUỒN (XÓA CŨ - DỰNG MỚI BẰNG CHỐT CHẶN AN TOÀN)
-- =========================================================================

-- 1. Lệnh SQL xóa (DROP) View cũ bị lỗi
DROP VIEW IF EXISTS reception_patient_view;

-- 2. Lệnh CREATE tạo View mới khắc phục hoàn toàn lỗ hổng
-- (Chỉ truy xuất 4 cột hợp lệ + Thêm chốt chặn WITH CHECK OPTION)
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


-- =========================================================================
-- KIỂM TRA SAU KHI VÁ BUG (Dùng để lấy dữ liệu chứng minh kết quả)
-- =========================================================================

-- LỆNH THỰC THI 3: Kiểm tra xem còn bị lộ thông tin bệnh án nhạy cảm không?
-- (Kết quả: Chỉ hiển thị đúng 4 cột an toàn, thông tin HIV và Tâm thần đã bị giấu sạch)
SELECT * FROM reception_patient_view;

-- LỆNH THỰC THI 4: Cố tình hack tuổi âm một lần nữa xem View mới có chặn không?
-- (Kết quả: MySQL sẽ văng lỗi đỏ rực 'CHECK OPTION failed' và chặn đứng lệnh này lại!)
UPDATE reception_patient_view
SET age = -10
WHERE patient_id = 2;