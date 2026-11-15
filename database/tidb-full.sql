-- ============================================================================
--  PianoStringDB — import completo (schema + tutti i dati)
--
--  Per database gestiti dove non puoi usare la riga di comando
--  (TiDB Cloud SQL Editor, phpMyAdmin): incolla questo file ed esegui.
--
--  ATTENZIONE: file GENERATO. Non modificarlo a mano.
--  Sorgenti: database/schema.sql + database/seed.sql + database/seed-brands.sql
--  Rigeneralo con:
--    ./database/build-tidb-full.sh
--
--  Contenuto: 5 marche, 160 modelli, 2350 sezioni, tabella calibri,
--  guida ufficiale Steinway, 1 utente admin (admin / admin — da cambiare).
-- ============================================================================

CREATE DATABASE IF NOT EXISTS `pianostrings_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `pianostrings_db`;

DROP TABLE IF EXISTS `ps_contributions`;
DROP TABLE IF EXISTS `ps_admins`;
DROP TABLE IF EXISTS `ps_official_steinway`;
DROP TABLE IF EXISTS `ps_string_sections`;
DROP TABLE IF EXISTS `ps_gauge_reference`;
DROP TABLE IF EXISTS `ps_models`;
DROP TABLE IF EXISTS `ps_brands`;

CREATE TABLE `ps_brands` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text,
  `country` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ps_models` (
  `id` int NOT NULL AUTO_INCREMENT,
  `brand_id` int NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `total_strings` int NOT NULL DEFAULT '88',
  `sort_order` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_brand_model` (`brand_id`,`code`),
  CONSTRAINT `ps_models_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `ps_brands` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ps_string_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `model_id` int NOT NULL,
  `section_name` varchar(200) DEFAULT NULL,
  `string_from` int NOT NULL,
  `string_to` int NOT NULL,
  `type` enum('plain','wound','wound1','wound2') NOT NULL DEFAULT 'plain',
  `gauge` decimal(4,1) DEFAULT NULL,
  `copper1` decimal(5,2) DEFAULT NULL,
  `copper2` decimal(5,2) DEFAULT NULL,
  `strings_per_note` tinyint DEFAULT NULL,
  `part_no_from` varchar(20) DEFAULT NULL,
  `part_no_to` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `model_id` (`model_id`),
  CONSTRAINT `ps_string_sections_ibfk_1` FOREIGN KEY (`model_id`) REFERENCES `ps_models` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ps_gauge_reference` (
  `id` int NOT NULL AUTO_INCREMENT,
  `gauge` decimal(4,1) NOT NULL,
  `diameter_mm` decimal(6,4) NOT NULL,
  `weight_gm` decimal(6,2) NOT NULL,
  `resist_mm2` int DEFAULT NULL,
  `resist_kg` decimal(6,1) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `gauge` (`gauge`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ps_official_steinway` (
  `id`           int          NOT NULL AUTO_INCREMENT,
  `model_label`  varchar(100) NOT NULL,
  `sort_order`   int          DEFAULT '0',
  `gauge_12`     int          DEFAULT '0',
  `gauge_12_5`   int          DEFAULT '0',
  `gauge_13`     int          DEFAULT '0',
  `gauge_13_5`   int          DEFAULT '0',
  `gauge_14`     int          DEFAULT '0',
  `gauge_14_5`   int          DEFAULT '0',
  `gauge_15`     int          DEFAULT '0',
  `gauge_15_5`   int          DEFAULT '0',
  `gauge_16`     int          DEFAULT '0',
  `gauge_16_5`   int          DEFAULT '0',
  `gauge_17`     int          DEFAULT '0',
  `gauge_17_5`   int          DEFAULT '0',
  `gauge_18`     int          DEFAULT '0',
  `gauge_19`     int          DEFAULT '0',
  `gauge_20`     int          DEFAULT '0',
  `gauge_21`     int          DEFAULT '0',
  `gauge_22`     int          DEFAULT '0',
  `gauge_23`     int          DEFAULT '0',
  `created_at`   datetime     DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ps_admins` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(60) NOT NULL,
  `password` varchar(255) NOT NULL,
  `token` varchar(128) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ps_contributions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(100) NOT NULL,
  `model_code` varchar(60) NOT NULL,
  `model_name` varchar(255) NOT NULL,
  `total_strings` tinyint NOT NULL DEFAULT '88',
  `sections_json` json NOT NULL,
  `contributor` varchar(120) DEFAULT NULL,
  `contributor_email` varchar(120) DEFAULT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `admin_notes` text,
  `source_file` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

-- ============================================================================
--  PianoStringDB — dati Yamaha, Kawai, Estonia, August Forster
--  Esegui DOPO schema.sql e seed.sql (che crea marche e Steinway).
--
--  Contenuto
--    Yamaha            31 modelli,  431 sezioni
--    Kawai            116 modelli, 1611 sezioni
--    Estonia            4 modelli,  145 sezioni
--    August Forster     1 modello,   37 sezioni
--
--  Fonti
--    Yamaha   Piano Parts Catalog 2012 (A Yamaha Piano Spare Parts Handbook)
--             sez. 5-1/5-2/5-3 (verticali) e 8-1..8-12 (a coda).
--             I calibri sono stampati sul ponte ("Number is Indicated on the Bridge").
--    Kawai    Kawai Acoustic Piano Parts List, Ver. 2001 — "String Scale",
--             pagg. 51-58 (verticali 51-53, a coda 54-58).
--    Estonia  "Мензуры роялей Estonia" (pianoage.ru), 4 varianti di modello.
--    Forster  "Мензура рояля August Förster", modello 275 cm.
--
--  Note sui dati
--    - corde avvolte Yamaha/Kawai: type 'wound' e gauge NULL. I costruttori non
--      pubblicano anima e rame; per Yamaha il codice ricambio identifica la corda
--      (part_no_*), per Kawai vale il ricambio 21-241 "Bass String".
--    - Estonia e Forster hanno diametri completi (nucleo + avvolgimenti in mm).
--    - gauge = numero del sistema europeo. Per Estonia/Forster e' convertito dai
--      mm pubblicati: ogni valore cade esattamente su una misura della scala EU.
--
--  Generato il 2026-11-15
-- ============================================================================

USE `pianostrings_db`;

-- Yamaha: 22 pianoforti a coda + 9 verticali.
-- Fonte: Yamaha Piano Parts Catalog 2012, sezioni 5-1/5-2/5-3 e 8-1..8-12.
-- I calibri sono quelli stampati sul ponte ("Number is Indicated on the Bridge").

-- A1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'A1', 'A1 — 149 cm', 88, 101 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 101;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Bass — bichord', 14, 31, 'wound', NULL, NULL, NULL, 2, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Plain wire', 32, 33, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Plain wire', 34, 35, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Plain wire', 36, 41, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Plain wire', 42, 47, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Plain wire', 48, 53, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Plain wire', 54, 59, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Plain wire', 60, 65, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Plain wire', 66, 71, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Plain wire', 72, 77, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Plain wire', 78, 83, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'A1'), 'Plain wire', 84, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- GB1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GB1', 'GB1 — 149 cm', 88, 102 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 102;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Bass — bichord', 14, 31, 'wound', NULL, NULL, NULL, 2, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Plain wire', 32, 33, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Plain wire', 34, 35, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Plain wire', 36, 41, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Plain wire', 42, 47, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Plain wire', 48, 53, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Plain wire', 54, 59, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Plain wire', 60, 65, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Plain wire', 66, 71, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Plain wire', 72, 77, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Plain wire', 78, 83, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GB1'), 'Plain wire', 84, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- C1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C1', 'C1 — 161 cm', 88, 103 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 103;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5609011', 'T5609101'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2, 'T5609111', 'T5609421'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Bass — bichord (middle)', 27, 29, 'wound', NULL, NULL, NULL, 2, 'T5609431', 'T5609481'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Plain wire', 30, 31, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Plain wire', 32, 35, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Plain wire', 36, 41, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Plain wire', 42, 47, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Plain wire', 48, 53, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Plain wire', 54, 59, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Plain wire', 60, 65, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Plain wire', 66, 71, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Plain wire', 72, 77, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Plain wire', 78, 83, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1'), 'Plain wire', 84, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- C1X
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C1X', 'C1X — 161 cm', 88, 104 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 104;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5613010', 'T5613100'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2, 'T5613110', 'T5613420'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Bass — bichord (middle)', 27, 29, 'wound', NULL, NULL, NULL, 2, 'T5613430', 'T5613480'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Plain wire', 30, 31, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Plain wire', 32, 35, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Plain wire', 36, 41, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Plain wire', 42, 47, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Plain wire', 48, 53, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Plain wire', 54, 59, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Plain wire', 60, 65, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Plain wire', 66, 71, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Plain wire', 72, 77, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Plain wire', 78, 83, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C1X'), 'Plain wire', 84, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- GC1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GC1', 'GC1 — 161 cm', 88, 105 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 105;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5609011', 'T5609101'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2, 'T5609111', 'T5609421'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Bass — bichord (middle)', 27, 29, 'wound', NULL, NULL, NULL, 2, 'T5609431', 'T5609481'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Plain wire', 30, 31, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Plain wire', 32, 35, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Plain wire', 36, 41, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Plain wire', 42, 47, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Plain wire', 48, 53, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Plain wire', 54, 59, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Plain wire', 60, 65, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Plain wire', 66, 71, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Plain wire', 72, 77, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Plain wire', 78, 83, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC1'), 'Plain wire', 84, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- C2
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C2', 'C2 — 173 cm', 88, 106 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 106;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5628011', 'T5628101'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2, 'T5628111', 'T5628421'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Bass — bichord (middle)', 27, 28, 'wound', NULL, NULL, NULL, 2, 'T5628431', 'T5628461'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Plain wire', 29, 30, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Plain wire', 31, 36, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Plain wire', 37, 40, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Plain wire', 41, 46, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Plain wire', 47, 50, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Plain wire', 51, 56, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Plain wire', 57, 62, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Plain wire', 63, 68, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Plain wire', 69, 75, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Plain wire', 76, 81, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2'), 'Plain wire', 82, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- C2X
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C2X', 'C2X — 173 cm', 88, 107 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 107;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5629010', 'T5629100'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2, 'T5629110', 'T5629420'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Bass — bichord (middle)', 27, 28, 'wound', NULL, NULL, NULL, 2, 'T5629430', 'T5629460'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Plain wire', 29, 30, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Plain wire', 31, 36, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Plain wire', 37, 40, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Plain wire', 41, 46, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Plain wire', 47, 50, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Plain wire', 51, 56, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Plain wire', 57, 62, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Plain wire', 63, 68, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Plain wire', 69, 75, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Plain wire', 76, 81, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C2X'), 'Plain wire', 82, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- GC2
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GC2', 'GC2 — 173 cm', 88, 108 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 108;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5628011', 'T5628101'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2, 'T5628111', 'T5628421'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Bass — bichord (middle)', 27, 28, 'wound', NULL, NULL, NULL, 2, 'T5628431', 'T5628461'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Plain wire', 29, 30, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Plain wire', 31, 36, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Plain wire', 37, 40, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Plain wire', 41, 46, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Plain wire', 47, 50, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Plain wire', 51, 56, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Plain wire', 57, 62, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Plain wire', 63, 68, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Plain wire', 69, 75, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Plain wire', 76, 81, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'GC2'), 'Plain wire', 82, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- C3
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C3', 'C3 — 186 cm', 88, 109 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 109;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5638011', 'T5638101'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2, 'T5638111', 'T5638421'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Plain wire', 27, 28, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Plain wire', 29, 30, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Plain wire', 31, 40, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Plain wire', 41, 48, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Plain wire', 49, 56, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Plain wire', 57, 66, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Plain wire', 67, 70, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Plain wire', 71, 75, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Plain wire', 76, 81, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Plain wire', 82, 83, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3'), 'Plain wire', 84, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- C3X
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C3X', 'C3X — 186 cm', 88, 110 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 110;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5634010', 'T5634100'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2, 'T5634110', 'T5634420'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Plain wire', 27, 28, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Plain wire', 29, 30, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Plain wire', 31, 40, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Plain wire', 41, 48, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Plain wire', 49, 56, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Plain wire', 57, 66, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Plain wire', 67, 70, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Plain wire', 71, 75, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Plain wire', 76, 81, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Plain wire', 82, 83, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C3X'), 'Plain wire', 84, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- C5
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C5', 'C5 — 200 cm', 88, 111 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 111;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5653011', 'T5653101'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2, 'T5653111', 'T5653421'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Plain wire', 27, 28, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Plain wire', 29, 32, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Plain wire', 33, 44, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Plain wire', 45, 52, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Plain wire', 53, 56, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Plain wire', 57, 60, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Plain wire', 61, 70, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Plain wire', 71, 75, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Plain wire', 76, 79, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Plain wire', 80, 83, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5'), 'Plain wire', 84, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- C5X
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C5X', 'C5X — 200 cm', 88, 112 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 112;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5666010', 'T5666100'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2, 'T5666110', 'T5666420'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Plain wire', 27, 28, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Plain wire', 29, 32, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Plain wire', 33, 44, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Plain wire', 45, 52, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Plain wire', 53, 56, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Plain wire', 57, 60, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Plain wire', 61, 70, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Plain wire', 71, 75, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Plain wire', 76, 79, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Plain wire', 80, 83, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C5X'), 'Plain wire', 84, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- C6
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C6', 'C6 — 212 cm', 88, 113 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 113;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5657011', 'T5657101'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Bass — bichord', 11, 23, 'wound', NULL, NULL, NULL, 2, 'T5657111', 'T5657361'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Plain wire', 24, 27, 'plain', 19, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Plain wire', 28, 31, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Plain wire', 32, 35, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Plain wire', 36, 41, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Plain wire', 42, 47, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Plain wire', 48, 52, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Plain wire', 65, 70, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Plain wire', 71, 76, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Plain wire', 77, 82, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6'), 'Plain wire', 83, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- C6X
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C6X', 'C6X — 212 cm', 88, 114 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 114;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5669010', 'T5669100'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Bass — bichord', 11, 23, 'wound', NULL, NULL, NULL, 2, 'T5669110', 'T5669360'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Plain wire', 24, 27, 'plain', 19, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Plain wire', 28, 31, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Plain wire', 32, 35, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Plain wire', 36, 41, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Plain wire', 42, 47, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Plain wire', 48, 52, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Plain wire', 65, 70, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Plain wire', 71, 76, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Plain wire', 77, 82, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C6X'), 'Plain wire', 83, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- C7
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C7', 'C7 — 227 cm', 88, 115 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 115;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5672011', 'T5672101'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Bass — bichord', 11, 23, 'wound', NULL, NULL, NULL, 2, 'T5672111', 'T5672361'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Plain wire', 24, 31, 'plain', 19, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Plain wire', 32, 35, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Plain wire', 36, 40, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Plain wire', 65, 70, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Plain wire', 71, 76, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Plain wire', 77, 82, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7'), 'Plain wire', 83, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- C7X
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C7X', 'C7X — 227 cm', 88, 116 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 116;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5674010', 'T5674100'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Bass — bichord', 11, 23, 'wound', NULL, NULL, NULL, 2, 'T5674110', 'T5674360'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Plain wire', 24, 31, 'plain', 19, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Plain wire', 32, 35, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Plain wire', 36, 40, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Plain wire', 65, 70, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Plain wire', 71, 76, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Plain wire', 77, 82, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'C7X'), 'Plain wire', 83, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- S4
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'S4', 'S4 — 190 cm', 88, 117 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 117;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5725011', 'T5725101'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2, 'T5725111', 'T5725421'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 29, 32, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 33, 36, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 37, 44, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 53, 57, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 58, 63, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 64, 69, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 70, 74, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S4'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3, NULL, NULL);

-- CF4
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CF4', 'CF4 — 190 cm', 88, 118 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 118;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5727010', 'T5727100'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2, 'T5727110', 'T5727420'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 29, 32, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 33, 36, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 37, 44, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 53, 57, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 58, 63, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 64, 69, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 70, 74, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF4'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3, NULL, NULL);

-- S6
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'S6', 'S6 — 212 cm', 88, 119 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 119;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5726011', 'T5726101'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Bass — bichord', 11, 23, 'wound', NULL, NULL, NULL, 2, 'T5726111', 'T5726361'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Plain wire', 24, 27, 'plain', 19, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Plain wire', 28, 33, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Plain wire', 34, 39, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Plain wire', 40, 46, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Plain wire', 47, 52, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Plain wire', 53, 56, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Plain wire', 57, 62, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Plain wire', 63, 70, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Plain wire', 71, 74, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Plain wire', 79, 82, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'S6'), 'Plain wire', 83, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- CF6
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CF6', 'CF6 — 212 cm', 88, 120 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 120;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1, 'T5728010', 'T5728100'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Bass — bichord', 11, 23, 'wound', NULL, NULL, NULL, 2, 'T5728110', 'T5728360'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Plain wire', 24, 27, 'plain', 19, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Plain wire', 28, 33, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Plain wire', 34, 39, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Plain wire', 40, 46, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Plain wire', 47, 52, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Plain wire', 53, 56, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Plain wire', 57, 62, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Plain wire', 63, 70, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Plain wire', 71, 74, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Plain wire', 79, 82, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF6'), 'Plain wire', 83, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- CF3S
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CF3S', 'CF3S — 275 cm', 88, 121 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 121;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Bass — monochord', 1, 8, 'wound', NULL, NULL, NULL, 1, 'T5751010', 'T5751080'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Bass — bichord', 9, 13, 'wound', NULL, NULL, NULL, 2, 'T5751090', 'T5751180'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Bass — trichord', 14, 20, 'wound', NULL, NULL, NULL, 3, 'T5751190', 'T5751390'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Plain wire', 21, 24, 'plain', 21, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Plain wire', 25, 30, 'plain', 20, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Plain wire', 31, 37, 'plain', 19, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Plain wire', 38, 43, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Plain wire', 44, 51, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Plain wire', 52, 57, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Plain wire', 58, 63, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Plain wire', 64, 71, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Plain wire', 72, 76, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Plain wire', 77, 80, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CF3S'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- CFX
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CFX', 'CFX — 275 cm', 88, 122 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 122;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Bass — monochord', 1, 8, 'wound', NULL, NULL, NULL, 1, 'T5752010', 'T5752080'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Bass — bichord', 9, 13, 'wound', NULL, NULL, NULL, 2, 'T5752090', 'T5752180'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Bass — trichord', 14, 20, 'wound', NULL, NULL, NULL, 3, 'T5752190', 'T5752390'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Plain wire', 21, 24, 'plain', 21, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Plain wire', 25, 30, 'plain', 20, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Plain wire', 31, 37, 'plain', 19, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Plain wire', 38, 43, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Plain wire', 44, 51, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Plain wire', 52, 57, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Plain wire', 58, 63, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Plain wire', 64, 71, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Plain wire', 72, 76, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Plain wire', 77, 80, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'CFX'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- YUS1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'YUS1', 'YUS1 — 121 cm', 88, 123 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 123;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1, 'T0511010', 'T0511120'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2, 'T0511130', 'T0511480'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Bass — bichord (middle)', 31, 32, 'wound', NULL, NULL, NULL, 2, 'T0511490', 'T0511520'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Plain wire', 33, 34, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Plain wire', 35, 40, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Plain wire', 41, 46, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Plain wire', 47, 52, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Plain wire', 53, 60, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Plain wire', 61, 66, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Plain wire', 67, 72, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Plain wire', 73, 78, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Plain wire', 79, 84, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS1'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- U1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'U1', 'U1 — 121 cm', 88, 124 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 124;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1, 'T0511010', 'T0511120'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2, 'T0511130', 'T0511480'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Bass — bichord (middle)', 31, 32, 'wound', NULL, NULL, NULL, 2, 'T0511490', 'T0511520'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Plain wire', 33, 34, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Plain wire', 35, 40, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Plain wire', 41, 46, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Plain wire', 47, 52, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Plain wire', 53, 60, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Plain wire', 61, 66, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Plain wire', 67, 72, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Plain wire', 73, 78, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Plain wire', 79, 84, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U1'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- b3
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'b3', 'b3 — 121 cm', 88, 125 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 125;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1, 'T0511010', 'T0511120'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2, 'T0511130', 'T0511480'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Bass — bichord (middle)', 31, 32, 'wound', NULL, NULL, NULL, 2, 'T0511490', 'T0511520'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Plain wire', 33, 34, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Plain wire', 35, 40, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Plain wire', 41, 46, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Plain wire', 47, 52, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Plain wire', 53, 60, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Plain wire', 61, 66, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Plain wire', 67, 72, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Plain wire', 73, 78, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Plain wire', 79, 84, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b3'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- YUS3
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'YUS3', 'YUS3 — 131 cm', 88, 126 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 126;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1, 'T0547010', 'T0547130'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2, 'T0547140', 'T0547390'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Bass — bichord (middle)', 27, 29, 'wound', NULL, NULL, NULL, 2, 'T0547400', 'T0547450'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Plain wire', 30, 31, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Plain wire', 32, 35, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Plain wire', 36, 41, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Plain wire', 42, 47, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Plain wire', 48, 53, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Plain wire', 54, 60, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Plain wire', 61, 66, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Plain wire', 67, 72, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Plain wire', 73, 78, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Plain wire', 79, 84, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS3'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- U3
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'U3', 'U3 — 131 cm', 88, 127 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 127;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1, 'T0547010', 'T0547130'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2, 'T0547140', 'T0547390'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Bass — bichord (middle)', 27, 29, 'wound', NULL, NULL, NULL, 2, 'T0547400', 'T0547450'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Plain wire', 30, 31, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Plain wire', 32, 35, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Plain wire', 36, 41, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Plain wire', 42, 47, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Plain wire', 48, 53, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Plain wire', 54, 60, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Plain wire', 61, 66, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Plain wire', 67, 72, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Plain wire', 73, 78, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Plain wire', 79, 84, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'U3'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- YUS5
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'YUS5', 'YUS5 — 131 cm', 88, 128 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 128;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1, 'T0547010', 'T0547130'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2, 'T0547140', 'T0547390'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Bass — bichord (middle)', 27, 29, 'wound', NULL, NULL, NULL, 2, 'T0547400', 'T0547450'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Plain wire', 30, 31, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Plain wire', 32, 35, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Plain wire', 36, 41, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Plain wire', 42, 47, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Plain wire', 48, 53, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Plain wire', 54, 60, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Plain wire', 61, 66, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Plain wire', 67, 72, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Plain wire', 73, 78, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Plain wire', 79, 84, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'YUS5'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- SU7
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'SU7', 'SU7 — 131 cm', 88, 129 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 129;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Bass — bichord (middle)', 27, 29, 'wound', NULL, NULL, NULL, 2, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Plain wire', 30, 31, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Plain wire', 32, 35, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Plain wire', 36, 41, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Plain wire', 42, 47, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Plain wire', 48, 53, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Plain wire', 54, 60, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Plain wire', 61, 66, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Plain wire', 67, 72, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Plain wire', 73, 78, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Plain wire', 79, 84, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'SU7'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3, NULL, NULL);

-- b1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'b1', 'b1 — verticale', 88, 130 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 130;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1, 'T0614010', 'T0614130'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2, 'T0614140', 'T0614470'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Bass — bichord (middle)', 31, 32, 'wound', NULL, NULL, NULL, 2, 'T0614480', 'T0614510'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Plain wire', 33, 36, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Plain wire', 45, 56, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Plain wire', 57, 60, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Plain wire', 61, 62, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Plain wire', 63, 68, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Plain wire', 79, 80, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Plain wire', 81, 86, 'plain', 13.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b1'), 'Plain wire', 87, 88, 'plain', 13, NULL, NULL, 3, NULL, NULL);

-- b2
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'b2', 'b2 — verticale', 88, 131 FROM `ps_brands` WHERE `name` = 'Yamaha'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 131;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`, `part_no_from`, `part_no_to`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1, 'T0615011', 'T0615131'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2, 'T0615141', 'T0615471'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Bass — bichord (middle)', 31, 32, 'wound', NULL, NULL, NULL, 2, 'T0615481', 'T0615511'),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Plain wire', 33, 36, 'plain', 18.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Plain wire', 45, 56, 'plain', 17, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Plain wire', 57, 60, 'plain', 16.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Plain wire', 61, 62, 'plain', 16, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Plain wire', 63, 68, 'plain', 15.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Plain wire', 79, 80, 'plain', 14, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Plain wire', 81, 86, 'plain', 13.5, NULL, NULL, 3, NULL, NULL),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Yamaha') AND `code` = 'b2'), 'Plain wire', 87, 88, 'plain', 13, NULL, NULL, 3, NULL, NULL);


-- Kawai: dalla Parts List 2001 (String Scale, pag. 51-58)
-- bassi senza diametri: type 'wound', gauge NULL (Kawai non li pubblica).

-- CE-7
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CE-7', 'CE-7', 88, 401 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 401;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Plain wire', 33, 34, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Plain wire', 35, 36, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Plain wire', 39, 42, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Plain wire', 43, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Plain wire', 49, 56, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Plain wire', 57, 64, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Plain wire', 65, 70, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Plain wire', 71, 76, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Plain wire', 77, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- C-107
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'C-107', 'C-107', 88, 401 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 401;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Plain wire', 33, 34, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Plain wire', 35, 36, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Plain wire', 39, 42, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Plain wire', 43, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Plain wire', 49, 56, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Plain wire', 57, 64, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Plain wire', 65, 70, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Plain wire', 71, 76, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Plain wire', 77, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'C-107'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- CE-7N
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CE-7N', 'CE-7N', 88, 402 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 402;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Plain wire', 43, 46, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Plain wire', 47, 48, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Plain wire', 49, 62, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Plain wire', 63, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-7N'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- 10
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '10', '10', 88, 402 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 402;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Plain wire', 43, 46, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Plain wire', 47, 48, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Plain wire', 49, 62, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Plain wire', 63, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- 10N
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '10N', '10 (N)', 88, 402 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 402;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Plain wire', 43, 46, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Plain wire', 47, 48, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Plain wire', 49, 62, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Plain wire', 63, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '10N'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- CH-7
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CH-7', 'CH-7', 88, 402 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 402;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Plain wire', 43, 46, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Plain wire', 47, 48, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Plain wire', 49, 62, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Plain wire', 63, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CH-7'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- 802
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '802', '802', 88, 402 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 402;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Plain wire', 43, 46, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Plain wire', 47, 48, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Plain wire', 49, 62, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Plain wire', 63, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '802'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- 803
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '803', '803', 88, 402 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 402;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Plain wire', 43, 46, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Plain wire', 47, 48, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Plain wire', 49, 62, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Plain wire', 63, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '803'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- 804
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '804', '804', 88, 402 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 402;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Plain wire', 43, 46, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Plain wire', 47, 48, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Plain wire', 49, 62, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Plain wire', 63, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '804'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- CE-8
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CE-8', 'CE-8', 88, 403 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 403;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Plain wire', 31, 32, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Plain wire', 35, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Plain wire', 53, 58, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Plain wire', 59, 64, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Plain wire', 65, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Plain wire', 73, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8'), 'Plain wire', 81, 88, 'plain', 13.5, NULL, NULL, 3);

-- CE-8N
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CE-8N', 'CE-8N', 88, 403 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 403;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Plain wire', 31, 32, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Plain wire', 35, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Plain wire', 53, 58, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Plain wire', 59, 64, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Plain wire', 65, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Plain wire', 73, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-8N'), 'Plain wire', 81, 88, 'plain', 13.5, NULL, NULL, 3);

-- SC-3
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'SC-3', 'SC-3', 88, 403 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 403;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Plain wire', 31, 32, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Plain wire', 35, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Plain wire', 53, 58, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Plain wire', 59, 64, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Plain wire', 65, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Plain wire', 73, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'SC-3'), 'Plain wire', 81, 88, 'plain', 13.5, NULL, NULL, 3);

-- CS-9
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-9', 'CS-9', 88, 403 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 403;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Plain wire', 31, 32, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Plain wire', 35, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Plain wire', 53, 58, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Plain wire', 59, 64, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Plain wire', 65, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Plain wire', 73, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9'), 'Plain wire', 81, 88, 'plain', 13.5, NULL, NULL, 3);

-- CS-9T
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-9T', 'CS-9T', 88, 403 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 403;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Plain wire', 31, 32, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Plain wire', 35, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Plain wire', 53, 58, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Plain wire', 59, 64, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Plain wire', 65, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Plain wire', 73, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9T'), 'Plain wire', 81, 88, 'plain', 13.5, NULL, NULL, 3);

-- CS-9E
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-9E', 'CS-9E', 88, 403 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 403;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Plain wire', 31, 32, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Plain wire', 35, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Plain wire', 53, 58, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Plain wire', 59, 64, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Plain wire', 65, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Plain wire', 73, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-9E'), 'Plain wire', 81, 88, 'plain', 13.5, NULL, NULL, 3);

-- UST-7
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'UST-7', 'UST-7', 88, 403 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 403;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Plain wire', 31, 32, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Plain wire', 35, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Plain wire', 53, 58, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Plain wire', 59, 64, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Plain wire', 65, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Plain wire', 73, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-7'), 'Plain wire', 81, 88, 'plain', 13.5, NULL, NULL, 3);

-- UST-8
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'UST-8', 'UST-8', 88, 403 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 403;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Plain wire', 31, 32, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Plain wire', 35, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Plain wire', 53, 58, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Plain wire', 59, 64, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Plain wire', 65, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Plain wire', 73, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8'), 'Plain wire', 81, 88, 'plain', 13.5, NULL, NULL, 3);

-- UST-8A
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'UST-8A', 'UST-8A', 88, 403 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 403;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Plain wire', 31, 32, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Plain wire', 35, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Plain wire', 53, 58, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Plain wire', 59, 64, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Plain wire', 65, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Plain wire', 73, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8A'), 'Plain wire', 81, 88, 'plain', 13.5, NULL, NULL, 3);

-- UST-8C
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'UST-8C', 'UST-8C', 88, 403 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 403;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Plain wire', 31, 32, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Plain wire', 35, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Plain wire', 53, 58, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Plain wire', 59, 64, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Plain wire', 65, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Plain wire', 73, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'UST-8C'), 'Plain wire', 81, 88, 'plain', 13.5, NULL, NULL, 3);

-- 902
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '902', '902', 88, 403 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 403;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Plain wire', 31, 32, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Plain wire', 35, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Plain wire', 53, 58, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Plain wire', 59, 64, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Plain wire', 65, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Plain wire', 73, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '902'), 'Plain wire', 81, 88, 'plain', 13.5, NULL, NULL, 3);

-- 906
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '906', '906', 88, 403 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 403;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Plain wire', 31, 32, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Plain wire', 33, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Plain wire', 35, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Plain wire', 53, 58, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Plain wire', 59, 64, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Plain wire', 65, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Plain wire', 73, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '906'), 'Plain wire', 81, 88, 'plain', 13.5, NULL, NULL, 3);

-- CE-11
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CE-11', 'CE-11', 88, 404 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 404;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Bass — bichord', 16, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Plain wire', 75, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- CE-11S
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CE-11S', 'CE-11S', 88, 404 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 404;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Bass — bichord', 16, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Plain wire', 75, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CE-11S'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- CS-11
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-11', 'CS-11', 88, 404 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 404;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Bass — bichord', 16, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Plain wire', 75, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-11'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- CS-14
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-14', 'CS-14', 88, 404 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 404;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Bass — bichord', 16, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Plain wire', 75, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- CS-14S
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-14S', 'CS-14S', 88, 404 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 404;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Bass — bichord', 16, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Plain wire', 75, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-14S'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- K-115
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'K-115', 'K-115', 88, 404 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 404;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Bass — bichord', 16, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Plain wire', 75, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-115'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- KX-15
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KX-15', 'KX-15', 88, 404 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 404;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Bass — bichord', 16, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Plain wire', 75, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-15'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- CX-5H
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CX-5H', 'CX-5H', 88, 405 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 405;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Bass — bichord', 16, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Plain wire', 39, 40, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Plain wire', 41, 44, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Plain wire', 45, 50, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Plain wire', 51, 54, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Plain wire', 55, 60, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Plain wire', 61, 64, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Plain wire', 65, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-5H'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- 504
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '504', '504', 88, 405 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 405;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Bass — bichord', 16, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Plain wire', 39, 40, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Plain wire', 41, 44, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Plain wire', 45, 50, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Plain wire', 51, 54, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Plain wire', 55, 60, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Plain wire', 61, 64, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Plain wire', 65, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '504'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- CX-8
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CX-8', 'CX-8', 88, 406 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 406;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Bass — bichord', 14, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Plain wire', 67, 70, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Plain wire', 71, 76, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Plain wire', 77, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-8'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- CX-9
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CX-9', 'CX-9', 88, 406 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 406;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Bass — bichord', 14, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Plain wire', 67, 70, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Plain wire', 71, 76, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Plain wire', 77, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- CX-9T
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CX-9T', 'CX-9T', 88, 406 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 406;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Bass — bichord', 14, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Plain wire', 67, 70, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Plain wire', 71, 76, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Plain wire', 77, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-9T'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- CX-10
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CX-10', 'CX-10', 88, 406 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 406;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Bass — bichord', 14, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Plain wire', 67, 70, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Plain wire', 71, 76, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Plain wire', 77, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-10'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- 506
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '506', '506', 88, 406 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 406;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Bass — bichord', 14, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Plain wire', 67, 70, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Plain wire', 71, 76, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Plain wire', 77, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '506'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- 604
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '604', '604', 88, 406 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 406;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Bass — bichord', 14, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Plain wire', 67, 70, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Plain wire', 71, 76, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Plain wire', 77, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '604'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- 605
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '605', '605', 88, 406 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 406;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Bass — bichord', 14, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Plain wire', 67, 70, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Plain wire', 71, 76, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Plain wire', 77, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '605'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- 606
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '606', '606', 88, 406 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 406;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Bass — bichord', 14, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Plain wire', 67, 70, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Plain wire', 71, 76, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Plain wire', 77, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '606'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- K-18E
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'K-18E', 'K-18E', 88, 406 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 406;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Bass — bichord', 14, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Plain wire', 67, 70, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Plain wire', 71, 76, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Plain wire', 77, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-18E'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- K-20E
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'K-20E', 'K-20E', 88, 406 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 406;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Bass — bichord', 14, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Plain wire', 67, 70, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Plain wire', 71, 76, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Plain wire', 77, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-20E'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- K-110
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'K-110', 'K-110', 88, 406 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 406;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Bass — bichord', 14, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Plain wire', 67, 70, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Plain wire', 71, 76, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Plain wire', 77, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-110'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- KX-10
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KX-10', 'KX-10', 88, 406 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 406;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Bass — bichord', 14, 34, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Plain wire', 67, 70, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Plain wire', 71, 76, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Plain wire', 77, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-10'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- CX-21D
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CX-21D', 'CX-21D', 88, 407 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 407;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Bass — bichord', 16, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 31, 32, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 33, 34, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 43, 46, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 53, 56, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 57, 62, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 63, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 67, 72, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 73, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21D'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- CX-21H
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CX-21H', 'CX-21H', 88, 407 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 407;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Bass — bichord', 16, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 31, 32, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 33, 34, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 43, 46, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 53, 56, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 57, 62, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 63, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 67, 72, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 73, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CX-21H'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- K-25E
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'K-25E', 'K-25E', 88, 407 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 407;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Bass — bichord', 16, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 31, 32, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 33, 34, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 43, 46, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 53, 56, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 57, 62, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 63, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 67, 72, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 73, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-25E'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- K-30E
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'K-30E', 'K-30E', 88, 407 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 407;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Bass — bichord', 16, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 31, 32, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 33, 34, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 43, 46, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 47, 52, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 53, 56, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 57, 62, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 63, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 67, 72, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 73, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-30E'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- CS-18
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-18', 'CS-18', 88, 408 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 408;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Plain wire', 79, 82, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Plain wire', 83, 86, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18'), 'Plain wire', 87, 88, 'plain', 13, NULL, NULL, 3);

-- CS-18T
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-18T', 'CS-18T', 88, 408 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 408;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Plain wire', 79, 82, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Plain wire', 83, 86, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-18T'), 'Plain wire', 87, 88, 'plain', 13, NULL, NULL, 3);

-- CS-21
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-21', 'CS-21', 88, 408 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 408;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Plain wire', 79, 82, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Plain wire', 83, 86, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21'), 'Plain wire', 87, 88, 'plain', 13, NULL, NULL, 3);

-- CS-21S
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-21S', 'CS-21S', 88, 408 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 408;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Plain wire', 79, 82, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Plain wire', 83, 86, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-21S'), 'Plain wire', 87, 88, 'plain', 13, NULL, NULL, 3);

-- K-121
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'K-121', 'K-121', 88, 408 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 408;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Plain wire', 79, 82, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Plain wire', 83, 86, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-121'), 'Plain wire', 87, 88, 'plain', 13, NULL, NULL, 3);

-- KX-21
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KX-21', 'KX-21', 88, 408 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 408;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Bass — bichord', 14, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Plain wire', 39, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Plain wire', 43, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Plain wire', 51, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Plain wire', 59, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Plain wire', 79, 82, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Plain wire', 83, 86, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KX-21'), 'Plain wire', 87, 88, 'plain', 13, NULL, NULL, 3);

-- NS-10
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'NS-10', 'NS-10', 88, 409 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 409;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- NS-10N
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'NS-10N', 'NS-10N', 88, 409 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 409;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-10N'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- NS-15
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'NS-15', 'NS-15', 88, 409 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 409;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-15'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- NS-20A
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'NS-20A', 'NS-20A', 88, 409 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 409;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20A'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- CS-35
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-35', 'CS-35', 88, 409 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 409;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- CS-35N
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-35N', 'CS-35N', 88, 409 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 409;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35N'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- CS-35NB
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'CS-35NB', 'CS-35NB', 88, 409 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 409;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'CS-35NB'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- K-50E
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'K-50E', 'K-50E', 88, 409 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 409;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-50E'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- K-70E
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'K-70E', 'K-70E', 88, 409 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 409;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 41, 44, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 53, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'K-70E'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- NS-20
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'NS-20', 'NS-20', 88, 410 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 410;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Plain wire', 39, 40, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Plain wire', 41, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Plain wire', 43, 44, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Plain wire', 45, 46, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Plain wire', 47, 50, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Plain wire', 51, 62, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Plain wire', 63, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Plain wire', 71, 80, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-20'), 'Plain wire', 81, 88, 'plain', 13, NULL, NULL, 3);

-- NS-25
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'NS-25', 'NS-25', 88, 410 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 410;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Plain wire', 39, 40, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Plain wire', 41, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Plain wire', 43, 44, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Plain wire', 45, 46, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Plain wire', 47, 50, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Plain wire', 51, 62, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Plain wire', 63, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Plain wire', 71, 80, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-25'), 'Plain wire', 81, 88, 'plain', 13, NULL, NULL, 3);

-- NS-30
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'NS-30', 'NS-30', 88, 410 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 410;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Plain wire', 39, 40, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Plain wire', 41, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Plain wire', 43, 44, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Plain wire', 45, 46, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Plain wire', 47, 50, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Plain wire', 51, 62, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Plain wire', 63, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Plain wire', 71, 80, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'NS-30'), 'Plain wire', 81, 88, 'plain', 13, NULL, NULL, 3);

-- KS-1F
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KS-1F', 'KS-1F', 88, 410 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 410;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Plain wire', 39, 40, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Plain wire', 41, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Plain wire', 43, 44, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Plain wire', 45, 46, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Plain wire', 47, 50, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Plain wire', 51, 62, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Plain wire', 63, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Plain wire', 71, 80, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-1F'), 'Plain wire', 81, 88, 'plain', 13, NULL, NULL, 3);

-- KS-2F
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KS-2F', 'KS-2F', 88, 410 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 410;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Plain wire', 39, 40, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Plain wire', 41, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Plain wire', 43, 44, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Plain wire', 45, 46, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Plain wire', 47, 50, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Plain wire', 51, 62, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Plain wire', 63, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Plain wire', 71, 80, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-2F'), 'Plain wire', 81, 88, 'plain', 13, NULL, NULL, 3);

-- KS-3F
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KS-3F', 'KS-3F', 88, 410 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 410;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Plain wire', 39, 40, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Plain wire', 41, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Plain wire', 43, 44, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Plain wire', 45, 46, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Plain wire', 47, 50, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Plain wire', 51, 62, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Plain wire', 63, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Plain wire', 71, 80, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KS-3F'), 'Plain wire', 81, 88, 'plain', 13, NULL, NULL, 3);

-- 706
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '706', '706', 88, 410 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 410;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Plain wire', 39, 40, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Plain wire', 41, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Plain wire', 43, 44, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Plain wire', 45, 46, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Plain wire', 47, 50, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Plain wire', 51, 62, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Plain wire', 63, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Plain wire', 71, 80, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '706'), 'Plain wire', 81, 88, 'plain', 13, NULL, NULL, 3);

-- 708
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '708', '708', 88, 410 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 410;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Bass — bichord', 14, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Plain wire', 31, 34, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Plain wire', 35, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Plain wire', 37, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Plain wire', 39, 40, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Plain wire', 41, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Plain wire', 43, 44, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Plain wire', 45, 46, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Plain wire', 47, 50, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Plain wire', 51, 62, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Plain wire', 63, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Plain wire', 71, 80, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = '708'), 'Plain wire', 81, 88, 'plain', 13, NULL, NULL, 3);

-- GM-1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GM-1', 'GM-1', 88, 411 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 411;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Bass — bichord', 16, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Plain wire', 39, 40, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Plain wire', 41, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Plain wire', 43, 48, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Plain wire', 49, 54, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Plain wire', 55, 60, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Plain wire', 61, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-1'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- GM-2
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GM-2', 'GM-2', 88, 411 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 411;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Bass — bichord', 16, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Plain wire', 39, 40, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Plain wire', 41, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Plain wire', 43, 48, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Plain wire', 49, 54, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Plain wire', 55, 60, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Plain wire', 61, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-2'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- GM-10
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GM-10', 'GM-10', 88, 411 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 411;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Bass — monochord', 1, 15, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Bass — bichord', 16, 32, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Plain wire', 33, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Plain wire', 35, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Plain wire', 37, 38, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Plain wire', 39, 40, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Plain wire', 41, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Plain wire', 43, 48, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Plain wire', 49, 54, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Plain wire', 55, 60, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Plain wire', 61, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GM-10'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- GE-1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GE-1', 'GE-1', 88, 412 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 412;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Plain wire', 33, 34, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Plain wire', 35, 38, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Plain wire', 39, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Plain wire', 43, 48, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Plain wire', 49, 54, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Plain wire', 55, 60, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Plain wire', 61, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- GE-1A
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GE-1A', 'GE-1A', 88, 412 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 412;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Plain wire', 33, 34, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Plain wire', 35, 38, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Plain wire', 39, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Plain wire', 43, 48, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Plain wire', 49, 54, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Plain wire', 55, 60, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Plain wire', 61, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1A'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- GE-1AS
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GE-1AS', 'GE-1AS', 88, 412 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 412;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Plain wire', 33, 34, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Plain wire', 35, 38, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Plain wire', 39, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Plain wire', 43, 48, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Plain wire', 49, 54, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Plain wire', 55, 60, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Plain wire', 61, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-1AS'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- GE-20
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GE-20', 'GE-20', 88, 412 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 412;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Plain wire', 33, 34, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Plain wire', 35, 38, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Plain wire', 39, 42, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Plain wire', 43, 48, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Plain wire', 49, 54, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Plain wire', 55, 60, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Plain wire', 61, 66, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Plain wire', 67, 70, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Plain wire', 71, 76, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-20'), 'Plain wire', 77, 88, 'plain', 13, NULL, NULL, 3);

-- GE-2
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GE-2', 'GE-2', 88, 413 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 413;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Bass — bichord', 14, 29, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Plain wire', 30, 31, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Plain wire', 32, 35, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Plain wire', 36, 39, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Plain wire', 40, 45, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Plain wire', 46, 55, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Plain wire', 56, 59, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Plain wire', 60, 65, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Plain wire', 66, 74, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Plain wire', 75, 80, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Plain wire', 81, 84, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Plain wire', 85, 86, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-2'), 'Plain wire', 87, 88, 'plain', 13.5, NULL, NULL, 3);

-- GE-3
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GE-3', 'GE-3', 88, 414 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 414;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 27, 28, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 29, 30, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 31, 32, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 33, 34, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 35, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-3'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- KG-1C
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-1C', 'KG-1C', 88, 415 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 415;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Plain wire', 31, 34, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Plain wire', 35, 38, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Plain wire', 43, 48, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Plain wire', 49, 54, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Plain wire', 55, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Plain wire', 59, 62, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Plain wire', 63, 66, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Plain wire', 67, 72, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Plain wire', 73, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Plain wire', 79, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1C'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- KG-1D
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-1D', 'KG-1D', 88, 415 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 415;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Plain wire', 31, 34, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Plain wire', 35, 38, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Plain wire', 39, 42, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Plain wire', 43, 48, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Plain wire', 49, 54, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Plain wire', 55, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Plain wire', 59, 62, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Plain wire', 63, 66, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Plain wire', 67, 72, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Plain wire', 73, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Plain wire', 79, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1D'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- KG-1E
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-1E', 'KG-1E', 88, 416 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 416;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1E'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- KF-1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KF-1', 'KF-1', 88, 416 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 416;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KF-1'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- GE-30
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GE-30', 'GE-30', 88, 416 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 416;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GE-30'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- KG-1A
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-1A', 'KG-1A', 88, 416 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 416;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-1A'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- RX-1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'RX-1', 'RX-1', 88, 416 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 416;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Bass — bichord', 13, 30, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-1'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- KG-2C
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-2C', 'KG-2C', 88, 417 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 417;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Plain wire', 29, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Plain wire', 35, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Plain wire', 41, 46, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Plain wire', 47, 52, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Plain wire', 53, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Plain wire', 59, 64, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Plain wire', 65, 70, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Plain wire', 71, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Plain wire', 75, 82, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2C'), 'Plain wire', 83, 88, 'plain', 14, NULL, NULL, 3);

-- KG-2D
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-2D', 'KG-2D', 88, 417 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 417;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Plain wire', 29, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Plain wire', 35, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Plain wire', 41, 46, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Plain wire', 47, 52, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Plain wire', 53, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Plain wire', 59, 64, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Plain wire', 65, 70, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Plain wire', 71, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Plain wire', 75, 82, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2D'), 'Plain wire', 83, 88, 'plain', 14, NULL, NULL, 3);

-- KG-2A
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-2A', 'KG-2A', 88, 418 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 418;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 27, 28, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 29, 30, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 31, 32, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 33, 34, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 35, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2A'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- KG-2E
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-2E', 'KG-2E', 88, 418 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 418;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 27, 28, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 29, 30, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 31, 32, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 33, 34, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 35, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-2E'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- RX-2
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'RX-2', 'RX-2', 88, 418 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 418;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 27, 28, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 29, 30, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 31, 32, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 33, 34, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 35, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-2'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- KG-3C
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-3C', 'KG-3C', 88, 419 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 419;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Plain wire', 29, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Plain wire', 35, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Plain wire', 41, 46, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Plain wire', 47, 52, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Plain wire', 53, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Plain wire', 59, 64, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Plain wire', 65, 70, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Plain wire', 71, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Plain wire', 75, 82, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3C'), 'Plain wire', 83, 88, 'plain', 14, NULL, NULL, 3);

-- KG-3D
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-3D', 'KG-3D', 88, 419 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 419;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Plain wire', 29, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Plain wire', 35, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Plain wire', 41, 46, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Plain wire', 47, 52, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Plain wire', 53, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Plain wire', 59, 64, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Plain wire', 65, 70, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Plain wire', 71, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Plain wire', 75, 82, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3D'), 'Plain wire', 83, 88, 'plain', 14, NULL, NULL, 3);

-- KG-3E
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-3E', 'KG-3E', 88, 420 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 420;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Bass — monochord', 1, 12, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Bass — bichord', 13, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 29, 30, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-3E'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- KG-5C
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-5C', 'KG-5C', 88, 421 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 421;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Bass — monochord', 1, 8, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Bass — bichord', 9, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Plain wire', 29, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Plain wire', 35, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Plain wire', 41, 46, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Plain wire', 47, 52, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Plain wire', 53, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Plain wire', 59, 64, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Plain wire', 65, 70, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Plain wire', 71, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Plain wire', 75, 82, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5C'), 'Plain wire', 83, 88, 'plain', 14, NULL, NULL, 3);

-- KG-5D
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-5D', 'KG-5D', 88, 421 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 421;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Bass — monochord', 1, 8, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Bass — bichord', 9, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Plain wire', 29, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Plain wire', 35, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Plain wire', 41, 46, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Plain wire', 47, 52, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Plain wire', 53, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Plain wire', 59, 64, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Plain wire', 65, 70, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Plain wire', 71, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Plain wire', 75, 82, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-5D'), 'Plain wire', 83, 88, 'plain', 14, NULL, NULL, 3);

-- KG-6C
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-6C', 'KG-6C', 88, 422 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 422;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Bass — monochord', 1, 8, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Bass — bichord', 9, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 27, 30, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 31, 32, 'plain', 19.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 33, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 37, 38, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 39, 46, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 47, 50, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 51, 54, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 55, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 59, 62, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 63, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 79, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6C'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- KG-7D
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-7D', 'KG-7D', 88, 422 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 422;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Bass — monochord', 1, 8, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Bass — bichord', 9, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 27, 30, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 31, 32, 'plain', 19.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 33, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 37, 38, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 39, 46, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 47, 50, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 51, 54, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 55, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 59, 62, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 63, 68, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 69, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 79, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-7D'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- KG-6E
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-6E', 'KG-6E', 88, 423 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 423;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 29, 30, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-6E'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- KG-8C
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'KG-8C', 'KG-8C', 88, 424 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 424;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Bass — monochord', 1, 8, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Bass — bichord', 9, 20, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Plain wire', 21, 24, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Plain wire', 25, 30, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Plain wire', 31, 37, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Plain wire', 38, 43, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Plain wire', 44, 51, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Plain wire', 52, 57, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Plain wire', 58, 63, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Plain wire', 64, 72, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Plain wire', 73, 76, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Plain wire', 77, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'KG-8C'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- GS-30
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GS-30', 'GS-30', 88, 425 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 425;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Plain wire', 27, 32, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Plain wire', 33, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Plain wire', 37, 40, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Plain wire', 67, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Plain wire', 73, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-30'), 'Plain wire', 79, 88, 'plain', 13.5, NULL, NULL, 3);

-- GS-40
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GS-40', 'GS-40', 88, 425 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 425;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Plain wire', 27, 32, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Plain wire', 33, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Plain wire', 37, 40, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Plain wire', 41, 44, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Plain wire', 45, 50, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Plain wire', 51, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Plain wire', 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Plain wire', 61, 66, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Plain wire', 67, 72, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Plain wire', 73, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-40'), 'Plain wire', 79, 88, 'plain', 13.5, NULL, NULL, 3);

-- GS-50
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GS-50', 'GS-50', 88, 426 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 426;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 27, 28, 'plain', 19.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 29, 30, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 31, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 35, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 39, 44, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 53, 60, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 61, 70, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 71, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 79, 82, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-50'), 'Plain wire', 83, 88, 'plain', 13.5, NULL, NULL, 3);

-- GS-60
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GS-60', 'GS-60', 88, 426 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 426;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Bass — bichord', 11, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 27, 28, 'plain', 19.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 29, 30, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 31, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 35, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 39, 44, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 53, 60, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 61, 70, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 71, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 79, 82, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-60'), 'Plain wire', 83, 88, 'plain', 13.5, NULL, NULL, 3);

-- GS-70
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GS-70', 'GS-70', 88, 427 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 427;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Bass — bichord', 11, 22, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 23, 24, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 25, 26, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 27, 28, 'plain', 19.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 29, 30, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 31, 34, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 35, 38, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 39, 44, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 45, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 49, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 53, 60, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 61, 70, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 71, 74, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 75, 78, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 79, 82, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-70'), 'Plain wire', 83, 88, 'plain', 13.5, NULL, NULL, 3);

-- GS-80
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GS-80', 'GS-80', 88, 428 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 428;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Bass — monochord', 1, 9, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Bass — bichord', 10, 22, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 23, 26, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 27, 32, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 33, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 37, 40, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 41, 42, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 43, 46, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 47, 52, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 53, 62, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 63, 70, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 71, 76, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 77, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-80'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- GS-100
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'GS-100', 'GS-100', 88, 429 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 429;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Bass — monochord', 1, 8, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Bass — bichord', 9, 20, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Plain wire', 21, 24, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Plain wire', 25, 30, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Plain wire', 31, 37, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Plain wire', 38, 43, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Plain wire', 44, 51, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Plain wire', 52, 57, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Plain wire', 58, 63, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Plain wire', 64, 72, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Plain wire', 73, 76, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Plain wire', 77, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'GS-100'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- R-0
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'R-0', 'R-0', 88, 430 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 430;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 29, 30, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-0'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- RX-3
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'RX-3', 'RX-3', 88, 430 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 430;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 29, 30, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-3'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- RX-A
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'RX-A', 'RX-A', 88, 430 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 430;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 29, 30, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-A'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- R-1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'R-1', 'R-1', 88, 430 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 430;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 29, 30, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-1'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- RX-5
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'RX-5', 'RX-5', 88, 430 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 430;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Bass — monochord', 1, 13, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Bass — bichord', 14, 26, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 29, 30, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-5'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- R-2
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'R-2', 'R-2', 88, 431 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 431;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Bass — bichord', 11, 22, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Plain wire', 23, 24, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Plain wire', 25, 30, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Plain wire', 31, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Plain wire', 39, 44, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Plain wire', 45, 52, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Plain wire', 53, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Plain wire', 59, 64, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Plain wire', 65, 72, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Plain wire', 73, 76, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Plain wire', 77, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'R-2'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- RX-6-1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'RX-6-1', 'RX-6 (fino a #2288671)', 88, 431 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 431;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Bass — monochord', 1, 10, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Bass — bichord', 11, 22, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Plain wire', 23, 24, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Plain wire', 25, 30, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Plain wire', 31, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Plain wire', 39, 44, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Plain wire', 45, 52, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Plain wire', 53, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Plain wire', 59, 64, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Plain wire', 65, 72, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Plain wire', 73, 76, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Plain wire', 77, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-1'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- RX-6-2
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'RX-6-2', 'RX-6 (da #2288671)', 88, 432 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 432;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Bass — monochord', 1, 9, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Bass — bichord', 10, 22, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 23, 24, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 25, 26, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 29, 30, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-6-2'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);

-- RX-7-1
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'RX-7-1', 'RX-7 (fino a #2314326)', 88, 433 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 433;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Bass — monochord', 1, 9, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Bass — bichord', 10, 22, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Plain wire', 23, 24, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Plain wire', 25, 30, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Plain wire', 31, 38, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Plain wire', 39, 44, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Plain wire', 45, 52, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Plain wire', 53, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Plain wire', 59, 64, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Plain wire', 65, 72, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Plain wire', 73, 76, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Plain wire', 77, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Plain wire', 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-1'), 'Plain wire', 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- RX-7-2
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, 'RX-7-2', 'RX-7 (da #2314326)', 88, 434 FROM `ps_brands` WHERE `name` = 'Kawai'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 434;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2');
INSERT INTO `ps_string_sections` (`model_id`, `section_name`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Bass — monochord', 1, 9, 'wound', NULL, NULL, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Bass — bichord', 10, 22, 'wound', NULL, NULL, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 23, 24, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 25, 26, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 27, 28, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 29, 30, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 31, 32, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 37, 42, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 43, 48, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 49, 58, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 59, 64, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 65, 68, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 69, 74, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 75, 78, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 79, 82, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Kawai') AND `code` = 'RX-7-2'), 'Plain wire', 83, 88, 'plain', 13, NULL, NULL, 3);


-- Estonia + August Forster
-- gauge = calibro EU (convertito da mm, corrispondenza esatta)
-- copper = diametro filo di rame in mm

INSERT INTO `ps_brands` (`name`, `slug`, `country`, `description`)
  VALUES ('Estonia', 'estonia', 'Estonia', 'Estonia Piano Factory, Tallinn (fondata 1893).')
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);
INSERT INTO `ps_brands` (`name`, `slug`, `country`, `description`)
  VALUES ('August Förster', 'august-forster', 'Germany', 'August Förster, Löbau (fondata 1859).')
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Estonia 168
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '168', '168 cm (dal 1995)', 88, 201 FROM `ps_brands` WHERE `name` = 'Estonia'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 201;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168');
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 1, 1, 'wound2', 23, 0.85, 1.9, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 2, 2, 'wound2', 23, 0.85, 1.7, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 3, 3, 'wound2', 23, 0.85, 1.5, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 4, 4, 'wound2', 22, 0.85, 1.4, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 5, 5, 'wound2', 21, 0.8, 1.35, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 6, 6, 'wound2', 20.5, 0.7, 1.35, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 7, 7, 'wound2', 20.5, 0.6, 1.35, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 8, 8, 'wound2', 20, 0.6, 1.25, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 9, 9, 'wound2', 20, 0.6, 1.15, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 10, 10, 'wound2', 20, 0.5, 1.15, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 11, 11, 'wound1', 18, 1.3, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 12, 12, 'wound1', 18, 1.25, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 13, 13, 'wound1', 17.5, 1.2, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 14, 14, 'wound1', 17.5, 1.15, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 15, 15, 'wound1', 17.5, 1.1, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 16, 16, 'wound1', 17, 1.05, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 17, 17, 'wound1', 17, 1, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 18, 18, 'wound1', 17, 0.95, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 19, 19, 'wound1', 17, 0.9, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 20, 20, 'wound1', 16.5, 0.85, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 21, 21, 'wound1', 16.5, 0.8, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 22, 22, 'wound1', 16.5, 0.75, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 23, 23, 'wound1', 16, 0.7, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 24, 24, 'wound1', 16, 0.65, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 25, 25, 'wound1', 15.5, 0.6, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 26, 26, 'wound1', 15.5, 0.55, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 27, 27, 'wound1', 19, 0.2, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 28, 28, 'wound1', 18, 0.2, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 29, 29, 'wound1', 17, 0.2, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 30, 30, 'plain', 19.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 31, 32, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 33, 36, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 37, 40, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 41, 46, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 47, 54, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 55, 60, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 61, 70, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 71, 76, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 77, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 81, 84, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '168'), 85, 88, 'plain', 13, NULL, NULL, 3);

-- Estonia 190
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '190', '190 cm (dal 1964)', 88, 202 FROM `ps_brands` WHERE `name` = 'Estonia'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 202;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190');
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 1, 1, 'wound1', 24, 1.85, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 2, 2, 'wound1', 24, 1.8, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 3, 3, 'wound1', 24, 1.75, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 4, 4, 'wound1', 23, 1.7, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 5, 5, 'wound1', 22, 1.6, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 6, 6, 'wound1', 22, 1.5, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 7, 7, 'wound1', 22, 1.45, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 8, 8, 'wound1', 22, 1.4, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 9, 9, 'wound1', 22, 1.35, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 10, 10, 'wound1', 22, 1.25, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 11, 11, 'wound1', 18, 1.05, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 12, 12, 'wound1', 18, 0.95, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 13, 13, 'wound1', 18, 0.9, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 14, 14, 'wound1', 17, 0.9, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 15, 15, 'wound1', 17, 0.85, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 16, 16, 'wound1', 17, 0.8, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 17, 17, 'wound1', 17, 0.7, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 18, 18, 'wound1', 17, 0.65, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 19, 19, 'wound1', 17, 0.6, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 20, 20, 'wound1', 17, 0.55, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 21, 21, 'wound1', 16, 0.4, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 22, 23, 'wound1', 16, 0.35, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 24, 25, 'wound1', 16, 0.3, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 26, 27, 'plain', 19.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 28, 31, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 32, 36, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 37, 48, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 49, 53, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 54, 59, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 60, 65, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 66, 71, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 72, 75, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 76, 79, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 80, 83, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '190'), 84, 88, 'plain', 13, NULL, NULL, 3);

-- Estonia 273-65
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '273-65', '273 cm (1965-1995)', 88, 203 FROM `ps_brands` WHERE `name` = 'Estonia'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 203;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65');
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 1, 1, 'wound1', 25, 1.55, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 2, 2, 'wound1', 25, 1.5, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 3, 3, 'wound1', 25, 1.35, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 4, 4, 'wound1', 25, 1.25, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 5, 5, 'wound1', 25, 1.15, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 6, 6, 'wound1', 24, 1.05, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 7, 7, 'wound1', 24, 0.85, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 8, 8, 'wound1', 23, 0.8, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 9, 9, 'wound1', 22, 0.7, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 10, 10, 'wound1', 22, 0.65, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 11, 11, 'wound1', 21, 0.6, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 12, 12, 'wound1', 20, 0.5, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 13, 13, 'wound1', 19.5, 0.45, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 14, 14, 'wound1', 17.5, 0.45, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 15, 15, 'wound1', 17.5, 0.4, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 16, 16, 'wound1', 16.5, 0.4, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 17, 17, 'wound1', 16.5, 0.35, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 18, 18, 'wound1', 16.5, 0.3, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 19, 19, 'wound1', 15.5, 0.3, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 20, 20, 'wound1', 15.5, 0.25, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 21, 24, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 25, 30, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 31, 37, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 38, 43, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 44, 51, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 52, 57, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 58, 63, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 64, 71, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 72, 76, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 77, 80, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 81, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-65'), 85, 88, 'plain', 13.5, NULL, NULL, 3);

-- Estonia 273-95
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '273-95', '273 cm (dal 1995)', 88, 204 FROM `ps_brands` WHERE `name` = 'Estonia'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 204;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95');
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 1, 1, 'wound1', 26, 2.2, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 2, 2, 'wound1', 26, 2, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 3, 3, 'wound1', 25.5, 1.8, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 4, 4, 'wound1', 25.5, 1.6, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 5, 5, 'wound1', 25, 1.45, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 6, 6, 'wound1', 24.5, 1.35, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 7, 7, 'wound1', 24, 1.25, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 8, 8, 'wound1', 23.5, 1.15, NULL, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 9, 9, 'wound1', 22, 0.8, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 10, 10, 'wound1', 22, 0.75, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 11, 11, 'wound1', 21.5, 0.7, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 12, 12, 'wound1', 21, 0.7, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 13, 13, 'wound1', 21, 0.65, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 14, 14, 'wound1', 20.5, 0.6, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 15, 15, 'wound1', 20, 0.6, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 16, 16, 'wound1', 19.5, 0.55, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 17, 17, 'wound1', 19, 0.55, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 18, 18, 'wound1', 18.5, 0.5, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 19, 19, 'wound1', 18, 0.5, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 20, 20, 'wound1', 17.5, 0.5, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 21, 22, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 23, 24, 'plain', 20.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 25, 26, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 27, 30, 'plain', 19.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 31, 40, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 41, 50, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 51, 56, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 57, 60, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 61, 64, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 65, 70, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 71, 76, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 77, 78, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 79, 80, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 81, 82, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 83, 84, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 85, 86, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'Estonia') AND `code` = '273-95'), 87, 88, 'plain', 13, NULL, NULL, 3);

-- August Förster 275
INSERT INTO `ps_models` (`brand_id`, `code`, `name`, `total_strings`, `sort_order`)
  SELECT `id`, '275', '275 cm', 88, 305 FROM `ps_brands` WHERE `name` = 'August Förster'
  ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `total_strings` = 88, `sort_order` = 305;
DELETE FROM `ps_string_sections` WHERE `model_id` = (SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275');
INSERT INTO `ps_string_sections` (`model_id`, `string_from`, `string_to`, `type`, `gauge`, `copper1`, `copper2`, `strings_per_note`) VALUES
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 1, 1, 'wound2', 27, 0.6, 1.05, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 2, 2, 'wound2', 26, 0.6, 1, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 3, 3, 'wound2', 25, 0.6, 0.95, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 4, 4, 'wound2', 24.5, 0.6, 0.9, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 5, 5, 'wound2', 24, 0.6, 0.85, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 6, 6, 'wound2', 23.5, 0.6, 0.8, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 7, 7, 'wound2', 23.5, 0.4, 0.8, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 8, 8, 'wound2', 23, 0.4, 0.8, 1),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 9, 9, 'wound1', 22, 0.8, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 10, 10, 'wound1', 22, 0.75, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 11, 11, 'wound1', 21.5, 0.7, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 12, 12, 'wound1', 20.5, 0.65, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 13, 13, 'wound1', 19.5, 0.6, NULL, 2),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 14, 14, 'wound1', 17, 0.5, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 15, 15, 'wound1', 17, 0.45, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 16, 16, 'wound1', 16.5, 0.45, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 17, 18, 'wound1', 16, 0.4, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 19, 19, 'wound1', 16, 0.35, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 20, 21, 'wound1', 15.5, 0.35, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 22, 22, 'plain', 21.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 23, 24, 'plain', 21, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 25, 26, 'plain', 20.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 27, 30, 'plain', 20, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 31, 36, 'plain', 19, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 37, 40, 'plain', 18.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 41, 44, 'plain', 18, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 45, 48, 'plain', 17.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 49, 52, 'plain', 17, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 53, 58, 'plain', 16.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 59, 62, 'plain', 16, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 63, 67, 'plain', 15.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 68, 72, 'plain', 15, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 73, 77, 'plain', 14.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 78, 80, 'plain', 14, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 81, 83, 'plain', 13.5, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 84, 86, 'plain', 13, NULL, NULL, 3),
  ((SELECT `id` FROM `ps_models` WHERE `brand_id` = (SELECT `id` FROM `ps_brands` WHERE `name` = 'August Förster') AND `code` = '275'), 87, 88, 'plain', 12.5, NULL, NULL, 3);

