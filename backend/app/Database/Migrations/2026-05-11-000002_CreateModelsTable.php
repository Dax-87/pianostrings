<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateModelsTable extends Migration
{
    public function up()
    {
        $this->forge->addField([
            'id'           => ['type' => 'INT', 'constraint' => 11, 'auto_increment' => true],
            'brand_id'     => ['type' => 'INT', 'constraint' => 11],
            'code'         => ['type' => 'VARCHAR', 'constraint' => 20],
            'name'         => ['type' => 'VARCHAR', 'constraint' => 200],
            'total_strings'=> ['type' => 'INT', 'constraint' => 11, 'default' => 88],
            'sort_order'   => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'created_at'   => ['type' => 'DATETIME', 'null' => true],
            'updated_at'   => ['type' => 'DATETIME', 'null' => true],
        ]);
        $this->forge->addKey('id', true);
        $this->forge->addUniqueKey(['brand_id', 'code']);
        $this->forge->addForeignKey('brand_id', 'ps_brands', 'id', 'CASCADE', 'CASCADE');
        $this->forge->createTable('ps_models');
    }

    public function down()
    {
        $this->forge->dropTable('ps_models');
    }
}
