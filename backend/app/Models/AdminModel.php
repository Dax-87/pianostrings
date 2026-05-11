<?php

namespace App\Models;

use CodeIgniter\Model;

class AdminModel extends Model
{
    protected $returnType    = 'object';
    protected $table         = 'ps_admins';
    protected $primaryKey    = 'id';
    protected $allowedFields = ['username', 'password', 'token'];
    protected $useTimestamps = true;
    protected $beforeInsert  = ['hashPassword'];
    protected $beforeUpdate  = ['hashPassword'];

    protected function hashPassword(array $data)
    {
        if (isset($data['data']['password'])) {
            $data['data']['password'] = password_hash($data['data']['password'], PASSWORD_BCRYPT);
        }
        return $data;
    }
}
