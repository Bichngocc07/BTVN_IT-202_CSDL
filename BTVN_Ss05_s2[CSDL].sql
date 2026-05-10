SELECT restaurant_name, created_at
FROM Restaurants
ORDER BY created_at DESC
LIMIT 5;
-- 1. Phân tích lỗ hổng kiến thức
-- Lỗ hổng: Trong SQL, dữ liệu lưu trữ trong bảng không có thứ tự mặc định vĩnh viễn. Khi 
-- bạn dùng LIMIT 5 mà 
-- không có ORDER BY, hệ quản trị cơ sở dữ liệu (DBMS) sẽ "bốc" ngẫu nhiên 5 dòng mà nó tìm 
-- thấy đầu tiên trong bộ nhớ đệm hoặc trên đĩa.

-- Hệ quả: * Dữ liệu không chính xác: 5 quán lấy ra không phải là 5 quán mới nhất mà
--  là 5 quán "tiện tay" nhất của hệ thống.

-- Dữ liệu không đồng nhất: Mỗi lần refresh, DBMS có thể quét dữ liệu theo các 
-- đường khác nhau, dẫn đến kết quả hiển thị bị thay đổi liên tục, gây trải nghiệm tệ 
-- cho người dùng.