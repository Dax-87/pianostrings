<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;

class Admin extends ResourceController
{
    public function contributions()
    {
        $status = $this->request->getGet('status');
        $model = model('App\Models\ContributionModel');

        if ($status) {
            $data = $model->where('status', $status)->orderBy('created_at', 'DESC')->findAll();
        } else {
            $data = $model->orderBy('created_at', 'DESC')->findAll();
        }

        foreach ($data as &$c) {
            $c->sections = json_decode($c->sections_json);
            unset($c->sections_json);
        }

        return $this->respond($data);
    }

    public function approve($id = null)
    {
        if (!$id) return $this->failValidationError('ID required');

        $contrib = model('App\Models\ContributionModel')->find($id);
        if (!$contrib) return $this->failNotFound('Contribution not found');
        if ($contrib->status !== 'pending') return $this->failValidationError('Already ' . $contrib->status);

        $sections = json_decode($contrib->sections_json, true);
        if (!$sections || !is_array($sections)) {
            return $this->failValidationError('Invalid sections data');
        }

        $db = db_connect();
        $db->transBegin();

        try {
            $brandId = $this->findOrCreateBrand($db, $contrib->brand_name);
            $modelId = $this->findOrCreateModel($db, $brandId, $contrib);
            $this->replaceSections($db, $modelId, $sections);

            model('App\Models\ContributionModel')->update($id, ['status' => 'approved']);

            $db->transCommit();
        } catch (\Exception $e) {
            $db->transRollback();
            return $this->failServerError('Approval failed: ' . $e->getMessage());
        }

        return $this->respond(['message' => 'Approved', 'model_id' => $modelId]);
    }

    public function reject($id = null)
    {
        if (!$id) return $this->failValidationError('ID required');

        $contrib = model('App\Models\ContributionModel')->find($id);
        if (!$contrib) return $this->failNotFound('Contribution not found');

        $notes = $this->request->getVar('admin_notes');
        $update = ['status' => 'rejected'];
        if ($notes) $update['admin_notes'] = $notes;

        model('App\Models\ContributionModel')->update($id, $update);

        return $this->respond(['message' => 'Rejected']);
    }

    public function deleteContribution($id = null)
    {
        if (!$id) return $this->failValidationError('ID required');
        model('App\Models\ContributionModel')->delete($id);
        return $this->respondDeleted(['message' => 'Deleted']);
    }

    private function findOrCreateBrand($db, string $name): int
    {
        $slug = mb_strtolower(trim(preg_replace('/[^a-zA-Z0-9]+/', '-', $name), '-'));
        $existing = $db->table('ps_brands')->where('slug', $slug)->get()->getRow();
        if ($existing) return (int)$existing->id;

        $db->table('ps_brands')->insert([
            'name' => $name,
            'slug' => $slug,
        ]);
        return (int)$db->insertID();
    }

    private function findOrCreateModel($db, int $brandId, object $contrib): int
    {
        $existing = $db->table('ps_models')
            ->where('brand_id', $brandId)
            ->where('code', $contrib->model_code)
            ->get()->getRow();

        if ($existing) return (int)$existing->id;

        $maxSort = $db->table('ps_models')
            ->where('brand_id', $brandId)
            ->selectMax('sort_order')
            ->get()->getRow()->sort_order;

        $db->table('ps_models')->insert([
            'brand_id'      => $brandId,
            'code'          => $contrib->model_code,
            'name'          => $contrib->model_name,
            'total_strings' => $contrib->total_strings,
            'sort_order'    => ($maxSort ?: 0) + 1,
        ]);
        return (int)$db->insertID();
    }

    private function replaceSections($db, int $modelId, array $sections): void
    {
        $db->table('ps_string_sections')->where('model_id', $modelId)->delete();

        $rows = [];
        foreach ($sections as $s) {
            $rows[] = [
                'model_id'    => $modelId,
                'string_from' => (int)$s['from'],
                'string_to'   => (int)$s['to'],
                'type'        => $s['type'],
                'gauge'       => (float)$s['gauge'],
                'copper1'     => isset($s['copper1']) ? (float)$s['copper1'] : null,
                'copper2'     => isset($s['copper2']) ? (float)$s['copper2'] : null,
            ];
        }

        if (!empty($rows)) {
            $db->table('ps_string_sections')->insertBatch($rows);
        }
    }
}
