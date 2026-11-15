# Database

Cinque tabelle: `ps_brands`, `ps_models`, `ps_string_sections`, `ps_gauge_reference`,
`ps_official_steinway`, più `ps_admins` e `ps_contributions` per l'area riservata.

## Tre modi per creare il database

| Percorso | Quando usarlo | Comandi |
|---|---|---|
| **Migrazioni CI4** | sviluppo, ambiente con `php spark` | `php spark migrate` + `php spark db:seed PianoStringSeeder` + `php spark db:seed AdminSeeder` + `mysql ... < database/seed-brands.sql` |
| **MySQL locale** | installazione rapida, MAMP | `mysql ... < database/schema.sql` + `seed.sql` + `seed-brands.sql` |
| **Import singolo** | TiDB Cloud SQL Editor, phpMyAdmin | `database/tidb-full.sql` (tutto in un file) |

`seed-brands.sql` va **sempre** dopo `seed.sql`: quest'ultimo crea le marche
Yamaha e Kawai (vuote) e i modelli Steinway, il primo le riempie.

`tidb-full.sql` è **generato**: non modificarlo a mano. Dopo aver cambiato
`schema.sql`, `seed.sql` o `seed-brands.sql`, rigeneralo con:

```bash
./database/build-tidb-full.sh
```

## Discrepanze note rispetto al database di produzione

Segnalate, non corrette (i dati esistenti non si toccano senza verifica):

1. **Steinway Model C** — qui 15 sezioni, in produzione 16: manca la suddivisione
   `81-84 = 13.5` (qui le corde 81-88 sono un unico tratto a 13.0). La tabella
   ufficiale Steinway per `Model C > 58952` riporta `13.5 = 4 note` e `13 = 0`,
   quindi nessuna delle due versioni combacia esattamente con la fonte.
2. **`ps_gauge_reference`** — qui 36 righe, in produzione 41 (mancano 7.0, 7.5,
   8.0, 8.5, 10.5). Nessuna sezione usa quei calibri, quindi nulla si rompe.
   Alcuni valori differiscono comunque (es. gauge 11: `resist_kg` 95 qui, 105
   in produzione).
