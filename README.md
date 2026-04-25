# Hotify

Hotify is a starter project with:

- A Flutter mobile frontend
- A Node.js + Express + TypeScript backend

## Project structure

- `backend` - API server
- `mobile` - Flutter app

## Important

Do not hardcode secrets. Use environment variables in `backend/.env`.

## Quick start

### 1) Backend

```bash
cd backend
npm install
cp .env.example .env
npm run dev
```

### 2) Flutter app

```bash
cd mobile
flutter pub get
flutter run
```

Set `API_BASE_URL` in `mobile/lib/config.dart` to your running backend URL.

For iPhone OAuth deep-link setup, follow `mobile/IOS_SETUP.md`.
For SideStore/LiveContainer packaging and install workflow, follow
`mobile/SIDESTORE_LIVECONTAINER.md`.
For Windows-to-iOS cloud builds with GitHub Actions, follow
`GITHUB_IOS_BUILD_SETUP.md`.
