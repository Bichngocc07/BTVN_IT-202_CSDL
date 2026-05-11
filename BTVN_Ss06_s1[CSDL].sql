CREATE TABLE btvn_Ss06;
USE btvn_Ss06;
SELECT 
    city, 
    SUM(total_price) AS revenue
FROM 
    Bookings
WHERE 
    status = 'COMPLETED'
GROUP BY 
    city
HAVING 
    SUM(total_price) > 0; 
    
-- 1. Phân tích lỗi: Tại sao Database Engine từ chối?
-- Nguyên nhân cốt lõi nằm ở việc bạn Fresher đã đặt hàm SUM(total_price) > 0 vào mệnh 
-- đề WHERE.
-- Dưới góc độ kiến trúc, SQL thực thi theo thứ tự sau:
-- FROM: Xác định bảng.
-- WHERE: Lọc từng dòng dữ liệu thô (Raw data). Tại thời điểm này, máy chưa hề 
-- tính toán tổng (SUM) hay gom nhóm (GROUP BY).
-- GROUP BY: Gom các dòng đã lọc vào từng nhóm (Thành phố).
-- HAVING: Lọc các nhóm sau khi đã tính toán xong.
-- SELECT: Trả về kết quả.
-- Lỗi logic: Bạn không thể yêu cầu máy lọc cái "Tổng" (SUM) khi mà nó còn chưa 
-- kịp gom nhóm để tính ra cái tổng đó. Mệnh 
-- đề WHERE chỉ hiểu các điều kiện của từng dòng đơn lẻ, nó không hiểu "tổng" là gì.
