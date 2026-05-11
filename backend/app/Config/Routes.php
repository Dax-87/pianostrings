<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */

$routes->setDefaultNamespace('App\Controllers');
$routes->setDefaultController('Home');
$routes->setDefaultMethod('index');
$routes->setTranslateURIDashes(false);
$routes->set404Override();

// API routes
$routes->group('api', static function ($routes) {
    $routes->get('brands',                    'Api\Brands::index');
    $routes->get('brands/(:segment)',         'Api\Brands::show/$1');
    $routes->get('models',                    'Api\Models::index');
    $routes->get('models/(:segment)',         'Api\Models::show/$1');
    $routes->get('strings/(:segment)',        'Api\Strings::byModel/$1');
    $routes->get('gauge-reference',           'Api\GaugeReference::index');
    $routes->get('official-steinway',         'Api\OfficialSteinway::index');

    // Auth
    $routes->post('auth/login',               'Api\Auth::login');
    $routes->post('auth/logout',              'Api\Auth::logout');

    // Admin (protected)
    $routes->group('admin', ['filter' => 'adminAuth'], static function ($routes) {
        $routes->get('auth/check',            'Api\Auth::check');
        $routes->get('contributions',         'Api\Admin::contributions');
        $routes->post('contributions/(:num)/approve', 'Api\Admin::approve/$1');
        $routes->post('contributions/(:num)/reject',  'Api\Admin::reject/$1');
        $routes->delete('contributions/(:num)',       'Api\Admin::deleteContribution/$1');
    });
});

$routes->get('/', 'Home::index');
