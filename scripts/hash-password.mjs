import { pbkdf2Sync, randomBytes } from "node:crypto";
import { argv, exit } from "node:process";

const password = argv[2];
if (!password) {
  console.error("Usage: node scripts/hash-password.mjs 'your password'");
  exit(1);
}

const iterations = 100000;
const salt = randomBytes(16);
const hash = pbkdf2Sync(password, salt, iterations, 32, "sha256");

console.log([
  "pbkdf2_sha256",
  iterations,
  base64url(salt),
  base64url(hash),
].join("$"));

function base64url(buffer) {
  return Buffer.from(buffer)
    .toString("base64")
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/g, "");
}
