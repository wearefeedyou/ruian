SET sql_mode = '';
DROP TABLE IF EXISTS ruian_obce;

ALTER TABLE `ruian_adresy` ADD INDEX `obec_id` (`obec_id`);
ALTER TABLE `ruian_vazby_okresy` ADD INDEX `obec_id` (`obec_id`);

CREATE TABLE ruian_obce
  SELECT a.id, a.nazev, vo.okres_id as okres_id FROM (
    SELECT
      a.obec_id as id,
      a.nazev_obce as nazev
    FROM `ruian_adresy` a
    GROUP BY a.obec_id, a.nazev_obce
  ) as a JOIN `ruian_vazby_okresy` vo ON vo.obec_id = a.id
  GROUP BY a.id, a.nazev, vo.okres_id;

ALTER TABLE `ruian_obce` ADD PRIMARY KEY `id` (`id`);
ALTER TABLE `ruian_obce` ADD INDEX `okres_id` (`okres_id`);


ALTER TABLE `ruian_adresy` DROP `nazev_obce`;

DROP TABLE IF EXISTS ruian_casti_obce;

CREATE TABLE ruian_casti_obce
  SELECT
    casti_obce_id as id,
    obec_id as obec_id,
    nazev_casti_obce as nazev,
    psc,
    nazev_momc,
    nazev_mop
  FROM `ruian_adresy`
  GROUP BY casti_obce_id;

UPDATE `ruian_adresy`
SET nazev_ulice = nazev_casti_obce
WHERE nazev_ulice = '';

ALTER TABLE `ruian_adresy` DROP `nazev_momc`, DROP `nazev_mop`;


ALTER TABLE `ruian_casti_obce`
ADD PRIMARY KEY `id` (`id`),
ADD INDEX `obec_id` (`obec_id`);

ALTER TABLE `ruian_adresy`
ADD INDEX `casti_obce_id` (`casti_obce_id`),
ADD INDEX `nazev_ulice` (`nazev_ulice`(4)),
ADD INDEX `ulice_id` (`ulice_id`);

DROP TABLE IF EXISTS ruian_ulice;
CREATE TABLE ruian_ulice
  SELECT
    ulice_id AS id,
    casti_obce_id,
    obec_id,
    nazev_ulice
  FROM `ruian_adresy`
  GROUP BY obec_id, nazev_ulice;

DELETE FROM ruian_ulice WHERE id=0;

ALTER TABLE `ruian_ulice`
ADD PRIMARY KEY `id` (`id`),
ADD INDEX `casti_obce_id` (`casti_obce_id`),
ADD INDEX `obec_id` (`obec_id`);