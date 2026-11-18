# Little Bloom — kế hoạch triển khai game Android 3D góc nhìn thứ nhất

> **Tài liệu triển khai cho solo developer** · GDD + kế hoạch kỹ thuật · 17/11/2026  
> **Thời lượng:** 16 tuần mục tiêu, tối đa 20 tuần · **Quỹ thời gian:** 15–20 giờ/tuần  
> **Công nghệ:** Godot 4.x + GDScript, Blender, Android · **Định hướng:** offline, cozy low-poly, ưu tiên chạy ổn định trên điện thoại

> Tên **Little Bloom** là tên làm việc. Kiểm tra tên ứng dụng, nhãn hiệu và khả năng dùng tên trên Google Play trước khi chốt.

## 1. Tóm tắt quyết định

- Làm một game 3D góc nhìn thứ nhất, người chơi đi trong tiệm hoa, nhặt hoa và phân loại vào giỏ đúng loại.
- Giữ tinh thần thư giãn của *Tidy Up the Flower Shop*: không đồng hồ đếm ngược, không thua cuộc, không ép người chơi phải tối ưu tốc độ. Tạo bản sắc riêng bằng bố cục, màu sắc, tên, nhân vật/bối cảnh, giao diện, âm thanh và nội dung tự làm.
- Bản MVP hiện hành có **một tiệm hai tầng**, **chín loại hoa**, **chín giỏ**, **600 bông tổng (66–67 mỗi loại)**, tủ áp tường, lưu cục bộ và chạy Android.
- Dùng asset CC0 hoặc giấy phép cho phép sử dụng thương mại rõ ràng; lưu lại nguồn, giấy phép và bản gốc theo từng asset.
- Làm bản thử trên điện thoại ngay tuần 2. Không đợi hoàn thiện đồ họa mới kiểm tra cảm giác điều khiển.
- Dự kiến phát hành sau tuần 16 nếu đạt tiêu chí; tuần 17–20 là dự phòng cho tối ưu, sửa lỗi, closed test và review.

## 2. Sản phẩm cần hoàn thành

### Câu mô tả game

Một trải nghiệm dọn dẹp tiệm hoa nhỏ trong góc nhìn thứ nhất: người chơi thong thả đi quanh cửa hàng, nhặt từng bông hoa rơi vãi, mang một số lượng hữu hạn và đặt chúng vào đúng giỏ; khi hoàn thành, tiệm trở nên gọn gàng và ấm cúng hơn.

### Người chơi mục tiêu

Người thích game cozy, dọn dẹp và sắp xếp; có thể chơi bằng cảm ứng trong các phiên ngắn. Game cần dễ hiểu khi không có hướng dẫn dài, hỗ trợ tạm dừng bất kỳ lúc nào và không cần mạng.

### Trụ cột thiết kế

1. **Dễ hiểu:** tâm ngắm cho biết vật nào có thể tương tác; một nút tương tác; mục tiêu luôn nhìn thấy.
2. **Thư giãn:** không giới hạn thời gian, không hình phạt, không thất bại.
3. **Tiến bộ nhìn thấy được:** mỗi bông được đặt đúng sẽ biến mất khỏi tay, vào giỏ và tăng tiến độ; căn phòng chuyển từ lộn xộn sang ngăn nắp.
4. **Chạm thoải mái:** nút lớn, giao diện ngang, vùng nhìn không bị che quá nhiều; độ nhạy và đảo trục có thể chỉnh.
5. **Đủ nhẹ để solo dev hoàn thành:** tái sử dụng một bộ nội thất, giới hạn số loại vật thể và ưu tiên biến thể màu/vật liệu thay vì tạo hàng chục model khác nhau.

### Vòng lặp chơi

`Nhìn quanh → đi đến bông hoa → nhấn Nhặt → mang tối đa 5 bông → đi đến giỏ đúng loại → nhấn Đặt → xem tiến độ tăng → hoàn thành khu vực`

### Cảm xúc theo nhịp

- **Bắt đầu:** một căn phòng hơi bừa bộn, mục tiêu đơn giản: “Xếp hoa vào đúng giỏ”.
- **Trong lúc chơi:** phản hồi xúc giác/âm thanh nhẹ khi nhặt và đặt; giỏ nhấn sáng khi được ngắm; bộ đếm tiến độ luôn rõ.
- **Hoàn thành:** âm thanh chúc mừng ngắn, toàn cảnh cửa hàng gọn gàng, nút “Chơi lại”/“Về menu”. Không dùng pháo hoa hoặc hiệu ứng che khuất.

## 3. GDD và phạm vi MVP

### Nội dung MVP

| Hạng mục | MVP |
|---|---|
| Camera | FPS, nhìn lên/xuống có giới hạn, xoay ngang tự do |
| Di chuyển | Joystick trái, đi bộ, va chạm tường/nội thất; không có nhảy/chạy |
| Tương tác | Raycast giữa màn hình, một nút dùng cho nhặt/đặt |
| Hoa | 9 loại, 600 bông tổng; chia 66–67 bông mỗi loại, dùng MultiMesh để giảm draw call |
| Giỏ | 9 giỏ phân bố ở hai tầng, mỗi giỏ chấp nhận đúng một loại hoa; phản hồi màu/nhãn và âm thanh |
| Mang đồ | Tối đa 5 bông; loại hoa đang cầm hiển thị trước camera; nút “Đặt vào giỏ” đặt một bông mỗi lần |
| Mục tiêu | Đặt đủ 600 bông vào đúng giỏ; progress `0/600` và trạng thái theo loại |
| Màn hình | Menu, cài đặt cơ bản, tạm dừng, HUD trong game, hoàn thành, credits/license |
| Lưu | Tự lưu tiến độ sau hành động; tiếp tục sau khi thoát; reset có xác nhận |
| Âm thanh | Nhạc nền tùy chọn, âm thanh nhặt/đặt/hoàn thành, volume music/SFX |
| Nền tảng | Android ngang; có thể chạy trên desktop để phát triển và debug |
| Mạng/monetization | Không cần trong MVP; không quảng cáo, không đăng nhập, không backend |

### Không đưa vào MVP (đưa vào backlog sau phát hành)

- Tầng thứ ba/phòng thứ hai, nhiệm vụ hằng ngày, cửa hàng trong game, tiền ảo, quảng cáo, tài khoản cloud, leaderboard.
- Tô màu giỏ, chế độ sandbox, hơn 600 vật thể, cốt truyện có hội thoại, NPC, vật lý nhặt tự do.
- Hệ thống kéo-thả vật thể, điều khiển tay, animation phức tạp, hiệu ứng hạt dày đặc.

**Quy tắc scope:** nếu một tính năng không giúp người chơi hiểu mục tiêu, di chuyển, nhặt/đặt hoa, thấy tiến độ hoặc lưu được cuộc chơi, hãy để sau MVP.

### Quy tắc gameplay cụ thể

- Tổng vật thể cần phân loại: 600 (gấp 10 lần bản 60 bông trước đó). Hoa rải trên hai tầng; không gom tất cả gần cửa hoặc đặt hoa ở vị trí người chơi không thể tới.
- Người chơi có thể mang tối đa 5 bông. Nếu đầy, nhấn nhặt sẽ hiện thông báo “Tay đang đầy”.
- Mỗi giỏ chỉ nhận loại hoa quy định. Đúng loại: đặt một bông và tăng số đã xếp. Sai loại: không tiêu thụ hoa, báo ngắn “Giỏ này dành cho …”.
- Khi nhìn vào đối tượng tương tác trong tầm 2.5–3.0 m, hiện tên hành động. Ngoài tầm hoặc bị che thì không tương tác.
- Giỏ hoàn thành đổi trạng thái rõ nhưng vẫn giữ mesh để thể hiện kết quả. Hoa đã đặt không thể bị nhặt lại trong MVP.
- Điều kiện hoàn thành: 600/600. Tự lưu trạng thái trước khi bật màn hoàn thành.

## 4. Art direction dành cho người chưa có designer

### Hướng hình ảnh

**Cozy low-poly 3D**, hình khối rõ, màu pastel hơi ấm, ánh sáng dịu, ít chi tiết nhỏ. Tiệm hoa là một căn phòng nhỏ có quầy gỗ, kệ sát tường, cửa sổ, vài chậu cây và các giỏ có màu phân loại.

### Quy tắc để asset khác nguồn vẫn cùng phong cách

- Chốt một bảng màu 12–14 màu trước khi dựng: gỗ sáng, kem, xanh lá dịu, chín màu hoa, màu nhấn giao diện.
- Ưu tiên mesh low-poly có tỷ lệ gần nhau; tránh trộn asset photorealistic với low-poly.
- Tắt hoặc giảm texture độ phân giải cao; dùng vật liệu màu phẳng, roughness cao, không dùng normal map trừ khi cần.
- Giữ cùng thang đo: chiều cao người chơi 1.7 m; mặt quầy khoảng 0.9 m; cửa khoảng 2 m.
- Tự tạo hoa/giỏ bằng Blender hoặc chỉnh sửa asset có phép thương mại để đảm bảo chín loại hoa dễ phân biệt ở khoảng cách chơi.
- Dùng palette/nhãn hình học bên cạnh màu để phân biệt giỏ, hỗ trợ người chơi khó phân biệt màu.

### Quy trình Blender tối thiểu

1. Dựng model theo tỷ lệ mét, origin hợp lý, tên object rõ ràng.
2. Dùng ít vật liệu, ưu tiên vật liệu dùng chung.
3. Apply rotation/scale, kiểm tra mặt normals, xóa mesh/vertex thừa.
4. Xuất `glTF 2.0 (.glb)` sang `assets/models/`; không xuất Blender project vào thư mục game trừ khi cần lưu nguồn trong `art_source/`.
5. Import vào Godot, kiểm tra kích thước, pivot, vật liệu và collision. Collision gameplay nên tạo riêng đơn giản trong Godot.

## 5. Sourcing asset và kiểm tra giấy phép

### Nguồn ưu tiên

| Nguồn | Dùng cho | Giấy phép và cách dùng |
|---|---|---|
| [Quaternius](https://quaternius.com/) | Model 3D stylized, thiên nhiên, props | FAQ nêu các model CC0, dùng thương mại được, không bắt buộc ghi công. Vẫn kiểm tra file LICENSE/README đi cùng đúng gói tải. |
| [Kenney Assets](https://kenney.nl/assets) | Props, UI, âm thanh, bộ asset game | Kenney ghi asset trên trang asset là CC0; lưu file license/README của gói cụ thể. Không dùng logo Kenney như logo game. |
| [Poly Haven](https://polyhaven.com/) | Texture, HDRI, model | Tất cả asset của họ phát hành theo CC0; dùng texture nhỏ/đơn giản trên Android. |
| Blender | Model/mesh tự làm | Tác phẩm tự tạo thuộc bạn; ghi lại nguồn nếu dựa trên reference/asset khác. |

Không lấy hình ảnh từ Google Images, game tham chiếu, itch.io hay Sketchfab nếu trang cụ thể không cho biết giấy phép sử dụng thương mại và điều kiện ghi công. “Miễn phí tải” không đồng nghĩa với “được dùng trong game thương mại”.

### Checklist mỗi asset

- [ ] Ghi tên asset, tác giả/nhà phát hành, URL trang gốc, ngày tải, phiên bản/gói.
- [ ] Lưu license/README gốc trong `licenses/assets/<asset-id>/`.
- [ ] Xác định rõ có dùng thương mại được không; cần attribution không; có hạn chế sửa/redistribution không.
- [ ] Ghi asset vào `ASSET_LEDGER.md`; không đưa vào build nếu chưa rõ license.
- [ ] Lưu file nguồn trong `art_source/` nếu license cho phép và dung lượng hợp lý; game chỉ đóng gói bản tối ưu.
- [ ] Kiểm tra kỹ font và nhạc/âm thanh riêng; giấy phép của model không tự động áp dụng cho âm thanh đi kèm từ nguồn khác.
- [ ] Trong credits, ghi nguồn dù CC0 không yêu cầu; đây là cách thuận tiện để tự kiểm toán và cảm ơn tác giả.

Mẫu dòng ledger:

```text
ID | Tên | Tác giả | URL | Tải ngày | License | Attribution? | File gốc | File đã sửa/dùng
```

Godot phát hành theo MIT; cần đưa thông báo bản quyền/giấy phép engine vào credits hoặc màn hình Third-party Licenses. Tài liệu Godot chính thức cũng khuyên liệt kê giấy phép của asset bên thứ ba. Xem [Godot license](https://godotengine.org/license/) và [hướng dẫn tuân thủ license](https://docs.godotengine.org/en/stable/about/complying_with_licenses.html).

## 6. Kiến trúc kỹ thuật Godot

### Cấu trúc thư mục dự kiến

```text
little_bloom/
├── project.godot
├── README.md
├── ASSET_LEDGER.md
├── addons/
├── assets/
│   ├── audio/{music,sfx}/
│   ├── fonts/
│   ├── materials/
│   ├── models/{flowers,props,room}/
│   └── ui/
├── licenses/
│   ├── GODOT_MIT.txt
│   └── assets/
├── scenes/
│   ├── main/Main.tscn
│   ├── player/FPSPlayer.tscn
│   ├── room/FlowerShop.tscn
│   ├── interactables/{Flower.tscn,FlowerBasket.tscn}/
│   └── ui/{HUD.tscn,MainMenu.tscn,PauseMenu.tscn,CompleteScreen.tscn}/
├── scripts/
│   ├── autoload/{GameState.gd,SaveManager.gd,AudioManager.gd}/
│   ├── player/{FPSPlayer.gd,TouchControls.gd,Interactor.gd}/
│   ├── interactables/{Flower.gd,FlowerBasket.gd}/
│   └── ui/{HUD.gd,SettingsMenu.gd}/
├── data/{flower_types.json,level_01.json}
└── tests_manual/
```

### Scene tree và trách nhiệm

```text
Main
├── FlowerShop (loaded level)
├── FPSPlayer
│   ├── CollisionShape3D
│   └── Head
│       ├── Camera3D
│       └── Interactor (RayCast3D)
├── HUD (CanvasLayer)
└── TouchControls (CanvasLayer; Android only)
```

| Thành phần | Trách nhiệm |
|---|---|
| `FPSPlayer (CharacterBody3D)` | Đọc input di chuyển, gravity/va chạm, giới hạn pitch; không chứa luật phân loại hoa. |
| `TouchControls` | Xuất action `move`, `look_delta`, `interact`, `drop`; hỗ trợ joystick trái và vùng vuốt phải. |
| `Interactor` | Raycast từ camera, xác định node có thể tương tác, cập nhật prompt; phát action tương tác. |
| `Flower` | ID loại hoa, trạng thái world/held/placed; cung cấp dữ liệu cho tương tác. |
| `FlowerBasket` | ID loại nhận, số lượng đã nhận, báo kết quả đúng/sai; không tự cập nhật save. |
| `GameState` (autoload) | Trạng thái phiên: inventory, số bông theo loại, completion; phát signal cho HUD. |
| `SaveManager` (autoload) | Đọc/ghi JSON vào `user://savegame.json`, version/schema và xử lý save hỏng. |
| `AudioManager` (autoload) | Bus volume, phát SFX, nhạc, tắt tiếng khi app background nếu cần. |
| `HUD` | Hiển thị mục tiêu, inventory 5 ô, prompt, tiến độ, thông báo. |

### Luồng tương tác

1. `Interactor` raycast mỗi frame hoặc theo nhịp 8–12 lần/giây vào collision layer tương tác.
2. Khi mục tiêu thay đổi, gọi `set_focus(true/false)` và phát signal `focus_changed(target)`.
3. Nút tương tác gửi action `interact`; `Interactor` gọi `target.interact(GameState)` nếu còn hợp lệ.
4. Hoa được nhặt: chuyển trạng thái, bỏ khỏi scene level, thêm ID vào inventory, báo `inventory_changed`.
5. Giỏ được dùng: kiểm tra `flower_type_id`; đúng thì xóa một item khỏi inventory, cập nhật counter, phát âm thanh, yêu cầu save; sai thì chỉ báo lỗi nhẹ.
6. Khi toàn bộ mục tiêu hoàn thành, SaveManager ghi trạng thái cuối trước khi GameState phát `level_completed`.

Tránh dùng tham chiếu cứng từ HUD tới từng hoa/giỏ. Dùng signal và ID dữ liệu để sau này thay bố cục mà không phải sửa luật chơi.

### Định nghĩa input

Tạo Input Map: `move_forward`, `move_back`, `move_left`, `move_right`, `interact`, `drop_one`, `pause`.

- Desktop debug: WASD, chuột nhìn, E tương tác, Q bỏ một bông, Esc tạm dừng.
- Android ngang: vùng joystick trái; vuốt ở 55% phía phải để nhìn; nút tương tác lớn ở phải-dưới; nút inventory/đặt dễ chạm ở dưới giữa hoặc phải.
- Không dùng nút “drop” rời trong MVP nếu HUD đã có nút “Đặt” theo context: nhìn vào giỏ thì đặt, nhìn vào hoa thì nhặt. Đây là cách giảm số nút; nếu playtest gây nhầm lẫn thì tách nút.

## 7. Android FPS touch controls

### Bố trí mặc định

- Game landscape. Bên trái: joystick 15–20% chiều rộng, thấp hơn giữa màn hình một chút.
- Bên phải: vuốt để xoay camera, trừ vùng nút UI.
- Phải-dưới: nút “Nhặt/Đặt” khoảng 64–76 dp, có nhãn hành động khi focus.
- Trên trái: `Đã xếp 120/600`; cạnh dưới/giữa: tối đa 5 ô inventory; trên phải: Pause.
- Thêm tùy chọn `Độ nhạy nhìn`, `Đảo trục dọc`, `Độ mờ HUD` nếu còn thời gian sau khi hoàn tất loop.

### Cảm giác camera

- Vuốt tương đối, delta theo pixel và tốc độ khung hình độc lập; giới hạn pitch khoảng −75° đến +75°.
- Đặt sensitivity mặc định vừa phải; cung cấp thanh chỉnh và lưu vào cấu hình.
- Không khóa camera khi chạm lên nút HUD; xử lý multi-touch để joystick và vuốt nhìn dùng đồng thời.
- Tránh acceleration nặng. Chuyển động dừng nhanh nhưng êm; tốc độ đi bộ bắt đầu khoảng 3.5 m/s, tune sau playtest.
- Tâm ngắm nhỏ, tương phản tốt, không làm UI rung; prompt cho biết hành động trước khi người chơi bấm.

### Kiểm tra sớm

Tuần 2, thử trên máy Android thật với 5 việc: đi thẳng/chéo, đi sát quầy, nhìn lên xuống, di chuyển và nhìn cùng lúc, nhấn tương tác bằng ngón cái. Nếu điều khiển không thoải mái, sửa ngay trước khi thêm nội dung.

## 8. Save/load và cài đặt

### Dữ liệu save

```json
{
  "schema_version": 1,
  "level_id": "shop_01",
  "placed_flower_ids": ["rose_01", "tulip_02"],
  "inventory": ["daisy_03"],
  "settings": {
    "music_volume": 0.7,
    "sfx_volume": 0.8,
    "look_sensitivity": 1.0,
    "invert_y": false
  }
}
```

Trong thực tế nên cân nhắc tách `settings.cfg` (Godot `ConfigFile`) khỏi tiến độ save. Không lưu node path hoặc tọa độ vật thể động nếu level có bố cục cố định; dùng ID ổn định. Chỉ cần lưu ID hoa đã đặt và inventory, rồi khởi tạo level theo dữ liệu.

### Yêu cầu bền vững

- Ghi save sau khi nhặt/đặt, khi pause, khi app chuyển background và trước màn hoàn thành.
- Dùng `FileAccess` trong `user://`; ghi file tạm, sau đó thay save chính nếu cách triển khai hỗ trợ an toàn.
- Kiểm tra JSON parse, `schema_version`, ID hợp lệ. Nếu file hỏng, không crash: khởi tạo save mới và hiển thị thông báo thân thiện.
- Có nút reset với hộp xác nhận. Không reset chỉ vì người chơi đóng game.
- Dành test manual cho force close/reopen, thiếu dung lượng giả lập nếu có thể, file JSON bị sửa/hỏng, nâng schema.

## 9. Hiệu năng và chất lượng Android

### Mục tiêu nội bộ (đo trên máy thật)

- 30 FPS ổn định tối thiểu trên thiết bị cấu hình thấp thuộc nhóm Android mục tiêu; hướng tới 60 FPS trên máy tầm trung.
- Thời gian tải level dưới 5 giây trên máy kiểm thử; không có hitch rõ rệt khi nhặt/đặt.
- Giới hạn phòng ở quy mô nhỏ; ít đèn realtime, bóng đổ chỉ cho các đèn chính; dùng baked light hoặc ánh sáng đơn giản nếu phù hợp.
- Tái sử dụng mesh/material; tránh tạo nhiều bản sao material trong runtime; không có vật lý rigid body cho từng bông hoa.
- Dùng collision shape đơn giản; texture nhỏ; atlas vật liệu nếu số material tăng.
- Kiểm tra nhiệt độ, tụt FPS sau 10–15 phút chơi; theo dõi memory/độ lớn build, không chỉ FPS lúc mở game.

### Kế hoạch tối ưu theo thứ tự

1. Đo trên điện thoại trước khi tối ưu; ghi model máy, phiên bản Android, renderer, FPS quan sát.
2. Giảm số đèn realtime/bóng đổ, độ phân giải texture và số material.
3. Dùng culling/occlusion theo cấu trúc phòng; tránh post-processing nặng.
4. Giảm tỷ lệ render/3D scale nếu máy yếu; kiểm tra chữ/UI còn đọc được.
5. Dùng MultiMesh cho hoa nhìn thấy và hoa đã xếp; đo 600 vật thể tương tác trên Android thật trước khi chốt hiệu năng.

### Thiết lập nền tảng

- Dùng Godot stable hiện hành tại lúc bắt đầu, ghi chính xác phiên bản editor và export templates trong README, không nâng giữa sprint nếu chưa có lý do.
- Dùng renderer phù hợp mục tiêu Android (thử Compatibility trước cho tương thích rộng; chỉ đổi sau khi test trên thiết bị thật).
- Cài export template đúng phiên bản Godot và Android SDK/JDK theo tài liệu chính thức. Godot yêu cầu template khớp phiên bản; bản mới trên Google Play cần xuất AAB. Xem [Godot Android export](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html).

## 10. Kiểm thử và acceptance criteria

Không cần viết test framework trong giai đoạn đầu. Duy trì checklist manual `tests_manual/` và chạy ở mỗi milestone. Mỗi build test cần ghi thiết bị, commit/version, kết quả, lỗi và ảnh/video nếu lỗi hình ảnh.

### Acceptance criteria tổng thể cho MVP

- [ ] Người mới có thể hiểu mục tiêu trong 30 giây mà không cần đọc tài liệu ngoài game.
- [ ] Di chuyển, xoay camera và tương tác cùng lúc hoạt động trên ít nhất 2 điện thoại Android thật khác phân khúc.
- [ ] Mỗi loại hoa chỉ được nhận vào giỏ đúng; sai loại không mất hoa.
- [ ] Có thể lên xuống hai tầng và nhặt/đặt đủ 600/600 bông, xem tiến độ cập nhật chính xác.
- [ ] Tối đa 5 bông trong inventory; không thể vượt giới hạn; UI không mất đồng bộ với game state.
- [ ] Thoát ứng dụng giữa chừng, mở lại và Continue cho trạng thái đã lưu chính xác.
- [ ] Pause/resume, âm thanh, menu, reset save và màn hoàn thành hoạt động không crash.
- [ ] Không có asset chưa xác minh license; credits có Godot và attribution cần thiết.
- [ ] Không có lỗi chặn tiến độ; không có crash trong phiên chơi thử 15 phút trên thiết bị kiểm thử.
- [ ] Mục tiêu hiệu năng nội bộ đạt: ít nhất 30 FPS tương đối ổn định trên máy yếu đã chọn; không quá nóng hoặc tụt khung hình nghiêm trọng.
- [ ] AAB release ký đúng, version/code tăng hợp lệ, icon/screenshots/short description/privacy/data disclosures đầy đủ theo sản phẩm thực tế.

### Checklist kiểm thử theo ca

- **Gameplay:** nhặt từng loại, nhặt khi đầy, nhìn vật ngoài tầm, bị vật cản, đặt đúng/sai, hoàn thành lần lượt các giỏ.
- **Touch:** chạm nút khi đang vuốt, joystick và camera đồng thời, multi-touch, đổi hướng nhanh, màn hình nhiều tỷ lệ, chạm sát mép.
- **Lưu:** thoát sau nhặt, thoát sau đặt, force close, Continue, reset có xác nhận, JSON lỗi.
- **Ứng dụng:** pause/resume, gọi thông báo Android rồi quay lại, âm lượng thiết bị thấp/tắt, app vào background, xoay màn hình (khóa landscape nếu thiết kế yêu cầu).
- **Thiết bị:** máy yếu mục tiêu, máy tầm trung, Android version thấp nhất dự định hỗ trợ, màn hình tỷ lệ dài.
- **Store:** cài từ closed-test track, cold start, cập nhật từ build cũ, link chính sách quyền riêng tư nếu khai báo cần.

## 11. Lịch 16 tuần + 4 tuần dự phòng

Giả định 15–20 giờ/tuần. Cuối mỗi tuần phải có build hoặc artefact nhìn thấy được; nếu trễ, cắt tính năng backlog thay vì kéo dài phạm vi.

### Tuần 1 — Setup và vertical slice khung

- [ ] Cài Godot stable, Blender, Git; chọn điện thoại Android mục tiêu.
- [ ] Tạo project landscape, Input Map cơ bản, repo, README, asset ledger.
- [ ] Tạo phòng blockout bằng mesh primitive: sàn, tường, quầy, kệ; scale theo mét.
- [ ] Tạo `FPSPlayer` với `CharacterBody3D`, `Camera3D`, va chạm, đi WASD/chuột.
- [ ] Chốt bảng màu và moodboard 5–8 ảnh tham khảo do bạn có quyền xem; ghi nguồn.
- **Kết quả:** đi được trong căn phòng xám trên desktop; project mở sạch sau khi đóng/mở.
- **Acceptance:** không xuyên tường/đi xuyên quầy, camera pitch giới hạn, scene tree rõ.

### Tuần 2 — Export Android và touch controls

- [ ] Cài Android SDK/JDK và template khớp Godot; tạo Android export preset.
- [ ] Dựng joystick trái, vùng vuốt phải, nút pause.
- [ ] Test USB deploy hoặc debug APK trên điện thoại thật; xác nhận landscape và safe area.
- [ ] Thêm sensitivity và ngưỡng bỏ qua touch trên UI.
- **Kết quả:** APK debug chạy trên máy thật, đi/nhìn đồng thời được.
- **Acceptance:** 10 phút thao tác không thấy lỗi focus/đụng UI; ghi lại FPS và cảm nhận.

### Tuần 3 — Tương tác và hoa đầu tiên

- [ ] Tạo `Interactor` raycast, reticle và prompt “Nhặt”.
- [ ] Tạo một flower placeholder có collision và ID.
- [ ] Nhấn interact để nhặt; hiện model ở vị trí held trước camera.
- [ ] Thêm giới hạn inventory 5 item và thông báo khi đầy.
- **Kết quả:** loop nhìn → nhặt → thấy hoa cầm trên tay hoạt động.
- **Acceptance:** không nhặt xuyên vật cản, không nhặt ngoài tầm, inventory chính xác.

### Tuần 4 — Giỏ, phân loại, loop hoàn chỉnh

- [ ] Tạo `FlowerBasket` có `accepted_flower_type_id`.
- [ ] Đặt một bông mỗi lần; loại sai không bị mất.
- [ ] Thêm HUD tiến độ và nhãn hành động theo target.
- [ ] Thử một phòng với 3 bông và 3 giỏ trước khi tăng nội dung.
- **Kết quả:** loop gameplay thật từ nhặt đến xếp đúng.
- **Acceptance:** hoàn tất 3/3 mà không cần debug; sai loại vẫn giữ hoa.

### Tuần 5 — Game state và save/load

- [ ] Tách trạng thái phiên sang `GameState`; thêm signals.
- [ ] Lưu/đọc save theo ID; auto-save sau hành động.
- [ ] Menu Continue/New/Reset; xử lý save hỏng và version.
- [ ] Kiểm tra force close và mở lại trên Android.
- **Kết quả:** tiến trình sống sót sau khi đóng app.
- **Acceptance:** trạng thái hoa đã nhặt/đặt được phục hồi chính xác.

### Tuần 6 — Nội dung MVP và hoàn thành màn

- [ ] Tạo 9 loại hoa, 9 giỏ, 600 ID duy nhất.
- [ ] Hoàn thành điều kiện 600/600; màn complete; nút chơi lại.
- [ ] Thêm pause/resume và thiết lập âm lượng.
- [ ] Tạo save reset có xác nhận.
- **Kết quả:** gameplay MVP đủ từ menu tới kết thúc.
- **Acceptance:** một người mới chơi hoàn tất; không có dead-end.

### Tuần 7 — Art pass: phòng và props

- [ ] Chọn tối đa 1–2 bộ asset phù hợp; tải nguồn và license.
- [ ] Thay blockout bằng sàn/tường/quầy/kệ/đèn/cửa sổ/props phù hợp.
- [ ] Chỉnh tỷ lệ, vật liệu và palette thống nhất.
- [ ] Thay collision phức tạp bằng shape đơn giản riêng.
- **Kết quả:** phòng có phong cách thống nhất và vẫn chơi được.
- **Acceptance:** không có nguồn asset thiếu trong ledger; không vật cản khó chịu.

### Tuần 8 — Art pass: hoa, giỏ, phản hồi

- [ ] Tạo/chỉnh 3 flower meshes khác silhouette và màu.
- [ ] Thiết kế giỏ với màu + icon/shape phân biệt.
- [ ] Thêm highlight khi ngắm, âm thanh nhặt/đặt, feedback sai loại.
- [ ] Chỉnh model held không che tâm/ngắm.
- **Kết quả:** gameplay nhận diện nhanh trên màn điện thoại.
- **Acceptance:** hoa/giỏ phân biệt được ở khoảng cách 2–3 m.

### Tuần 9 — UI/UX và onboarding

- [ ] Hoàn thiện menu, cài đặt, HUD, pause, complete, credits.
- [ ] Thêm hướng dẫn 3 bước ngay trong level; có thể bỏ qua.
- [ ] Kiểm tra chữ đọc được ở màn nhỏ; nút đủ lớn; safe area.
- [ ] Test với người không tham gia làm game (tối thiểu 2 người nếu có thể); ghi điểm họ mắc.
- **Kết quả:** game tự giải thích được.
- **Acceptance:** người chơi biết di chuyển, nhặt và đặt mà không cần lời giải thích miệng.

### Tuần 10 — Audio, polish và cảm giác cozy

- [ ] Nhạc nền nhẹ có loop sạch, volume riêng; SFX có license.
- [ ] Thêm chuyển cảnh đơn giản, âm thanh UI và hoàn thành.
- [ ] Chỉnh tốc độ di chuyển, camera, prompt, âm lượng, màu sắc theo playtest.
- [ ] Giới hạn hiệu ứng để không ảnh hưởng FPS.
- **Kết quả:** bản chơi có nhịp và phản hồi nhất quán.
- **Acceptance:** có thể chơi 10 phút không khó chịu vì âm thanh/điều khiển.

### Tuần 11 — Save hardening và edge cases

- [ ] Test save schema, dữ liệu thiếu/hỏng, IDs không hợp lệ.
- [ ] Test pause/background/resume, bấm liên tục, double tap.
- [ ] Chặn đặt cùng một hoa hai lần hoặc vào hai giỏ.
- [ ] Thêm thông báo lỗi thân thiện và log debug có kiểm soát.
- **Kết quả:** phiên chơi không mất tiến độ trong các tình huống thường gặp.
- **Acceptance:** toàn bộ checklist save/load đạt.

### Tuần 12 — Tối ưu hiệu năng và build profile

- [ ] Profile trên hai máy thật; ghi FPS, tải, nhiệt/độ tụt hiệu năng sau 15 phút.
- [ ] Tối ưu đèn, texture, material, draw calls theo kết quả đo.
- [ ] Kiểm tra size build; bỏ file source không cần thiết khỏi export.
- [ ] Chốt renderer và Android minimum version dựa trên máy thử.
- **Kết quả:** build ổn định để cho người khác test.
- **Acceptance:** đạt mục tiêu hiệu năng nội bộ hoặc có quyết định cắt/tối ưu cụ thể.

### Tuần 13 — Closed alpha và sửa lỗi

- [ ] Gửi build cho 5–8 người quen; yêu cầu chơi ít nhất một lần đến complete.
- [ ] Hỏi: điều khiển có dễ không, biết phải làm gì không, có lỗi/mất save không, muốn chơi tiếp không.
- [ ] Sửa lỗi chặn tiến độ, lỗi touch, chữ nhỏ, nhầm loại hoa.
- [ ] Không thêm nội dung mới.
- **Kết quả:** danh sách lỗi ưu tiên và bản alpha ổn định.
- **Acceptance:** không còn blocker; mỗi lỗi có trạng thái và cách tái hiện.

### Tuần 14 — Release candidate và nội dung store

- [ ] Tạo icon, feature graphic, screenshots thật, mô tả ngắn/dài và tên tạm cuối.
- [ ] Soạn chính sách quyền riêng tư nếu yêu cầu theo dữ liệu/SDK thực tế; khai báo Data safety chính xác.
- [ ] Điền content rating, target audience, app access và store listing.
- [ ] Chuẩn bị AAB release ký bằng keystore giữ an toàn; backup offline an toàn.
- **Kết quả:** hồ sơ store và AAB release candidate.
- **Acceptance:** build cài được từ Play testing track; toàn bộ listing khớp game thật.

### Tuần 15 — Closed test chính thức

- [ ] Tải AAB lên internal test để smoke test, sau đó closed test.
- [ ] Mời ít nhất 12 tester giữ opt-in liên tục đủ thời gian nếu tài khoản cá nhân thuộc diện áp dụng; nên có dự phòng người tham gia.
- [ ] Ghi nhận feedback, crash, thiết bị và mức độ tham gia; phát hành bản sửa trong test nếu cần.
- [ ] Bắt đầu sớm: điều kiện 14 ngày có thể đẩy lịch qua tuần 16.
- **Kết quả:** test track hoạt động, tester có link cài, phản hồi được theo dõi.
- **Acceptance:** 12 tester liên tục 14 ngày cho tài khoản cá nhân mới thuộc diện Google Play quy định; kiểm tra chính sách hiện hành trong Play Console.

### Tuần 16 — Production access / phát hành mềm

- [ ] Hoàn tất phản hồi test, trả lời câu hỏi production access nếu được yêu cầu.
- [ ] Kiểm tra AAB cuối, version, signing, screenshots, disclosures và license credits.
- [ ] Phát hành theo staged rollout nhỏ nếu được cấp production access; theo dõi crash/đánh giá.
- [ ] Chuẩn bị rollback bằng bản sửa, không xóa listing.
- **Kết quả:** sẵn sàng hoặc đã phát hành lên Google Play.
- **Acceptance:** không còn blocker, kiểm soát được build đang phát hành và có kế hoạch phản ứng lỗi.

### Tuần 17–20 — Buffer (không phải thêm scope)

- **Tuần 17:** hoàn thành thời gian closed test còn thiếu / bổ sung tester / sửa feedback.
- **Tuần 18:** xử lý yêu cầu thêm test hoặc lỗi tương thích; kiểm tra lại AAB và metadata.
- **Tuần 19:** polish nhỏ dựa trên dữ liệu; không làm lại art pipeline.
- **Tuần 20:** phát hành nếu đủ điều kiện; nếu chưa, chốt nguyên nhân, phạm vi còn lại và lịch mới.

Google Play yêu cầu tài khoản cá nhân tạo sau 13/11/2023 chạy closed test với ít nhất 12 tester đã opt-in liên tục 14 ngày trước khi xin production access. Kiểm tra trang yêu cầu mới nhất trước khi lập lịch phát hành: [Google Play Console Help](https://support.google.com/googleplay/android-developer/answer/14151465?hl=en).

## 12. Backlog tasks checklist theo ưu tiên

### P0 — phải có

- [ ] Project Godot chạy desktop và Android.
- [ ] FPS movement, collision, touch look/joystick.
- [ ] Raycast interact + prompt.
- [ ] Hoa/giỏ với luật đúng/sai.
- [ ] Inventory giới hạn và HUD tiến độ.
- [ ] Một level 600 hoa trên hai tầng, điều kiện hoàn thành.
- [ ] Save/load, Continue, reset confirm.
- [ ] Menu/pause/settings/credits.
- [ ] Asset/license ledger và Godot MIT notice.
- [ ] Android performance pass, AAB release build.

### P1 — tăng chất lượng nếu còn thời gian

- [ ] Sensitivity slider, invert Y, volume sliders.
- [ ] Onboarding 3 bước, accessibility màu/shape.
- [ ] Haptic feedback tùy chọn.
- [ ] Hai bố cục nút UI hoặc tùy chỉnh vị trí.
- [ ] Thống kê thời gian chơi cục bộ không cần backend.

### P2 — sau phát hành

- [ ] Khu vực thứ hai, thêm loại hoa, giỏ trang trí.
- [ ] Chế độ sandbox, nhiệm vụ nhẹ, daily task.
- [ ] Cloud save, analytics, monetization (chỉ nếu có nhu cầu và đã đánh giá riêng tư/chính sách).

## 13. Rủi ro và cách giảm thiểu

| Rủi ro | Dấu hiệu sớm | Cách xử lý |
|---|---|---|
| FPS touch khó chịu | Người chơi quay quá tay/khó bấm | Prototype bằng placeholder tuần 2; test multi-touch, cho chỉnh sensitivity. |
| Scope nở | Thêm phòng, thêm nhiệm vụ trước khi loop ổn | Khóa MVP; chuyển ý tưởng sang P2. |
| Asset không đồng phong cách | Mesh tỷ lệ/màu/độ chi tiết lệch | Giới hạn số nguồn, dùng palette chung, sửa material hoặc tự làm props chủ đạo. |
| Vướng license | Không tìm thấy trang/license file | Không đóng gói asset; thay bằng nguồn CC0 đã xác minh. |
| Android yếu | FPS giảm, nóng, tải lâu | Test sớm, giảm realtime lights/texture, ưu tiên phòng nhỏ. |
| Save hỏng/mất tiến độ | Resume khác trạng thái trước khi thoát | Lưu theo ID và sau mỗi hành động; test force close và file hỏng. |
| Closed test kéo dài | Khó đủ tester hoặc bị yêu cầu test thêm | Tìm tester trước tuần 13; mở test tuần 15; có buffer 4 tuần. |
| Solo dev quá tải art | Dành nhiều tuần chỉnh model thay vì loop | Tái sử dụng mesh và MultiMesh; chín silhouette chung phong cách, ưu tiên hiệu năng mobile. |

## 14. Chỉ dẫn bắt tay trong ba ngày đầu

### Ngày 1 — tạo project và căn phòng blockout (3–5 giờ)

1. Cài Godot stable, Blender, Git; ghi phiên bản vào README.
2. Trong Godot chọn **New Project**, tạo `LittleBloom` với renderer mặc định phù hợp Android, bật landscape sau khi có preset.
3. Tạo các thư mục `scenes`, `scripts`, `assets`, `data`, `licenses`, `tests_manual` như cấu trúc ở trên.
4. Dựng scene `FlowerShop.tscn`: sàn 8×8 m, tường 3 m, quầy/kệ bằng BoxMesh; thêm StaticBody3D/CollisionShape3D.
5. Tạo scene `FPSPlayer.tscn` có `CharacterBody3D`, CapsuleShape3D, `Head/Camera3D`; thêm WASD và chuột để test trên desktop.
6. Commit: `chore: create Godot project and room blockout`.

**Kết thúc ngày 1:** có thể chạy, đi quanh phòng, không xuyên vật thể. Không tải asset trang trí trước khi đạt điều này.

### Ngày 2 — điều khiển điện thoại (3–5 giờ)

1. Cài Android SDK/JDK theo tài liệu Godot hiện hành; cài export templates đúng phiên bản editor.
2. Tạo Android export preset, bật landscape, đặt application ID tạm dạng `com.yourname.littlebloom`.
3. Tạo joystick trái và vùng vuốt phải; thêm nút pause.
4. Xuất debug build và cài lên Android thật; thử giữ joystick trong khi vuốt camera.
5. Ghi lại vấn đề: joystick bị kẹt, camera rung, UI bị che, FPS hoặc aspect ratio.
6. Commit: `feat: add Android touch movement and camera look`.

**Kết thúc ngày 2:** APK chạy trên thiết bị thật. Nếu chưa chạy được, chỉ tập trung hoàn tất export; chưa thêm gameplay.

### Ngày 3 — nhặt một bông hoa (3–5 giờ)

1. Tạo `Flower.tscn` bằng mesh placeholder và collision, gắn ID `rose_01`/type `rose`.
2. Thêm `RayCast3D` từ camera và reticle giữa màn hình.
3. Khi nhìn đúng hoa trong 3 m, hiện “Nhặt”; bấm E trên desktop/nút trên Android.
4. Chuyển hoa sang vị trí held trước camera; tăng inventory `1/5`.
5. Test ngoài tầm, sau tường, nhấn hai lần và nhặt khi inventory đầy.
6. Commit: `feat: pick up first flower with camera raycast`.

**Kết thúc ngày 3:** prototype đầu tiên đã có cảm giác FPS + nhặt hoa trên điện thoại. Từ đây mới mở rộng tương tác với giỏ.

## 15. Lệnh khởi tạo thiết thực

Các lệnh sau tạo khung thư mục và repo. Chạy tại nơi bạn muốn đặt dự án; sau đó tạo project bằng Godot Editor để `project.godot` và các thiết lập Android được tạo đúng phiên bản.

```bash
mkdir -p little-bloom/{scenes/{main,player,room,interactables,ui},scripts/{autoload,player,interactables,ui},assets/{audio/{music,sfx},fonts,materials,models/{flowers,props,room},ui},data,licenses/assets,tests_manual,art_source}
cd little-bloom
git init
touch README.md ASSET_LEDGER.md
```

Sau khi project được tạo trong Godot, kiểm tra `project.godot` và mở game; commit baseline:

```bash
git add project.godot README.md ASSET_LEDGER.md scenes scripts assets data licenses tests_manual
git commit -m "chore: create Little Bloom project skeleton"
```

Lưu ý: nếu lệnh `mkdir` shell của bạn không hỗ trợ brace expansion, tạo thư mục bằng file manager hoặc chạy từng đường dẫn riêng.

### Nhánh làm việc và backup

- Làm solo vẫn nên commit mỗi mốc chạy được; dùng nhánh `main` ổn định và nhánh ngắn `feat/...` khi thay đổi lớn.
- Không commit keystore/password, Android signing credentials hoặc thông tin cá nhân; backup keystore ở nơi an toàn riêng.
- Giữ build debug cũ cho đến khi build mới đã cài và smoke test trên điện thoại.

## 16. Ước lượng thời gian và chi phí

- **15–20 giờ/tuần × 16 tuần = 240–320 giờ**; người mới với Godot/Blender/Android có thể cần buffer tuần 17–20 hoặc lâu hơn.
- Engine, Blender và các nguồn asset nêu trên miễn phí theo giấy phép của từng bên. Google Play có phí đăng ký tài khoản nhà phát triển; mức phí có thể thay đổi theo quốc gia/thời điểm, kiểm tra trực tiếp trong Play Console trước khi chốt ngân sách.
- Chưa tính thiết bị Android nếu chưa có, nhạc/asset trả phí tùy chọn, thuê tester hoặc chi phí chính sách/quảng cáo.
- Giữ ngân sách asset bằng 0 trong MVP; chỉ mua asset nếu nó thay thế được nhiều giờ làm và license rõ ràng.

## 17. Định nghĩa “xong”

Game MVP được xem là xong khi người chơi tải từ closed test/Google Play, mở game offline, hiểu mục tiêu, di chuyển FPS bằng cảm ứng, đi được cả hai tầng, nhặt và phân loại đủ 600 bông, thoát rồi tiếp tục không mất tiến độ, hoàn thành màn chơi, và app chạy ổn trên các thiết bị Android đã chọn. Mọi asset có hồ sơ license, credits có thông báo cần thiết, còn các tính năng ngoài phạm vi được ghi vào backlog sau phát hành.

---

## Nguồn chính thức để kiểm tra lại trước phát hành

- [Godot Engine license (MIT)](https://godotengine.org/license/)
- [Godot: complying with licenses](https://docs.godotengine.org/en/stable/about/complying_with_licenses.html)
- [Godot: exporting for Android](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html)
- [Google Play: testing requirements for new personal developer accounts](https://support.google.com/googleplay/android-developer/answer/14151465?hl=en)
- [Quaternius FAQ and CC0 statement](https://quaternius.com/faq.html)
- [Kenney support and asset licensing](https://kenney.nl/support)
- [Poly Haven license](https://polyhaven.com/license)

> Các trang này được kiểm tra ngày 17/11/2026. Chính sách cửa hàng và giấy phép asset có thể thay đổi; trước mỗi lần phát hành, xác minh lại trang gốc và file license đi cùng asset cụ thể.

