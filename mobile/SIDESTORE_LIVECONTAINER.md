# SideStore and LiveContainer support

This project can support both SideStore and LiveContainer by shipping a clean
iOS `.ipa` with no restricted entitlements and with app deep links configured.

## 1) Prepare iOS folder

From `mobile/`:

```bash
flutter create .
flutter pub get
```

## 2) Apply OAuth deep-link settings

Follow `IOS_SETUP.md` first so `hotify://auth/callback` works.

## 3) Xcode signing profile

In `ios/Runner.xcworkspace`:

- Set a unique Bundle Identifier (example: `com.tyler.hotify`)
- Set your Apple Team
- Keep signing automatic unless you use a custom cert workflow

## 4) Keep entitlements SideStore-friendly

Do not add capabilities that require special Apple approval unless needed.
For best compatibility keep only:

- default app sandbox
- network access (normal)

Avoid adding Push, App Groups, iCloud, or Sign In with Apple unless you
explicitly configure matching profiles and need them.

## 5) Build release and export IPA

```bash
flutter build ios --release
```

Then archive/export in Xcode:

- Product -> Archive
- Distribute App -> Ad Hoc (or Development for personal testing)
- Export `.ipa`

## 6) Install with SideStore

- Open SideStore on iPhone
- Import exported `.ipa`
- Sign and install
- Trust the certificate/profile in iOS settings if prompted

## 7) Use with LiveContainer

LiveContainer can run many sideloaded apps, but compatibility depends on:

- app size and memory usage
- dynamic frameworks/plugins in the app
- iOS version and LiveContainer build

If launch fails in LiveContainer:

- test the same IPA in SideStore first
- disable heavy plugins not required for MVP
- rebuild release IPA and re-import

## 8) Callback checklist

Before testing login on device:

- `MOBILE_REDIRECT_URI=hotify://auth/callback` in backend `.env`
- `CFBundleURLSchemes` includes `hotify`
