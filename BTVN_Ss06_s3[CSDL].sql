CREATE TABLE btvn_ss06;
USE btvn_ss06;
SELECT 
    user_id,
    COUNT(*) AS total_bookings, -- Tổng số lần đặt phòng
    SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) AS total_cancelled
FROM 
    Bookings
GROUP BY 
    user_id
HAVING 
    -- Tiêu chí 1: Tổng số lần đặt >= 10
    total_bookings >= 10 
    -- Tiêu chí 2: Số lượng đơn hủy > 5
    AND SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) > 5;
-- 1. Thiết kế I/O & Luồng xử lý Logic
-- Để giải quyết yêu cầu "đếm riêng số đơn Hủy trên cùng một dòng SELECT", chúng ta 
-- sử dụng kỹ thuật Conditional Aggregation (Tổng hợp có điều kiện).
-- Ý tưởng chủ đạo: Thay vì chỉ đếm đơn thuần, chúng ta lồng một cấu trúc rẽ 
-- nhánh (CASE WHEN) vào bên trong hàm tổng hợp (SUM hoặc COUNT).
-- Cơ chế hoạt động: * Máy sẽ duyệt qua từng đơn hàng của một user_id.
-- Nếu đơn hàng đó có status = 'CANCELLED', máy sẽ gán cho nó giá trị là 1.
-- Nếu không phải, máy gán giá trị 0.
-- Hàm SUM() sau đó cộng tất cả các giá trị 1 và 0 này lại. Kết quả cuối
--  cùng chính là tổng số đơn đã hủy.

-- Luồng thực thi: 1. FROM Bookings: Lấy dữ liệu.
-- 2. GROUP BY user_id: Nhóm dữ liệu theo từng khách hàng.
-- 3. SUM(1) hoặc COUNT(*): Tính tổng tất cả các đơn.
-- 4. SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END): Tính riêng số đơn hủy.
-- 5. HAVING: Áp dụng bộ lọc hai tầng để tìm ra "kẻ đầu cơ".