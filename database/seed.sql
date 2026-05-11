-- PianoStringDB - Dati iniziali
-- Esegui dopo aver creato il database con schema.sql

USE `pianostrings_db`;

-- Marche
INSERT INTO `ps_brands` (`name`, `slug`, `description`, `country`) VALUES
('Steinway & Sons', 'steinway', 'Fondato a New York nel 1853, stabilimento ad Amburgo.', 'USA / Germania'),
('Yamaha', 'yamaha', 'Produttore giapponese fondato nel 1887.', 'Giappone'),
('Kawai', 'kawai', 'Produttore giapponese fondato nel 1927.', 'Giappone');

-- Modelli Steinway
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`) VALUES
(1, 'S', 'Model S — 155 cm', 88, 1),
(1, 'M', 'Model M — 170 cm', 88, 2),
(1, 'O', 'Model O — 180 cm', 88, 3),
(1, 'L', 'Model L — 188 cm', 88, 4),
(1, 'A', 'Model A — 188 cm', 88, 5),
(1, 'B', 'Model B — 211 cm', 88, 6),
(1, 'C', 'Model C — 227 cm', 88, 7),
(1, 'D', 'Model D — 274 cm', 88, 8);

-- Sezioni corde Model S
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`) VALUES
(1, 1, 7, 'wound2', 9.0, 8.00, 4.50),
(1, 8, 14, 'wound2', 10.0, 9.00, 5.00),
(1, 15, 21, 'wound2', 11.0, 10.00, 5.50),
(1, 22, 28, 'wound2', 13.0, 12.00, 6.00),
(1, 29, 31, 'wound1', 14.0, 6.50, NULL),
(1, 32, 37, 'wound1', 16.0, 7.00, NULL),
(1, 38, 39, 'plain', 18.0, NULL, NULL),
(1, 40, 41, 'plain', 19.0, NULL, NULL),
(1, 42, 46, 'plain', 17.0, NULL, NULL),
(1, 47, 51, 'plain', 16.5, NULL, NULL),
(1, 52, 56, 'plain', 16.0, NULL, NULL),
(1, 57, 62, 'plain', 15.5, NULL, NULL),
(1, 63, 68, 'plain', 15.0, NULL, NULL),
(1, 69, 73, 'plain', 14.5, NULL, NULL),
(1, 74, 78, 'plain', 14.0, NULL, NULL),
(1, 79, 82, 'plain', 13.5, NULL, NULL),
(1, 83, 88, 'plain', 12.5, NULL, NULL);

-- Sezioni corde Model M
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`) VALUES
(2, 1, 6, 'wound2', 9.0, 8.00, 4.50),
(2, 7, 11, 'wound2', 10.0, 9.00, 5.00),
(2, 12, 17, 'wound2', 12.0, 10.00, 5.50),
(2, 18, 23, 'wound2', 14.0, 12.00, 6.00),
(2, 24, 28, 'wound1', 15.0, 7.00, NULL),
(2, 29, 34, 'wound1', 17.0, 8.00, NULL),
(2, 35, 38, 'plain', 19.0, NULL, NULL),
(2, 39, 40, 'plain', 18.0, NULL, NULL),
(2, 41, 46, 'plain', 17.0, NULL, NULL),
(2, 47, 51, 'plain', 16.5, NULL, NULL),
(2, 52, 56, 'plain', 16.0, NULL, NULL),
(2, 57, 62, 'plain', 15.5, NULL, NULL),
(2, 63, 68, 'plain', 15.0, NULL, NULL),
(2, 69, 73, 'plain', 14.5, NULL, NULL),
(2, 74, 78, 'plain', 14.0, NULL, NULL),
(2, 79, 82, 'plain', 13.5, NULL, NULL),
(2, 83, 88, 'plain', 13.0, NULL, NULL);

-- Sezioni corde Model O
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`) VALUES
(3, 1, 6, 'wound2', 9.0, 8.00, 4.50),
(3, 7, 11, 'wound2', 10.0, 9.00, 5.00),
(3, 12, 18, 'wound2', 12.0, 10.00, 5.50),
(3, 19, 25, 'wound2', 14.0, 12.00, 6.00),
(3, 26, 29, 'wound1', 16.0, 7.50, NULL),
(3, 30, 34, 'wound1', 18.0, 9.00, NULL),
(3, 35, 46, 'plain', 17.0, NULL, NULL),
(3, 47, 51, 'plain', 16.5, NULL, NULL),
(3, 52, 56, 'plain', 16.0, NULL, NULL),
(3, 57, 62, 'plain', 15.5, NULL, NULL),
(3, 63, 68, 'plain', 15.0, NULL, NULL),
(3, 69, 73, 'plain', 14.5, NULL, NULL),
(3, 74, 78, 'plain', 14.0, NULL, NULL),
(3, 79, 82, 'plain', 13.5, NULL, NULL),
(3, 83, 88, 'plain', 13.0, NULL, NULL);

-- Sezioni corde Model L
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`) VALUES
(4, 1, 5, 'wound2', 9.5, 8.50, 4.50),
(4, 6, 10, 'wound2', 11.0, 9.50, 5.00),
(4, 11, 16, 'wound2', 13.0, 11.00, 5.50),
(4, 17, 22, 'wound2', 15.0, 13.00, 6.50),
(4, 23, 26, 'wound1', 16.0, 7.50, NULL),
(4, 27, 33, 'wound1', 18.0, 9.00, NULL),
(4, 34, 46, 'plain', 17.0, NULL, NULL),
(4, 47, 51, 'plain', 16.5, NULL, NULL),
(4, 52, 56, 'plain', 16.0, NULL, NULL),
(4, 57, 62, 'plain', 15.5, NULL, NULL),
(4, 63, 68, 'plain', 15.0, NULL, NULL),
(4, 69, 73, 'plain', 14.5, NULL, NULL),
(4, 74, 78, 'plain', 14.0, NULL, NULL),
(4, 79, 82, 'plain', 13.5, NULL, NULL),
(4, 83, 88, 'plain', 13.0, NULL, NULL);

-- Sezioni corde Model A
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`) VALUES
(5, 1, 5, 'wound2', 9.5, 8.50, 4.50),
(5, 6, 10, 'wound2', 11.0, 9.50, 5.00),
(5, 11, 16, 'wound2', 13.0, 11.00, 5.50),
(5, 17, 22, 'wound2', 15.0, 13.00, 6.50),
(5, 23, 28, 'wound1', 17.0, 8.00, NULL),
(5, 29, 34, 'wound1', 19.0, 9.50, NULL),
(5, 35, 46, 'plain', 17.0, NULL, NULL),
(5, 47, 51, 'plain', 16.5, NULL, NULL),
(5, 52, 56, 'plain', 16.0, NULL, NULL),
(5, 57, 62, 'plain', 15.5, NULL, NULL),
(5, 63, 68, 'plain', 15.0, NULL, NULL),
(5, 69, 72, 'plain', 14.5, NULL, NULL),
(5, 73, 76, 'plain', 14.0, NULL, NULL),
(5, 77, 80, 'plain', 13.5, NULL, NULL),
(5, 81, 88, 'plain', 13.0, NULL, NULL);

-- Sezioni corde Model B
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`) VALUES
(6, 1, 4, 'wound2', 13.0, 11.00, 5.50),
(6, 5, 9, 'wound2', 16.0, 14.00, 7.00),
(6, 10, 14, 'wound1', 18.0, 8.50, NULL),
(6, 15, 19, 'wound1', 20.0, 10.00, NULL),
(6, 20, 21, 'plain', 20.0, NULL, NULL),
(6, 22, 30, 'plain', 19.0, NULL, NULL),
(6, 31, 46, 'plain', 17.0, NULL, NULL),
(6, 47, 51, 'plain', 16.5, NULL, NULL),
(6, 52, 56, 'plain', 16.0, NULL, NULL),
(6, 57, 62, 'plain', 15.5, NULL, NULL),
(6, 63, 68, 'plain', 15.0, NULL, NULL),
(6, 69, 73, 'plain', 14.5, NULL, NULL),
(6, 74, 78, 'plain', 14.0, NULL, NULL),
(6, 79, 82, 'plain', 13.5, NULL, NULL),
(6, 83, 88, 'plain', 13.0, NULL, NULL);

-- Sezioni corde Model C
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`) VALUES
(7, 1, 3, 'wound2', 14.0, 12.00, 6.00),
(7, 4, 8, 'wound2', 17.0, 15.00, 7.00),
(7, 9, 12, 'wound1', 19.0, 9.00, NULL),
(7, 13, 16, 'wound1', 21.0, 11.00, NULL),
(7, 17, 18, 'plain', 20.0, NULL, NULL),
(7, 19, 26, 'plain', 19.0, NULL, NULL),
(7, 27, 46, 'plain', 17.0, NULL, NULL),
(7, 47, 50, 'plain', 17.5, NULL, NULL),
(7, 51, 55, 'plain', 16.5, NULL, NULL),
(7, 56, 60, 'plain', 16.0, NULL, NULL),
(7, 61, 66, 'plain', 15.5, NULL, NULL),
(7, 67, 72, 'plain', 15.0, NULL, NULL),
(7, 73, 76, 'plain', 14.5, NULL, NULL),
(7, 77, 80, 'plain', 14.0, NULL, NULL),
(7, 81, 88, 'plain', 13.0, NULL, NULL);

-- Sezioni corde Model D
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`) VALUES
(8, 1, 3, 'wound2', 14.0, 12.00, 6.00),
(8, 4, 8, 'wound2', 17.0, 15.00, 7.50),
(8, 9, 12, 'wound1', 20.0, 9.50, NULL),
(8, 13, 16, 'wound1', 22.0, 11.50, NULL),
(8, 17, 18, 'plain', 21.0, NULL, NULL),
(8, 19, 26, 'plain', 20.0, NULL, NULL),
(8, 27, 36, 'plain', 18.0, NULL, NULL),
(8, 37, 46, 'plain', 17.0, NULL, NULL),
(8, 47, 51, 'plain', 16.5, NULL, NULL),
(8, 52, 56, 'plain', 16.0, NULL, NULL),
(8, 57, 62, 'plain', 15.5, NULL, NULL),
(8, 63, 68, 'plain', 15.0, NULL, NULL),
(8, 69, 73, 'plain', 14.5, NULL, NULL),
(8, 74, 78, 'plain', 14.0, NULL, NULL),
(8, 79, 82, 'plain', 13.5, NULL, NULL),
(8, 83, 88, 'plain', 13.0, NULL, NULL);

-- Tabella gauge di riferimento
INSERT INTO `ps_gauge_reference` (`gauge`, `diameter_mm`, `weight_gm`, `resist_mm2`, `resist_kg`) VALUES
(9.0, 0.5750, 2.08, 275, 71),
(9.5, 0.6000, 2.26, 272, 77),
(10.0, 0.6250, 2.45, 270, 83),
(11.0, 0.6750, 2.86, 265, 95),
(11.5, 0.7000, 3.08, 262, 101),
(12.0, 0.7250, 3.30, 260, 108),
(12.5, 0.7500, 3.53, 260, 115),
(13.0, 0.7750, 3.76, 255, 120),
(13.5, 0.8000, 4.00, 250, 125),
(14.0, 0.8250, 4.25, 245, 130),
(14.5, 0.8500, 4.52, 240, 137),
(15.0, 0.8750, 4.79, 240, 145),
(15.5, 0.9000, 5.06, 240, 152),
(16.0, 0.9250, 5.35, 240, 160),
(16.5, 0.9500, 5.64, 235, 167),
(17.0, 0.9750, 5.94, 235, 175),
(17.5, 1.0000, 6.25, 235, 182),
(18.0, 1.0250, 6.57, 230, 190),
(18.5, 1.0500, 6.89, 230, 197),
(19.0, 1.0750, 7.22, 225, 205),
(19.5, 1.1000, 7.56, 225, 215),
(20.0, 1.1250, 7.91, 225, 225),
(20.5, 1.1500, 8.27, 225, 235),
(21.0, 1.1750, 8.63, 225, 245),
(21.5, 1.2000, 9.00, 225, 255),
(22.0, 1.2250, 9.38, 225, 265),
(22.5, 1.2500, 9.77, 220, 275),
(23.0, 1.3000, 10.56, 220, 290),
(23.5, 1.3500, 11.39, 215, 305),
(24.0, 1.4000, 12.25, 210, 320),
(24.5, 1.4500, 13.14, 210, 350),
(25.0, 1.5000, 14.06, 210, 370),
(25.5, 1.5500, 15.02, 210, 400),
(26.0, 1.6000, 16.00, 210, 425),
(27.0, 1.7000, 18.00, 200, 450),
(28.0, 1.8000, 20.20, 200, 510);

-- Tabella ufficiale Steinway
INSERT INTO `ps_official_steinway` (`model_label`, `sort_order`,
  `gauge_12`, `gauge_12_5`, `gauge_13`, `gauge_13_5`, `gauge_14`, `gauge_14_5`,
  `gauge_15`, `gauge_15_5`, `gauge_16`, `gauge_16_5`, `gauge_17`, `gauge_17_5`,
  `gauge_18`, `gauge_19`, `gauge_20`, `gauge_21`, `gauge_22`, `gauge_23`)
VALUES
('Model S',                    1,  0, 2, 4, 4, 4, 5, 6, 6, 5, 6, 12, 0,  2, 2, 0, 0, 0, 0),
('Model M',                    2,  0, 0, 6, 4, 4, 5, 6, 6, 5, 6, 12, 0,  2, 4, 0, 0, 0, 0),
('Model L',                    3,  0, 0, 6, 4, 4, 5, 6, 6, 5, 6, 12, 0,  8, 0, 0, 0, 0, 0),
('Model O',                    4,  0, 0, 6, 4, 4, 5, 6, 6, 5, 6, 12, 0,  8, 0, 0, 0, 0, 0),
('85 Tasti - Model A < 72000', 5,  0, 0, 4, 4, 4, 4, 5, 6, 6, 5, 12, 0,  6, 0, 0, 0, 0, 0),
('Model A < 86000',            6,  0, 0, 6, 4, 4, 4, 6, 6, 6, 5, 12, 0,  6, 0, 0, 0, 0, 0),
('Model A > 86000',            7,  0, 0, 6, 4, 4, 4, 6, 6, 6, 5, 12, 0,  4, 4, 2, 0, 0, 0),
('85 Tasti - Model B < 73226', 8,  0, 0, 4, 4, 4, 4, 5, 6, 6, 5, 12, 0,  8, 5, 2, 0, 0, 0),
('Model B > 73226',            9,  0, 0, 6, 4, 4, 4, 6, 6, 6, 5, 12, 0,  8, 5, 2, 0, 0, 0),
('85 Tasti - Model C < 58952', 10, 0, 0, 4, 4, 4, 4, 5, 5, 5, 5, 12, 0,  7, 5, 4, 0, 0, 0),
('Model C > 58952',            11, 0, 0, 0, 4, 4, 4, 5, 8, 6, 4,  3, 4,  8, 8, 8, 2, 0, 0),
('Concert < 33000',            12, 0, 4, 4, 4, 4, 4, 4, 8, 8,12,  0, 0,  4, 4, 4, 4, 2, 1),
('Centennial < 51272',         13, 0, 0, 0, 0, 4, 4, 4, 9, 6, 8,  6, 0,  8, 8, 4, 4, 0, 0),
('Model D > 51272',            14, 0, 0, 0, 4, 4, 5, 8, 6, 6, 8,  0, 0,  6, 7, 6, 4, 0, 0),
('Model 40',                   15, 2, 4, 4, 4, 4, 4, 4, 4, 6, 6,  4, 4,  0, 0, 0, 0, 0, 0),
('Model 100',                  16, 2, 4, 4, 4, 4, 4, 4, 4, 6, 6,  4, 2,  2, 2, 0, 0, 0, 0),
('Model 45, 1098',             17, 0, 2, 4, 4, 4, 4, 6, 6, 5, 6, 13, 0,  2, 2, 2, 0, 0, 0),
('Model I, R, S, T, FF, N',    18, 0, 0, 6, 4, 4, 4, 4, 4, 9, 8,  8, 0, 11, 0, 0, 0, 0, 0),
('Model O-85 Note',            19, 0, 0, 4, 4, 4, 6,10, 4, 4, 4,  8, 0,  6, 0, 0, 0, 0, 0),
('Model F, L, X',              20, 0, 0, 7, 4, 4, 4, 4, 4, 8, 8,  8, 0, 11, 0, 0, 0, 0, 0),
('Model G',                    21, 0, 0, 6, 4, 4, 4, 5, 6, 4, 8, 12, 0,  6, 0, 0, 0, 0, 0),
('Model M',                    22, 0, 0, 7, 4, 4, 4, 4, 4, 8, 8,  8, 0, 11, 0, 0, 0, 0, 0),
('Model F-85 Note',            23, 0, 0, 3, 4, 4, 4, 5, 6, 4, 8, 12, 0,  6, 0, 0, 0, 0, 0),
('Model E',                    24, 0, 0, 7, 4, 4, 4, 4, 4, 8, 8,  8, 0,  6, 0, 0, 0, 0, 0),
('Model E-85 Note',            25, 0, 0, 4, 4, 4, 4, 4, 4, 8, 8,  8, 0,  6, 0, 0, 0, 0, 0),
('Model V',                    26, 0, 0, 6, 4, 4, 4, 4, 4, 9, 8,  8, 0,  9, 0, 0, 0, 0, 0),
('Model K (Vertegrand)',       27, 0, 0, 6, 4, 4, 4, 4, 4, 9, 8,  8, 0, 11, 0, 0, 0, 0, 0);

-- Admin user (password: admin)
INSERT INTO `ps_admins` (`username`, `password`) VALUES ('admin', '$2y$12$ThAyeWV518QGc0XbG8blfOCzYhiNDRbj30MqUrocCPPKFbFmFJAg2');
