<?php

namespace App\Models;

use CodeIgniter\Model;

class BrandModel extends Model
{
    protected $returnType    = 'object';
    protected $table         = 'ps_brands';
    protected $primaryKey    = 'id';
    protected $allowedFields = ['name', 'slug', 'description', 'country'];
    protected $useTimestamps = true;
}
