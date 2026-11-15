<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

/**
 * Metadati aggiuntivi sulle sezioni di corde.
 *
 * Perche' servono:
 *  - `gauge` deve poter essere NULL: Yamaha e Kawai non pubblicano il diametro
 *    di anima e rame delle corde avvolte (vendono la corda come ricambio).
 *  - `type` accetta 'wound' (avvolta, tipo di avvolgimento non dichiarato).
 *  - `strings_per_note`: monocordo / bicordo / tricordo.
 *  - `part_no_from` / `part_no_to`: codici ricambio (Yamaha), per identificare
 *    la corda esatta quando il diametro non e' disponibile.
 *
 * Le modifiche sono condizionali: se le colonne esistono gia' (es. database
 * allineato a mano) la migrazione non fa nulla e non fallisce.
 *
 * Nessun AFTER: TiDB rifiuta un AFTER che punta a una colonna aggiunta nella
 * stessa ALTER ("Unknown column ... in ps_string_sections"), MySQL 8 lo accetta.
 */
class AddStringMetadata extends Migration
{
    public function up()
    {
        if ($this->hasColumn('strings_per_note')) {
            return;
        }

        $this->db->query("ALTER TABLE `ps_string_sections`
            MODIFY COLUMN `type` enum('plain','wound','wound1','wound2') NOT NULL DEFAULT 'plain',
            MODIFY COLUMN `gauge` decimal(4,1) DEFAULT NULL,
            ADD COLUMN `strings_per_note` tinyint(4) DEFAULT NULL,
            ADD COLUMN `part_no_from` varchar(20) DEFAULT NULL,
            ADD COLUMN `part_no_to` varchar(20) DEFAULT NULL");
    }

    public function down()
    {
        if (!$this->hasColumn('strings_per_note')) {
            return;
        }

        // gauge torna NOT NULL: le righe senza diametro non possono restare
        $this->db->query("DELETE FROM `ps_string_sections` WHERE `gauge` IS NULL");
        $this->db->query("ALTER TABLE `ps_string_sections`
            DROP COLUMN `part_no_to`,
            DROP COLUMN `part_no_from`,
            DROP COLUMN `strings_per_note`,
            MODIFY COLUMN `gauge` decimal(4,1) NOT NULL,
            MODIFY COLUMN `type` enum('plain','wound1','wound2') NOT NULL DEFAULT 'plain'");
    }

    private function hasColumn(string $column): bool
    {
        $rows = $this->db->query(
            'SELECT 1 FROM information_schema.COLUMNS
              WHERE TABLE_SCHEMA = DATABASE()
                AND TABLE_NAME = ?
                AND COLUMN_NAME = ?',
            ['ps_string_sections', $column]
        )->getResultArray();

        return $rows !== [];
    }
}
