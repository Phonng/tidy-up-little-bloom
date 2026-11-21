# Little Bloom — checklist triển khai từng phần

Checklist này là bảng theo dõi công việc của project. Mỗi phần sẽ được xử lý riêng; chỉ chuyển sang phần tiếp theo sau khi phần hiện tại hoàn tất hoặc có vướng mắc được ghi rõ.

Tài liệu sản phẩm chuẩn là [`PRODUCT_SPEC.md`](PRODUCT_SPEC.md). Các quyết định scope và acceptance criteria cần theo tài liệu này trước khi mở rộng prototype.

## Ưu tiên demo từ 19/11/2026

Các dấu hoàn thành dưới đây ghi nhận code prototype hiện có, không chứng nhận bản demo đã đạt. Code có demo 90 bông, khu hoa hồng mở đầu và thử tải 504 bông. Xem [DEMO_PLAN.md](DEMO_PLAN.md).

- [ ] D0: Đã sửa mất bám sàn và chuyển spawn ra sàn phẳng; [probe trước/sau](docs/STAIRCASE_CHECK.md) đạt 140 vòng, 0 tick mất bám sau sửa. Bản có cửa sổ trên Mac hiển thị hai đầu thang và đi tới 9/9 giỏ bằng điều khiển mô phỏng. Còn thử bằng tay và trên Android.
- [x] D1: Tách demo 90 bông và thử tải 504 bông trong menu. Đã kiểm tra cả hai tổng, resume, khôi phục save demo và bảo toàn save 504 cũ trên bản sao.
- [x] D2 triển khai: Giỏ hồng gần cửa, 10 bông ở tầng trệt, chỉ dẫn trong lúc chơi và phản hồi 10/10. Bản QA qua hai chuyến, nạp được save demo 1 và giữ nguyên save 504.
- [ ] D2 đo với người mới: Ghi thời gian của 5 người chưa biết game, mục tiêu ít nhất 4/5 xong giỏ trong tối đa 3 phút.
- [ ] D3: Hoàn thiện 9 loại hoa, 9 giỏ, hoa rải tự nhiên và trên mặt tủ; nhãn tên/hiệu ứng focus.
- [ ] D4: Chạy demo Android thật, kiểm tra cảm ứng, lưu/phục hồi và hiệu năng.
- [ ] Chỉ mở backlog sau demo khi các tiêu chí demo đã đạt.

## Bổ sung từ bản Claude v2 — 21/11/2026

Xem [bảng đối chiếu và tiêu chí](DEMO_PLAN.md#đối-chiếu-bản-claude-v2--21112026). Các mục dưới đây chưa thực hiện; T là mã nguồn tham khảo, D là mốc demo đang áp dụng.

- [x] Lưu bản nguồn v2 và đối chiếu với phạm vi demo; giữ riêng các đề xuất sau demo.
- [x] T0.1 — soạn tài liệu: Đã viết [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) từ 10 script và 2 scene tại mốc code `6fc071c`; kiểm tra tĩnh, không sửa hoặc chạy game.
- [ ] T0.1 — duyệt hiện trạng: Chủ dự án đọc tài liệu kiến trúc và xác nhận; chưa có xác nhận, chưa coi toàn bộ cổng T0.1 đã được duyệt.
- [x] T0.6: Đã lập [docs/KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md): mức độ, bằng chứng, kịch bản và tiêu chí đóng; LB-001 cầu thang ưu tiên D0. Đã sửa checklist test lỗi thời; chưa sửa hoặc đóng lỗi gameplay.
- [ ] T0.3–T0.4: Ghi `docs/DEVICES.md` và `docs/BASELINE.md`; đo FPS, thời gian giỏ và số chuyến trên build/profile xác định.
- [ ] T1.1: Sau kiểm tra nhanh D0, thử mở rộng 50 vòng lên/xuống bằng mỗi kiểu điều khiển, gồm cả khi mang đủ hoa.
- [ ] T1.3–T1.4: Kiểm tra 3 mẫu save và vòng vào nền/đóng/mở lại; bảo toàn ID theo profile.
- [ ] T2.8/T4.7: Ghi kết quả 10 phút trên ít nhất 2 điện thoại; không đánh dấu đạt chỉ dựa trên parse script.

## Trạng thái nhanh

| Phần | Hạng mục | Trạng thái |
|---|---|---|
| 1 | Nền project, phòng blockout, điều khiển FPS và cảm ứng | Đã bỏ tay, cầu thang 20 bậc; D0 sửa bám sàn/spawn, probe đạt, còn thử bằng tay và trên Android |
| 2 | Vòng chơi nhặt, mang và phân loại hoa | Có 9 loại ở cả demo 90 và thử tải 504. Còn thử vòng chơi demo trên thiết bị |
| 3 | Save/load an toàn, Continue và reset | Lưu/phục hồi và hộp xác nhận đã có; còn thử phục hồi và thoát đột ngột |
| 4 | Menu, pause, cài đặt và hướng dẫn người chơi | Luồng, audio và onboarding đã có; còn cân chỉnh UI/âm thanh trên thiết bị |
| 5 | Art pass và quản lý license asset | Props procedural, tiệm hai tầng, tủ áp tường và 9 giỏ phân loại đã thêm; còn review trực quan trong game |
| 6 | Tối ưu và đóng gói Android | Preset/icon/API đã chuẩn bị; Android SDK/JDK, AAB và đo máy còn chờ |
| 7 | Kiểm thử người chơi, Google Play và phát hành | Nội dung listing đã soạn; Play Console, tester và phát hành còn chờ |

## Phần 1 — Nền project và điều khiển

- [x] Tạo project Godot 4, main scene và cấu trúc scripts.
- [x] Dựng phòng blockout bằng hình khối, có collision cho tường/sàn/quầy/kệ.
- [x] Thêm FPS player, camera, WASD/phím mũi tên và chuột.
- [x] Thêm joystick cảm ứng có hiển thị, vùng vuốt camera và nút tương tác.
- [x] Sửa collision để người chơi va vào giỏ nhưng camera vẫn raycast trúng giỏ/hoa.
- [x] Cập nhật README và checklist chơi thử.
- [x] Mở project bằng Godot 4.7.2 headless và sửa lỗi parser phát hiện ở save/load; import asset hoàn tất.
- [ ] Chạy một vòng thử trên desktop và một điện thoại Android thật.

**Kết quả cần đạt:** project mở được; người chơi đi/nhìn thoải mái; joystick không cản nút; có thể nhắm trúng hoa và giỏ.

**Ghi chú kiểm tra:** Godot headless xác nhận menu và level khởi động; chưa kiểm tra trực quan hoặc thao tác tay. Máy chưa có Android SDK/JDK/ADB.

## Phần 2 — Vòng chơi cốt lõi

- [x] Logic nhặt hoa, giới hạn mang 5 bông và phản hồi khi tay đầy.
- [x] Giỏ chỉ nhận đúng loại; sai loại không làm mất hoa.
- [x] Biểu diễn các bông đang cầm bằng model màu tương ứng và đếm theo loại trong HUD.
- [x] Hiển thị tiến độ từng loại và tổng tiến độ.
- [x] Hiển thị các bông đã đặt ở trong giỏ.
- [x] Hoàn thành 504/504 thì hiện màn hoàn thành và cho chơi lại.
- [x] Có phản hồi trực quan khi tay đầy, chọn sai giỏ, tăng tiến độ và hoàn thành.
- [x] Thêm SFX nhặt, đặt đúng, đặt sai và hoàn thành bằng âm tổng hợp gốc; còn nghe/điều chỉnh trong Godot.
- [ ] Mở project bằng Godot và kiểm tra trọn vòng chơi trên desktop/Android.

**Kết quả cần đạt:** người mới phân biệt được 9 loại hoa, đi được cả hai tầng và hoàn thành lượt 504 bông mà không cần debug hoặc giải thích miệng.

## Phần 3 — Lưu tiến độ

- [x] Lưu sau mỗi lần nhặt/đặt và khi ứng dụng vào nền/đóng game.
- [x] Phục hồi inventory và hoa đã đặt sau khi thoát/mở lại.
- [x] Chặn ID trùng, ID lạ, dữ liệu vượt số lượng mục tiêu và file save sai cấu trúc.
- [x] Ghi save tạm, giữ bản dự phòng trong lúc thay file và phục hồi bản dự phòng nếu cần.
- [x] Thêm reset tiến độ có hộp xác nhận.
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
- [ ] Nghe và cân chỉnh mix audio trong Godot; nhạc ambient tổng hợp và bus SFX đã được nối.
- [ ] Kiểm tra chữ, safe area và kích thước nút trên điện thoại nhỏ.

## Phần 5 — Art pass và giấy phép

- [x] Chốt bảng màu, tỷ lệ và quy tắc phong cách trong tài liệu sản phẩm.
- [x] Chọn hướng dùng model tự dựng trong Godot cho prototype; chưa thêm asset bên thứ ba.
- [x] Tạo silhouette hoa hồng, tulip, cúc, hướng dương, oải hương, mẫu đơn, lan, ly, sao nhái và giỏ có nhãn/hoa hiển thị.
- [x] Mở rộng tiệm thành hai tầng, thêm đường dốc nối tầng và tủ áp tường; phân phối 504 hoa cùng 9 giỏ ở cả hai tầng.
- [x] Thêm cửa sổ, cây chậu và thảm chào trong blockout tiệm.
- [x] Ghi trạng thái không dùng asset bên thứ ba trong `ASSET_LEDGER.md`.
- [x] Bổ sung đèn treo emissive, giấy gói/hộp quà trên quầy và bình hoa trưng bày trên kệ bằng mesh tự dựng.
- [x] Thêm credits/license Godot trong menu game; asset ledger hiện không có asset bên thứ ba.
- [ ] Kiểm tra art pass trực quan trong Godot trên màn hình ngang.

**Không đưa asset vào build nếu chưa xác minh quyền dùng thương mại và attribution.**

## Phần 6 — Android và hiệu năng

- [x] Chọn baseline Godot 4.7.2 stable theo release archive ngày 17/11/2026; ghi trong `ANDROID_RELEASE_GUIDE.md`.
- [ ] Cấu hình Android SDK/JDK; preset Android Play đã được thêm.
- [x] Bật landscape; thêm icon project vector gốc.
- [ ] Hoàn thiện safe area, multi-touch và resume trên Android thật. Trạng thái input cảm ứng được xóa khi mở modal hoặc ứng dụng vào nền; còn xác minh hành vi trên thiết bị.
- [x] Thêm launcher icon classic 512×512, adaptive foreground/background và monochrome 512×512 vào preset; Godot tạo các density variant thấp hơn.
- [x] Đặt target SDK 36 trong preset.
- [ ] Xuất AAB và xác nhận manifest thực tế có target SDK 36.
- [ ] Đo FPS/tải/nhiệt trên máy yếu và máy tầm trung.
- [ ] Tối ưu ánh sáng, texture, material, collision theo số đo.
- [ ] Xuất AAB release và cất signing key an toàn ngoài repo.

## Phần 7 — QA và phát hành

- [ ] Hoàn thành checklist manual trong `tests_manual/first_playable.md`.
- [ ] Thu feedback từ người chơi chưa biết project.
- [x] Tạo icon Google Play 512×512, feature graphic 1024×500 và bản nháp mô tả tiếng Việt trong `PLAY_STORE_DRAFT.md`.
- [x] Soạn chính sách quyền riêng tư và thêm mục đọc trong game; còn địa chỉ hỗ trợ và URL HTTPS công khai cho Play Console.
- [ ] Chụp screenshots gameplay thật; hoàn tất content rating và Data safety trong Play Console sau khi xác minh build/dependencies.
- [ ] Tạo internal test rồi closed test.
- [ ] Hoàn tất yêu cầu tester/production access đang áp dụng cho tài khoản Play Console.
- [ ] Phát hành staged rollout và theo dõi crash/feedback.

## Quy tắc cập nhật checklist

- Đánh dấu `[x]` khi công việc thực sự hoàn tất; chưa kiểm tra thì không đánh dấu.
- Nếu bị chặn, ghi lý do ngay dưới phần tương ứng.
- Giữ mỗi phần đủ nhỏ để có kết quả chạy được trước khi mở rộng phạm vi.
