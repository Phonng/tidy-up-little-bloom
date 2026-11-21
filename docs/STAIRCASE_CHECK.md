# D0 — kiểm tra và sửa chuyển động cầu thang

Ngày: 21/11/2026. Bản trước: `7deb072`. Bản sau: thay đổi D0 trong `scripts/player.gd` và `scripts/main.gd` đi kèm báo cáo này. Godot `4.7.2.stable.official.ed1daf0bf`, macOS, headless, fixed FPS 60. Ma trận 140 vòng chạy headless. Kiểm tra hình ảnh và đường đi tới giỏ được chạy riêng trong cửa sổ Godot trên macOS 15.6.1, Apple M1.

## Kết luận

**Chưa tái hiện được kẹt lên/xuống trên bản trước.** Đã tái hiện nhân vật mất tiếp xúc sàn khi đi qua đầu thang; bản trước giữ vận tốc hướng lên, bản sau không còn hiện tượng này trong cùng ma trận thử. LB-001 vẫn chờ xác nhận bằng thao tác thực tế, không đóng toàn bộ lỗi từ kết quả headless.

| Chỉ số | Trước sửa | Sau sửa |
|---|---:|---:|
| Vòng lên/xuống hoàn chỉnh | 140/140 | 140/140 |
| Đoạn đi bổ sung có dừng/đổi hướng giữa dốc | 12/12 | 12/12 |
| Tổng đoạn đi đạt đích | 292/292 | 292/292 |
| Số tick liên tiếp mất tiếp xúc sàn lớn nhất khi đang đi | 19 (~0.32 giây) | 0 |
| Kết quả probe | FAIL tiêu chí bám sàn | PASS |

Probe bản trước kết thúc: `RESULT legs=292 max_air_ticks=19 failures=["Unexpected loss of floor contact: 19 consecutive ticks"]`.

Probe bản sau kết thúc: `RESULT legs=292 max_air_ticks=0 failures=[]`.

## Thay đổi và căn cứ

- `FPSPlayer` chỉ cấp vận tốc ngang; khi đang đứng sàn đặt `velocity.y = 0`, để `move_and_slide()` xử lý dốc. Bỏ phép chiếu rồi normalize velocity lên normal sàn vốn tạo thành phần vận tốc hướng lên khi leo.
- Giữ floor snap 0.8, góc sàn tối đa 40° và margin 0.02; đặt chúng thành hằng số có tên để dễ kiểm tra.
- Spawn chuyển từ `(0, 0, 9)` ngay chân dốc sang `(0, 0.05, 9.8)` trên khoảng sàn phẳng phía trước dốc. Không đổi geometry/collision cầu thang, số hoa, ID hoặc định dạng save.
- Đối chiếu [CharacterBody3D: floor_snap_length, floor_constant_speed và move_and_slide](https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html) ngày 21/11/2026: vận tốc hướng lên ngăn tự snap. Kết quả thực tế của engine 4.7.2 ở bảng trên là bằng chứng cho thay đổi này.

## Ma trận tự động

Dùng phòng, player, giỏ, 504 hoa và HUD thực tế; không thay collider hoặc bỏ đồ vật để làm bài thử đạt.

- Mỗi kiểu input: 50 vòng liên tục ở giữa thang, 10 vòng sát trái x = -1.45 và 10 vòng sát phải x = 1.45.
- Hai kiểu input: `Input.action_press("ui_up")` cho đường xử lý phím mũi tên; `InputEventScreenTouch/ScreenDrag` đưa trực tiếp vào handler TouchControls cho đường xử lý joystick. Nhân vật quay 180° để đi xuống bằng input tiến.
- Nửa đầu mỗi nhóm để inventory trống, nửa sau gán 5 ID hợp lệ trong bộ nhớ QA và cập nhật hình đang cầm. Không gọi nhặt/đặt hay sửa save cá nhân trong probe này.
- Mỗi kiểu input thêm 6 đoạn dừng/đổi hướng ở giữa dốc và đầu/chân thang; tổng 12 đoạn. Mỗi đoạn giới hạn 600 tick, thất bại nếu đứng yên 60 tick khi vẫn đang yêu cầu đi, hoặc ra ngoài khoảng cao độ kiểm tra.
- Chỉ chuyển vị trí trực tiếp khi thiết lập nhóm thử; các vòng lên/xuống trong nhóm đi liên tục bằng controller thật.

## Chạy lại

Tại thư mục project:

```sh
python3 tools/check_stairs.py
```

Nếu Godot ở nơi khác:

```sh
python3 tools/check_stairs.py --godot /duong/dan/toi/Godot
```

Runner tạo bản sao tạm, thay đường dẫn save/settings **chỉ trong bản sao**, import asset rồi chạy probe. Console in đường dẫn bản sao và log để xem lại. Không thêm framework test. File probe lưu dạng `.gd.txt`, chỉ chuyển thành script trong bản QA, không gắn vào scene game.

Đã chạy runner được lưu trong repo thành công. Cả trước và sau đều có lỗi môi trường macOS `get_system_ca_certificates`; lúc import còn có lỗi không ghi được editor settings ngoài workspace. Không có `SCRIPT ERROR`/`Parse Error` trong các lượt này. Không diễn giải kết quả thành “Output hoàn toàn không có lỗi”.

## Kiểm tra trong cửa sổ Godot trên Mac

Bản QA dùng renderer Compatibility ở 960 × 540. Hai ảnh chụp từ camera tại chân và đầu thang đều hiển thị bậc, lan can, hoa và HUD. Một lượt chạy dùng lệnh điều khiển mô phỏng đã đi qua cả hai tầng, ngắm đúng **9/9 giỏ** bằng ray của player và quay về tầng trệt. Kết quả log là `ROUTES PASS 9/9`. Lượt này dùng dữ liệu QA riêng.

## Phần còn phải xác minh

- [ ] Chạy GUI trên máy người dùng: lên/xuống 5 vòng, dừng/quay đầu, sát lan can và tay trống/đầy; ghi vị trí nếu còn kẹt.
- [x] Đi lại và tiếp cận đủ 9 giỏ bằng lượt chạy mô phỏng trong cửa sổ Godot.
- [x] Quan sát ảnh ở chân và đầu thang trong cửa sổ Godot.
- [ ] Thử cảm giác điều khiển và chuyển tiếp giữa bậc với sàn bằng tay.
- [ ] Thử bàn phím trên desktop và joystick trên Android thật theo ma trận trong DEMO_PLAN.

LB-005 màn trắng không tái hiện trên bản QA Mac. Kiểm tra trong cửa sổ Godot kích hoạt hai nút từ menu. Chơi mới và Tiếp tục đều dựng cảnh và camera. Tiếp tục giữ đúng một bông mẫu đang mang khi quay lại từ menu trong cùng phiên. ENV-001 Android build-tools vẫn chờ kiểm tra ở mốc Android.
