<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;
use App\Models\GaugeReferenceModel;

class GaugeReference extends ResourceController
{
    public function index()
    {
        return $this->respond(model(GaugeReferenceModel::class)->findAllOrdered());
    }
}
