<?php

namespace App\Models;

use CodeIgniter\Model;

class ContributionModel extends Model
{
    protected $returnType    = 'object';
    protected $table         = 'ps_contributions';
    protected $primaryKey    = 'id';
    protected $allowedFields = [
        'brand_name', 'model_code', 'model_name', 'total_strings',
        'sections_json', 'contributor', 'contributor_email',
        'status', 'admin_notes', 'source_file',
    ];
    protected $useTimestamps = true;
}
