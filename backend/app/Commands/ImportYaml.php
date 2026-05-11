<?php

namespace App\Commands;

use CodeIgniter\CLI\BaseCommand;
use CodeIgniter\CLI\CLI;
use Symfony\Component\Yaml\Yaml;

class ImportYaml extends BaseCommand
{
    protected $group       = 'PianoStringDB';
    protected $name        = 'import:yaml';
    protected $description = 'Import a YAML contribution file as pending';

    public function run(array $params)
    {
        $file = $params[0] ?? null;

        if (!$file) {
            $file = CLI::prompt('Path to YAML file');
        }

        if (!is_file($file)) {
            CLI::error("File not found: $file");
            return EXIT_ERROR;
        }

        try {
            $data = Yaml::parseFile($file);
        } catch (\Exception $e) {
            CLI::error('YAML parse error: ' . $e->getMessage());
            return EXIT_ERROR;
        }

        $sections = $data['sections'] ?? [];
        if (empty($sections) || !is_array($sections)) {
            CLI::error('No sections found in YAML');
            return EXIT_ERROR;
        }

        $model = model('App\Models\ContributionModel');
        $model->save([
            'brand_name'       => $data['brand'] ?? 'Unknown',
            'model_code'       => $data['model'] ?? 'unknown',
            'model_name'       => ($data['brand'] ?? '') . ' — ' . ($data['model_name'] ?? ($data['model'] ?? '')),
            'total_strings'    => $data['total_strings'] ?? 88,
            'sections_json'    => json_encode($sections),
            'contributor'      => $data['contributor'] ?? null,
            'contributor_email'=> $data['contributor_email'] ?? null,
            'status'           => 'pending',
            'source_file'      => basename($file),
        ]);

        $id = $model->insertID();
        CLI::write("Contribution #$id imported as pending from: " . basename($file), 'green');
        CLI::write("Brand: {$data['brand']} | Model: {$data['model']} | Sections: " . count($sections), 'yellow');

        return EXIT_SUCCESS;
    }
}
