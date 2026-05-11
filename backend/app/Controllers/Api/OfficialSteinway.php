<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;
use App\Models\OfficialSteinwayModel;

class OfficialSteinway extends ResourceController
{
    public function index()
    {
        return $this->respond(model(OfficialSteinwayModel::class)->findAllOrdered());
    }
}
