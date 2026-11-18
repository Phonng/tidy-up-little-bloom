# Google Play listing preparation — Little Bloom

Draft for the first Vietnamese listing. Final values must match the tested release build and the live Play Console form.

## Listing text

**App name**

Little Bloom

**Short description**

Dọn tiệm hoa nhỏ bằng góc nhìn thứ nhất, thư giãn không áp lực

**Full description**

Ghé thăm một tiệm hoa nhỏ và giúp nơi đây trở nên ngăn nắp hơn.

Khám phá căn phòng ở góc nhìn thứ nhất, nhặt những bông hoa đang nằm trên sàn rồi xếp chúng vào đúng giỏ. Mỗi lần mang được tối đa năm bông, vì vậy hãy chọn đường đi và sắp xếp từng lượt theo nhịp của riêng bạn.

• Tìm và phân loại chín loại hoa ở cả hai tầng của tiệm.
• Theo dõi tiến độ của từng loại hoa và cả căn phòng.
• Lưu tiến độ trên thiết bị để có thể quay lại sau.
• Chơi ngoại tuyến, không tính giờ và không có hình phạt.

Little Bloom là một trải nghiệm dọn dẹp nhỏ, ấm áp dành cho những lúc bạn muốn chậm lại vài phút.

## Console fields still to complete

- **Category:** Game → Casual (confirm the current category options in Play Console).
- **Support contact:** add a monitored developer email; it was not supplied in the project context.
- **App icon:** `store/google_play_icon_512.png` (512×512 RGBA PNG, under 1 MB, generated from the original project SVG).
- **App icon alt text:** Pink flower with a yellow center and green stem on a warm cream background.
- **Feature graphic:** `store/feature_graphic_1024x500.png` (1024×500 RGB PNG, no alpha; original vector illustration).
- **Feature graphic alt text:** Illustration of a warm flower shop with a window, baskets, and colorful flowers.
- **Phone screenshots:** still need to be captured from the tested build. Play requires two screenshots across different device types; three 16:9 landscape gameplay screenshots at 1920×1080 or higher are recommended for games. Do not use mockups that imply unimplemented features.
- **Content rating:** draft facts for the Play Console questionnaire: flower sorting, no violence, user-generated content, social features, gambling, ads, or purchases. Confirm all answers against the shipped build.
- **Ads declaration:** current build contains no ad SDK or ad placements; confirm this remains true in the final export.
- **Privacy policy:** draft is in `PRIVACY_POLICY.md` and is shown in the in-game menu. Host it at a public, non-editable HTTPS URL and add that URL to Play Console; provide a monitored support contact in the listing first.
- **Data safety:** the current project has no account, ads, analytics, internet permission, or third-party SDK and stores progress/settings locally. Treat “no data collected/shared” as a draft until the final manifest and dependencies are checked; complete the Play form for the final track.
- **Target audience, ads declaration, app access, and country availability:** complete based on the actual release and account settings.

## Testing-track note

For personal Play developer accounts created after 13 November 2023, Google currently requires a closed test with at least 12 testers opted in continuously for 14 days before applying for production access. Check the account's Play Console dashboard because eligibility and requirements depend on account type and may change. See [Google Play's testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465).

## Official references

- [Google Play target API requirement](https://developer.android.com/google/play/requirements/target-sdk)
- [Add preview assets to a store listing](https://support.google.com/googleplay/android-developer/answer/9866151)
- [Data safety section](https://support.google.com/googleplay/android-developer/answer/10787469)
