<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateContributionsTable extends Migration
{
    public function up()
    {
        $this->forge->addField([
            'id'               => ['type' => 'INT', 'constraint' => 11, 'unsigned' => true, 'auto_increment' => true],
            'brand_name'       => ['type' => 'VARCHAR', 'constraint' => 100],
            'model_code'       => ['type' => 'VARCHAR', 'constraint' => 60],
            'model_name'       => ['type' => 'VARCHAR', 'constraint' => 255],
            'total_strings'    => ['type' => 'TINYINT', 'constraint' => 3, 'default' => 88],
            'sections_json'    => ['type' => 'JSON'],
            'contributor'      => ['type' => 'VARCHAR', 'constraint' => 120, 'null' => true],
            'contributor_email'=> ['type' => 'VARCHAR', 'constraint' => 120, 'null' => true],
            'status'           => ['type' => "ENUM('pending','approved','rejected')", 'default' => 'pending'],
            'admin_notes'      => ['type' => 'TEXT', 'null' => true],
            'source_file'      => ['type' => 'VARCHAR', 'constraint' => 255, 'null' => true],
            'created_at'       => ['type' => 'DATETIME', 'null' => true],
            'updated_at'       => ['type' => 'DATETIME', 'null' => true],
        ]);
        $this->forge->addKey('id', true);
        $this->forge->addKey('status');
        $this->forge->createTable('ps_contributions');
    }

    public function down()
    {
        $this->forge->dropTable('ps_contributions');
    }
}
