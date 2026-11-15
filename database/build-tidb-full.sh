#!/usr/bin/env bash
# Rigenera database/tidb-full.sql da schema.sql + seed.sql + seed-brands.sql.
# Uso: ./database/build-tidb-full.sh
set -euo pipefail
cd "$(dirname "$0")"

{
  cat <<'HEADER'
-- ============================================================================
--  PianoStringDB — import completo (schema + tutti i dati)
--
--  Per database gestiti dove non puoi usare la riga di comando
--  (TiDB Cloud SQL Editor, phpMyAdmin): incolla questo file ed esegui.
--
--  ATTENZIONE: file GENERATO. Non modificarlo a mano.
--  Sorgenti: database/schema.sql + database/seed.sql + database/seed-brands.sql
--  Rigeneralo con:
--    ./database/build-tidb-full.sh
--
--  Contenuto: 5 marche, 160 modelli, 2350 sezioni, tabella calibri,
--  guida ufficiale Steinway, 1 utente admin (admin / admin — da cambiare).
-- ============================================================================

HEADER
  cat schema.sql
  echo
  cat seed.sql
  echo
  cat seed-brands.sql
} > tidb-full.sql

echo "database/tidb-full.sql rigenerato ($(wc -c < tidb-full.sql) byte)"
