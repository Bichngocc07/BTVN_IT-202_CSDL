CREATE DATABASE btvn_Ss5;
USE btvn_Ss5;

SELECT restaurant_name, created_at
FROM Restaurants
ORDER BY  created_at DESC
LIMIT 5;
-- 1. Phân tích Logic: Tại sao dữ liệu Quận 1 lại sai?
-- Nguyên nhân cốt lõi nằm ở quy tắc ưu tiên: Toán tử AND luôn được ưu tiên 
-- thực hiện trước toán tử OR.

-- Cách SQL hiểu đoạn code lỗi: Hệ thống sẽ gom nhóm điều kiện district = 'Quận 3' 
-- AND rating > 4.0 lại thành một cụm trước. Do đó, câu lệnh bị biến thành:
-- "Lấy nhà hàng ở (Quận 1) HOẶC (ở Quận 3 mà có rating > 4.0)".

-- Hậu quả: Bất kỳ nhà hàng nào ở Quận 1 cũng sẽ bị lấy ra, bất kể rating là 1.0 
-- hay 2.0, vì điều kiện rating > 4.0 chỉ đang bị ràng buộc vào mỗi Quận 3.
