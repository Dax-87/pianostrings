<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;
use App\Models\ModelModel;
use App\Models\StringSectionModel;
use App\Models\GaugeReferenceModel;

class Strings extends ResourceController
{
    public function byModel($modelCode = null)
    {
        if (!$modelCode) {
            return $this->failValidationError('Model code required');
        }

        $modelModel = model(ModelModel::class);
        $model = $modelModel->findByCode($modelCode);

        if (!$model) {
            return $this->failNotFound('Model not found');
        }

        $sectionModel = model(StringSectionModel::class);
        $sections = $sectionModel->findByModelId($model->id);

        $gaugeModel = model(GaugeReferenceModel::class);
        $gaugeMap = [];
        foreach ($gaugeModel->findAllOrdered() as $g) {
            $gaugeMap[(string)$g->gauge] = $g;
        }

        $strings = [];
        for ($n = 1; $n <= $model->total_strings; $n++) {
            $section = null;
            foreach ($sections as $s) {
                if ($n >= $s->string_from && $n <= $s->string_to) {
                    $section = $s;
                    break;
                }
            }

            // gauge puo' essere NULL: le corde avvolte Yamaha/Kawai non hanno
            // diametro pubblicato dal costruttore.
            $gaugeRaw = $section ? $section->gauge : null;
            $hasGauge = $gaugeRaw !== null && $gaugeRaw !== '';
            $gauge = $hasGauge ? (float) $gaugeRaw : null;
            $gaugeKey = $gauge !== null ? sprintf('%.1f', $gauge) : null;
            $gaugeRef = $gaugeKey !== null && isset($gaugeMap[$gaugeKey]) ? $gaugeMap[$gaugeKey] : null;

            $note = $this->stringToNote($n);

            $strings[] = [
                'number'    => $n,
                'note'      => $note,
                'type'      => $section ? $section->type : 'plain',
                'gauge'     => $gauge,
                'diameter_mm' => $gaugeRef ? (float)$gaugeRef->diameter_mm : null,
                'weight_gm'   => $gaugeRef ? (float)$gaugeRef->weight_gm : null,
                'resist_kg'   => $gaugeRef ? (float)$gaugeRef->resist_kg : null,
                'copper1'   => $section ? ($section->copper1 ? (float)$section->copper1 : null) : null,
                'copper2'   => $section ? ($section->copper2 ? (float)$section->copper2 : null) : null,
                'strings_per_note' => ($section && $section->strings_per_note !== null) ? (int)$section->strings_per_note : null,
                'part_no_from'     => $section ? $section->part_no_from : null,
                'part_no_to'       => $section ? $section->part_no_to : null,
            ];
        }

        return $this->respond([
            'model'   => $model,
            'strings' => $strings,
        ]);
    }

    private function stringToNote(int $n): string
    {
        $chromatic = ['C','C#','D','D#','E','F','F#','G','G#','A','A#','B'];
        $midi = 20 + $n;
        $oct = (int)floor($midi / 12) - 1;
        return $chromatic[$midi % 12] . $oct;
    }
}
