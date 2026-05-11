<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;

class Contributions extends ResourceController
{
    public function create()
    {
        $json = $this->request->getJSON(true);
        if (!$json) {
            return $this->failValidationError('Invalid JSON');
        }

        $rules = [
            'brand_name'    => 'required|string|max_length[255]',
            'model_name'    => 'required|string|max_length[255]',
            'model_code'    => 'required|string|max_length[50]',
            'total_strings' => 'permit_empty|integer',
            'contributor'   => 'permit_empty|string|max_length[255]',
            'contributor_email' => 'permit_empty|valid_email',
            'sections'      => 'required|is_array',
        ];

        if (!$this->validate($rules)) {
            return $this->failValidationErrors($this->validator->getErrors());
        }

        $sections = $json['sections'];
        if (empty($sections)) {
            return $this->failValidationError('At least one section required');
        }

        foreach ($sections as $i => $s) {
            if (!isset($s['from'], $s['to'], $s['type'], $s['gauge'])) {
                return $this->failValidationError("Section $i: from, to, type, gauge required");
            }
            if ((int)$s['from'] < 1 || (int)$s['to'] > 88 || (int)$s['from'] > (int)$s['to']) {
                return $this->failValidationError("Section $i: invalid string range");
            }
            if (!in_array($s['type'], ['plain', 'wound1', 'wound2'])) {
                return $this->failValidationError("Section $i: invalid type");
            }
        }

        model('App\Models\ContributionModel')->insert([
            'brand_name'     => $json['brand_name'],
            'model_name'     => $json['model_name'],
            'model_code'     => $json['model_code'],
            'total_strings'  => (int)($json['total_strings'] ?? 88),
            'sections_json'  => json_encode($sections, JSON_UNESCAPED_UNICODE),
            'contributor'    => $json['contributor'] ?? null,
            'contributor_email' => $json['contributor_email'] ?? null,
            'status'         => 'pending',
        ]);

        return $this->respondCreated(['message' => 'Contribution submitted for review']);
    }
}
