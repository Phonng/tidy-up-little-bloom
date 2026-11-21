# Little Bloom — kế hoạch demo một cửa hàng

Cập nhật: 21/11/2026. Tài liệu sản phẩm chuẩn: [PRODUCT_SPEC.md](PRODUCT_SPEC.md).

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

## Đối chiếu bản Claude v2 — 21/11/2026

Lưu nguyên văn [bản nguồn v2 ngày 19/11/2026](docs/reference/CLAUDE_PLAN_V2_2026-11-19.txt) để tra cứu mã task. Đây là tài liệu tham khảo; các prompt và quy tắc giao việc trong mục 12 của bản nguồn không tự thay thế hướng dẫn của người dùng hay quy tắc repo. Phần đối chiếu này ghi nội dung được đưa vào kế hoạch demo, không xác nhận đã triển khai hoặc kiểm thử.

### Bổ sung vào cách triển khai demo

Trước D0, kiểm kê code và ghi số liệu nền; không cần tạo tài khoản quảng cáo để bắt đầu. Từng task ghi rõ file thay đổi, cách kiểm tra và bằng chứng còn thiếu. Chỉ đánh dấu hoàn thành khi tiêu chí tương ứng đã đạt; kiểm tra script không thay thế thao tác trên thiết bị.

| Task nguồn | Áp dụng vào demo | Bằng chứng cần có |
|---|---|---|
| T0.1 | Viết `docs/ARCHITECTURE.md` từ repo thực tế: scene, autoload, input, save, ID hoa/giỏ, mesh và trách nhiệm script | Đường dẫn code và danh sách 9 loài khớp thực tế; phân biệt hiện trạng với thiết kế demo |
| T0.3–T0.4 | Ghi thiết bị và số đo nền trong `docs/DEVICES.md`, `docs/BASELINE.md` | Commit/build, profile 504 hoặc 90, máy/Android/RAM, FPS theo tầng, thời gian một giỏ và số chuyến; chưa đo thì ghi chưa đo |
| T0.6 | Theo dõi lỗi trong `docs/KNOWN_ISSUES.md` | Bước tái hiện, kết quả mong đợi/thực tế, mức độ và trạng thái; cầu thang chưa được đóng lỗi khi chưa thử |
| T1.1 → D0 | Xác định nguyên nhân trước khi sửa cầu thang; thử cả hai chiều, đầu/chân thang, tay trống và mang 5 bông | D0 vẫn cần 5 vòng liên tiếp; bài thử mở rộng 50 vòng bằng bàn phím và 50 vòng bằng joystick trước khi chốt độ ổn định Android |
| T1.3–T1.4 → D1/D4 | Bảo toàn save cũ, kiểm tra lưu khi vào nền và phục hồi sau đóng app | Ít nhất 3 mẫu: save prototype 504, save demo đang mang hoa, save chính hỏng có bản dự phòng; không mất hoặc trùng ID |
| T2.1/T2.8 → D4 | Kiểm tra joystick và vuốt nhìn cùng lúc trên 2 điện thoại | Ghi máy/build; chơi 10 phút, không kẹt ngón hoặc xung đột vùng chạm; thử Home, khóa màn hình và quay lại |
| T2.2/T2.6 → D2/D3 | Kiểm tra nhặt trong tầm, che khuất và đo giỏ mở đầu | Không nhặt xuyên tường/tầng; ghi thời gian từng người mới theo tiêu chí demo hiện tại |
| T4.7–T4.8 → D4 | Đo hiệu năng trước/sau thay đổi; kiểm kê tài sản thực sự được đóng gói | Cùng máy/cảnh/profile, đo sau 10 phút; mục tiêu ≥30 FPS trên máy baseline; asset nhập mới có nguồn và giấy phép đã kiểm tra |

Các file `docs/ARCHITECTURE.md`, `docs/DEVICES.md`, `docs/BASELINE.md` và `docs/KNOWN_ISSUES.md` ở bảng trên là đầu ra còn phải tạo, không phải báo cáo đã có. Số hoa phải bảo toàn theo **tổng của profile đang chơi**: trên sàn + đang mang + trong giỏ = 90 cho demo hoặc 504 cho thử tải, đồng thời từng ID chỉ thuộc một trạng thái.

### Những khác biệt chưa đổi thành yêu cầu demo

| Bản nguồn v2 | Quyết định đang dùng |
|---|---|
| Giỏ đầu 6–8 bông, 5/5 người hoàn thành trong 3 phút | Giữ mốc thiết kế 10 bông, 4/5 người trong tối đa 3 phút; ghi cả 5 kết quả. Chỉ cân chỉnh số hoa sau khi có số đo, rồi cập nhật tổng/ID/save cùng nhau |
| Giữ 504 bông trong nhiều tiêu chí | Code hiện là 504; demo dự kiến 90. Không đổi số lượng trong code ở lần cập nhật tài liệu này |
| M1 yêu cầu lưu cả vị trí nhân vật; T1.2 có nút thoát kẹt và hoa rơi tự phục hồi | Demo bảo toàn tiến độ/inventory và điểm xuất phát an toàn; lưu vị trí chính xác, nút thoát kẹt và mô phỏng hoa rơi là mở rộng cần đánh giá riêng |
| Chạm trực tiếp hoa/giỏ, bản đồ giỏ, song ngữ, biển Open | Backlog sau demo; chưa thay cơ chế ngắm rồi tương tác hoặc màn hoàn thành hiện tại |
| Quảng cáo cơ bản ở M5; thử plugin ở M2; gỡ quảng cáo có điều kiện G2 | Ghi nhận hướng thương mại của bản nguồn; không đưa SDK quảng cáo, UMP, billing hay việc tạo tài khoản vào demo |
| Lịch 18 tuần, 15–20 giờ/tuần, phát hành tháng 3/2027 | Là lịch tham khảo cho bản đầy đủ, chưa phải lịch cam kết của dự án |

### Điểm cần xử lý khi mở kế hoạch bản đầy đủ

- Mục 3 chuyển bó hoa/cắm bình ra sau 1.1, nhưng mục 8 lại đưa chúng vào 1.1. Dùng backlog chưa xếp lịch cho đến khi chốt phạm vi bản đầy đủ.
- Mục 6 đặt thử plugin cuối M2 (tuần 6), trong khi bảng rủi ro còn ghi T4. Chọn một lịch thống nhất khi thực sự mở task plugin.
- Định nghĩa quảng cáo theo giỏ hay mốc 10% chưa thống nhất với T5.2 chỉ nghe `basket_completed`; phải chốt theo số đo rồi mới thiết kế tín hiệu.
- Tín hiệu hoàn thành giỏ cần phân biệt chuyển từ chưa đầy sang đầy với phục hồi save: tải lại không phát sự kiện thưởng/quảng cáo lần nữa; lượt chơi mới phải có thể hoàn thành lại.
- Mọi thông tin Google Play, plugin, giá, quyền dùng asset trong bản nguồn là thông tin chưa được kiểm chứng ở lần cập nhật này. Trước khi áp dụng, đối chiếu nguồn chính thức và ghi URL/ngày kiểm tra; không dùng nhãn “nguồn đã kiểm tra” của tài liệu làm bằng chứng cấp phép.
