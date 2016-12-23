BEGIN;

CREATE TABLE foodgroups (

  -- 4-digit code identifying a food group. Only the first 2 digits are
  -- currently assigned. In the future, the last 2 digits may be used.
  -- Codes may not be consecutive.
  foodgroup_id varchar(4) PRIMARY KEY,

  -- Name of food group.
  foodgroup_desc varchar(60) not null
);

CREATE TABLE foods (

  -- 5-digit Nutrient Databank number that uniquely identifies a food item.
  -- If this field is defined as numeric, the leading zero will be lost.
  ndb_no varchar(5) PRIMARY KEY,

  -- 4-digit code indicating food group to which a food item belongs.
  foodgroup_id varchar(4) references foodgroups(foodgroup_id) not null,

  -- 200-character description of food item.
  long_desc varchar(200) not null,

  -- 60-character abbreviated description of food item. Generated from
  -- the 200-character description using abbreviations in Appendix A.
  -- If short description is longer than 60 characters,
  -- additional abbreviations are made.
  short_desc varchar(60) not null,

  -- Other names commonly used to describe a food, including local or
  -- regional names for various foods, for example,
  -- “soda” or “pop” for “carbonated beverages.”
  com_name varchar(100),

  -- Indicates the company that manufactured the product, when appropriate.
  manufac_name varchar(65),

  -- Indicates if the food item is used in the USDA Food and Nutrient Database
  -- for Dietary Studies (FNDDS) and thus has a complete nutrient profile
  -- for the 65 FNDDS nutrients.
  survey varchar(1),

  -- Description of inedible parts of a food item (refuse), such as seeds or bone.
  ref_desc varchar(135),

  -- Percentage of refuse.
  refuse smallint,

  -- Scientific name of the food item. Given for the least processed form
  -- of the food (usually raw), if applicable.
  sci_name varchar(65),

  -- Factor for converting nitrogen to protein
  n_factor real,

  -- Factor for calculating calories from protein
  pro_factor real,

  -- Factor for calculating calories from fat
  fat_factor real,

  -- Factor for calculating calories from carbohydrate
  cho_factor real
);

CREATE TABLE langual_desc (

  -- The LanguaL factor from the Thesaurus. Only those codes used to factor
  -- the foods contained in the LanguaL Factor file are included in this file.
  factor_code varchar(5) PRIMARY KEY,

  -- The description of the LanguaL Factor Code from the thesaurus.
  description varchar(140) not null
);

CREATE TABLE langual_factor (

  -- 5-digit Nutrient Databank number that uniquely identifies a food item.
  -- If this field is defined as numeric, the leading zero will be lost.
  ndb_no varchar(5) references foods(ndb_no),

  -- The LanguaL factor from the Thesaurus.
  factor_code varchar(5) references langual_desc(factor_code),

  PRIMARY KEY(ndb_no, factor_code)
);

CREATE TABLE nutrients_desc (
    -- Unique 3-digit identifier code for a nutrient.
    nutr_no varchar(3) PRIMARY KEY,

    -- Units of measure (mg, g, μg, and so on).
    units varchar(7) not null,

    -- International Network of Food Data Systems (INFOODS) Tagnames. A unique
    -- abbreviation for a nutrient/food component developed by INFOODS to aid
    -- in the interchange of data.
    tagname varchar(20),

    -- Name of nutrient/food component.
    nutr_desc varchar(60) not null,

    -- Number of decimal places to which a nutrient value is rounded.
    num_dec varchar(1) not null,

    -- Used to sort nutrient records in the same order as various reports
    -- produced from SR.
    sr_order integer not null
);

CREATE TABLE source_codes (
    -- A 2-digit code indicating type of data.
    src_code varchar(2) PRIMARY KEY,

    -- Description of source code that identifies the type of nutrient data.
    src_desc varchar(60) not null
);

CREATE TABLE data_derivation_codes (
    -- Derivation Code.
    deriv_code varchar(4) PRIMARY KEY,

    -- Description of derivation code giving specific information on how the
    -- value was determined.
    devir_desc varchar(120) not null
);

CREATE TABLE weights (
    -- 5-digit Nutrient Databank number that uniquely identifies a food item.
    -- If this field is defined as numeric, the leading zero will be lost.
    ndb_no varchar(5) REFERENCES foods(ndb_no),

    -- Sequence number.
    seq varchar(2) not null,

    -- Unit modifier (for example, 1 in “1 cup”).
    amount real not null,

    -- Description (for example, cup, diced, and 1-inch pieces).
    msre_desc varchar(84) not null,

    -- Gram weight.
    gm_wgt real not null,

    -- Number of data points.
    num_data_pts smallint,

    -- Standard deviation.
    std_dev real,

    PRIMARY KEY(ndb_no, seq)
);

CREATE TABLE footnotes (
    -- 5-digit Nutrient Databank number that uniquely identifies a food item.
    -- If this field is defined as numeric, the leading zero will be lost.
    ndb_no varchar(5) REFERENCES foods(ndb_no),

    -- Sequence number. If a given footnote applies to more than one nutrient
    -- number, the same footnote number is used. As a result, this file cannot
    -- be indexed and there is no primary key.
    footnt_no varchar(4) not null,

    -- Type of footnote:
    -- D = footnote adding information to the food description;
    -- M = footnote adding information to measure description;
    -- N = footnote providing additional information on a nutrient value.
    -- If the Footnt_typ = N, the Nutr_No will also be filled in.
    footnt_typ varchar(1) not null,

    -- Unique 3-digit identifier code for a nutrient to which footnote applies.
    nutr_no varchar(3) REFERENCES nutrients_desc(nutr_no),

    -- Footnote text.
    footnt_txt varchar(200) not null

);

CREATE TABLE data_sources (
    -- Unique number identifying the reference/source.
    datasrc_id varchar(6) PRIMARY KEY,

    -- List of authors for a journal article or name of sponsoring organization
    -- for other documents.
    authors varchar(255),

    -- Title of article or name of document, such as a report from a
    -- company or trade association.
    title varchar(255) not null,

    -- Year article or document was published.
    year varchar(4),

    -- Name of the journal in which the article was published.
    journal varchar(135),

    -- Volume number for journal articles, books, or reports; city where
    -- sponsoring organization is located.
    vol_city varchar(16),

    -- Issue number for journal article; State where the sponsoring
    -- organization is located.
    issue_state varchar(5),

    -- Starting page number of article/document.
    start_page varchar(5),

    -- Ending page number of article/document.
    end_page varchar(5)
);

CREATE TABLE data_sources_link (
    -- 5-digit Nutrient Databank number that uniquely identifies a food item.
    -- If this field is defined as numeric, the leading zero will be lost.
    ndb_no varchar(5) REFERENCES foods(ndb_no),

    -- Unique 3-digit identifier code for a nutrient.
    nutr_no varchar(3) REFERENCES nutrients_desc(nutr_no),

    -- Unique ID identifying the reference/source.
    datasrc_id varchar(6) REFERENCES data_sources(datasrc_id),

    PRIMARY KEY(ndb_no, nutr_no, datasrc_id)
);

CREATE TABLE nutrients (
    -- 5-digit Nutrient Databank number that uniquely identifies a food item.
    -- If this field is defined as numeric, the leading zero will be lost.
    ndb_no varchar(5) REFERENCES foods(ndb_no),

    -- Unique 3-digit identifier code for a nutrient.
    nutr_no varchar(3) REFERENCES nutrients_desc(nutr_no),

    -- Amount in 100 grams, edible portion
    nutr_val real not null,

    -- Number of data points is the number of analyses used to calculate the
    -- nutrient value. If the number of data points is 0,
    -- the value was calculated or imputed.
    num_data_points real not null,

    -- Standard error of the mean. Null if cannot be calculated. The standard
    -- error is also not given if the number of data points is less than three.
    std_error real,

    -- Standard error of the mean. Null if cannot be calculated.
    -- The standard error is also not given if the number of data points
    -- is less than three.
    src_code varchar(2) not null REFERENCES source_codes(src_code),

    -- Data Derivation Code giving specific information on how the value is determined.
    -- This field is populated only for items added or updated starting with SR14.
    -- This field may not be populated if older records were used in the
    -- calculation of the mean value.
    deriv_code varchar(4) REFERENCES data_derivation_codes(deriv_code),

    -- NDB number of the item used to calculate a missing value.
    -- Populated only for items added or updated starting with SR14.
    ref_ndb_no varchar(5) REFERENCES foods(ndb_no),

    -- Indicates a vitamin or mineral added for fortification or enrichment.
    -- This field is populated for ready-to- eat breakfast cereals and
    -- many brand-name hot cereals in food group 08.
    add_nutr_mark varchar(1),

    -- Number of studies.
    num_studies smallint,

    -- Minimum value.
    min real,

    -- Maximum value.
    max real,

    -- Degrees of freedom.
    df smallint,

    -- Lower 95% error bound.
    low_eb real,

    -- Upper 95% error bound.
    up_eb real,

    -- Statistical comments. See definitions below.
    stat_comt varchar(10),

    -- Indicates when a value was either added to the database or last modified.
    addmod_date varchar(10),

    -- Confidence Code indicating data quality, based on evaluation of sample
    -- plan, sample handling, analytical method, analytical quality control,
    -- and number of samples analyzed. Not included in this release, but is
    -- planned for future releases.
    cc varchar(1),

    PRIMARY KEY(ndb_no, nutr_no)
);


COMMIT;
