const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'gateway01.eu-central-1.prod.aws.tidbcloud.com',
  port: parseInt(process.env.DB_PORT || '4000'),
  user: process.env.DB_USER || 'MVo3iYEZNmbFX1Y.root',
  password: process.env.DB_PASSWORD || 'gIYzGORgr3mLoe3c',
  database: process.env.DB_NAME || 'pianostrings_db',
  ssl: { rejectUnauthorized: false },
  waitForConnections: true,
  connectionLimit: 5,
  enableKeepAlive: true,
});

function json(res, data, status = 200) {
  res.status(status).setHeader('Content-Type', 'application/json').end(JSON.stringify(data));
}

function error(res, msg, status = 400) {
  json(res, { message: msg }, status);
}

async function getAuthUser(authHeader) {
  if (!authHeader || !authHeader.startsWith('Bearer ')) return null;
  const token = authHeader.slice(7);
  const [rows] = await pool.query('SELECT id, username FROM ps_admins WHERE token = ?', [token]);
  return rows.length ? rows[0] : null;
}

const CHROMATIC = ['C','C#','D','D#','E','F','F#','G','G#','A','A#','B'];

function stringToNote(n) {
  const midi = 20 + n;
  const oct = Math.floor(midi / 12) - 1;
  return CHROMATIC[midi % 12] + oct;
}

function parseBody(req) {
  return new Promise((resolve, reject) => {
    let data = '';
    req.on('data', chunk => data += chunk);
    req.on('end', () => {
      try { resolve(JSON.parse(data || '{}')); }
      catch (e) { reject(new Error('Invalid JSON')); }
    });
    req.on('error', reject);
  });
}

module.exports = async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);
  const path = url.pathname.replace(/\/+$/, '');
  const method = req.method;
  const segs = path.split('/').filter(Boolean);

  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  if (method === 'OPTIONS') return res.status(204).end();

  try {
    // GET /api/brands
    if (method === 'GET' && path === '/api/brands') {
      const [rows] = await pool.query('SELECT * FROM ps_brands ORDER BY name');
      return json(res, rows);
    }

    // GET /api/brands/:slug
    if (method === 'GET' && segs.length === 3 && segs[0] === 'api' && segs[1] === 'brands') {
      const [rows] = await pool.query('SELECT * FROM ps_brands WHERE slug = ?', [segs[2]]);
      return rows.length ? json(res, rows[0]) : error(res, 'Brand not found', 404);
    }

    // GET /api/models
    if (method === 'GET' && path === '/api/models') {
      const brandSlug = url.searchParams.get('brand');
      if (brandSlug) {
        const [rows] = await pool.query(
          'SELECT m.* FROM ps_models m JOIN ps_brands b ON m.brand_id = b.id WHERE b.slug = ? ORDER BY m.sort_order',
          [brandSlug]
        );
        return json(res, rows);
      }
      const [rows] = await pool.query('SELECT * FROM ps_models ORDER BY sort_order');
      return json(res, rows);
    }

    // GET /api/models/:code
    if (method === 'GET' && segs.length === 3 && segs[0] === 'api' && segs[1] === 'models') {
      const [rows] = await pool.query(
        'SELECT m.*, b.name AS brand_name, b.slug AS brand_slug FROM ps_models m JOIN ps_brands b ON m.brand_id = b.id WHERE m.code = ?',
        [segs[2]]
      );
      return rows.length ? json(res, rows[0]) : error(res, 'Model not found', 404);
    }

    // GET /api/strings/:code
    if (method === 'GET' && segs.length === 3 && segs[0] === 'api' && segs[1] === 'strings') {
      const [models] = await pool.query(
        'SELECT m.*, b.name AS brand_name, b.slug AS brand_slug FROM ps_models m JOIN ps_brands b ON m.brand_id = b.id WHERE m.code = ?',
        [segs[2]]
      );
      if (!models.length) return error(res, 'Model not found', 404);
      const model = models[0];
      const [sections] = await pool.query('SELECT * FROM ps_string_sections WHERE model_id = ? ORDER BY string_from', [model.id]);
      const [gaugeRows] = await pool.query('SELECT * FROM ps_gauge_reference');
      const gaugeMap = {};
      for (const g of gaugeRows) gaugeMap[parseFloat(g.gauge)] = g;

      const strings = [];
      const total = model.total_strings || 88;
      for (let n = 1; n <= total; n++) {
        const sec = sections.find(s => n >= s.string_from && n <= s.string_to);
        if (sec) {
          const gr = gaugeMap[parseFloat(sec.gauge)];
          strings.push({
            number: n, note: stringToNote(n), type: sec.type,
            gauge: parseFloat(sec.gauge),
            diameter_mm: gr ? parseFloat(gr.diameter_mm) : null,
            weight_gm: gr ? parseFloat(gr.weight_gm) : null,
            resist_kg: gr ? parseFloat(gr.resist_kg) : null,
            copper1: sec.copper1 ? parseFloat(sec.copper1) : null,
            copper2: sec.copper2 ? parseFloat(sec.copper2) : null,
          });
        } else {
          strings.push({ number: n, note: stringToNote(n), type: 'plain', gauge: null, diameter_mm: null, weight_gm: null, resist_kg: null, copper1: null, copper2: null });
        }
      }
      return json(res, {
        model: { code: model.code, name: model.name, brand_name: model.brand_name, brand_slug: model.brand_slug },
        strings,
      });
    }

    // GET /api/gauge-reference
    if (method === 'GET' && path === '/api/gauge-reference') {
      const [rows] = await pool.query('SELECT * FROM ps_gauge_reference ORDER BY gauge');
      return json(res, rows);
    }

    // GET /api/official-steinway
    if (method === 'GET' && path === '/api/official-steinway') {
      const [rows] = await pool.query('SELECT * FROM ps_official_steinway ORDER BY sort_order');
      return json(res, rows);
    }

    // POST /api/auth/login
    if (method === 'POST' && path === '/api/auth/login') {
      const body = await parseBody(req);
      const [rows] = await pool.query('SELECT * FROM ps_admins WHERE username = ?', [body.username]);
      if (!rows.length) return error(res, 'Invalid credentials', 401);
      const match = await bcrypt.compare(body.password, rows[0].password);
      if (!match) return error(res, 'Invalid credentials', 401);
      const token = crypto.randomBytes(32).toString('hex');
      await pool.query('UPDATE ps_admins SET token = ? WHERE id = ?', [token, rows[0].id]);
      return json(res, { token, username: rows[0].username });
    }

    // POST /api/auth/logout
    if (method === 'POST' && path === '/api/auth/logout') {
      const user = await getAuthUser(req.headers.authorization);
      if (user) await pool.query('UPDATE ps_admins SET token = NULL WHERE id = ?', [user.id]);
      return json(res, { message: 'Logged out' });
    }

    // GET /api/auth/check
    if (method === 'GET' && path === '/api/auth/check') {
      const user = await getAuthUser(req.headers.authorization);
      return json(res, user ? { valid: true, username: user.username } : { valid: false });
    }

    // POST /api/contributions
    if (method === 'POST' && path === '/api/contributions') {
      const body = await parseBody(req);
      if (!body.brand_name || !body.model_name || !body.model_code || !body.sections) {
        return error(res, 'brand_name, model_name, model_code, sections required');
      }
      if (!Array.isArray(body.sections) || !body.sections.length) {
        return error(res, 'sections must be a non-empty array');
      }
      await pool.query(
        'INSERT INTO ps_contributions (brand_name, model_code, model_name, total_strings, sections_json, contributor, contributor_email, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())',
        [body.brand_name, body.model_code, body.model_name, body.total_strings || 88, JSON.stringify(body.sections), body.contributor || null, body.contributor_email || null, 'pending']
      );
      return json(res, { message: 'Contribution submitted for review' }, 201);
    }

    // ── Admin (auth required) ─────────────────────────────────────────────────
    const user = await getAuthUser(req.headers.authorization);
    if (path.startsWith('/api/admin') && !user) {
      return error(res, 'Unauthorized', 401);
    }

    // GET /api/admin/contributions
    if (method === 'GET' && path === '/api/admin/contributions') {
      const status = url.searchParams.get('status');
      let q = 'SELECT * FROM ps_contributions';
      const params = [];
      if (status) { q += ' WHERE status = ?'; params.push(status); }
      q += ' ORDER BY created_at DESC';
      const [rows] = await pool.query(q, params);
      for (const row of rows) {
        row.sections = typeof row.sections_json === 'string' ? JSON.parse(row.sections_json) : row.sections_json;
        delete row.sections_json;
      }
      return json(res, rows);
    }

    // POST /api/admin/approve/:id
    if (method === 'POST' && segs.length === 4 && segs[2] === 'approve') {
      return await approveContribution(parseInt(segs[3]), res);
    }

    // POST /api/admin/reject/:id
    if (method === 'POST' && segs.length === 4 && segs[2] === 'reject') {
      const body = await parseBody(req);
      await pool.query('UPDATE ps_contributions SET status = ?, admin_notes = ?, updated_at = NOW() WHERE id = ?', ['rejected', body.admin_notes || null, parseInt(segs[3])]);
      return json(res, { message: 'Rejected' });
    }

    // DELETE /api/admin/delete/:id
    if (method === 'DELETE' && segs.length === 4 && segs[2] === 'delete') {
      await pool.query('DELETE FROM ps_contributions WHERE id = ?', [parseInt(segs[3])]);
      return json(res, { message: 'Deleted' });
    }

    return error(res, 'Not found', 404);

  } catch (e) {
    console.error(e);
    return error(res, 'Internal server error: ' + e.message, 500);
  }
};

async function approveContribution(id, res) {
  const [contribs] = await pool.query('SELECT * FROM ps_contributions WHERE id = ?', [id]);
  if (!contribs.length) return error(res, 'Not found', 404);
  const contrib = contribs[0];
  if (contrib.status !== 'pending') return error(res, 'Already ' + contrib.status);

  const sections = typeof contrib.sections_json === 'string' ? JSON.parse(contrib.sections_json) : contrib.sections_json;
  if (!sections || !Array.isArray(sections)) return error(res, 'Invalid sections');

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const slug = contrib.brand_name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
    let [brands] = await conn.query('SELECT id FROM ps_brands WHERE slug = ?', [slug]);
    let brandId;
    if (brands.length) {
      brandId = brands[0].id;
    } else {
      const [r] = await conn.query('INSERT INTO ps_brands (name, slug, created_at, updated_at) VALUES (?, ?, NOW(), NOW())', [contrib.brand_name, slug]);
      brandId = r.insertId;
    }
    let [models] = await conn.query('SELECT id FROM ps_models WHERE brand_id = ? AND code = ?', [brandId, contrib.model_code]);
    let modelId;
    if (models.length) {
      modelId = models[0].id;
    } else {
      const [sortRows] = await conn.query('SELECT MAX(sort_order) AS mx FROM ps_models WHERE brand_id = ?', [brandId]);
      const maxSort = sortRows[0]?.mx || 0;
      const [r] = await conn.query('INSERT INTO ps_models (brand_id, code, name, total_strings, sort_order, created_at, updated_at) VALUES (?, ?, ?, ?, ?, NOW(), NOW())', [brandId, contrib.model_code, contrib.model_name, contrib.total_strings, maxSort + 1]);
      modelId = r.insertId;
    }
    await conn.query('DELETE FROM ps_string_sections WHERE model_id = ?', [modelId]);
    for (const s of sections) {
      await conn.query('INSERT INTO ps_string_sections (model_id, string_from, string_to, type, gauge, copper1, copper2, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())', [modelId, s.from, s.to, s.type, s.gauge, s.copper1 || null, s.copper2 || null]);
    }
    await conn.query('UPDATE ps_contributions SET status = ?, updated_at = NOW() WHERE id = ?', ['approved', id]);
    await conn.commit();
    return json(res, { message: 'Approved', model_id: modelId });
  } catch (e) {
    await conn.rollback();
    return error(res, 'Approval failed: ' + e.message, 500);
  } finally {
    conn.release();
  }
}
