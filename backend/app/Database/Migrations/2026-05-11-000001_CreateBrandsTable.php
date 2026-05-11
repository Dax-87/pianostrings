<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateBrandsTable extends Migration
{
    public function up()
    {
        $this->forge->addField([
            'id'          => ['type' => 'INT', 'constraint' => 11, 'auto_increment' => true],
            'name'        => ['type' => 'VARCHAR', 'constraint' => 100],
            'slug'        => ['type' => 'VARCHAR', 'constraint' => 100],
            'description' => ['type' => 'TEXT', 'null' => true],
            'country'     => ['type' => 'VARCHAR', 'constraint' => 100, 'null' => true],
            'created_at'  => ['type' => 'DATETIME', 'null' => true],
            'updated_at'  => ['type' => 'DATETIME', 'null' => true],
        ]);
        $this->forge->addKey('id', true);
        $this->forge->addUniqueKey('slug');
        $this->forge->createTable('ps_brands');
    }

    public function down()
    {
        $this->forge->dropTable('ps_brands');
    }
}
