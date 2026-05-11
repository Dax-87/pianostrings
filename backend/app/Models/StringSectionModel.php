<?php

namespace App\Models;

use CodeIgniter\Model;

class StringSectionModel extends Model
{
    protected $returnType    = 'object';
    protected $table         = 'ps_string_sections';
    protected $primaryKey    = 'id';
    protected $allowedFields = ['model_id', 'section_name', 'string_from', 'string_to', 'type', 'gauge', 'copper1', 'copper2'];
    protected $useTimestamps = true;

    public function findByModelId(int $modelId)
    {
        return $this->where('model_id', $modelId)
            ->orderBy('string_from')
            ->findAll();
    }
}
