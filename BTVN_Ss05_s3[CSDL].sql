CREATE DATABASE btvn_Ss5;
USE btvn_Ss5;

-- Giả sử bảng Drivers đã tồn tại và có dữ liệu
SELECT 
    driver_id, 
    driver_name, 
    distance_km, 
    trust_score
FROM 
    Drivers
WHERE 
    status = 'AVAILABLE'
    -- Thay biến bằng số cụ thể ở đây
    AND trust_score >= GREATEST(80, 80) 
ORDER BY 
    distance_km ASC,
    trust_score DESC;
--     1. Phân tích nguyên nhân (Tại sao bị từ chối?)
-- Sai mật khẩu: Đây là lý do của 90% trường hợp. Bạn có thể đã gõ nhầm, để 
-- Caps Lock, hoặc bộ gõ tiếng Việt (Telex) tự chèn dấu vào mật khẩu.

-- Sai User: Bạn đang cố đăng nhập bằng user ngocs, nhưng có thể 
-- lúc cài đặt bạn chỉ tạo user mặc định là root.

-- Sai quyền truy cập (Privileges): User ngocs có thể tồn tại nhưng 
-- chưa được cấp quyền truy cập từ địa chỉ 127.0.0.1 (localhost).