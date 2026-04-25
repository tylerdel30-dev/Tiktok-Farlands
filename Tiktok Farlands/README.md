# Tiktok Farlands (Swift iOS App)

This is a full SwiftUI iOS app implementation named `Tiktok Farlands` with:

- TikTok OAuth login flow via `ASWebAuthenticationSession`
- token exchange layer (backend endpoint + local fallback)
- recommendation fetch layer for TikTok-backed videos (via your backend/API integration)
- strict hashtag filtering that only allows:

- `#tiktokfarlands`
- `#farlands`
- `#ishoweyes`

## What is implemented

- Login-first UI (`Continue with TikTok`)
- Keychain-backed session storage
- OAuth callback state validation
- Vertical/page-style feed UI + inline video playback
- `Video` model
- `TikTokFeedService` with network fetch + local fallback dataset
- `FeedViewModel` async loading + pull-to-refresh

## Real TikTok setup required

Before it can fetch your real recommendations, configure your local `Secrets.xcconfig` and wire it into Xcode:

- Required keys in `Secrets.xcconfig`:
  - `TIKTOK_CLIENT_KEY`
  - `TIKTOK_CLIENT_SECRET`
  - `TIKTOK_REDIRECT_URI`
- Optional:
  - `TIKTOK_RECOMMENDATIONS_ENDPOINT`
  - `TIKTOK_TOKEN_EXCHANGE_ENDPOINT`

Xcode steps:

1. Open project settings -> your app target -> **Build Settings**.
2. Set **Base Configuration** for Debug/Release to `Secrets.xcconfig`.
3. In `Info.plist`, add keys:
   - `TIKTOK_CLIENT_KEY` -> `$(TIKTOK_CLIENT_KEY)`
   - `TIKTOK_CLIENT_SECRET` -> `$(TIKTOK_CLIENT_SECRET)`
   - `TIKTOK_REDIRECT_URI` -> `$(TIKTOK_REDIRECT_URI)`
   - `TIKTOK_RECOMMENDATIONS_ENDPOINT` -> `$(TIKTOK_RECOMMENDATIONS_ENDPOINT)` (optional)
   - `TIKTOK_TOKEN_EXCHANGE_ENDPOINT` -> `$(TIKTOK_TOKEN_EXCHANGE_ENDPOINT)` (optional)

The app reads these values at runtime via `AppConfig` from environment/Info.plist so secrets are not hardcoded in source files.

Why backend is needed:

- TikTok APIs typically require approved app credentials and server-side token exchange.
- The app is already wired to send bearer auth + requested tags to your endpoint.

## Hashtag enforcement

The app always filters recommendations again on-device and keeps only videos that contain at least one of the allowed tags (case-insensitive).

## Open in Xcode and run

1. Create a new **iOS App** project in Xcode named `TiktokFarlands` (Swift + SwiftUI).
2. Replace the generated source files with files in this folder.
3. Add URL type for callback scheme (`tiktokfarlands`) in `Info.plist`.
4. Build and run on simulator/device.

## Build signed IPA from Windows

Use the GitHub Actions pipeline files in:

- `.github/workflows/ios-ipa.yml`
- `ci/ios/SETUP.md`
- `Tiktok Farlands/project.yml`

This lets you build/sign on GitHub's macOS runner and download the IPA artifact on Windows.
