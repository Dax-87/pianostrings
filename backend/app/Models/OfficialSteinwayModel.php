<?php

namespace App\Models;

use CodeIgniter\Model;

class OfficialSteinwayModel extends Model
{
    protected $returnType    = 'object';
    protected $table         = 'ps_official_steinway';
    protected $primaryKey    = 'id';
    protected $allowedFields = ['model_label', 'sort_order',
        'gauge_12', 'gauge_12_5', 'gauge_13', 'gauge_13_5', 'gauge_14', 'gauge_14_5',
        'gauge_15', 'gauge_15_5', 'gauge_16', 'gauge_16_5', 'gauge_17', 'gauge_17_5',
        'gauge_18', 'gauge_19', 'gauge_20', 'gauge_21', 'gauge_22', 'gauge_23'];
    protected $useTimestamps = true;

    public function findAllOrdered()
    {
        return $this->orderBy('sort_order')->findAll();
    }
}
