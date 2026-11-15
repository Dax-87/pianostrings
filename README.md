# PianoStringDB

Open database of piano string measurements. A reference tool for piano technicians, restorers, and enthusiasts.

- **REST API** — CodeIgniter 4 backend
- **Frontend** — Static HTML/JS, no build tools, works out of the box
- **Admin panel** — Approve/reject community contributions (`/admin`)
- **Bilingual** — English and Italian UI

| Brand | Models | Sections | Source |
|---|---|---|---|
| Steinway & Sons | 8 | 126 | Official Steinway wire guide |
| Yamaha | 31 | 431 | Piano Parts Catalog 2012, § 5-1…5-3, 8-1…8-12 |
| Kawai | 116 | 1611 | Kawai Acoustic Piano Parts List, Ver. 2001, p. 51-58 |
| Estonia | 4 | 145 | «Мензуры роялей Estonia» (4 model variants) |
| August Förster | 1 | 37 | «Мензура рояля August Förster», 275 cm |

Yamaha and Kawai do not publish core and copper diameters for wound bass
strings: those sections are stored with `type = 'wound'` and `gauge = NULL`.
For Yamaha the exact string is identified by the maker part number
(`part_no_from` / `part_no_to`).

## Quick start

### Requirements

- PHP 8.2+
- MySQL 8+
- MAMP / XAMPP / LAMP

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/Dax-87/pianostrings.git
cd pianostrings

# 2. Install backend dependencies
cd backend
composer install
cp env .env

# 3. Configure .env
#    Edit backend/.env — set your database credentials:
#   database.default.hostname = localhost
#   database.default.database = pianostrings_db
#   database.default.username = root
#   database.default.password = root

# 4. Create the database
mysql -u root -p -e "CREATE DATABASE pianostrings_db"

# 5. Run migrations and seed
php spark migrate
php spark db:seed PianoStringSeeder

# 5b. Load Yamaha, Kawai, Estonia and August Förster (~2200 sections)
mysql -u root -p pianostrings_db < database/seed-brands.sql

# 6. Create an admin user
php spark db:seed AdminSeeder
```

### Serve

Point your web server to `backend/public/` (or use MAMP).

- **Frontend:** `frontend/index.html`
- **Admin:** `backend/public/admin` (CI4 controller views)
- **API:** `backend/public/api/...`

## Vercel deployment (serverless API)

`api/index.js` connects to TiDB Cloud and reads the connection settings from
environment variables — there are no credentials in the repository:

| Variable | Required |
|---|---|
| `DB_HOST` | yes |
| `DB_USER` | yes |
| `DB_PASSWORD` | yes |
| `DB_PORT` | no (default `4000`) |
| `DB_NAME` | no (default `pianostrings_db`) |

The frontend (`frontend/index.html`) is served statically by Vercel; the
serverless function is rewritten from `/api/*`. The same schema and seed files
must be applied to that database.

## API Endpoints

| Endpoint | Description |
|---|---|
| `GET /api/brands` | List all brands |
| `GET /api/models?brand=steinway` | List models by brand slug |
| `GET /api/strings/S` | Full string table for model S |

Each string also carries `strings_per_note` (1/2/3) and `part_no_from` /
`part_no_to`. `gauge` is `null` for wound strings whose diameter the maker
does not publish, and `type` can be `wound` (winding type not stated).
| `GET /api/gauge-reference` | Complete European gauge table |
| `GET /api/official-steinway` | Steinway official wire guide |
| `POST /api/auth/login` | Admin login |
| `POST /api/auth/logout` | Admin logout |
| `GET /api/admin/contributions` | List contributions (auth) |
| `POST /api/admin/contributions/{id}/approve` | Approve (auth) |
| `POST /api/admin/contributions/{id}/reject` | Reject (auth) |
| `POST /api/contributions` | Submit a new contribution (public) |

## How to contribute

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide.

**Quick version:** Use the **Contribute** tab in the web app to fill out the form, or upload a YAML file directly. Alternatively, copy `contrib/example.yaml`, fill in the string sections for your piano model, and submit a Pull Request on GitHub. Only specify brand, model, and gauge numbers — the system calculates diameters automatically.

## License

MIT
