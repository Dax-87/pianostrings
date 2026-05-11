<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateStringSectionsTable extends Migration
{
    public function up()
    {
        $this->forge->addField([
            'id'          => ['type' => 'INT', 'constraint' => 11, 'auto_increment' => true],
            'model_id'    => ['type' => 'INT', 'constraint' => 11],
            'section_name'=> ['type' => 'VARCHAR', 'constraint' => 200, 'null' => true],
            'string_from' => ['type' => 'INT', 'constraint' => 11],
            'string_to'   => ['type' => 'INT', 'constraint' => 11],
            'type'        => ['type' => 'ENUM', 'constraint' => ['plain', 'wound1', 'wound2'], 'default' => 'plain'],
            'gauge'       => ['type' => 'DECIMAL', 'constraint' => '4,1'],
            'copper1'     => ['type' => 'DECIMAL', 'constraint' => '5,2', 'null' => true],
            'copper2'     => ['type' => 'DECIMAL', 'constraint' => '5,2', 'null' => true],
            'created_at'  => ['type' => 'DATETIME', 'null' => true],
            'updated_at'  => ['type' => 'DATETIME', 'null' => true],
        ]);
        $this->forge->addKey('id', true);
        $this->forge->addForeignKey('model_id', 'ps_models', 'id', 'CASCADE', 'CASCADE');
        $this->forge->createTable('ps_string_sections');
    }

    public function down()
    {
        $this->forge->dropTable('ps_string_sections');
    }
}
