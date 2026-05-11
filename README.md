# PianoStringDB

Open database of piano string measurements. A reference tool for piano technicians, restorers, and enthusiasts.

- **REST API** — CodeIgniter 4 backend
- **Frontend** — Static HTML/JS, no build tools, works out of the box
- **Admin panel** — Approve/reject community contributions (`/admin`)
- **Bilingual** — English and Italian UI

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

# 6. Create an admin user
php spark db:seed AdminSeeder
```

### Serve

Point your web server to `backend/public/` (or use MAMP).

- **Frontend:** `frontend/index.html`
- **Admin:** `backend/public/admin` (CI4 controller views)
- **API:** `backend/public/api/...`

## API Endpoints

| Endpoint | Description |
|---|---|
| `GET /api/brands` | List all brands |
| `GET /api/models?brand=steinway` | List models by brand slug |
| `GET /api/strings/S` | Full string table for model S |
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
