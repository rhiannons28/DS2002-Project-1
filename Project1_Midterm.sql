#LAB 2A PORTION (Creating Sakila_DW in SQL - for Practice)
CREATE DATABASE `Sakila_dw` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016
DEFAULT ENCRYPTION='N' */;
USE Sakila_dw2;

#DROP TABLE `dim_film`;
CREATE TABLE `dim_film` (
  `film_key` smallint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `release_year` year DEFAULT NULL,
  `language_id` tinyint unsigned NOT NULL,
  `original_language_id` tinyint unsigned DEFAULT NULL,
  `rental_duration` tinyint unsigned NOT NULL DEFAULT '3',
  `rental_rate` decimal(4,2) NOT NULL DEFAULT '4.99',
  `length` smallint unsigned DEFAULT NULL,
  `replacement_cost` decimal(5,2) NOT NULL DEFAULT '19.99',
  `rating` enum('G','PG','PG-13','R','NC-17') DEFAULT 'G',
  `special_features` set('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`film_key`),
  KEY `idx_title` (`title`),
  KEY `idx_fk_language_id` (`language_id`),
  KEY `idx_fk_original_language_id` (`original_language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb3;
TRUNCATE TABLE `sakila_dw`.`dim_film`;

CREATE TABLE `dim_film_actor` (
  `actor_key` smallint unsigned NOT NULL,
  `film_key` smallint unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actor_key`,`film_key`),
  KEY `idx_fk_film_id` (`film_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
TRUNCATE TABLE `sakila_dw`.`dim_film_actor`;

#DROP TABLE `dim_film_category`;
CREATE TABLE `dim_film_category` (
  `category_key` BIGINT unsigned NOT NULL,
  `film_id` smallint unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
TRUNCATE TABLE `sakila_dw`.`dim_film_category`;
SELECT * FROM `sakila`.`film_category`;
desc sakila_dw.dim_film_category;

#DROP TABLE `dim_language`;
CREATE TABLE `dim_language` (
  `language_key` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `name` char(20) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`language_key`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
TRUNCATE TABLE `sakila_dw`.`dim_language`;

#DROP TABLE `dim_payment`;
CREATE TABLE `dim_payment` (
  `payment_key` smallint unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` smallint unsigned NOT NULL,
  `staff_id` tinyint unsigned NULL,
  `rental_id` int DEFAULT NULL,
  `amount` decimal(5,2) NOT NULL,
  `payment_date` datetime NOT NULL,
  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_key`),
  KEY `idx_fk_staff_id` (`staff_id`),
  KEY `idx_fk_customer_id` (`customer_id`),
  KEY `fk_payment_rental` (`rental_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16050 DEFAULT CHARSET=utf8mb3;
TRUNCATE TABLE `sakila_dw`.`dim_payment`;

#DROP TABLE `dim_rental`;
CREATE TABLE `dim_rental` (
  `rental_key` int NOT NULL AUTO_INCREMENT,
  `rental_date` datetime NOT NULL,
  `inventory_id` mediumint unsigned NOT NULL,
  `customer_id` smallint unsigned NOT NULL,
  `return_date` datetime DEFAULT NULL,
  `staff_id` tinyint unsigned NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rental_key`),
  UNIQUE KEY `rental_date` (`rental_date`,`inventory_id`,`customer_id`),
  KEY `idx_fk_inventory_id` (`inventory_id`),
  KEY `idx_fk_customer_id` (`customer_id`),
  KEY `idx_fk_staff_id` (`staff_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16050 DEFAULT CHARSET=utf8mb3;
TRUNCATE TABLE `sakila_dw`.`dim_payment`;

#LAB 2B PORTION (Inserting Data into Sakila DW)
INSERT INTO `Sakila_dw`.`dim_film`
(`film_key`,
`title`,
`release_year`,
`language_id`,
`rental_duration`,
`rental_rate`,
`length`,
`rating`,
`last_update`)
SELECT `film_id`,
`title`,
`release_year`,
`language_id`,
`rental_duration`,
`rental_rate`,
`length`,
`rating`,
`last_update`
FROM sakila.film;
#VALIDATE DATA WAS INSERTED
SELECT * FROM sakila_dw.dim_film;

INSERT INTO `sakila_dw`.`dim_film_actor`
(`actor_key`,
`film_key`,
`last_update`)
SELECT `film_actor`.`actor_id`,
    `film_actor`.`film_id`,
    `film_actor`.`last_update`
FROM `sakila`.`film_actor`;
SELECT * FROM sakila_dw.dim_film_actor;

INSERT INTO `sakila_dw`.`dim_film_category`
(`category_key`,
`film_id`,
`last_update`)
SELECT `film_category`.`film_id`,
    `film_category`.`category_id`,
    `film_category`.`last_update`
FROM `sakila`.`film_category`;
SELECT * FROM sakila_dw.dim_film_category;

INSERT INTO `sakila_dw`.`dim_language`
(`language_key`,
`name`,
`last_update`)
SELECT `language`.`language_id`,
    `language`.`name`,
    `language`.`last_update`
FROM `sakila`.`language`;
SELECT * FROM sakila_dw.dim_language;

#Files to download for MongoDB and Locally
SELECT * FROM sakila.payment;
SELECT * FROM sakila.rental;
