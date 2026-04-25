# iOS setup

Use these steps after generating the full Flutter iOS project (`flutter create .` if needed).

## 1) Add URL scheme for callback

In `ios/Runner/Info.plist`, add:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string>hotify-auth</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>hotify</string>
    </array>
  </dict>
</array>
```

## 2) Backend env

Set this in `backend/.env`:

```env
MOBILE_REDIRECT_URI=hotify://auth/callback
```
