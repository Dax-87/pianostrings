<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>PianoStringDB — Admin Login</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
<style>
:root{--bg:#0d0d0f;--bg2:#13131a;--bg3:#1a1a24;--border:#2a2a38;--text:#e8e4dc;--text2:#a09890;--text3:#6a6278;--accent:#c8a96e;--accent2:#e8c98e;--accent-glow:rgba(200,169,110,0.15);--red:#c85050}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
body{font-family:'DM Mono',monospace;background:var(--bg);color:var(--text);min-height:100vh;display:flex;align-items:center;justify-content:center}
.login-box{width:340px;background:var(--bg2);border:1px solid var(--border);border-radius:14px;padding:32px}
h2{font-family:'Cormorant Garamond',serif;font-weight:300;color:var(--accent);margin-bottom:20px;text-align:center}
.field{display:flex;flex-direction:column;gap:6px;margin-bottom:14px}
.field label{font-size:.6rem;letter-spacing:.2em;text-transform:uppercase;color:var(--text3)}
.field input{background:var(--bg3);border:1px solid var(--border);border-radius:7px;color:var(--text);font-family:'DM Mono',monospace;font-size:.8rem;padding:10px 13px;outline:none}
.field input:focus{border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-glow)}
.btn{background:var(--accent);color:var(--bg);border:none;border-radius:7px;font-family:'DM Mono',monospace;font-size:.7rem;font-weight:500;letter-spacing:.14em;text-transform:uppercase;padding:11px 22px;cursor:pointer;transition:all .2s;width:100%}
.btn:hover{background:var(--accent2);box-shadow:0 6px 20px var(--accent-glow)}
.error{background:rgba(200,80,80,.15);border:1px solid var(--red);border-radius:7px;padding:10px;font-size:.7rem;color:var(--red);margin-bottom:14px;display:<?= session('error') ? 'block' : 'none' ?>}
</style>
</head>
<body>
<div class="login-box">
  <h2>PianoStringDB · Admin</h2>
  <div class="error"><?= session('error') ?></div>
  <form method="post" action="/admin/login">
    <?= csrf_field() ?>
    <div class="field"><label>Username</label><input type="text" name="username" required autofocus></div>
    <div class="field"><label>Password</label><input type="password" name="password" required></div>
    <button class="btn" type="submit">Login</button>
  </form>
</div>
</body>
</html>
