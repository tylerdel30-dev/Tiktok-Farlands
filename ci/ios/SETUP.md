# iOS IPA Build Setup (Windows + GitHub Actions)

Use this once to enable signed `.ipa` builds from Windows.

## 1) Prerequisites

- Apple Developer account
- iOS Distribution or Development certificate exported as `.p12`
- Provisioning profile `.mobileprovision`
- No Mac needed locally (workflow generates `.xcodeproj` using XcodeGen)

## 2) Add GitHub Secrets

Open GitHub repo -> Settings -> Secrets and variables -> Actions, then add:

- `BUILD_CERTIFICATE_BASE64` (base64 of your `.p12`)
- `P12_PASSWORD` (password used when exporting `.p12`)
- `BUILD_PROVISION_PROFILE_BASE64` (base64 of your `.mobileprovision`)
- `KEYCHAIN_PASSWORD` (any strong random string)
- `APPLE_TEAM_ID` (Apple Developer team ID)
- `BUNDLE_ID` (ex: `com.yourname.tiktokfarlands`)
- `PROFILE_NAME` (exact provisioning profile name)
- `TIKTOK_CLIENT_KEY`
- `TIKTOK_CLIENT_SECRET`
- `TIKTOK_REDIRECT_URI`
- `TIKTOK_RECOMMENDATIONS_ENDPOINT` (optional)
- `TIKTOK_TOKEN_EXCHANGE_ENDPOINT` (optional)

## 3) Base64 commands

On PowerShell:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("path\to\cert.p12"))
[Convert]::ToBase64String([IO.File]::ReadAllBytes("path\to\profile.mobileprovision"))
```

## 4) Run workflow

1. Push to GitHub.
2. Open Actions -> `Build Signed iOS IPA`.
3. Click `Run workflow`.
4. Choose export method (`ad-hoc`, `development`, or `app-store`).
5. Download IPA artifact named `TiktokFarlands-ipa`.

## 5) Important

- If workflow says missing `project.yml`, ensure `Tiktok Farlands/project.yml` is committed.
- This repo already includes workflow file: `.github/workflows/ios-ipa.yml`.
