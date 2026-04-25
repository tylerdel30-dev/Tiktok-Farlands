import dotenv from "dotenv";

dotenv.config();

export const config = {
  port: Number(process.env.PORT ?? 4000),
  clientUrl: process.env.CLIENT_URL ?? "http://localhost:3000",
  mobileRedirectUri: process.env.MOBILE_REDIRECT_URI ?? "hotify://auth/callback"
};
