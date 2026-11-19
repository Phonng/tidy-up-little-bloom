# Little Bloom — kế hoạch demo một cửa hàng

Cập nhật: 19/11/2026. Tài liệu sản phẩm chuẩn: [PRODUCT_SPEC.md](PRODUCT_SPEC.md).

## Quyết định và trạng thái

- Người dùng chọn làm một cửa hàng demo trước, ưu tiên vòng chơi dễ hiểu và giỏ đầu trong 2–3 phút.
- Người dùng xác nhận giữ 9 loại hoa hiện có trong demo; đổi loài để sau.
- Giữ cửa hàng hai tầng đã dựng. Đi lên và xuống cầu thang là điều kiện bắt buộc trước khi mở rộng nội dung.
- Mốc cân chỉnh đề xuất: **90 bông, 10 bông mỗi loại**, 9 giỏ, mang tối đa 5 bông. Đây là thiết kế đích chưa triển khai; code hiện vẫn có 504 bông, 56 mỗi loại.
- Cấu hình 504 bông sẽ dùng để thử tải khi đã tách cấu hình level. Không cần hoàn thành 504 bông để chứng minh demo dễ hiểu.
- Không áp lịch 18 tuần của bản Claude vào demo. Các mốc dưới đây hoàn thành theo tiêu chí, sau đó mới ước lượng lịch bản đầy đủ.

## Nội dung demo

Một cửa hàng, hai tầng, một lượt dọn hoàn chỉnh: vào menu → bắt đầu → học thao tác qua giỏ đầu → khám phá phần còn lại → hoàn thành → thoát/tiếp tục/chơi lại.

| ID hiện tại | Tên trong demo | Số lượng thiết kế |
|---|---|---:|
| rose | Hoa hồng | 10 |
| tulip | Hoa tulip | 10 |
| daisy | Hoa cúc | 10 |
| sunflower | Hoa hướng dương | 10 |
| lavender | Hoa oải hương | 10 |
| peony | Hoa mẫu đơn | 10 |
| orchid | Hoa lan | 10 |
| lily | Hoa ly | 10 |
| cosmos | Hoa sao nhái | 10 |

Đây là danh sách hoa của demo, không quảng bá như bộ 9 loài bản địa Việt Nam. Mô hình hai bàn tay đã bỏ theo yêu cầu người dùng.

## Giỏ mở đầu: mục tiêu 2–3 phút

- Chọn giỏ hoa hồng làm giỏ hướng dẫn, đủ 10 bông để hoàn thành trong hai chuyến mang tối đa 5 bông.
- Đặt người chơi tại một khoảng sàn phẳng cạnh cửa vào, nhìn thấy giỏ và vài bông đầu tiên. Không xuất phát dưới hoặc bên trong collider cầu thang.
- Rải 10 bông hồng không theo hàng, trong khu vực khoảng 4 × 4 m gần giỏ. Khoảng đi bộ từ các bông đến giỏ khoảng 1–3 m; không bắt leo tầng hoặc tìm sau đồ nội thất.
- Các loại khác bố trí ngoài cụm mở đầu, vẫn có thể khám phá tự do; không khóa người chơi vào tutorial.
- Chỉ dẫn ngắn theo hành động: nhìn hoa → nhặt → đặt đúng giỏ. Khi ngắm, hiện tên phía trên và hiệu ứng sáng/viền nhẹ; khi nhìn giỏ, hiện loại hoa cần đặt.
- Giỏ hoàn thành có phản hồi rõ và lưu ngay. Không chèn đồng hồ đếm ngược, thời gian chờ hoặc thao tác bắt buộc để kéo dài phiên chơi.
- Sau giỏ đầu, 80 bông còn lại rải cả hai tầng và trên mặt tủ trong tầm tương tác. Không bắt buộc chia đều số lượng mỗi tầng; ưu tiên đường đi và khả năng nhặt.

### Tiêu chí chấp nhận giỏ đầu

- [ ] Thử với 5 người chưa biết game, bắt đầu từ lượt chơi mới và không hướng dẫn bằng lời ngoài game.
- [ ] Ghi thời gian từ lúc điều khiển được nhân vật đến khi giỏ hồng đủ 10/10; tính cả thời gian tutorial trong game.
- [ ] Ít nhất 4/5 người hoàn thành trong tối đa 3 phút; mốc thiết kế 2–3 phút. Người hoàn thành nhanh hơn không bị coi là lỗi.
- [ ] Người thử hiểu nhặt, giới hạn mang và đặt đúng giỏ; không bị kẹt hoặc phải lên tầng hai.
- [ ] Ghi riêng thời gian, số lần đặt sai, số lần đầy inventory và chỗ người chơi cần trợ giúp.

## Công việc triển khai theo thứ tự

| Mốc | Công việc | Điều kiện chuyển mốc |
|---|---|---|
| D0 — Đi lại | Xác minh cầu thang hai chiều, chân/đầu thang, lan can, điểm xuất phát; sửa lỗi mắc kẹt | Lên/xuống 5 lượt liên tiếp và tiếp cận được cả 9 giỏ; mở project không lỗi script |
| D1 — Cấu hình demo | Tách dữ liệu level: ID, seed, mục tiêu từng loại, vị trí giỏ, vùng rải hoa; tạo demo 90 và cấu hình thử tải 504 | Tổng mục tiêu khớp tổng ID; từng profile lưu riêng, không thay hằng số rồi làm mất ID của save cũ |
| D2 — Giỏ đầu | Dựng cụm 10 hoa hồng, giỏ gần cửa, hướng dẫn ngắn và phản hồi hoàn thành giỏ | Đạt tiêu chí thử với 5 người ở trên |
| D3 — Cửa hàng hoàn chỉnh | 80 bông còn lại, tương tác/nhãn focus, tủ và hai tầng, kết thúc 90/90 | Nhặt được mọi bông, không xuyên tường; mất focus/nhặt xong thì ẩn nhãn; hoàn thành và chơi lại được |
| D4 — Android demo | Cấu hình SDK, build cài máy thật, kiểm tra cảm ứng, pause/resume, save/load, đo tải/FPS | Chơi được cả vòng trên Android, không mất save; hướng tới ≥30 FPS ổn định trên thiết bị baseline đã ghi nhận |

Các mục trên là công việc còn phải làm. Việc Godot parse được script chưa chứng minh lên/xuống cầu thang hoặc vòng chơi đã hoạt động đúng.

## Save và kiến trúc khi tách demo

- Thêm `level_id` và `layout_version` vào dữ liệu level/save. Nạp mục tiêu theo cấu hình level, tính tổng từ mục tiêu từng loại.
- File save của demo tách khỏi file prototype hiện tại. Giữ nguyên bản save 504 cũ và ghi rõ profile tương ứng.
- Save schema cũ được nhận là profile prototype 504; không đọc bằng giới hạn 10 bông rồi loại bỏ ID lớn hơn 10.
- Nếu cần chuyển tiến độ sang demo, phải có quy tắc chuyển riêng, bản sao lưu và lựa chọn của người chơi; demo mới không tự ghi đè save cũ.
- Sinh vị trí với seed cố định trong một phiên bản layout để Continue không làm các bông còn lại đổi chỗ.
- Giữ ID hoa ổn định giữa nhặt, inventory, giỏ và save. Geometry/nhãn/hiệu ứng là phần hiển thị.
- Dùng chung một đối tượng highlight và nhãn cho bông đang ngắm, không tạo hàng trăm nhãn chạy animation đồng thời.

## Đổi loài sau demo

Giữ roster hiện tại trong demo là quyết định đã xác nhận. Khi mở việc đổi loài:

- [ ] Chốt danh sách 9 loài và tên hiển thị; không tự suy diễn từ cụm “hoa Việt”.
- [ ] Làm model/silhouette, màu, nhãn giỏ và hình hoa đang mang tương ứng; kiểm tra giấy phép asset cụ thể.
- [ ] Lập bảng ánh xạ ID cũ sang mới hoặc tạo level/version mới; không chỉ đổi chữ khiến save mang sai loại.
- [ ] Kiểm tra đủ số lượng, tiến độ, inventory, Continue và Credits sau chuyển đổi.

## Backlog sau demo

Các phần mở rộng của bản Claude chưa phải yêu cầu bản demo: đổi roster hoa, chạm trực tiếp vào vật thể thay cho tâm ngắm, bản đồ giỏ, nâng sức chứa 8–10, tùy chỉnh màu giỏ, 10–15 ghi chú/song ngữ, biển Open và ánh sáng kết màn, chế độ chụp ảnh, thêm nhạc, trang trí nâng cao, bình/bó hoa, nội dung theo lễ, quảng cáo, UMP, billing/gỡ quảng cáo, analytics.

Play Console, tuyển tester production, listing và phát hành thương mại được lập lịch sau demo. Tài liệu release đang có là tài liệu tham khảo; chính sách, plugin, giấy phép và thông tin nguồn trong bản Claude cần kiểm tra lại từ nguồn chính thức trước khi áp dụng.
