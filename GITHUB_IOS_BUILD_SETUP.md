# GitHub iOS IPA build setup

This repo now includes `.github/workflows/build-ios-ipa.yml`.

## 1) Add required GitHub Secrets

In GitHub -> Settings -> Secrets and variables -> Actions, add:

- `IOS_P12_BASE64` - base64 of your Apple signing cert (`.p12`)
- `IOS_P12_PASSWORD` - password used when exporting `.p12`
- `IOS_PROFILE_BASE64` - base64 of your provisioning profile (`.mobileprovision`)
- `IOS_DEVELOPMENT_TEAM` - Apple Team ID (example: `AB12C3D4E5`)
- `IOS_BUNDLE_ID` - bundle id (example: `com.tyler.hotify`)

## 2) Create base64 values (on Mac)

```bash
base64 -i Certificates.p12 | pbcopy
base64 -i Hotify.mobileprovision | pbcopy
```

Paste clipboard output into the matching GitHub secret values.

## 3) Run build

- Push to `main`, or
- Actions -> **Build iOS IPA** -> **Run workflow**

When successful, download artifact:

- `hotify-ipa` -> contains `.ipa`

## 4) Install

Use SideStore (or another sideload method) to import the `.ipa`.

## Notes

- iOS IPA signing still requires valid Apple cert/profile.
- The workflow bootstraps missing iOS Flutter project files using `flutter create .`.
