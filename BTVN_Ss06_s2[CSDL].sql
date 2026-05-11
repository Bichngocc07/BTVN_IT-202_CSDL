CREATE TABLE btvn_ss06;
USE btvn_ss06;
SELECT 
    hotel_id, 
    MIN(price_per_night) AS min_price
FROM 
    Rooms
GROUP BY 
    hotel_id;
-- 1. Phân tích kiến trúc: Tại sao room_name lại sai quy tắc?
-- Lỗi này nằm ở tính mập mờ về logic (Non-deterministic).
-- Quy tắc toán học của GROUP BY: Khi cậu dùng GROUP BY hotel_id, máy sẽ gộp tất cả các 
-- dòng có cùng mã khách sạn vào làm một. Lúc này, cột 
-- price_per_night được đưa vào hàm MIN(), máy tính toán ra được một con số 
-- duy nhất (giá rẻ nhất) — điều này rất rõ ràng.
-- Vấn đề với room_name: Một khách sạn có nhiều phòng (Phòng VIP, Phòng Đơn,
--  Phòng Đôi...). Khi máy gộp 10 dòng phòng vào thành 1 dòng khách sạn duy nhất, nhưng 
--  cậu lại yêu cầu hiện room_name (mà không có hàm gộp nào), máy sẽ bối rối: "Trong 10 
--  cái tên phòng này, tôi phải lấy cái tên nào để hiển thị?".
-- Kết luận: MySQL 8.0 ở chế độ Strict Mode cấm việc chọn một cột không nằm trong GROUP BY 
-- và cũng không nằm trong hàm tính toán (MIN, MAX, SUM...), vì nó không thể tự quyết 
-- định lấy giá trị nào đại diện cho nhóm đó.
