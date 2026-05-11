<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateOfficialSteinwayTable extends Migration
{
    public function up()
    {
        $this->forge->addField([
            'id'          => ['type' => 'INT', 'constraint' => 11, 'auto_increment' => true],
            'model_label' => ['type' => 'VARCHAR', 'constraint' => 100],
            'sort_order'  => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_12'    => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_12_5'  => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_13'    => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_13_5'  => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_14'    => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_14_5'  => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_15'    => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_15_5'  => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_16'    => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_16_5'  => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_17'    => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_17_5'  => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_18'    => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_19'    => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_20'    => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_21'    => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_22'    => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'gauge_23'    => ['type' => 'INT', 'constraint' => 11, 'default' => 0],
            'created_at'  => ['type' => 'DATETIME', 'null' => true],
            'updated_at'  => ['type' => 'DATETIME', 'null' => true],
        ]);
        $this->forge->addKey('id', true);
        $this->forge->createTable('ps_official_steinway');
    }

    public function down()
    {
        $this->forge->dropTable('ps_official_steinway');
    }
}
