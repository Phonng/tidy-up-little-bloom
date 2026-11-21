# Little Bloom — Product Requirements Document

**Phiên bản:** 1.5 · **Trạng thái:** Đã triển khai giỏ đầu trong demo 90 bông · **Cập nhật:** 21/11/2026

**Tên sản phẩm:** Little Bloom *(tên làm việc; chưa xác nhận khả năng đăng ký/phát hành)*  
**Nền tảng đầu tiên:** Android · **Thể loại:** Cozy, dọn dẹp và sắp xếp, góc nhìn thứ nhất  
**Đội ngũ:** Solo developer · **Engine:** Godot 4 / GDScript · **Mục tiêu trước mắt:** Một cửa hàng demo chơi được trọn vòng; lịch phát hành đầy đủ lập sau khi demo đạt tiêu chí

## 1. Tóm tắt sản phẩm

Little Bloom là game 3D góc nhìn thứ nhất dành cho điện thoại Android. Người chơi bước vào một tiệm hoa nhỏ đang bừa bộn, nhặt hoa rơi, mang một số lượng giới hạn và xếp mỗi loại vào đúng giỏ. Khi hoàn tất, căn phòng chuyển từ lộn xộn sang gọn gàng.

Sản phẩm hướng đến những phiên chơi ngắn, điều khiển cảm ứng dễ hiểu và cảm giác tiến bộ nhìn thấy được. Game hoạt động offline, không có đồng hồ đếm ngược, điểm phạt hay cơ chế thua trong MVP.

**Lời hứa với người chơi:** “Dành vài phút để làm một tiệm hoa nhỏ trở nên ngăn nắp và dễ chịu hơn.”

## 2. Tầm nhìn và định vị

### Tầm nhìn

Tạo một game cozy mobile nhỏ, hoàn chỉnh và có thể phát hành bởi một solo developer; tập trung vào cảm giác tự tay dọn dẹp, thao tác rõ ràng và bầu không khí ấm áp thay vì số lượng màn chơi hay hệ thống phức tạp.

### Định vị

Một game dọn dẹp cửa hàng hoa góc nhìn thứ nhất, chơi bằng cảm ứng trong các phiên ngắn. Lấy cảm hứng ở cấp độ thể loại từ game cozy sắp xếp cửa hàng; mọi tên, bố cục, hình ảnh, giao diện, âm thanh và nội dung trong Little Bloom cần có bản sắc riêng.

### Trụ cột sản phẩm

1. **Thư giãn:** không áp lực thời gian, điểm số hay thất bại.
2. **Tương tác trực tiếp:** di chuyển trong không gian 3D, ngắm vật thể rồi chạm để thao tác.
3. **Phản hồi dễ đọc:** người chơi biết mình đang ngắm gì, giỏ nhận loại nào và đã hoàn thành bao nhiêu.
4. **Tiến bộ hữu hình:** hoa rời khỏi sàn/tay và xuất hiện trong giỏ; căn phòng nhìn gọn hơn theo từng hành động.
5. **Scope vừa sức:** một căn phòng và vài vật thể có thể làm tốt trước khi mở rộng nội dung.

## 3. Người chơi mục tiêu

### Nhóm chính

- Người chơi thích game cozy, dọn dẹp, sắp xếp và trang trí nhẹ.
- Người dùng Android muốn chơi không cần mạng, không cần đăng nhập và có thể dừng bất cứ lúc nào.
- Người thích khám phá không gian 3D nhưng không tìm kiếm thử thách hành động hoặc cạnh tranh.

### Nhu cầu người chơi

- Hiểu cách chơi mà không phải đọc hướng dẫn dài.
- Điều khiển FPS trên màn hình cảm ứng mà không che khuất vật thể.
- Có mục tiêu nhỏ, rõ ràng và nhìn thấy kết quả ngay sau mỗi lần đặt hoa.
- Thoát ứng dụng rồi quay lại mà không mất tiến độ.

### Job to be done

> Khi muốn nghỉ ngắn và thư giãn, tôi muốn tự tay sắp xếp một không gian nhỏ, để thấy căn phòng thay đổi rõ rệt mà không bị tính giờ hay bị phạt.

## 4. Trải nghiệm cốt lõi

### Vòng chơi

`Quan sát tiệm → ngắm hoa → nhặt hoa → mang tối đa 5 bông → đi tới giỏ đúng loại → đặt hoa → xem tiến độ tăng → hoàn thành căn phòng`

### Nhịp trải nghiệm

| Giai đoạn | Trải nghiệm mong muốn | Phản hồi của game |
|---|---|---|
| Mở game | Người chơi biết có thể tiếp tục hoặc bắt đầu | Màn hình menu rõ ràng |
| Bắt đầu level | Nhận ra căn phòng đang cần dọn | Mục tiêu “Xếp hoa vào đúng giỏ” và chỉ dẫn ngắn |
| Nhặt | Biết hoa nào đang được nhắm và có thể nhặt | Prompt theo tâm ngắm, phản hồi trực quan, inventory tăng |
| Phân loại | Biết giỏ nhận loại hoa nào | Nhãn/icon/màu của giỏ và prompt “Đặt …” |
| Sai thao tác | Không mất vật phẩm, hiểu lý do | Thông báo ngắn; giữ nguyên hoa trong inventory |
| Hết chỗ mang | Biết cần đặt bớt trước | Thông báo “Tay đang đầy”; không nhặt thêm |
| Hoàn thành | Cảm thấy kết quả và được quyền dừng | Tổng kết hoàn thành, chơi lại hoặc thoát level |

## 5. Phạm vi demo trước mắt

### Nội dung bắt buộc

Phạm vi dưới đây là thiết kế demo đích. D1 đã triển khai demo 90 bông và thử tải 504 bông, mỗi chế độ có save riêng. D2 đã triển khai giỏ hồng gần cửa. Mục tiêu thời gian còn chờ thử với người mới. Chi tiết triển khai, thứ tự công việc và cách bảo toàn save nằm trong [DEMO_PLAN.md](DEMO_PLAN.md).

| Nội dung | Cam kết demo |
|---|---|
| Không gian | Một tiệm hoa hai tầng: tầng trệt 24 m × 22 m, tầng lửng 24 m × 10.4 m, có cầu thang nối tầng; phải kiểm chứng đi lên và xuống |
| Góc nhìn | 3D góc nhìn thứ nhất, camera nhìn tự do có giới hạn dọc |
| Tay người chơi | Đã bỏ mô hình hai bàn tay theo quyết định của người dùng |
| Loại hoa | Giữ 9 loại hiện tại: hồng, tulip, cúc, hướng dương, oải hương, mẫu đơn, lan, ly, sao nhái; đổi loài sau demo |
| Số lượng | Demo 90 bông, 10 mỗi loại. Thử tải 504 bông, 56 mỗi loại, dùng save 504 hiện có |
| Giỏ | 9 giỏ đặt ở cả hai tầng; mỗi giỏ nhận một loại hoa |
| Inventory | Mang tối đa 5 bông; cho phép mang nhiều loại cùng lúc |
| Thao tác | Đi bộ, nhìn, nhặt và đặt; không có nhảy hoặc chiến đấu |
| Điều kiện hoàn thành | Đặt đúng toàn bộ 90 bông của cấu hình demo |
| Giỏ đầu tiên | 10 bông hồng gần cửa vào, giỏ trong tầm nhìn; mục tiêu hoàn thành sau 2–3 phút |
| Save | Tiến độ và inventory lưu cục bộ, tiếp tục offline |
| Giao diện | Menu tối thiểu, HUD, tạm dừng, cài đặt cơ bản, hoàn thành, credits/license |
| Audio | Nhạc/SFX nhẹ, điều khiển âm lượng; asset có license hợp lệ |
| Nền tảng | Android landscape; desktop hỗ trợ phát triển/debug |

### Sau demo — chưa xếp vào sprint hiện tại

- Tầng thứ ba, phòng thứ hai, nhiệm vụ hằng ngày hoặc campaign.
- Tô màu giỏ, sandbox, tiền ảo, cửa hàng trong game, quảng cáo, IAP.
- Đăng nhập, cloud save, backend, leaderboard, mạng xã hội.
- NPC, hội thoại dài, cốt truyện nhiều chương, vật lý nâng/hất vật thể.
- Thêm loại hoa vượt scope chín loại, hàng trăm props hoặc công cụ tùy biến level.

Các đề xuất mở rộng từ bản Claude ngày 19/11/2026 được để sau demo: quảng cáo/AdMob/UMP, mua gỡ quảng cáo, analytics, nâng sức chứa 8–10, bản đồ giỏ, tùy chỉnh giỏ, ghi chú song ngữ, màn kết biển Open, chụp ảnh, nội dung lễ và trang trí nâng cao. Chưa chốt mô hình kiếm tiền hay lịch phát hành 18 tuần của bản đó.

## 6. Yêu cầu sản phẩm và tiêu chí chấp nhận

### FR-01 — Điều khiển di chuyển và camera

Người chơi điều khiển nhân vật bằng joystick trái và xoay camera bằng vùng vuốt bên phải. Trên desktop cần WASD/phím mũi tên và chuột để debug.

- [ ] Di chuyển và nhìn có thể thực hiện đồng thời bằng nhiều ngón.
- [ ] Nhân vật không đi xuyên tường, kệ, quầy hoặc giỏ.
- [ ] Camera không lật ngược; góc nhìn dọc có giới hạn.
- [ ] Thao tác UI không làm camera xoay ngoài ý muốn.
- [ ] Có thể điều chỉnh độ nhạy nhìn trong cài đặt.
- [ ] Đi lên và xuống cầu thang 5 lượt liên tiếp, không mắc ở chân/đầu thang hoặc xuất hiện dưới mặt thang.

### FR-02 — Ngắm và tương tác

Game chọn mục tiêu từ tâm camera trong tầm tương tác. Khi ngắm vật thể tương tác trong tầm, HUD hiển thị hành động có thể thực hiện.

- [ ] Hoa trong tầm và không bị vật khác che có prompt “Nhặt …”.
- [ ] Hoa đang ngắm có viền/sáng nhẹ có animation và tên loại phía trên; mất focus hoặc nhặt xong thì ẩn.
- [ ] Giỏ có prompt “Đặt …” kèm loại giỏ.
- [ ] Một nút tương tác thực hiện đúng hành động của target đang ngắm.
- [ ] Không tương tác xuyên tường hoặc ngoài tầm.

### FR-03 — Nhặt và mang hoa

- [ ] Nhặt hoa thành công khi inventory còn chỗ.
- [ ] Giới hạn inventory là 5 bông.
- [ ] Khi đầy, không xóa hoa khỏi level và hiện thông báo dễ hiểu.
- [ ] UI biểu diễn được số lượng và loại hoa đang mang.
- [ ] Hoa đã nhặt không xuất hiện lại sau khi load save.

### FR-04 — Phân loại vào giỏ

- [ ] Mỗi giỏ nhận đúng loại hoa được cấu hình.
- [ ] Đặt đúng sẽ giảm inventory một bông và tăng tiến độ tương ứng.
- [ ] Đặt sai loại không làm mất hoa; game giải thích ngắn gọn.
- [ ] Mỗi ID hoa chỉ có thể được đặt một lần.
- [ ] Người chơi nhìn thấy số đã đặt theo từng loại và tổng số.

### FR-05 — Hoàn thành level

- [ ] Level demo hoàn thành khi đủ 90/90 hoa được đặt đúng.
- [ ] Hiện màn hoàn thành riêng, không chỉ thông báo tạm thời.
- [ ] Màn hoàn thành có hành động rõ ràng để chơi lại.
- [ ] Trạng thái hoàn thành được lưu trước khi hiển thị kết quả.

### FR-06 — Save/load offline

- [ ] Lưu inventory và các ID đã đặt vào bộ nhớ cục bộ.
- [ ] Continue khôi phục chính xác trạng thái gần nhất.
- [ ] Save lỗi/không tương thích không làm app crash.
- [ ] Reset tiến độ yêu cầu xác nhận.
- [ ] Game không đòi mạng hoặc tài khoản để chơi phần MVP.

### FR-07 — UI, cài đặt và tạm dừng

- [ ] Menu phân biệt New Game và Continue.
- [ ] Pause có thể vào từ game và quay lại đúng trạng thái.
- [ ] Có điều khiển âm lượng nhạc/SFX và độ nhạy nhìn.
- [ ] Chữ đọc được ở màn điện thoại nhỏ; nút bấm không quá nhỏ.
- [ ] HUD không che mục tiêu hoặc các vùng điều khiển chính.

## 7. Nguyên tắc UX và accessibility

- Dùng ngang màn hình để có vùng nhìn đủ rộng cho FPS.
- Nút tương tác chính luôn ở cùng vị trí và có nhãn hành động theo ngữ cảnh.
- Màu hoa/giỏ luôn đi cùng hình dáng, icon hoặc chữ; không dựa vào màu đơn lẻ.
- Tránh rung màn hình, nhấp nháy nhanh, âm lượng đột ngột hoặc hiệu ứng che vật thể.
- Hỗ trợ pause ngay lập tức; không mất tiến độ khi app bị đưa xuống nền.
- Cho phép giảm/tắt nhạc và hiệu ứng âm thanh.
- Không yêu cầu phản xạ nhanh, thao tác nhiều nút cùng lúc ngoài di chuyển + nhìn.

## 8. Art direction và nội dung

### Hướng hình ảnh

Cozy low-poly 3D, hình khối rõ, màu ấm/pastel, ánh sáng mềm, ít chi tiết nhỏ. Dùng hình học và vật liệu đơn giản để đồng nhất nhiều nguồn asset và phù hợp Android.

### Quy tắc sản xuất

- Chiều cao nhân vật tham chiếu khoảng 1.7 m; mặt quầy khoảng 0.9 m.
- Mỗi loại hoa phải khác silhouette đủ để nhận ra ở khoảng cách chơi.
- Giỏ khác loại bằng cả màu và dấu hiệu hình học.
- Props nền chỉ dùng khi hỗ trợ cảm giác tiệm hoa; không làm khuất hoa/giỏ.
- Asset bên thứ ba phải có entry trong `ASSET_LEDGER.md` trước khi được đóng gói.

### Âm thanh

Âm lượng thấp, vòng lặp nhạc sạch, SFX nhẹ cho nhặt/đặt/sai thao tác/hoàn thành. Không dùng file âm thanh nếu chưa xác minh license cụ thể.

## 9. Nền tảng, hiệu năng và chất lượng

### Yêu cầu nền tảng

- Android là nền tảng phát hành đầu tiên; offline-first.
- Hỗ trợ landscape và nhiều tỷ lệ màn hình.
- Godot stable + export templates phải cùng phiên bản; ghi phiên bản trong README.
- Xuất Android App Bundle cho quy trình phát hành Play Store.

### Mục tiêu hiệu năng nội bộ

- Tối thiểu khoảng 30 FPS ổn định trên điện thoại cấu hình thấp được chọn làm baseline.
- Hướng tới 60 FPS trên máy tầm trung.
- Level tải trong khoảng 5 giây trên thiết bị kiểm tra.
- Không có crash hoặc mất tiến độ trong một phiên chơi 15 phút.
- Hạn chế realtime lights, texture lớn, material trùng và physics không cần thiết.

Các số này là ngưỡng nội bộ ban đầu, cần điều chỉnh sau khi chọn thiết bị Android baseline và đo build thật.

## 10. Bảo mật, riêng tư và dữ liệu

- MVP không cần thu thập dữ liệu cá nhân, tài khoản, quảng cáo hoặc analytics bên thứ ba.
- Save nằm cục bộ trên thiết bị.
- Không thêm SDK/permission Android nếu tính năng không yêu cầu.
- Khai báo Play Console phải đúng với code và SDK có trong bản release.
- Nếu sau này thêm analytics, cloud save, quảng cáo hoặc IAP, cần cập nhật tài liệu sản phẩm và đánh giá chính sách trước khi triển khai.

## 11. Chỉ số thành công

### Trước phát hành — kiểm tra usability

- Ít nhất 4/5 người thử độc lập hiểu mục tiêu mà không được giải thích trực tiếp.
- Ít nhất 4/5 người thử có thể nhặt và đặt hoa đúng sau phần hướng dẫn trong game.
- Không ai mất tiến độ đã lưu trong các tình huống thoát/mở lại đã kiểm tra.
- Không có blocker khiến không thể hoàn thành 90/90 của cấu hình demo.
- Người thử đánh giá điều khiển là “dùng được” hoặc tốt hơn; mọi vấn đề khó chịu được ghi và xử lý.

### Sau phát hành — quan sát nếu có dữ liệu hợp lệ

- Crash-free sessions, tỉ lệ hoàn thành level, số lần Continue thành công, feedback về touch controls.
- Không thêm analytics chỉ để đo các chỉ số này trong MVP; ưu tiên feedback test thủ công và báo cáo crash do Play Console cung cấp.

## 12. Thứ tự demo và phát hành đầy đủ

Ưu tiên hiện tại là demo nội bộ theo DEMO_PLAN.md. Các bước Play Console, store listing và production bên dưới thuộc giai đoạn sau khi demo đạt tiêu chí.

1. Desktop prototype để sửa gameplay nhanh.
2. Android debug build chạy trên điện thoại thật càng sớm càng tốt.
3. Alpha test nhóm nhỏ để phát hiện vấn đề điều khiển/logic.
4. Closed test trên Google Play; thực hiện yêu cầu hiện hành của loại tài khoản nhà phát triển.
5. Sửa lỗi blocker, chốt listing, xuất AAB release.
6. Phát hành theo staged rollout nếu tài khoản/console hỗ trợ, theo dõi crash và phản hồi.

Kế hoạch sprint, checklist asset, lệnh khởi tạo và phần việc tuần nằm trong [kế hoạch triển khai](ke-hoach-little-bloom-android.md). Tiến độ thực hiện theo [roadmap checklist](ROADMAP_CHECKLIST.md).

## 13. Rủi ro sản phẩm

| Rủi ro | Tác động | Hướng xử lý |
|---|---|---|
| Điều khiển FPS trên cảm ứng không thoải mái | Người chơi bỏ trước khi hiểu loop | Prototype trên máy thật tuần đầu; tune joystick/sensitivity trước khi art pass |
| Không nhìn thấy tiến bộ | Sắp xếp hoa cảm giác lặp | Tiến độ từng giỏ, hoa hiện trong giỏ, phản hồi ngay sau thao tác |
| Scope vượt sức solo developer | Trễ phát hành | Khóa demo một tiệm hai tầng/chín loại/90 hoa; giữ 504 làm cấu hình thử tải; đo Android thật |
| Asset khác phong cách hoặc license không rõ | Giảm chất lượng hoặc rủi ro phát hành | Giới hạn nguồn, ưu tiên CC0/giấy phép rõ, lưu hồ sơ từng file |
| Save lỗi | Mất tiến độ và đánh giá xấu | Schema version, kiểm tra dữ liệu, lưu sau hành động, test phục hồi |
| Thiết bị Android yếu | FPS giảm, máy nóng, crash | Đo trên máy baseline sớm; giảm lights/texture và hiệu ứng theo số đo |

## 14. Các quyết định còn mở

Các mục này không chặn việc hoàn thiện prototype, nhưng cần được chốt trước khi làm store listing/release candidate:

- Tên thương mại cuối cùng và kiểm tra khả dụng trên Google Play.
- Android minimum version và thiết bị cấu hình thấp làm baseline.
- Ngôn ngữ phát hành ban đầu (dự kiến tiếng Việt; có thể bổ sung tiếng Anh nếu đủ thời gian).
- Mô hình giá/monetization sau MVP; hiện chưa đưa quảng cáo hoặc IAP vào scope.
- Số liệu hiệu năng cuối sau khi có điện thoại kiểm tra.
- Nội dung privacy policy và store disclosures theo SDK/tính năng thực tế.

## 15. Definition of Done cho demo

Demo được xem là hoàn thành khi:

- [ ] Người chơi mới hiểu mục tiêu và hoàn tất một level mà không cần trợ giúp ngoài game.
- [ ] Di chuyển, nhìn, nhặt và đặt hoạt động trên Android bằng cảm ứng.
- [ ] Phân loại đúng/sai, inventory 5 bông và tiến độ từng loại hoạt động chính xác.
- [ ] Có màn hoàn thành và chơi lại.
- [ ] Save/load offline phục hồi trạng thái chính xác; reset yêu cầu xác nhận.
- [ ] Hai thiết bị Android mục tiêu chạy ổn theo ngưỡng nội bộ.
- [ ] Không còn blocker hoặc mất save trong kiểm tra release candidate.
- [ ] Asset/license và credits đúng với nội dung được đóng gói; có bản Android demo cài được. Listing và AAB production thuộc giai đoạn sau.
- [ ] Ít nhất 4/5 người chơi mới hoàn thành giỏ đầu trong tối đa 3 phút, không được nhắc ngoài game; mục tiêu thiết kế là 2–3 phút, không cố tình kéo dài người chơi nhanh.
- [ ] Không yêu cầu leo tầng hai trước khi hoàn thành giỏ mở đầu.

## 16. Quy tắc thay đổi phạm vi

Mỗi tính năng mới cần trả lời được ba câu hỏi: nhu cầu người chơi nào được giải quyết, có bắt buộc cho MVP không, và nó làm tăng thời gian/độ phức tạp bao nhiêu. Nếu không làm vòng chơi cơ bản rõ hơn hoặc ổn định hơn, đưa vào backlog sau phát hành.

## 17. Quyết định demo ngày 19/11/2026

- Người dùng chọn làm một cửa hàng demo trước; các hệ thống mở rộng từ bản Claude để sau.
- Ưu tiên giỏ đầu hoàn thành trong 2–3 phút và sửa dứt điểm đường đi hai tầng.
- 90 bông ban đầu là mốc cân chỉnh thiết kế. D1 đã triển khai mốc này thành chế độ riêng.
- Người dùng đã xác nhận giữ 9 loại hiện có trong demo; đổi loài sau. Khi đổi phải có model, nhãn giỏ, tên hiển thị và kế hoạch chuyển save.
- Thứ tự tài liệu: PRODUCT_SPEC.md → DEMO_PLAN.md → ROADMAP_CHECKLIST.md. Kế hoạch 16–20 tuần là tham khảo dài hạn.

## 18. Tiếp nhận kế hoạch bổ sung v2 ngày 21/11/2026

Đã lưu [bản Claude v2](docs/reference/CLAUDE_PLAN_V2_2026-11-19.txt) làm nguồn tham khảo và [đối chiếu vào kế hoạch demo](DEMO_PLAN.md#đối-chiếu-bản-claude-v2--21112026). Bổ sung kiểm kê kiến trúc, danh sách lỗi, số đo nền và bằng chứng kiểm thử theo từng task. Không thay phạm vi demo đã chốt: 9 loài hiện có, một tiệm hai tầng, demo 90 bông và giỏ đầu 10 bông. D1 đã tách chế độ 504 để thử tải, D2 đã thêm bố cục giỏ đầu và giữ được tiến độ demo D1.

Các đề xuất bản 1.0/1.1, quảng cáo, lịch 18 tuần và tiêu chí khác demo trong bản nguồn không tự trở thành công việc của sprint hiện tại. Những thông tin chính sách, tương thích plugin và giấy phép phải được xác minh khi mở task liên quan.
