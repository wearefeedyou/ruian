DROP TABLE IF EXISTS obce;

CREATE TABLE obce
SELECT kod_obce,nazev_obce
FROM `adresni_mista`
GROUP BY kod_obce;

ALTER TABLE `obce`
ADD PRIMARY KEY `kod_obce` (`kod_obce`);


ALTER TABLE `adresni_mista` DROP `nazev_obce`;

DROP TABLE IF EXISTS casti_obce;

CREATE TABLE casti_obce
SELECT kod_obce,kod_casti_obce,nazev_casti_obce,psc,nazev_momc,nazev_mop
FROM `adresni_mista`
GROUP BY kod_casti_obce;

UPDATE `adresni_mista` SET nazev_ulice=nazev_casti_obce WHERE NOT nazev_ulice;

ALTER TABLE `adresni_mista` DROP `nazev_casti_obce`, DROP `psc`, DROP `nazev_momc`, DROP `nazev_mop`;



ALTER TABLE `casti_obce`
ADD PRIMARY KEY `kod_casti_obce` (`kod_casti_obce`),
ADD INDEX `kod_obce` (`kod_obce`);
