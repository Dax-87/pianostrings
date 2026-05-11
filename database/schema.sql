CREATE DATABASE IF NOT EXISTS `pianostrings_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `pianostrings_db`;

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
  `type` enum('plain','wound1','wound2') NOT NULL DEFAULT 'plain',
  `gauge` decimal(4,1) NOT NULL,
  `copper1` decimal(5,2) DEFAULT NULL,
  `copper2` decimal(5,2) DEFAULT NULL,
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
