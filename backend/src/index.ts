import cors from "cors";
import express from "express";
import { config } from "./config.js";

const app = express();
app.use(express.json());
app.use(cors({ origin: config.clientUrl }));

app.get("/health", (_req, res) => {
  res.json({ ok: true });
});

app.listen(config.port, () => {
  console.log(`Hotify backend listening on http://localhost:${config.port}`);
});
