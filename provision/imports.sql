BEGIN;

COPY foodgroups             FROM '/tmp/FD_GROUP.psv' DELIMITER as '|' NULL as '';
COPY foods                  FROM '/tmp/FOOD_DES.psv' DELIMITER as '|' NULL as '';
COPY langual_desc           FROM '/tmp/LANGDESC.psv' DELIMITER as '|' NULL as '';
COPY langual_factor         FROM '/tmp/LANGUAL.psv'  DELIMITER as '|' NULL as '';
COPY nutrients_desc         FROM '/tmp/NUTR_DEF.psv' DELIMITER as '|' NULL as '';
COPY source_codes           FROM '/tmp/SRC_CD.psv'   DELIMITER as '|' NULL as '';
COPY data_derivation_codes  FROM '/tmp/DERIV_CD.psv' DELIMITER as '|' NULL as '';
COPY weights                FROM '/tmp/WEIGHT.psv'   DELIMITER as '|' NULL as '';
COPY footnotes              FROM '/tmp/FOOTNOTE.psv' DELIMITER as '|' NULL as '';
COPY data_sources           FROM '/tmp/DATA_SRC.psv' DELIMITER as '|' NULL as '';
COPY data_sources_link      FROM '/tmp/DATSRCLN.psv' DELIMITER as '|' NULL as '';
COPY nutrients              FROM '/tmp/NUT_DATA.psv' DELIMITER as '|' NULL as '';

COMMIT;
