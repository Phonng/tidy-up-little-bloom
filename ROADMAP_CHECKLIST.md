# Little Bloom — checklist triển khai từng phần

Checklist này là bảng theo dõi công việc của project. Mỗi phần sẽ được xử lý riêng; chỉ chuyển sang phần tiếp theo sau khi phần hiện tại hoàn tất hoặc có vướng mắc được ghi rõ.

Tài liệu sản phẩm chuẩn là [`PRODUCT_SPEC.md`](PRODUCT_SPEC.md). Các quyết định scope và acceptance criteria cần theo tài liệu này trước khi mở rộng prototype.

## Trạng thái nhanh

| Phần | Hạng mục | Trạng thái |
|---|---|---|
| 1 | Nền project, phòng blockout, điều khiển FPS và cảm ứng | Đã dựng; cần mở trong Godot để xác nhận trực quan |
| 2 | Vòng chơi nhặt, mang và phân loại hoa | Đã bổ sung; còn SFX và kiểm tra trong Godot/Android |
| 3 | Save/load an toàn, Continue và reset | Đã gia cố lưu/phục hồi; còn UI reset và xác minh trên máy |
| 4 | Menu, pause, cài đặt và hướng dẫn người chơi | Luồng và onboarding đã có; còn xác minh UI trên thiết bị |
| 5 | Art pass và quản lý license asset | Hoa/giỏ/props đầu tiên đã tự dựng; còn credits và kiểm tra hình ảnh |
| 6 | Tối ưu và đóng gói Android | Phiên bản/requirements đã ghi; build và đo máy còn chờ |
| 7 | Kiểm thử người chơi, Google Play và phát hành | Chưa làm |

## Phần 1 — Nền project và điều khiển

- [x] Tạo project Godot 4, main scene và cấu trúc scripts.
- [x] Dựng phòng blockout bằng hình khối, có collision cho tường/sàn/quầy/kệ.
- [x] Thêm FPS player, camera, WASD/phím mũi tên và chuột.
- [x] Thêm joystick cảm ứng có hiển thị, vùng vuốt camera và nút tương tác.
- [x] Sửa collision để người chơi va vào giỏ nhưng camera vẫn raycast trúng giỏ/hoa.
- [x] Cập nhật README và checklist chơi thử.
- [ ] Mở project bằng Godot 4 và xử lý mọi lỗi import/parser nếu có.
- [ ] Chạy một vòng thử trên desktop và một điện thoại Android thật.

**Kết quả cần đạt:** project mở được; người chơi đi/nhìn thoải mái; joystick không cản nút; có thể nhắm trúng hoa và giỏ.

**Ghi chú môi trường:** chưa có executable Godot trong môi trường làm việc này, nên phần chạy thực tế còn chờ mở bằng Godot trên máy của bạn.

## Phần 2 — Vòng chơi cốt lõi

- [x] Logic nhặt hoa, giới hạn mang 5 bông và phản hồi khi tay đầy.
- [x] Giỏ chỉ nhận đúng loại; sai loại không làm mất hoa.
- [x] Biểu diễn các bông đang cầm bằng model màu tương ứng và đếm theo loại trong HUD.
- [x] Hiển thị tiến độ từng loại và tổng tiến độ.
- [x] Hiển thị các bông đã đặt ở trong giỏ.
- [x] Hoàn thành 30/30 thì hiện màn hoàn thành và cho chơi lại.
- [x] Có phản hồi trực quan khi tay đầy, chọn sai giỏ, tăng tiến độ và hoàn thành.
- [ ] Thêm/điều chỉnh SFX nhặt, đặt đúng, đặt sai và hoàn thành trong audio polish.
- [ ] Mở project bằng Godot và kiểm tra trọn vòng chơi trên desktop/Android.

**Kết quả cần đạt:** người mới có thể hoàn thành một lượt 30 bông mà không cần debug hoặc giải thích miệng.

## Phần 3 — Lưu tiến độ

- [x] Lưu sau mỗi lần nhặt/đặt và khi ứng dụng vào nền/đóng game.
- [x] Phục hồi inventory và hoa đã đặt sau khi thoát/mở lại.
- [x] Chặn ID trùng, ID lạ, dữ liệu vượt số lượng mục tiêu và file save sai cấu trúc.
- [x] Ghi save tạm, giữ bản dự phòng trong lúc thay file và phục hồi bản dự phòng nếu cần.
- [ ] Thêm reset tiến độ có hộp xác nhận.
- [x] Đặt schema version và từ chối cấu trúc/schema không hợp lệ.
- [ ] Xác minh thoát đột ngột và phục hồi save trên desktop/Android.

**Kết quả cần đạt:** thoát đột ngột không làm mất tiến độ đã lưu; save lỗi không làm game crash.

## Phần 4 — UI và trải nghiệm người chơi

- [x] Màn hình title: Chơi mới / Tiếp tục / Cài đặt.
- [x] Pause menu có tiếp tục, cài đặt, xóa tiến độ và về menu.
- [x] Màn hình hoàn thành có chơi lại.
- [x] Có hộp xác nhận trước khi xóa tiến độ.
- [x] Lưu độ nhạy nhìn, đảo trục Y, âm lượng nhạc và hiệu ứng vào cấu hình cục bộ.
- [x] Hướng dẫn 3 bước lần đầu trong level, có nút bỏ qua và lưu lựa chọn.
- [ ] Kết nối audio bus với nhạc/SFX thực tế khi có audio asset.
- [ ] Kiểm tra chữ, safe area và kích thước nút trên điện thoại nhỏ.

## Phần 5 — Art pass và giấy phép

- [x] Chốt bảng màu, tỷ lệ và quy tắc phong cách trong tài liệu sản phẩm.
- [x] Chọn hướng dùng model tự dựng trong Godot cho prototype; chưa thêm asset bên thứ ba.
- [x] Tạo silhouette hoa hồng, tulip, cúc và giỏ có nhãn/hoa hiển thị.
- [x] Thêm cửa sổ, cây chậu và thảm chào trong blockout tiệm.
- [x] Ghi trạng thái không dùng asset bên thứ ba trong `ASSET_LEDGER.md`.
- [ ] Thay hoặc hoàn thiện các props blockout còn lại.
- [x] Thêm credits/license Godot trong menu game; asset ledger hiện không có asset bên thứ ba.
- [ ] Kiểm tra art pass trực quan trong Godot trên màn hình ngang.

**Không đưa asset vào build nếu chưa xác minh quyền dùng thương mại và attribution.**

## Phần 6 — Android và hiệu năng

- [x] Chọn baseline Godot 4.7.2 stable theo release archive ngày 17/11/2026; ghi trong `ANDROID_RELEASE_GUIDE.md`.
- [ ] Cấu hình Android SDK/JDK và export preset.
- [x] Bật landscape; thêm icon project vector gốc.
- [ ] Hoàn thiện launcher icon sizes, safe area, multi-touch và resume trên Android thật.
- [ ] Đặt target SDK 36 hoặc cao hơn, rồi xác nhận manifest theo yêu cầu Play hiện hành.
- [ ] Đo FPS/tải/nhiệt trên máy yếu và máy tầm trung.
- [ ] Tối ưu ánh sáng, texture, material, collision theo số đo.
- [ ] Xuất AAB release và cất signing key an toàn ngoài repo.

## Phần 7 — QA và phát hành

- [ ] Hoàn thành checklist manual trong `tests_manual/first_playable.md`.
- [ ] Thu feedback từ người chơi chưa biết project.
- [ ] Chuẩn bị icon, screenshots, mô tả, content rating và khai báo dữ liệu.
- [ ] Tạo internal test rồi closed test.
- [ ] Hoàn tất yêu cầu tester/production access đang áp dụng cho tài khoản Play Console.
- [ ] Phát hành staged rollout và theo dõi crash/feedback.

## Quy tắc cập nhật checklist

- Đánh dấu `[x]` khi công việc thực sự hoàn tất; chưa kiểm tra thì không đánh dấu.
- Nếu bị chặn, ghi lý do ngay dưới phần tương ứng.
- Giữ mỗi phần đủ nhỏ để có kết quả chạy được trước khi mở rộng phạm vi.
