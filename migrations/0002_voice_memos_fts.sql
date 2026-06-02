CREATE VIRTUAL TABLE IF NOT EXISTS voice_memos_fts
USING fts5(
  memo_id UNINDEXED,
  transcript,
  mode,
  local_date UNINDEXED
);

INSERT INTO voice_memos_fts (memo_id, transcript, mode, local_date)
SELECT id, transcript, mode, local_date
FROM voice_memos
WHERE NOT EXISTS (
  SELECT 1 FROM voice_memos_fts WHERE memo_id = voice_memos.id
);
