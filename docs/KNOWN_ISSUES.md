# Little Bloom — lỗi đã biết và việc cần xác minh

Cập nhật: 21/11/2026 · T0.6 lập tại `3f16d2a`; bổ sung kết quả D0 so với `7deb072`.

Nguồn: báo cáo người dùng trong cuộc trò chuyện, [kiến trúc hiện tại](ARCHITECTURE.md), code và [checklist chơi thử](../tests_manual/first_playable.md). Khi lập T0.6 chỉ đọc code và tài liệu. D0 đã chạy kiểm thử vật lý riêng cho cầu thang; xem [báo cáo D0](STAIRCASE_CHECK.md). Các kịch bản khác chưa được chạy lại; chưa đo trên điện thoại.

## Cách đọc và đóng lỗi

- **P0:** không vào/chơi hết được vòng chơi, hoặc mất tiến độ; ưu tiên trước mở rộng nội dung.
- **P1:** tương tác/điều khiển sai, ảnh hưởng rõ tới trải nghiệm nhưng chưa chặn toàn bộ vòng chơi.
- **P2:** thông tin hoặc hiển thị sai, ảnh hưởng nhỏ hơn.
- **Đã báo, chờ tái hiện:** người dùng từng gặp; chưa biết bản hiện tại còn lỗi không.
- **Có căn cứ từ code:** xác định được nhánh xử lý có vấn đề; biểu hiện trên thiết bị chưa được kiểm chứng.
- **Đã sửa tài liệu:** chỉ xác nhận nội dung tài liệu đã đổi, không xác nhận game đã đạt.

Mức độ là mức ảnh hưởng nếu lỗi xảy ra, không phải mức chắc chắn lỗi đang xảy ra. Đóng lỗi gameplay cần commit sửa, build/thiết bị, bước thử và kết quả thực tế. Không đóng chỉ vì không còn parse error.

## Danh sách ưu tiên

| ID | Mức | Vấn đề | Bằng chứng / trạng thái | Mốc xử lý |
|---|---|---|---|---|
| LB-001 | P0 | Mắc khi lên hoặc xuống cầu thang | Chưa tái hiện kẹt trong probe, đã sửa mất bám sàn, thử tay và Android còn chờ | D0 / T1.1, ưu tiên đầu |
| LB-002 | P1 | Chọn hoa/giỏ qua vật cản | D3 đã sửa và qua kịch bản che khuất trên Mac | D3 |
| LB-003 | P1 | Ngón chạm mới giành quyền xoay camera | D4 giữ quyền ngón nhìn. Qua thử mô phỏng trên Mac, còn thử multitouch Android | D4 |
| LB-004 | P2 | Tổng hoa trên màn hoàn thành dùng số cũ | D1 dùng tổng của chế độ. Bài thử 89 → 90 cùng phiên và chơi lại đã qua trên bản sao | D1/D4 |
| LB-005 | P0 | Vào màn chơi chỉ thấy nền trống/trắng | Không tái hiện với Chơi mới và Tiếp tục trên bản QA Mac | Kiểm tra đầu D0 nếu còn xảy ra |
| ENV-001 | P0 với kiểm thử Android | Không mở được thư mục Android build-tools | Đã xuất APK debug trong bộ công cụ QA riêng. Môi trường xuất AAB Play còn chờ | D4 / T0.3 |
| DOC-001 | P2 | Checklist còn ghi 600 bông và hai bàn tay | Đã sửa tài liệu trong T0.6; chưa chạy lại checklist | T0.6 |

## LB-001 — Cầu thang lên/xuống bị kẹt

**Bằng chứng:** người dùng từng báo không lên tầng hai, sau đó không xuống được. Commit `3d7147e` đổi hình cầu thang; chưa có báo cáo xác nhận đi hai chiều thành công trên bản này. Không gán các lần báo trước cho một commit cụ thể khi chưa có build tương ứng.

**Nguồn code:** [main.gd](../scripts/main.gd), `_add_ramp()`, `_add_stair_steps()`, `_build_room()`, `_build_player()`; [player.gd](../scripts/player.gd), `_ready()`, `_physics_process()`.

**Kịch bản tái hiện:**

1. Dùng bản QA với dữ liệu lưu riêng; ghi commit, phiên bản Godot, máy và kiểu điều khiển. Vào lượt mới, đóng tutorial.
2. Từ spawn hiện tại `(0, 0.05, 9.8)` (bản trước là `(0, 0, 9)`), đi giữa thang lên tầng hai; dừng, quay lại và đi xuống. Một vòng = lên hoàn toàn rồi xuống sàn trệt.
3. Thử đi sát trái/phải nhưng trong lan can, tiếp cận đầu thang từ tầng hai, dừng/đổi hướng ở chân và đầu thang.
4. Lặp với tay trống và đang mang 5 bông; dùng WASD trước, joystick trên Android sau.
5. Khi kẹt, ghi vị trí, hướng di chuyển, đoạn thang, có rơi/xuyên sàn không, ảnh/video và Output. Khi làm task sửa, xem collision thực tế và ghi `is_on_floor()`, velocity, normal/collider va chạm nếu cần.

**Mong đợi:** đi hai chiều không kẹt, không cần nhảy, không rơi hoặc bật lên; tiếp cận được 9 giỏ. **Kết quả D0:** trước và sau sửa đều hoàn thành 140 vòng tự động, chưa tái hiện kẹt. Trước sửa có 19 tick liên tiếp mất tiếp xúc sàn; sau sửa còn 0. Đã sửa vận tốc dọc, chuyển spawn ra sàn phẳng và xác nhận tiếp cận đủ 9 giỏ trong cửa sổ Godot bằng input mô phỏng. Xem [ma trận và kết quả](STAIRCASE_CHECK.md).

**Giả thuyết cần kiểm chứng, chưa chốt nguyên nhân:** spawn nằm ngay chân dốc; mặt dốc/đầu nối sàn trên hoặc lan can có thể cản capsule; xử lý velocity theo normal và floor snap có thể ảnh hưởng khi chuyển mặt tiếp xúc. Bậc nhìn thấy không có collision riêng, nên đổi hình bậc chưa chứng minh đã sửa đường đi.

**Điều kiện đóng:** D0 đạt 5 vòng liên tiếp, thử các vị trí nêu trên và tay trống/đầy; kiểm thử mở rộng đạt 50 vòng bằng bàn phím và 50 vòng bằng joystick trước khi chốt độ ổn định Android. Ghi kết quả mỗi kiểu điều khiển; chưa thử Android thì chỉ ghi desktop đạt, không đóng toàn bộ yêu cầu Android.

## LB-002 — Tương tác qua vật cản

Trước D3, ray nhắm giỏ chỉ xét lớp tương tác của giỏ, còn hoa được chọn theo vị trí và không có kiểm tra che khuất. D3 giới hạn lựa chọn theo điểm va chạm đầu tiên và kiểm tra đoạn nhìn tới tâm bông. Thân và cánh tủ tham gia chặn ray.

Bản QA trên Mac đã thử hoa và giỏ bị tường che, tâm ngắm lướt cạnh tường, hoa dưới sàn tầng hai và hoa bị thân tủ che từ dưới. Tiến độ giữ nguyên khi thao tác bị chặn. Cùng bông hoa nhìn thấy thì nhặt được và nhãn ẩn ngay. Lượt demo hoàn chỉnh nhặt đủ hoa trên cả hai tầng và trên tủ. [Kết quả D3](../DEMO_PLAN.md#kết-quả-d3).

## LB-003 — Ngón chạm thứ ba làm mất điều khiển nhìn

**Bằng chứng code:** [touch_controls.gd](../scripts/touch_controls.gd), `_input()` nhận touch bên phải và gán `_look_touch = event.index` dù đã có ngón nhìn. Nhả ngón mới đặt `_look_touch = -1`; ngón nhìn ban đầu còn trên màn hình nhưng không còn được nhận drag.

**Kịch bản:** giữ ngón A trên joystick, vuốt nhìn bằng B; giữ B và chạm thêm C vào vùng nhìn bên phải, ngoài nút tương tác/pause; nhả C rồi tiếp tục kéo B. Lặp các thứ tự nhả ngón, thêm pause/resume và Home/quay lại.

**Mong đợi:** ngón nhìn ban đầu giữ quyền cho tới khi nhả hoặc có quy tắc chuyển ngón rõ ràng; không phải nhấc lại B để camera hoạt động. **Thực tế suy ra:** index bị thay thế, sau khi nhả C thì B không còn điều khiển nhìn. Chưa đo trên điện thoại.

**Điều kiện đóng:** các chuỗi touch trên chạy đúng trên ít nhất 2 điện thoại; thao tác hai ngón thông thường, nút tương tác và pause không hồi quy. Lưu model máy/Android/build và thứ tự sự kiện dùng thử.

**Cập nhật D4:** input gameplay dùng ngón giữ nút riêng, bỏ qua ngón nhìn mới khi đã có ngón nhìn. App vào nền và mở tạm dừng đều xóa trạng thái touch và thao tác chờ. Đã qua thử mô phỏng ngón thứ ba, thả hủy, thả ngoài nút và pause/resume trên Mac. [Kịch bản Android](ANDROID_QA.md)

## LB-004 — Màn hoàn thành hiển thị số hoa lúc vào level

**Bằng chứng trước D1:** [touch_controls.gd](../scripts/touch_controls.gd), `_build_completion_overlay()` tạo label cục bộ `summary` và gán số từ `GameState.placed_ids.size()` ngay khi dựng UI. `_show_complete()` chỉ hiện overlay và pause, không cập nhật label.

**Kịch bản:** trong dữ liệu QA riêng, dùng save hợp lệ 503 bông đã đặt và bông cuối trong inventory. Continue, đặt bông cuối vào đúng giỏ. Kiểm tra HUD, nội dung overlay và save; mở lại save hoàn thành để đối chiếu.

**Mong đợi:** thông báo đúng 504 ở thời điểm hoàn thành (sau này lấy tổng profile). **Kết quả suy ra từ code:** trong phiên bắt đầu ở 503, overlay còn ghi 503; nếu bắt đầu từ 0 và chơi hết cùng phiên thì còn ghi 0. Load lại save đã hoàn thành có thể hiển thị đúng vì UI dựng lại, nên chỉ thử Continue save đầy là chưa đủ.

**Điều kiện đóng:** số trên overlay bằng số đã đặt thực tế khi hoàn thành trong cùng phiên; đúng khi load save đầy, chơi lại và với profile demo khi có. Không sửa giới hạn hoa hoặc save chỉ để làm đúng nhãn.

## LB-005 — Màn chơi trống/trắng (báo cáo lịch sử)

**Bằng chứng:** ảnh người dùng từng thấy cửa sổ game chỉ có nền; log từng có parse error `Cannot infer the type of "side_x"` trong `main.gd`. Các sửa trước đã thay khai báo kiểu và sửa thao tác xáo trộn; chưa có kết quả kiểm chứng hiện tại cho triệu chứng này.

**Nguồn điều tra:** [main.gd](../scripts/main.gd), `_ready()` và chuỗi dựng scene; [flower_field.gd](../scripts/flower_field.gd); [project.godot](../project.godot).

**Kịch bản:** mở đúng project trong Editor, vào menu rồi Chơi mới trên dữ liệu QA; nếu trống, ghi thời gian chờ và lấy lỗi đầu tiên ở Output/Debugger kèm các dòng tiếp theo. Kiểm tra scene Remote có player/camera/FlowerField không. Ghi renderer và commit, không đổi số hoa ngay để che triệu chứng.

**Mong đợi:** thấy phòng, HUD, camera hoạt động và thao tác được. **Thực tế hiện tại:** bản QA có cửa sổ hiển thị cảnh và HUD ở hai tầng. Chơi mới và Tiếp tục từ menu đều mở được màn chơi trên bản QA Mac. Chưa có số đo chứng minh do lag, 504 bông, ánh sáng hoặc driver.

**Điều kiện đóng:** menu → level và Continue mở được, không có lỗi script mới trên máy từng gặp; nếu không tái hiện thì ghi build/máy và trạng thái “không tái hiện trên build đã thử”, không tự kết luận mọi máy đã hết.

## ENV-001 — Android build-tools chưa sẵn sàng

**Bằng chứng:** log cũ `Unable to open Android 'build-tools' directory`. Chưa kiểm tra SDK/JDK/ADB của máy hiện tại trong T0.6.

**Kịch bản:** khi mở T0.3/D4, kiểm tra đường dẫn SDK/JDK trong Editor và thử xuất APK debug của đúng commit. Ghi lỗi đầu tiên và phiên bản công cụ. Có preset Android không đồng nghĩa môi trường build đã sẵn sàng.

**Mong đợi:** xuất, cài và mở APK debug trên điện thoại. **Điều kiện đóng:** ghi đường dẫn/cấu hình phù hợp, build thành công và kết quả cài/chạy; không dùng việc menu desktop chạy để đóng lỗi môi trường này. Không xem cảnh báo Android này là bằng chứng gây màn trắng desktop.

## DOC-001 — Checklist kiểm thử lỗi thời

Đã đối chiếu [checklist](../tests_manual/first_playable.md) với code: thay yêu cầu 600 bằng 504, thay kiểm tra bàn tay bằng không có bàn tay, thêm link hồ sơ lỗi và tiêu chí cầu thang/che khuất/multitouch/nhãn hoàn thành. Giữ nguyên các dấu chưa kiểm thử; các dấu đã kiểm thử trước đây chỉ là lịch sử ngày 18/11, không phải kết quả build hiện tại. Trạng thái: **đã sửa tài liệu, kiểm tra diff T0.6**.

## Save và hiệu năng: kiểm chứng bắt buộc, chưa phải lỗi đã tái hiện

| Hạng mục | Căn cứ / kịch bản cần làm | Điều kiện đạt |
|---|---|---|
| Save khi vào nền/đóng app | GameState đã có lưu sau nhặt/đặt và notification; thử khi đang mang 5 bông, Home rồi đóng app, mở lại | Đúng tập inventory và placed IDs, không trùng/mất; trở lại spawn mặc định là hành vi hiện tại, không coi là lỗi mất save |
| Phục hồi save lỗi | Chỉ thử trong bản QA/dữ liệu riêng: save chính sai JSON + `.bak` hợp lệ; thêm tình huống không có backup | Phục hồi mẫu hợp lệ; báo rõ trường hợp không thể phục hồi. `.bak` bị xóa sau lần lưu thành công, không hứa luôn có backup |
| D1 chuyển 504 → 90 | Validator dùng target từng loài; chỉ giảm target sẽ lọc ID >10 khỏi save cũ | Đã có save riêng. Bài thử với save 504 cũ, save demo đang mang hoa và save demo hỏng có backup đều qua. Android còn cần kiểm tra vòng đời app |
| Khả năng lấy đủ mọi hoa | Hoa sàn/tủ sinh bằng tọa độ, chưa có kiểm chứng mọi điểm trong tầm và đường đi | Thử lấy đủ ID trên hai tầng, nhất là hoa trên tủ; nếu có điểm không lấy được thì mở lỗi riêng với ID/tọa độ |
| FPS và thời gian vào level | Có MultiMesh, chưa có số đo nền; không suy ra nguyên nhân từ số lượng hoa | Ghi commit/profile/máy/cảnh, thời gian tải và FPS sau 10 phút; đo lại cùng điều kiện khi tối ưu |

Không mở thêm tính năng quảng cáo, bản đồ giỏ, lưu vị trí hay đổi roster để giải quyết danh sách này. Đó là phạm vi riêng trong kế hoạch sản phẩm.

## Mẫu ghi kết quả và thứ tự tiếp theo

Mỗi lần thử ghi: ID lỗi · ngày · commit/build · profile/số hoa · Godot/renderer · máy/OS · kiểu input · trạng thái save đầu · bước thực tế · mong đợi/thực tế · số lần lỗi/tổng số lần thử · log/ảnh/video · kết luận. Chưa có dữ liệu thì để “chưa thử”, không điền PASS.

1. D0: vào được level; nếu LB-005 tái hiện thì lấy lỗi đầu tiên trước.
2. Tái hiện LB-001 và xác định collider/điểm kẹt, sửa phạm vi nhỏ rồi kiểm tra lại hai chiều.
3. D1: tách cấu hình/save và kiểm chứng bảo toàn ID, trước khi giảm số hoa.
4. D4: kiểm tra LB-003, môi trường Android và số đo thực tế. Chạy lại các ca D3 trên thiết bị.

**Kết quả T0.6:** đã lập danh sách và đồng bộ checklist. **Bổ sung D0:** đã sửa hiện tượng mất bám sàn ở cầu thang, kiểm chứng tự động trước/sau; LB-001 vẫn mở để xác minh điều khiển bằng tay trên desktop và Android.
