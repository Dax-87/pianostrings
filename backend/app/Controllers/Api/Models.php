<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;
use App\Models\ModelModel;

class Models extends ResourceController
{
    protected $modelName = 'App\Models\ModelModel';

    public function index()
    {
        $brandSlug = $this->request->getGet('brand');
        if ($brandSlug) {
            return $this->respond(model($this->modelName)->findByBrandSlug($brandSlug));
        }
        return $this->respond(model($this->modelName)->findAll());
    }

    public function show($code = null)
    {
        $model = model($this->modelName)->findByCode($code);
        if (!$model) {
            return $this->failNotFound('Model not found');
        }
        return $this->respond($model);
    }
}
