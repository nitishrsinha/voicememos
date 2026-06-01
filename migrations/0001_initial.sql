CREATE TABLE IF NOT EXISTS voice_memos (
  id TEXT PRIMARY KEY,
  created_at TEXT NOT NULL,
  local_date TEXT NOT NULL,
  transcript TEXT NOT NULL,
  duration_seconds INTEGER,
  mode TEXT NOT NULL DEFAULT 'free',
  source TEXT NOT NULL DEFAULT 'web',
  included_in_report_id TEXT
);

CREATE INDEX IF NOT EXISTS idx_voice_memos_local_date_created
  ON voice_memos(local_date, created_at);

CREATE INDEX IF NOT EXISTS idx_voice_memos_report
  ON voice_memos(included_in_report_id);

CREATE TABLE IF NOT EXISTS daily_reports (
  id TEXT PRIMARY KEY,
  report_date TEXT NOT NULL UNIQUE,
  body TEXT NOT NULL,
  memo_count INTEGER NOT NULL DEFAULT 0,
  sent_at TEXT NOT NULL
);
