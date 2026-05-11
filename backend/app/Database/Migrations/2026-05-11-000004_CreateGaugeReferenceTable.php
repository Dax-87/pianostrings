<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateGaugeReferenceTable extends Migration
{
    public function up()
    {
        $this->forge->addField([
            'id'          => ['type' => 'INT', 'constraint' => 11, 'auto_increment' => true],
            'gauge'       => ['type' => 'DECIMAL', 'constraint' => '4,1'],
            'diameter_mm' => ['type' => 'DECIMAL', 'constraint' => '6,4'],
            'weight_gm'   => ['type' => 'DECIMAL', 'constraint' => '6,2'],
            'resist_mm2'  => ['type' => 'INT', 'constraint' => 11, 'null' => true],
            'resist_kg'   => ['type' => 'DECIMAL', 'constraint' => '6,1', 'null' => true],
            'created_at'  => ['type' => 'DATETIME', 'null' => true],
            'updated_at'  => ['type' => 'DATETIME', 'null' => true],
        ]);
        $this->forge->addKey('id', true);
        $this->forge->addUniqueKey('gauge');
        $this->forge->createTable('ps_gauge_reference');
    }

    public function down()
    {
        $this->forge->dropTable('ps_gauge_reference');
    }
}
