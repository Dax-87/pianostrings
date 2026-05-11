<?php

namespace App\Database\Seeds;

use CodeIgniter\Database\Seeder;

class PianoStringSeeder extends Seeder
{
    public function run()
    {
        // Brands
        $this->db->table('ps_brands')->insertBatch([
            ['name' => 'Steinway & Sons',  'slug' => 'steinway', 'description' => 'Fondato a New York nel 1853, stabilimento ad Amburgo.', 'country' => 'USA / Germania'],
            ['name' => 'Yamaha',           'slug' => 'yamaha',   'description' => 'Produttore giapponese fondato nel 1887.', 'country' => 'Giappone'],
            ['name' => 'Kawai',            'slug' => 'kawai',    'description' => 'Produttore giapponese fondato nel 1927.', 'country' => 'Giappone'],
        ]);

        // Models for Steinway (brand_id = 1)
        $this->db->table('ps_models')->insertBatch([
            ['brand_id' => 1, 'code' => 'S', 'name' => 'Model S — 155 cm', 'total_strings' => 88, 'sort_order' => 1],
            ['brand_id' => 1, 'code' => 'M', 'name' => 'Model M — 170 cm', 'total_strings' => 88, 'sort_order' => 2],
            ['brand_id' => 1, 'code' => 'O', 'name' => 'Model O — 180 cm', 'total_strings' => 88, 'sort_order' => 3],
            ['brand_id' => 1, 'code' => 'L', 'name' => 'Model L — 188 cm', 'total_strings' => 88, 'sort_order' => 4],
            ['brand_id' => 1, 'code' => 'A', 'name' => 'Model A — 188 cm', 'total_strings' => 88, 'sort_order' => 5],
            ['brand_id' => 1, 'code' => 'B', 'name' => 'Model B — 211 cm', 'total_strings' => 88, 'sort_order' => 6],
            ['brand_id' => 1, 'code' => 'C', 'name' => 'Model C — 227 cm', 'total_strings' => 88, 'sort_order' => 7],
            ['brand_id' => 1, 'code' => 'D', 'name' => 'Model D — 274 cm', 'total_strings' => 88, 'sort_order' => 8],
        ]);

        // String sections for Model S (model_id=1)
        $this->db->table('ps_string_sections')->insertBatch([
            ['model_id' => 1, 'string_from' => 1,  'string_to' => 7,  'type' => 'wound2', 'gauge' => 9,   'copper1' => 8,   'copper2' => 4.5],
            ['model_id' => 1, 'string_from' => 8,  'string_to' => 14, 'type' => 'wound2', 'gauge' => 10,  'copper1' => 9,   'copper2' => 5],
            ['model_id' => 1, 'string_from' => 15, 'string_to' => 21, 'type' => 'wound2', 'gauge' => 11,  'copper1' => 10,  'copper2' => 5.5],
            ['model_id' => 1, 'string_from' => 22, 'string_to' => 28, 'type' => 'wound2', 'gauge' => 13,  'copper1' => 12,  'copper2' => 6],
            ['model_id' => 1, 'string_from' => 29, 'string_to' => 31, 'type' => 'wound1', 'gauge' => 14,  'copper1' => 6.5],
            ['model_id' => 1, 'string_from' => 32, 'string_to' => 37, 'type' => 'wound1', 'gauge' => 16,  'copper1' => 7],
            ['model_id' => 1, 'string_from' => 38, 'string_to' => 39, 'type' => 'plain',  'gauge' => 18],
            ['model_id' => 1, 'string_from' => 40, 'string_to' => 41, 'type' => 'plain',  'gauge' => 19],
            ['model_id' => 1, 'string_from' => 42, 'string_to' => 46, 'type' => 'plain',  'gauge' => 17],
            ['model_id' => 1, 'string_from' => 47, 'string_to' => 51, 'type' => 'plain',  'gauge' => 16.5],
            ['model_id' => 1, 'string_from' => 52, 'string_to' => 56, 'type' => 'plain',  'gauge' => 16],
            ['model_id' => 1, 'string_from' => 57, 'string_to' => 62, 'type' => 'plain',  'gauge' => 15.5],
            ['model_id' => 1, 'string_from' => 63, 'string_to' => 68, 'type' => 'plain',  'gauge' => 15],
            ['model_id' => 1, 'string_from' => 69, 'string_to' => 73, 'type' => 'plain',  'gauge' => 14.5],
            ['model_id' => 1, 'string_from' => 74, 'string_to' => 78, 'type' => 'plain',  'gauge' => 14],
            ['model_id' => 1, 'string_from' => 79, 'string_to' => 82, 'type' => 'plain',  'gauge' => 13.5],
            ['model_id' => 1, 'string_from' => 83, 'string_to' => 88, 'type' => 'plain',  'gauge' => 12.5],
        ]);

        // String sections for Model M (model_id=2)
        $this->db->table('ps_string_sections')->insertBatch([
            ['model_id' => 2, 'string_from' => 1,  'string_to' => 6,  'type' => 'wound2', 'gauge' => 9,   'copper1' => 8,   'copper2' => 4.5],
            ['model_id' => 2, 'string_from' => 7,  'string_to' => 11, 'type' => 'wound2', 'gauge' => 10,  'copper1' => 9,   'copper2' => 5],
            ['model_id' => 2, 'string_from' => 12, 'string_to' => 17, 'type' => 'wound2', 'gauge' => 12,  'copper1' => 10,  'copper2' => 5.5],
            ['model_id' => 2, 'string_from' => 18, 'string_to' => 23, 'type' => 'wound2', 'gauge' => 14,  'copper1' => 12,  'copper2' => 6],
            ['model_id' => 2, 'string_from' => 24, 'string_to' => 28, 'type' => 'wound1', 'gauge' => 15,  'copper1' => 7],
            ['model_id' => 2, 'string_from' => 29, 'string_to' => 34, 'type' => 'wound1', 'gauge' => 17,  'copper1' => 8],
            ['model_id' => 2, 'string_from' => 35, 'string_to' => 38, 'type' => 'plain',  'gauge' => 19],
            ['model_id' => 2, 'string_from' => 39, 'string_to' => 40, 'type' => 'plain',  'gauge' => 18],
            ['model_id' => 2, 'string_from' => 41, 'string_to' => 46, 'type' => 'plain',  'gauge' => 17],
            ['model_id' => 2, 'string_from' => 47, 'string_to' => 51, 'type' => 'plain',  'gauge' => 16.5],
            ['model_id' => 2, 'string_from' => 52, 'string_to' => 56, 'type' => 'plain',  'gauge' => 16],
            ['model_id' => 2, 'string_from' => 57, 'string_to' => 62, 'type' => 'plain',  'gauge' => 15.5],
            ['model_id' => 2, 'string_from' => 63, 'string_to' => 68, 'type' => 'plain',  'gauge' => 15],
            ['model_id' => 2, 'string_from' => 69, 'string_to' => 73, 'type' => 'plain',  'gauge' => 14.5],
            ['model_id' => 2, 'string_from' => 74, 'string_to' => 78, 'type' => 'plain',  'gauge' => 14],
            ['model_id' => 2, 'string_from' => 79, 'string_to' => 82, 'type' => 'plain',  'gauge' => 13.5],
            ['model_id' => 2, 'string_from' => 83, 'string_to' => 88, 'type' => 'plain',  'gauge' => 13],
        ]);

        // String sections for Model O (model_id=3)
        $this->db->table('ps_string_sections')->insertBatch([
            ['model_id' => 3, 'string_from' => 1,  'string_to' => 6,  'type' => 'wound2', 'gauge' => 9,   'copper1' => 8,   'copper2' => 4.5],
            ['model_id' => 3, 'string_from' => 7,  'string_to' => 11, 'type' => 'wound2', 'gauge' => 10,  'copper1' => 9,   'copper2' => 5],
            ['model_id' => 3, 'string_from' => 12, 'string_to' => 18, 'type' => 'wound2', 'gauge' => 12,  'copper1' => 10,  'copper2' => 5.5],
            ['model_id' => 3, 'string_from' => 19, 'string_to' => 25, 'type' => 'wound2', 'gauge' => 14,  'copper1' => 12,  'copper2' => 6],
            ['model_id' => 3, 'string_from' => 26, 'string_to' => 29, 'type' => 'wound1', 'gauge' => 16,  'copper1' => 7.5],
            ['model_id' => 3, 'string_from' => 30, 'string_to' => 34, 'type' => 'wound1', 'gauge' => 18,  'copper1' => 9],
            ['model_id' => 3, 'string_from' => 35, 'string_to' => 46, 'type' => 'plain',  'gauge' => 17],
            ['model_id' => 3, 'string_from' => 47, 'string_to' => 51, 'type' => 'plain',  'gauge' => 16.5],
            ['model_id' => 3, 'string_from' => 52, 'string_to' => 56, 'type' => 'plain',  'gauge' => 16],
            ['model_id' => 3, 'string_from' => 57, 'string_to' => 62, 'type' => 'plain',  'gauge' => 15.5],
            ['model_id' => 3, 'string_from' => 63, 'string_to' => 68, 'type' => 'plain',  'gauge' => 15],
            ['model_id' => 3, 'string_from' => 69, 'string_to' => 73, 'type' => 'plain',  'gauge' => 14.5],
            ['model_id' => 3, 'string_from' => 74, 'string_to' => 78, 'type' => 'plain',  'gauge' => 14],
            ['model_id' => 3, 'string_from' => 79, 'string_to' => 82, 'type' => 'plain',  'gauge' => 13.5],
            ['model_id' => 3, 'string_from' => 83, 'string_to' => 88, 'type' => 'plain',  'gauge' => 13],
        ]);

        // String sections for Model L (model_id=4)
        $this->db->table('ps_string_sections')->insertBatch([
            ['model_id' => 4, 'string_from' => 1,  'string_to' => 5,  'type' => 'wound2', 'gauge' => 9.5, 'copper1' => 8.5, 'copper2' => 4.5],
            ['model_id' => 4, 'string_from' => 6,  'string_to' => 10, 'type' => 'wound2', 'gauge' => 11,  'copper1' => 9.5, 'copper2' => 5],
            ['model_id' => 4, 'string_from' => 11, 'string_to' => 16, 'type' => 'wound2', 'gauge' => 13,  'copper1' => 11,  'copper2' => 5.5],
            ['model_id' => 4, 'string_from' => 17, 'string_to' => 22, 'type' => 'wound2', 'gauge' => 15,  'copper1' => 13,  'copper2' => 6.5],
            ['model_id' => 4, 'string_from' => 23, 'string_to' => 26, 'type' => 'wound1', 'gauge' => 16,  'copper1' => 7.5],
            ['model_id' => 4, 'string_from' => 27, 'string_to' => 33, 'type' => 'wound1', 'gauge' => 18,  'copper1' => 9],
            ['model_id' => 4, 'string_from' => 34, 'string_to' => 46, 'type' => 'plain',  'gauge' => 17],
            ['model_id' => 4, 'string_from' => 47, 'string_to' => 51, 'type' => 'plain',  'gauge' => 16.5],
            ['model_id' => 4, 'string_from' => 52, 'string_to' => 56, 'type' => 'plain',  'gauge' => 16],
            ['model_id' => 4, 'string_from' => 57, 'string_to' => 62, 'type' => 'plain',  'gauge' => 15.5],
            ['model_id' => 4, 'string_from' => 63, 'string_to' => 68, 'type' => 'plain',  'gauge' => 15],
            ['model_id' => 4, 'string_from' => 69, 'string_to' => 73, 'type' => 'plain',  'gauge' => 14.5],
            ['model_id' => 4, 'string_from' => 74, 'string_to' => 78, 'type' => 'plain',  'gauge' => 14],
            ['model_id' => 4, 'string_from' => 79, 'string_to' => 82, 'type' => 'plain',  'gauge' => 13.5],
            ['model_id' => 4, 'string_from' => 83, 'string_to' => 88, 'type' => 'plain',  'gauge' => 13],
        ]);

        // String sections for Model A (model_id=5)
        $this->db->table('ps_string_sections')->insertBatch([
            ['model_id' => 5, 'string_from' => 1,  'string_to' => 5,  'type' => 'wound2', 'gauge' => 9.5, 'copper1' => 8.5, 'copper2' => 4.5],
            ['model_id' => 5, 'string_from' => 6,  'string_to' => 10, 'type' => 'wound2', 'gauge' => 11,  'copper1' => 9.5, 'copper2' => 5],
            ['model_id' => 5, 'string_from' => 11, 'string_to' => 16, 'type' => 'wound2', 'gauge' => 13,  'copper1' => 11,  'copper2' => 5.5],
            ['model_id' => 5, 'string_from' => 17, 'string_to' => 22, 'type' => 'wound2', 'gauge' => 15,  'copper1' => 13,  'copper2' => 6.5],
            ['model_id' => 5, 'string_from' => 23, 'string_to' => 28, 'type' => 'wound1', 'gauge' => 17,  'copper1' => 8],
            ['model_id' => 5, 'string_from' => 29, 'string_to' => 34, 'type' => 'wound1', 'gauge' => 19,  'copper1' => 9.5],
            ['model_id' => 5, 'string_from' => 35, 'string_to' => 46, 'type' => 'plain',  'gauge' => 17],
            ['model_id' => 5, 'string_from' => 47, 'string_to' => 51, 'type' => 'plain',  'gauge' => 16.5],
            ['model_id' => 5, 'string_from' => 52, 'string_to' => 56, 'type' => 'plain',  'gauge' => 16],
            ['model_id' => 5, 'string_from' => 57, 'string_to' => 62, 'type' => 'plain',  'gauge' => 15.5],
            ['model_id' => 5, 'string_from' => 63, 'string_to' => 68, 'type' => 'plain',  'gauge' => 15],
            ['model_id' => 5, 'string_from' => 69, 'string_to' => 72, 'type' => 'plain',  'gauge' => 14.5],
            ['model_id' => 5, 'string_from' => 73, 'string_to' => 76, 'type' => 'plain',  'gauge' => 14],
            ['model_id' => 5, 'string_from' => 77, 'string_to' => 80, 'type' => 'plain',  'gauge' => 13.5],
            ['model_id' => 5, 'string_from' => 81, 'string_to' => 88, 'type' => 'plain',  'gauge' => 13],
        ]);

        // String sections for Model B (model_id=6)
        $this->db->table('ps_string_sections')->insertBatch([
            ['model_id' => 6, 'string_from' => 1,  'string_to' => 4,  'type' => 'wound2', 'gauge' => 13,  'copper1' => 11,  'copper2' => 5.5],
            ['model_id' => 6, 'string_from' => 5,  'string_to' => 9,  'type' => 'wound2', 'gauge' => 16,  'copper1' => 14,  'copper2' => 7],
            ['model_id' => 6, 'string_from' => 10, 'string_to' => 14, 'type' => 'wound1', 'gauge' => 18,  'copper1' => 8.5],
            ['model_id' => 6, 'string_from' => 15, 'string_to' => 19, 'type' => 'wound1', 'gauge' => 20,  'copper1' => 10],
            ['model_id' => 6, 'string_from' => 20, 'string_to' => 21, 'type' => 'plain',  'gauge' => 20],
            ['model_id' => 6, 'string_from' => 22, 'string_to' => 30, 'type' => 'plain',  'gauge' => 19],
            ['model_id' => 6, 'string_from' => 31, 'string_to' => 46, 'type' => 'plain',  'gauge' => 17],
            ['model_id' => 6, 'string_from' => 47, 'string_to' => 51, 'type' => 'plain',  'gauge' => 16.5],
            ['model_id' => 6, 'string_from' => 52, 'string_to' => 56, 'type' => 'plain',  'gauge' => 16],
            ['model_id' => 6, 'string_from' => 57, 'string_to' => 62, 'type' => 'plain',  'gauge' => 15.5],
            ['model_id' => 6, 'string_from' => 63, 'string_to' => 68, 'type' => 'plain',  'gauge' => 15],
            ['model_id' => 6, 'string_from' => 69, 'string_to' => 73, 'type' => 'plain',  'gauge' => 14.5],
            ['model_id' => 6, 'string_from' => 74, 'string_to' => 78, 'type' => 'plain',  'gauge' => 14],
            ['model_id' => 6, 'string_from' => 79, 'string_to' => 82, 'type' => 'plain',  'gauge' => 13.5],
            ['model_id' => 6, 'string_from' => 83, 'string_to' => 88, 'type' => 'plain',  'gauge' => 13],
        ]);

        // String sections for Model C (model_id=7)
        $this->db->table('ps_string_sections')->insertBatch([
            ['model_id' => 7, 'string_from' => 1,  'string_to' => 3,  'type' => 'wound2', 'gauge' => 14,  'copper1' => 12,  'copper2' => 6],
            ['model_id' => 7, 'string_from' => 4,  'string_to' => 8,  'type' => 'wound2', 'gauge' => 17,  'copper1' => 15,  'copper2' => 7],
            ['model_id' => 7, 'string_from' => 9,  'string_to' => 12, 'type' => 'wound1', 'gauge' => 19,  'copper1' => 9],
            ['model_id' => 7, 'string_from' => 13, 'string_to' => 16, 'type' => 'wound1', 'gauge' => 21,  'copper1' => 11],
            ['model_id' => 7, 'string_from' => 17, 'string_to' => 18, 'type' => 'plain',  'gauge' => 20],
            ['model_id' => 7, 'string_from' => 19, 'string_to' => 26, 'type' => 'plain',  'gauge' => 19],
            ['model_id' => 7, 'string_from' => 27, 'string_to' => 46, 'type' => 'plain',  'gauge' => 17],
            ['model_id' => 7, 'string_from' => 47, 'string_to' => 50, 'type' => 'plain',  'gauge' => 17.5],
            ['model_id' => 7, 'string_from' => 51, 'string_to' => 55, 'type' => 'plain',  'gauge' => 16.5],
            ['model_id' => 7, 'string_from' => 56, 'string_to' => 60, 'type' => 'plain',  'gauge' => 16],
            ['model_id' => 7, 'string_from' => 61, 'string_to' => 66, 'type' => 'plain',  'gauge' => 15.5],
            ['model_id' => 7, 'string_from' => 67, 'string_to' => 72, 'type' => 'plain',  'gauge' => 15],
            ['model_id' => 7, 'string_from' => 73, 'string_to' => 76, 'type' => 'plain',  'gauge' => 14.5],
            ['model_id' => 7, 'string_from' => 77, 'string_to' => 80, 'type' => 'plain',  'gauge' => 14],
            ['model_id' => 7, 'string_from' => 81, 'string_to' => 88, 'type' => 'plain',  'gauge' => 13],
        ]);

        // String sections for Model D (model_id=8)
        $this->db->table('ps_string_sections')->insertBatch([
            ['model_id' => 8, 'string_from' => 1,  'string_to' => 3,  'type' => 'wound2', 'gauge' => 14,  'copper1' => 12,  'copper2' => 6],
            ['model_id' => 8, 'string_from' => 4,  'string_to' => 8,  'type' => 'wound2', 'gauge' => 17,  'copper1' => 15,  'copper2' => 7.5],
            ['model_id' => 8, 'string_from' => 9,  'string_to' => 12, 'type' => 'wound1', 'gauge' => 20,  'copper1' => 9.5],
            ['model_id' => 8, 'string_from' => 13, 'string_to' => 16, 'type' => 'wound1', 'gauge' => 22,  'copper1' => 11.5],
            ['model_id' => 8, 'string_from' => 17, 'string_to' => 18, 'type' => 'plain',  'gauge' => 21],
            ['model_id' => 8, 'string_from' => 19, 'string_to' => 26, 'type' => 'plain',  'gauge' => 20],
            ['model_id' => 8, 'string_from' => 27, 'string_to' => 36, 'type' => 'plain',  'gauge' => 18],
            ['model_id' => 8, 'string_from' => 37, 'string_to' => 46, 'type' => 'plain',  'gauge' => 17],
            ['model_id' => 8, 'string_from' => 47, 'string_to' => 51, 'type' => 'plain',  'gauge' => 16.5],
            ['model_id' => 8, 'string_from' => 52, 'string_to' => 56, 'type' => 'plain',  'gauge' => 16],
            ['model_id' => 8, 'string_from' => 57, 'string_to' => 62, 'type' => 'plain',  'gauge' => 15.5],
            ['model_id' => 8, 'string_from' => 63, 'string_to' => 68, 'type' => 'plain',  'gauge' => 15],
            ['model_id' => 8, 'string_from' => 69, 'string_to' => 73, 'type' => 'plain',  'gauge' => 14.5],
            ['model_id' => 8, 'string_from' => 74, 'string_to' => 78, 'type' => 'plain',  'gauge' => 14],
            ['model_id' => 8, 'string_from' => 79, 'string_to' => 82, 'type' => 'plain',  'gauge' => 13.5],
            ['model_id' => 8, 'string_from' => 83, 'string_to' => 88, 'type' => 'plain',  'gauge' => 13],
        ]);

        // Gauge reference
        $gaugeData = [];
        $gauges = [
            [9, 0.575, 2.08, 275, 71], [9.5, 0.600, 2.26, 272, 77],
            [10, 0.625, 2.45, 270, 83], [11, 0.675, 2.86, 265, 95],
            [11.5, 0.700, 3.08, 262, 101],
            [12, 0.725, 3.30, 260, 108], [12.5, 0.750, 3.53, 260, 115],
            [13, 0.775, 3.76, 255, 120], [13.5, 0.800, 4.00, 250, 125],
            [14, 0.825, 4.25, 245, 130], [14.5, 0.850, 4.52, 240, 137],
            [15, 0.875, 4.79, 240, 145], [15.5, 0.900, 5.06, 240, 152],
            [16, 0.925, 5.35, 240, 160], [16.5, 0.950, 5.64, 235, 167],
            [17, 0.975, 5.94, 235, 175], [17.5, 1.000, 6.25, 235, 182],
            [18, 1.025, 6.57, 230, 190], [18.5, 1.050, 6.89, 230, 197],
            [19, 1.075, 7.22, 225, 205], [19.5, 1.100, 7.56, 225, 215],
            [20, 1.125, 7.91, 225, 225], [20.5, 1.150, 8.27, 225, 235],
            [21, 1.175, 8.63, 225, 245], [21.5, 1.200, 9.00, 225, 255],
            [22, 1.225, 9.38, 225, 265], [22.5, 1.250, 9.77, 220, 275],
            [23, 1.300, 10.56, 220, 290], [23.5, 1.350, 11.39, 215, 305],
            [24, 1.400, 12.25, 210, 320], [24.5, 1.450, 13.14, 210, 350],
            [25, 1.500, 14.06, 210, 370], [25.5, 1.550, 15.02, 210, 400],
            [26, 1.600, 16.00, 210, 425], [27, 1.700, 18.00, 200, 450],
            [28, 1.800, 20.20, 200, 510],
        ];
        foreach ($gauges as $g) {
            $gaugeData[] = ['gauge' => $g[0], 'diameter_mm' => $g[1], 'weight_gm' => $g[2], 'resist_mm2' => $g[3], 'resist_kg' => $g[4]];
        }
        $this->db->table('ps_gauge_reference')->insertBatch($gaugeData);

        // Official Steinway table
        $this->db->table('ps_official_steinway')->insertBatch([
            ['model_label' => 'Model S',                    'sort_order' => 1,  'gauge_12_5'=>2, 'gauge_13'=>4, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>5, 'gauge_15'=>6, 'gauge_15_5'=>6, 'gauge_16'=>5, 'gauge_16_5'=>6, 'gauge_17'=>12, 'gauge_18'=>2, 'gauge_19'=>2],
            ['model_label' => 'Model M',                    'sort_order' => 2,  'gauge_13'=>6, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>5, 'gauge_15'=>6, 'gauge_15_5'=>6, 'gauge_16'=>5, 'gauge_16_5'=>6, 'gauge_17'=>12, 'gauge_18'=>2, 'gauge_19'=>4],
            ['model_label' => 'Model L',                    'sort_order' => 3,  'gauge_13'=>6, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>5, 'gauge_15'=>6, 'gauge_15_5'=>6, 'gauge_16'=>5, 'gauge_16_5'=>6, 'gauge_17'=>12, 'gauge_18'=>8],
            ['model_label' => 'Model O',                    'sort_order' => 4,  'gauge_13'=>6, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>5, 'gauge_15'=>6, 'gauge_15_5'=>6, 'gauge_16'=>5, 'gauge_16_5'=>6, 'gauge_17'=>12, 'gauge_18'=>8],
            ['model_label' => '85 Tasti - Model A < 72000', 'sort_order' => 5,  'gauge_13'=>4, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>5, 'gauge_15_5'=>6, 'gauge_16'=>6, 'gauge_16_5'=>5, 'gauge_17'=>12, 'gauge_18'=>6],
            ['model_label' => 'Model A < 86000',            'sort_order' => 6,  'gauge_13'=>6, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>6, 'gauge_15_5'=>6, 'gauge_16'=>6, 'gauge_16_5'=>5, 'gauge_17'=>12, 'gauge_18'=>6],
            ['model_label' => 'Model A > 86000',            'sort_order' => 7,  'gauge_13'=>6, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>6, 'gauge_15_5'=>6, 'gauge_16'=>6, 'gauge_16_5'=>5, 'gauge_17'=>12, 'gauge_18'=>4, 'gauge_19'=>4, 'gauge_20'=>2],
            ['model_label' => '85 Tasti - Model B < 73226', 'sort_order' => 8,  'gauge_13'=>4, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>5, 'gauge_15_5'=>6, 'gauge_16'=>6, 'gauge_16_5'=>5, 'gauge_17'=>12, 'gauge_18'=>8, 'gauge_19'=>5, 'gauge_20'=>2],
            ['model_label' => 'Model B > 73226',            'sort_order' => 9,  'gauge_13'=>6, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>6, 'gauge_15_5'=>6, 'gauge_16'=>6, 'gauge_16_5'=>5, 'gauge_17'=>12, 'gauge_18'=>8, 'gauge_19'=>5, 'gauge_20'=>2],
            ['model_label' => '85 Tasti - Model C < 58952', 'sort_order' => 10, 'gauge_13'=>4, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>5, 'gauge_15_5'=>5, 'gauge_16'=>5, 'gauge_16_5'=>5, 'gauge_17'=>12, 'gauge_18'=>7, 'gauge_19'=>5, 'gauge_20'=>4],
            ['model_label' => 'Model C > 58952',            'sort_order' => 11, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>5, 'gauge_15_5'=>8, 'gauge_16'=>6, 'gauge_16_5'=>4, 'gauge_17'=>3, 'gauge_17_5'=>4, 'gauge_18'=>8, 'gauge_19'=>8, 'gauge_20'=>8, 'gauge_21'=>2],
            ['model_label' => 'Concert < 33000',            'sort_order' => 12, 'gauge_12_5'=>4, 'gauge_13'=>4, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>4, 'gauge_15_5'=>8, 'gauge_16'=>8, 'gauge_16_5'=>12, 'gauge_18'=>4, 'gauge_19'=>4, 'gauge_20'=>4, 'gauge_21'=>4, 'gauge_22'=>2, 'gauge_23'=>1],
            ['model_label' => 'Centennial < 51272',         'sort_order' => 13, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>4, 'gauge_15_5'=>9, 'gauge_16'=>6, 'gauge_16_5'=>8, 'gauge_17'=>6, 'gauge_18'=>8, 'gauge_19'=>8, 'gauge_20'=>4, 'gauge_21'=>4],
            ['model_label' => 'Model D > 51272',            'sort_order' => 14, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>5, 'gauge_15'=>8, 'gauge_15_5'=>6, 'gauge_16'=>6, 'gauge_16_5'=>8, 'gauge_18'=>6, 'gauge_19'=>7, 'gauge_20'=>6, 'gauge_21'=>4],
            ['model_label' => 'Model 40',                   'sort_order' => 15, 'gauge_12'=>2, 'gauge_12_5'=>4, 'gauge_13'=>4, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>4, 'gauge_15_5'=>4, 'gauge_16'=>6, 'gauge_16_5'=>6, 'gauge_17'=>4, 'gauge_17_5'=>4],
            ['model_label' => 'Model 100',                  'sort_order' => 16, 'gauge_12'=>2, 'gauge_12_5'=>4, 'gauge_13'=>4, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>4, 'gauge_15_5'=>4, 'gauge_16'=>6, 'gauge_16_5'=>6, 'gauge_17'=>4, 'gauge_17_5'=>2, 'gauge_18'=>2, 'gauge_19'=>2],
            ['model_label' => 'Model 45, 1098',             'sort_order' => 17, 'gauge_12_5'=>2, 'gauge_13'=>4, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>6, 'gauge_15_5'=>6, 'gauge_16'=>5, 'gauge_16_5'=>6, 'gauge_17'=>13, 'gauge_18'=>2, 'gauge_19'=>2, 'gauge_20'=>2],
            ['model_label' => 'Model I, R, S, T, FF, N',    'sort_order' => 18, 'gauge_13'=>6, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>4, 'gauge_15_5'=>4, 'gauge_16'=>9, 'gauge_16_5'=>8, 'gauge_17'=>8, 'gauge_18'=>11],
            ['model_label' => 'Model O-85 Note',            'sort_order' => 19, 'gauge_13'=>4, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>6, 'gauge_15'=>10, 'gauge_15_5'=>4, 'gauge_16'=>4, 'gauge_16_5'=>4, 'gauge_17'=>8, 'gauge_18'=>6],
            ['model_label' => 'Model F, L, X',              'sort_order' => 20, 'gauge_13'=>7, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>4, 'gauge_15_5'=>4, 'gauge_16'=>8, 'gauge_16_5'=>8, 'gauge_17'=>8, 'gauge_18'=>11],
            ['model_label' => 'Model G',                    'sort_order' => 21, 'gauge_13'=>6, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>5, 'gauge_15_5'=>6, 'gauge_16'=>4, 'gauge_16_5'=>8, 'gauge_17'=>12, 'gauge_18'=>6],
            ['model_label' => 'Model M',                    'sort_order' => 22, 'gauge_13'=>7, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>4, 'gauge_15_5'=>4, 'gauge_16'=>8, 'gauge_16_5'=>8, 'gauge_17'=>8, 'gauge_18'=>11],
            ['model_label' => 'Model F-85 Note',            'sort_order' => 23, 'gauge_13'=>3, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>5, 'gauge_15_5'=>6, 'gauge_16'=>4, 'gauge_16_5'=>8, 'gauge_17'=>12, 'gauge_18'=>6],
            ['model_label' => 'Model E',                    'sort_order' => 24, 'gauge_13'=>7, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>4, 'gauge_15_5'=>4, 'gauge_16'=>8, 'gauge_16_5'=>8, 'gauge_17'=>8, 'gauge_18'=>6],
            ['model_label' => 'Model E-85 Note',            'sort_order' => 25, 'gauge_13'=>4, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>4, 'gauge_15_5'=>4, 'gauge_16'=>8, 'gauge_16_5'=>8, 'gauge_17'=>8, 'gauge_18'=>6],
            ['model_label' => 'Model V',                    'sort_order' => 26, 'gauge_13'=>6, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>4, 'gauge_15_5'=>4, 'gauge_16'=>9, 'gauge_16_5'=>8, 'gauge_17'=>8, 'gauge_18'=>9],
            ['model_label' => 'Model K (Vertegrand)',       'sort_order' => 27, 'gauge_13'=>6, 'gauge_13_5'=>4, 'gauge_14'=>4, 'gauge_14_5'=>4, 'gauge_15'=>4, 'gauge_15_5'=>4, 'gauge_16'=>9, 'gauge_16_5'=>8, 'gauge_17'=>8, 'gauge_18'=>11],
        ]);
    }
}
