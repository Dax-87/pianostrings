<?php

namespace App\Models;

use CodeIgniter\Model;

class GaugeReferenceModel extends Model
{
    protected $returnType    = 'object';
    protected $table         = 'ps_gauge_reference';
    protected $primaryKey    = 'id';
    protected $allowedFields = ['gauge', 'diameter_mm', 'weight_gm', 'resist_mm2', 'resist_kg'];
    protected $useTimestamps = true;

    public function findAllOrdered()
    {
        return $this->orderBy('gauge')->findAll();
    }
}
