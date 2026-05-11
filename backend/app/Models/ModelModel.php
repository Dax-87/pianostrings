<?php

namespace App\Models;

use CodeIgniter\Model;

class ModelModel extends Model
{
    protected $returnType    = 'object';
    protected $table         = 'ps_models';
    protected $primaryKey    = 'id';
    protected $allowedFields = ['brand_id', 'code', 'name', 'total_strings', 'sort_order'];
    protected $useTimestamps = true;

    public function findByBrandSlug(string $slug)
    {
        return $this->select('ps_models.*')
            ->join('ps_brands', 'ps_brands.id = ps_models.brand_id')
            ->where('ps_brands.slug', $slug)
            ->orderBy('ps_models.sort_order')
            ->findAll();
    }

    public function findByCode(string $code)
    {
        return $this->where('code', $code)->first();
    }
}
