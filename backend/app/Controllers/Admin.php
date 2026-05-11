<?php

namespace App\Controllers;

use App\Models\AdminModel;

class Admin extends BaseController
{
    public function login()
    {
        if (session('admin_id')) {
            return redirect()->to('/admin/dashboard');
        }

        if ($this->request->getMethod() === 'POST') {
            $username = $this->request->getPost('username');
            $password = $this->request->getPost('password');

            $admin = model(AdminModel::class)->where('username', $username)->first();

            if ($admin && password_verify($password, $admin->password)) {
                session()->set([
                    'admin_id'  => $admin->id,
                    'admin_user'=> $admin->username,
                ]);

                if ($this->request->getPost('ajax')) {
                    return $this->response->setJSON(['success' => true]);
                }
                return redirect()->to('/admin/dashboard');
            }

            if ($this->request->getPost('ajax')) {
                return $this->response->setStatusCode(401)->setJSON(['error' => 'Invalid credentials']);
            }

            return redirect()->back()->with('error', 'Invalid credentials');
        }

        return view('admin/login');
    }

    public function dashboard()
    {
        if (!session('admin_id')) {
            return redirect()->to('/admin/login');
        }

        $status = $this->request->getGet('status');
        $model = model('App\Models\ContributionModel');

        if ($status) {
            $contribs = $model->where('status', $status)->orderBy('created_at', 'DESC')->findAll();
        } else {
            $contribs = $model->where('status', 'pending')->orderBy('created_at', 'DESC')->findAll();
        }

        foreach ($contribs as &$c) {
            $c->sections = json_decode($c->sections_json);
            unset($c->sections_json);
        }

        return view('admin/dashboard', [
            'contributions' => $contribs,
            'current_status' => $status ?: 'pending',
            'count_pending'  => $model->where('status', 'pending')->countAllResults(),
            'count_approved' => $model->where('status', 'approved')->countAllResults(),
            'count_rejected' => $model->where('status', 'rejected')->countAllResults(),
        ]);
    }

    public function approve($id = null)
    {
        if (!session('admin_id')) {
            return redirect()->to('/admin/login');
        }
        if (!$id) return redirect()->back()->with('error', 'ID required');

        $contrib = model('App\Models\ContributionModel')->find($id);
        if (!$contrib) return redirect()->back()->with('error', 'Not found');
        if ($contrib->status !== 'pending') return redirect()->back()->with('error', 'Already ' . $contrib->status);

        $sections = json_decode($contrib->sections_json, true);
        if (!$sections) return redirect()->back()->with('error', 'Invalid sections');

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
            return redirect()->back()->with('error', $e->getMessage());
        }

        return redirect()->to('/admin/dashboard')->with('message', 'Approved: ' . $contrib->model_name);
    }

    public function reject($id = null)
    {
        if (!session('admin_id')) {
            return redirect()->to('/admin/login');
        }
        if (!$id) return redirect()->back()->with('error', 'ID required');

        $contrib = model('App\Models\ContributionModel')->find($id);
        if (!$contrib) return redirect()->back()->with('error', 'Not found');

        $notes = $this->request->getPost('admin_notes');
        $update = ['status' => 'rejected'];
        if ($notes) $update['admin_notes'] = $notes;

        model('App\Models\ContributionModel')->update($id, $update);

        return redirect()->to('/admin/dashboard')->with('message', 'Rejected: ' . $contrib->model_name);
    }

    public function delete($id = null)
    {
        if (!session('admin_id')) return redirect()->to('/admin/login');
        if (!$id) return redirect()->back()->with('error', 'ID required');

        model('App\Models\ContributionModel')->delete($id);
        return redirect()->to('/admin/dashboard')->with('message', 'Deleted');
    }

    public function logout()
    {
        session()->destroy();
        return redirect()->to('/admin/login');
    }

    private function findOrCreateBrand($db, string $name): int
    {
        $slug = mb_strtolower(trim(preg_replace('/[^a-zA-Z0-9]+/', '-', $name), '-'));
        $existing = $db->table('ps_brands')->where('slug', $slug)->get()->getRow();
        if ($existing) return (int)$existing->id;

        $db->table('ps_brands')->insert(['name' => $name, 'slug' => $slug]);
        return (int)$db->insertID();
    }

    private function findOrCreateModel($db, int $brandId, object $contrib): int
    {
        $existing = $db->table('ps_models')
            ->where('brand_id', $brandId)->where('code', $contrib->model_code)
            ->get()->getRow();
        if ($existing) return (int)$existing->id;

        $maxSort = $db->table('ps_models')->where('brand_id', $brandId)
            ->selectMax('sort_order')->get()->getRow()->sort_order;

        $db->table('ps_models')->insert([
            'brand_id' => $brandId, 'code' => $contrib->model_code,
            'name' => $contrib->model_name, 'total_strings' => $contrib->total_strings,
            'sort_order' => ($maxSort ?: 0) + 1,
        ]);
        return (int)$db->insertID();
    }

    private function replaceSections($db, int $modelId, array $sections): void
    {
        $db->table('ps_string_sections')->where('model_id', $modelId)->delete();
        $rows = [];
        foreach ($sections as $s) {
            $rows[] = [
                'model_id' => $modelId, 'string_from' => (int)$s['from'],
                'string_to' => (int)$s['to'], 'type' => $s['type'],
                'gauge' => (float)$s['gauge'],
                'copper1' => isset($s['copper1']) ? (float)$s['copper1'] : null,
                'copper2' => isset($s['copper2']) ? (float)$s['copper2'] : null,
            ];
        }
        if (!empty($rows)) $db->table('ps_string_sections')->insertBatch($rows);
    }
}
