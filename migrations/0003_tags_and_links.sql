ALTER TABLE voice_memos ADD COLUMN tags TEXT NOT NULL DEFAULT '';

CREATE TABLE IF NOT EXISTS links (
  id TEXT PRIMARY KEY,
  created_at TEXT NOT NULL,
  url TEXT NOT NULL,
  label TEXT NOT NULL,
  folder TEXT NOT NULL DEFAULT ''
);

CREATE INDEX IF NOT EXISTS idx_links_folder ON links(folder);
