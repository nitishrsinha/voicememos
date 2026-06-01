import { randomBytes } from "node:crypto";
import { argv } from "node:process";

const issuer = encodeURIComponent(argv[2] || "Voice Memos");
const account = encodeURIComponent(argv[3] || "owner");
const secret = base32(randomBytes(20));

console.log(`Secret: ${secret}`);
console.log(`URI: otpauth://totp/${issuer}:${account}?secret=${secret}&issuer=${issuer}&digits=6&period=30`);

function base32(buffer) {
  const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
  let bits = "";
  for (const byte of buffer) bits += byte.toString(2).padStart(8, "0");
  let out = "";
  for (let i = 0; i < bits.length; i += 5) {
    const chunk = bits.slice(i, i + 5).padEnd(5, "0");
    out += alphabet[parseInt(chunk, 2)];
  }
  return out;
}
