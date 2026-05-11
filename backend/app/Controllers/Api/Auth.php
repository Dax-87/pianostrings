<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;

class Auth extends ResourceController
{
    public function login()
    {
        $rules = [
            'username' => 'required',
            'password' => 'required',
        ];

        if (!$this->validate($rules)) {
            return $this->failValidationErrors($this->validator->getErrors());
        }

        $username = $this->request->getVar('username');
        $password = $this->request->getVar('password');

        $admin = model('App\Models\AdminModel')->where('username', $username)->first();

        if (!$admin || !password_verify($password, $admin->password)) {
            return $this->failUnauthorized('Invalid credentials');
        }

        $token = bin2hex(random_bytes(32));
        model('App\Models\AdminModel')->update($admin->id, ['token' => $token]);

        return $this->respond([
            'token'    => $token,
            'username' => $admin->username,
        ]);
    }

    public function logout()
    {
        $auth = $this->request->getHeaderLine('Authorization');
        if ($auth && str_starts_with($auth, 'Bearer ')) {
            $token = substr($auth, 7);
            $admin = model('App\Models\AdminModel')->where('token', $token)->first();
            if ($admin) {
                model('App\Models\AdminModel')->update($admin->id, ['token' => null]);
            }
        }
        return $this->respond(['message' => 'Logged out']);
    }

    public function check()
    {
        return $this->respond(['authenticated' => true, 'username' => $this->request->admin->username]);
    }
}
