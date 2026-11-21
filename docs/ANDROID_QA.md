# Little Bloom · kiểm thử Android D4

Cập nhật 21/11/2026.

## Bản thử an toàn với save cũ

Preset **Android QA** dùng mẫu APK debug Godot 4.7.2, ARM64. Mã ứng dụng là `com.phonng.littlebloom.qa`, cài cạnh Little Bloom `com.phonng.littlebloom`. Android cấp thư mục dữ liệu riêng cho mỗi ứng dụng. Demo và thử tải tiếp tục dùng hai file save riêng trong từng bản cài. Khi thử, chỉ thao tác trên **Little Bloom QA**.

Android Play vẫn là preset dùng để xuất AAB. Hướng dẫn chuẩn bị SDK và Java nằm trong [ANDROID_RELEASE_GUIDE.md](../ANDROID_RELEASE_GUIDE.md). Tài liệu Godot mô tả thiết lập mẫu và đường dẫn công cụ. [Godot Android export](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html)

Để xuất lại bằng Godot đã có export template, Java 17 và Android build-tools:

```sh
mkdir -p build
godot --headless --path . --import
godot --headless --path . --export-debug "Android QA" build/LittleBloom-QA.apk
```

Dùng cùng khóa debug khi cập nhật bản QA để Android giữ tiến độ QA. Khóa được dùng cho bản build cục bộ nằm trong thư mục `.godot` bị Git bỏ qua. Bản chính có mã ứng dụng riêng.

## APK đã xuất

File cục bộ: `build/LittleBloom-QA.apk` (28.5 MB). Godot 4.7.2 xuất thành công với Java 17 và Android Build-Tools 35.0.1. APK dùng ARM64, Android 7.0 trở lên (API 24) và target SDK 36 theo manifest. Android Build-Tools xác minh chữ ký APK v2/v3. Kiểm tra nội dung gói xác nhận có cờ FPS QA và không kèm file save hay khóa ký.

SHA-256: `864338702739bf361c224b7282e98b6d78694273577d2302f1871931761e8adf`

## Kết quả trước khi có điện thoại

| Hạng mục | Kết quả |
|---|---|
| Hai ngón di chuyển và nhìn | Qua kiểm tra tín hiệu touch mô phỏng trên Godot Mac |
| Ngón thứ ba và nút nhặt/đặt | Ngón mới không giành quyền nhìn. Nút nhặt/đặt kích hoạt một lần khi giữ hai ngón. Hủy hoặc thả ngoài nút không kích hoạt |
| Tạm dừng và vào nền | Tình huống mô phỏng đã xóa quyền các ngón, vận tốc di chuyển và lệnh đang chờ |
| Lưu và mở lại | Tiến trình Godot mới khôi phục một bông đã đặt, một bông đang mang và các ID chưa nhặt. Save 504 mẫu nguyên từng byte và mở được |
| Hoàn thành demo | Godot Mac chạy 90/90 với sự kiện chạm nút nhặt/đặt mô phỏng |
| FPS trên Android | Chưa đo |
| Cài và chơi trên Android thật | Chưa có điện thoại để kết nối. ADB không liệt kê thiết bị |

## Kịch bản cho điện thoại thật

1. Ghi model, phiên bản Android, độ phân giải và mã bản build. Kết nối điện thoại qua USB, bật gỡ lỗi USB và chấp nhận khóa ADB trên điện thoại.
2. Cài APK QA, mở biểu tượng **Little Bloom QA** và chọn **Demo · 90 bông**.
3. Giữ joystick trái và vuốt phải. Chạm nhặt/đặt khi một hoặc hai ngón kia đang giữ. Thử một ngón chạm thừa, tạm dừng và quay lại. Ghi lỗi nếu camera đổi ngón điều khiển hoặc nhân vật tự đi tiếp.
4. Đặt một bông rồi nhặt một bông khác. Bấm Home, đóng app và mở lại. Chọn **Tiếp tục**, đối chiếu số hoa đã xếp, hoa đang mang và vị trí bông còn lại. Vị trí người chơi trở về spawn.
5. Thu FPS trong 10 phút thực chơi, gồm sàn tầng trệt, đầu cầu thang và khu nhiều hoa tầng hai. Bộ đếm trong APK QA hiển thị và ghi điểm lấy mẫu xấp xỉ mỗi giây khi game đang hoạt động. Dừng lấy mẫu khi tạm dừng hoặc app xuống nền. Ghi số mẫu, trung bình, thấp nhất, đoạn giảm mạnh và tên máy. Mục tiêu ít nhất 30 FPS ổn định trên máy baseline.
6. Xếp đủ 90 bông, gồm 8 bông trên tủ. Ghi rằng màn hoàn thành xuất hiện, tiến độ 90/90 nạp được sau khi mở lại và Chơi lại vẫn tạo đủ 90 bông.

```sh
adb devices -l
adb install -r build/LittleBloom-QA.apk
adb logcat | grep LB_QA_FPS
```

Chạy các lệnh ADB sau khi điện thoại của bạn xuất hiện ở trạng thái `device`. [Android Debug Bridge](https://developer.android.com/tools/adb)
