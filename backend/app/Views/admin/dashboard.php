<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>PianoStringDB — Admin</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
<style>
:root{--bg:#0d0d0f;--bg2:#13131a;--bg3:#1a1a24;--border:#2a2a38;--border2:#3a3a50;--text:#e8e4dc;--text2:#a09890;--text3:#6a6278;--accent:#c8a96e;--accent2:#e8c98e;--accent-glow:rgba(200,169,110,0.15);--green:#4a9e7a;--red:#c85050}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'DM Mono',monospace;background:var(--bg);color:var(--text);min-height:100vh}
.container{max-width:960px;margin:0 auto;padding:40px 20px}
h1{font-family:'Cormorant Garamond',serif;font-weight:300;color:var(--accent);font-size:1.5rem}
.header{display:flex;align-items:center;justify-content:space-between;margin-bottom:24px;padding-bottom:16px;border-bottom:1px solid var(--border)}
.header-right{display:flex;align-items:center;gap:12px;font-size:.7rem;color:var(--text3)}
.btn{background:var(--accent);color:var(--bg);border:none;border-radius:7px;font-family:'DM Mono',monospace;font-size:.6rem;font-weight:500;letter-spacing:.12em;text-transform:uppercase;padding:8px 16px;cursor:pointer;transition:all .2s;text-decoration:none;display:inline-block}
.btn:hover{background:var(--accent2);box-shadow:0 6px 20px var(--accent-glow)}
.btn-sm{padding:5px 12px;font-size:.55rem}
.btn-green{background:var(--green)}
.btn-red{background:var(--red)}
.btn-outline{background:transparent;border:1px solid var(--border);color:var(--text3)}
.btn-outline:hover{border-color:var(--accent);color:var(--accent);background:transparent;box-shadow:none}
.btn-outline.active{background:var(--accent);color:var(--bg);border-color:var(--accent)}
.tabs{display:flex;gap:6px;margin-bottom:20px;flex-wrap:wrap}
.msg{background:rgba(74,158,122,.15);border:1px solid var(--green);border-radius:7px;padding:10px 14px;font-size:.7rem;color:var(--green);margin-bottom:14px}
.card{background:var(--bg2);border:1px solid var(--border);border-radius:10px;padding:18px;margin-bottom:14px}
.meta{font-size:.62rem;color:var(--text3);margin-bottom:6px}
.title{font-family:'Cormorant Garamond',serif;font-size:1.1rem;color:var(--accent);margin-bottom:10px}
table{width:100%;border-collapse:collapse;font-size:.68rem}
th{text-align:left;padding:4px 8px;color:var(--text3);border-bottom:1px solid var(--border);font-weight:400}
td{padding:4px 8px;border-bottom:1px solid var(--border);color:var(--text2)}
.actions{display:flex;gap:6px;margin-top:12px;flex-wrap:wrap}
.badge{display:inline-block;padding:2px 8px;border-radius:4px;font-size:.55rem;letter-spacing:.1em;text-transform:uppercase}
.badge-pending{background:rgba(200,169,110,.15);color:var(--accent);border:1px solid var(--accent)}
.badge-approved{background:rgba(74,158,122,.15);color:var(--green);border:1px solid var(--green)}
.badge-rejected{background:rgba(200,80,80,.15);color:var(--red);border:1px solid var(--red)}
.empty{text-align:center;padding:40px;color:var(--text3);font-size:.7rem}
form.inline{display:inline}
.notes-input{background:var(--bg3);border:1px solid var(--border);border-radius:5px;padding:6px 10px;font-family:'DM Mono',monospace;font-size:.65rem;color:var(--text);outline:none;width:200px;margin-right:6px}
.notes-input:focus{border-color:var(--accent)}
.rejected-note{font-size:.62rem;color:var(--text3);margin-top:6px;padding:6px 10px;background:var(--bg3);border-radius:5px}
</style>
</head>
<body>
<div class="container">
  <div class="header">
    <h1>PianoStringDB · Admin</h1>
    <div class="header-right">
      <span><?= session('admin_user') ?></span>
      <a href="<?= base_url('admin/logout') ?>" class="btn btn-sm btn-outline">Logout</a>
    </div>
  </div>

  <?php if (session('message')): ?>
    <div class="msg"><?= session('message') ?></div>
  <?php endif; ?>

  <div class="tabs">
    <a href="<?= base_url('admin/dashboard?status=pending') ?>"  class="btn btn-sm btn-outline <?= $current_status === 'pending' ? 'active' : '' ?>">Pending (<?= $count_pending ?>)</a>
    <a href="<?= base_url('admin/dashboard?status=approved') ?>" class="btn btn-sm btn-outline <?= $current_status === 'approved' ? 'active' : '' ?>">Approved (<?= $count_approved ?>)</a>
    <a href="<?= base_url('admin/dashboard?status=rejected') ?>" class="btn btn-sm btn-outline <?= $current_status === 'rejected' ? 'active' : '' ?>">Rejected (<?= $count_rejected ?>)</a>
  </div>

  <?php if (empty($contributions)): ?>
    <div class="empty">No contributions found</div>
  <?php else: ?>
    <?php foreach ($contributions as $c): ?>
      <div class="card">
        <div class="meta">
          <span class="badge badge-<?= $c->status ?>"><?= $c->status ?></span>
          · <?= date('Y-m-d', strtotime($c->created_at)) ?>
          <?php if ($c->contributor): ?> · by <?= esc($c->contributor) ?><?php endif; ?>
          <?php if ($c->source_file): ?> · <?= esc($c->source_file) ?><?php endif; ?>
        </div>
        <div class="title"><?= esc($c->brand_name) ?> — <?= esc($c->model_name) ?> (<?= esc($c->model_code) ?>)</div>
        <table>
          <tr><th>#</th><th>From</th><th>To</th><th>Type</th><th>Gauge</th><th>Cu1</th><th>Cu2</th></tr>
          <?php $i=0; foreach ($c->sections as $s): $i++; ?>
            <tr>
              <td><?= $i ?></td>
              <td><?= $s->from ?></td>
              <td><?= $s->to ?></td>
              <td><?= $s->type ?></td>
              <td><?= $s->gauge ?></td>
              <td><?= $s->copper1 ?? '—' ?></td>
              <td><?= $s->copper2 ?? '—' ?></td>
            </tr>
          <?php endforeach; ?>
        </table>
        <?php if ($c->status === 'rejected' && $c->admin_notes): ?>
          <div class="rejected-note"><?= esc($c->admin_notes) ?></div>
        <?php endif; ?>
        <div class="actions">
          <?php if ($c->status === 'pending'): ?>
            <form method="post" action="<?= base_url('admin/approve/' . $c->id) ?>" class="inline">
              <?= csrf_field() ?>
              <button type="submit" class="btn btn-sm btn-green">Approve</button>
            </form>
            <form method="post" action="<?= base_url('admin/reject/' . $c->id) ?>" class="inline" onsubmit="return confirm('Reject this contribution?')">
              <?= csrf_field() ?>
              <input type="text" name="admin_notes" class="notes-input" placeholder="Reason (optional)">
              <button type="submit" class="btn btn-sm btn-red">Reject</button>
            </form>
          <?php else: ?>
            <form method="post" action="<?= base_url('admin/delete/' . $c->id) ?>" class="inline" onsubmit="return confirm('Delete?')">
              <?= csrf_field() ?>
              <button type="submit" class="btn btn-sm btn-outline">Delete</button>
            </form>
          <?php endif; ?>
        </div>
      </div>
    <?php endforeach; ?>
  <?php endif; ?>
</div>
</body>
</html>
