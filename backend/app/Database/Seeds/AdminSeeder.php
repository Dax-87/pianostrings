<?php

namespace App\Database\Seeds;

use CodeIgniter\Database\Seeder;

class AdminSeeder extends Seeder
{
    public function run()
    {
        $this->db->table('ps_admins')->insert([
            'username' => 'admin',
            'password' => password_hash('admin', PASSWORD_BCRYPT),
        ]);

        echo "Admin user created: username=admin password=admin\n";
    }
}
