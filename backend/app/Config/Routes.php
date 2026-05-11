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
});

$routes->get('/', 'Home::index');
