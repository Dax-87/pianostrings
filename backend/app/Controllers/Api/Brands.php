<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;
use App\Models\BrandModel;

class Brands extends ResourceController
{
    protected $modelName = 'App\Models\BrandModel';

    public function index()
    {
        return $this->respond(model($this->modelName)->findAll());
    }

    public function show($slug = null)
    {
        $brand = model($this->modelName)->where('slug', $slug)->first();
        if (!$brand) {
            return $this->failNotFound('Brand not found');
        }
        return $this->respond($brand);
    }
}
