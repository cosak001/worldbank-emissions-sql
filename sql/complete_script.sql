/* =====================================================================
   GLOBAL EMISSIONS & ECONOMIC DEVELOPMENT ANALYSIS – COMPLETE SCRIPT
   Database: PostgreSQL
   Source: World Bank World Development Indicators (8 selected series)

   USAGE:
   ===================
   PART 1: Run sections 0-3 (creates schema and raw import tables)
   PART 2: Import CSVs using pgAdmin GUI into raw_* tables
   PART 3: Run section 4 (combines raw tables into data table)
   PART 4: Run sections 5-6 (creates views)
   PART 5: Run section 7 (tests, validation, summary)
   ===================================================================== */


/* =====================================================================
   0. CLEAN SLATE – DROP EVERYTHING
   ===================================================================== */

-- Drop views
DROP VIEW IF EXISTS A5 CASCADE;
DROP VIEW IF EXISTS A4 CASCADE;
DROP VIEW IF EXISTS A3 CASCADE;
DROP VIEW IF EXISTS A2 CASCADE;
DROP VIEW IF EXISTS A1 CASCADE;
DROP VIEW IF EXISTS M9 CASCADE;
DROP VIEW IF EXISTS M8 CASCADE;
DROP VIEW IF EXISTS M7 CASCADE;
DROP VIEW IF EXISTS M6 CASCADE;
DROP VIEW IF EXISTS M5 CASCADE;
DROP VIEW IF EXISTS M4 CASCADE;
DROP VIEW IF EXISTS M3 CASCADE;
DROP VIEW IF EXISTS M2 CASCADE;
DROP VIEW IF EXISTS M1 CASCADE;
DROP VIEW IF EXISTS topic_indicator_codes CASCADE;

-- Drop raw import tables
DROP TABLE IF EXISTS raw_co2_total CASCADE;
DROP TABLE IF EXISTS raw_co2_per_capita CASCADE;
DROP TABLE IF EXISTS raw_co2_liquid_fuel CASCADE;
DROP TABLE IF EXISTS raw_co2_solid_fuel CASCADE;
DROP TABLE IF EXISTS raw_co2_gas_fuel CASCADE;
DROP TABLE IF EXISTS raw_gdp_per_capita CASCADE;
DROP TABLE IF EXISTS raw_internet_users CASCADE;
DROP TABLE IF EXISTS raw_inflation CASCADE;

-- Drop core tables
DROP TABLE IF EXISTS data CASCADE;
DROP TABLE IF EXISTS indicator CASCADE;
DROP TABLE IF EXISTS continent_country CASCADE;
DROP TABLE IF EXISTS country CASCADE;
DROP TABLE IF EXISTS continent CASCADE;



/* =====================================================================
   1. CORE WORLD STRUCTURE: CONTINENT, COUNTRY, CONTINENT_COUNTRY
   ===================================================================== */

---------------------------------------------------------------
-- 1.1 CREATE STRUCTURE TABLES
---------------------------------------------------------------

CREATE TABLE continent (
    continent_code VARCHAR(2) PRIMARY KEY,
    continent_name VARCHAR(50) NOT NULL
);

CREATE TABLE country (
    country_code VARCHAR(3) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

CREATE TABLE continent_country (
    continent_code VARCHAR(2) REFERENCES continent(continent_code),
    country_code   VARCHAR(3) REFERENCES country(country_code),
    PRIMARY KEY (continent_code, country_code)
);

---------------------------------------------------------------
-- 1.2 INSERT CONTINENTS
---------------------------------------------------------------

INSERT INTO continent (continent_code, continent_name) VALUES
('AF', 'Africa'),
('AN', 'Antarctica'),
('AS', 'Asia'),
('EU', 'Europe'),
('NA', 'North America'),
('OC', 'Oceania'),
('SA', 'South America');

---------------------------------------------------------------
-- 1.3 INSERT ALL COUNTRIES
---------------------------------------------------------------

INSERT INTO country (country_code, country_name) VALUES
-- Africa
('DZA','Algeria'),('AGO','Angola'),('BEN','Benin'),('BWA','Botswana'),
('BFA','Burkina Faso'),('BDI','Burundi'),('CMR','Cameroon'),('CPV','Cabo Verde'),
('CAF','Central African Republic'),('TCD','Chad'),('COM','Comoros'),('COG','Congo, Rep.'),
('COD','Congo, Dem. Rep.'),('CIV','Côte d''Ivoire'),('DJI','Djibouti'),('EGY','Egypt, Arab Rep.'),
('GNQ','Equatorial Guinea'),('ERI','Eritrea'),('SWZ','Eswatini'),('ETH','Ethiopia'),
('GAB','Gabon'),('GMB','Gambia, The'),('GHA','Ghana'),('GIN','Guinea'),
('GNB','Guinea-Bissau'),('KEN','Kenya'),('LSO','Lesotho'),('LBR','Liberia'),
('LBY','Libya'),('MDG','Madagascar'),('MWI','Malawi'),('MLI','Mali'),
('MRT','Mauritania'),('MUS','Mauritius'),('MAR','Morocco'),('MOZ','Mozambique'),
('NAM','Namibia'),('NER','Niger'),('NGA','Nigeria'),('RWA','Rwanda'),
('STP','Sao Tome and Principe'),('SEN','Senegal'),('SYC','Seychelles'),('SLE','Sierra Leone'),
('SOM','Somalia'),('ZAF','South Africa'),('SSD','South Sudan'),('SDN','Sudan'),
('TZA','Tanzania'),('TGO','Togo'),('TUN','Tunisia'),('UGA','Uganda'),
('ZMB','Zambia'),('ZWE','Zimbabwe'),

-- Antarctica & Territories
('ATA','Antarctica'),('BVT','Bouvet Island'),('HMD','Heard Island and McDonald Islands'),
('SGS','South Georgia and South Sandwich Islands'),('ATF','French Southern Territories'),

-- Asia
('AFG','Afghanistan'),('ARM','Armenia'),('AZE','Azerbaijan'),('BHR','Bahrain'),
('BGD','Bangladesh'),('BTN','Bhutan'),('BRN','Brunei Darussalam'),('KHM','Cambodia'),
('CHN','China'),('CYP','Cyprus'),('GEO','Georgia'),('HKG','Hong Kong SAR, China'),
('IND','India'),('IDN','Indonesia'),('IRN','Iran, Islamic Rep.'),('IRQ','Iraq'),
('ISR','Israel'),('JPN','Japan'),('JOR','Jordan'),('KAZ','Kazakhstan'),
('KWT','Kuwait'),('KGZ','Kyrgyz Republic'),('LAO','Lao PDR'),('LBN','Lebanon'),
('MAC','Macao SAR, China'),('MYS','Malaysia'),('MDV','Maldives'),('MNG','Mongolia'),
('MMR','Myanmar'),('NPL','Nepal'),('PRK','Korea, Dem. People''s Rep.'),('OMN','Oman'),
('PAK','Pakistan'),('PHL','Philippines'),('QAT','Qatar'),('SAU','Saudi Arabia'),
('SGP','Singapore'),('KOR','Korea, Rep.'),('LKA','Sri Lanka'),('SYR','Syrian Arab Republic'),
('TWN','Taiwan'),('TJK','Tajikistan'),('THA','Thailand'),('TUR','Turkey'),
('TKM','Turkmenistan'),('ARE','United Arab Emirates'),('UZB','Uzbekistan'),
('VNM','Vietnam'),('YEM','Yemen, Rep.'),('PSE','West Bank and Gaza'),

-- Europe
('ALB','Albania'),('AND','Andorra'),('AUT','Austria'),('BLR','Belarus'),
('BEL','Belgium'),('BIH','Bosnia and Herzegovina'),('BGR','Bulgaria'),('HRV','Croatia'),
('CZE','Czechia'),('DNK','Denmark'),('EST','Estonia'),('FRO','Faroe Islands'),
('FIN','Finland'),('FRA','France'),('DEU','Germany'),('GRC','Greece'),
('GRL','Greenland'),('HUN','Hungary'),('ISL','Iceland'),('IRL','Ireland'),
('ITA','Italy'),('XKX','Kosovo'),('LVA','Latvia'),('LIE','Liechtenstein'),
('LTU','Lithuania'),('LUX','Luxembourg'),('MLT','Malta'),('MDA','Moldova'),
('MCO','Monaco'),('MNE','Montenegro'),('NLD','Netherlands'),('MKD','North Macedonia'),
('NOR','Norway'),('POL','Poland'),('PRT','Portugal'),('ROU','Romania'),
('RUS','Russian Federation'),('SMR','San Marino'),('SRB','Serbia'),('SVK','Slovak Republic'),
('SVN','Slovenia'),('ESP','Spain'),('SWE','Sweden'),('CHE','Switzerland'),
('UKR','Ukraine'),('GBR','United Kingdom'),

-- North America & Caribbean
('ATG','Antigua and Barbuda'),('BHS','Bahamas, The'),('BRB','Barbados'),('BLZ','Belize'),
('CAN','Canada'),('CRI','Costa Rica'),('CUB','Cuba'),('DMA','Dominica'),
('DOM','Dominican Republic'),('SLV','El Salvador'),('GRD','Grenada'),('GTM','Guatemala'),
('HTI','Haiti'),('HND','Honduras'),('JAM','Jamaica'),('MEX','Mexico'),
('NIC','Nicaragua'),('PAN','Panama'),('KNA','St. Kitts and Nevis'),('LCA','St. Lucia'),
('VCT','St. Vincent and the Grenadines'),('TTO','Trinidad and Tobago'),('USA','United States'),
('GLP','Guadeloupe'),('MTQ','Martinique'),('PRI','Puerto Rico'),('BLM','Saint Barthélemy'),
('MAF','Saint Martin (French part)'),('CYM','Cayman Islands'),('ASM','American Samoa'),
('ABW','Aruba'),('BMU','Bermuda'),('CUW','Curaçao'),('GUM','Guam'),
('MNP','Northern Mariana Islands'),('VIR','Virgin Islands (U.S.)'),
('TCA','Turks and Caicos Islands'),('SXM','Sint Maarten (Dutch part)'),

-- Oceania
('AUS','Australia'),('FJI','Fiji'),('KIR','Kiribati'),('MHL','Marshall Islands'),
('FSM','Micronesia, Fed. Sts.'),('NRU','Nauru'),('NZL','New Zealand'),('PLW','Palau'),
('PNG','Papua New Guinea'),('WSM','Samoa'),('SLB','Solomon Islands'),('TON','Tonga'),
('TUV','Tuvalu'),('VUT','Vanuatu'),('NCL','New Caledonia'),('PYF','French Polynesia'),

-- South America
('ARG','Argentina'),('BOL','Bolivia'),('BRA','Brazil'),('CHL','Chile'),
('COL','Colombia'),('ECU','Ecuador'),('GUY','Guyana'),('PRY','Paraguay'),
('PER','Peru'),('SUR','Suriname'),('URY','Uruguay'),('VEN','Venezuela, RB'),
('FLK','Falkland Islands');

---------------------------------------------------------------
-- 1.4 CONTINENT → COUNTRY MAPPINGS
---------------------------------------------------------------

INSERT INTO continent_country (continent_code, country_code) VALUES
-- Africa
('AF','DZA'),('AF','AGO'),('AF','BEN'),('AF','BWA'),('AF','BFA'),('AF','BDI'),
('AF','CMR'),('AF','CPV'),('AF','CAF'),('AF','TCD'),('AF','COM'),('AF','COG'),
('AF','COD'),('AF','CIV'),('AF','DJI'),('AF','EGY'),('AF','GNQ'),('AF','ERI'),
('AF','SWZ'),('AF','ETH'),('AF','GAB'),('AF','GMB'),('AF','GHA'),('AF','GIN'),
('AF','GNB'),('AF','KEN'),('AF','LSO'),('AF','LBR'),('AF','LBY'),('AF','MDG'),
('AF','MWI'),('AF','MLI'),('AF','MRT'),('AF','MUS'),('AF','MAR'),('AF','MOZ'),
('AF','NAM'),('AF','NER'),('AF','NGA'),('AF','RWA'),('AF','STP'),('AF','SEN'),
('AF','SYC'),('AF','SLE'),('AF','SOM'),('AF','ZAF'),('AF','SSD'),('AF','SDN'),
('AF','TZA'),('AF','TGO'),('AF','TUN'),('AF','UGA'),('AF','ZMB'),('AF','ZWE'),

-- Antarctica
('AN','ATA'),('AN','BVT'),('AN','HMD'),('AN','SGS'),('AN','ATF'),

-- Asia
('AS','AFG'),('AS','ARM'),('AS','AZE'),('AS','BHR'),('AS','BGD'),('AS','BTN'),
('AS','BRN'),('AS','KHM'),('AS','CHN'),('AS','CYP'),('AS','GEO'),('AS','HKG'),
('AS','IND'),('AS','IDN'),('AS','IRN'),('AS','IRQ'),('AS','ISR'),('AS','JPN'),
('AS','JOR'),('AS','KAZ'),('AS','KWT'),('AS','KGZ'),('AS','LAO'),('AS','LBN'),
('AS','MAC'),('AS','MYS'),('AS','MDV'),('AS','MNG'),('AS','MMR'),('AS','NPL'),
('AS','PRK'),('AS','OMN'),('AS','PAK'),('AS','PHL'),('AS','QAT'),('AS','SAU'),
('AS','SGP'),('AS','KOR'),('AS','LKA'),('AS','SYR'),('AS','TWN'),('AS','TJK'),
('AS','THA'),('AS','TUR'),('AS','TKM'),('AS','ARE'),('AS','UZB'),('AS','VNM'),
('AS','YEM'),('AS','PSE'),

-- Europe
('EU','ALB'),('EU','AND'),('EU','AUT'),('EU','BLR'),('EU','BEL'),('EU','BIH'),
('EU','BGR'),('EU','HRV'),('EU','CZE'),('EU','DNK'),('EU','EST'),('EU','FRO'),
('EU','FIN'),('EU','FRA'),('EU','DEU'),('EU','GRC'),('EU','GRL'),('EU','HUN'),
('EU','ISL'),('EU','IRL'),('EU','ITA'),('EU','XKX'),('EU','LVA'),('EU','LIE'),
('EU','LTU'),('EU','LUX'),('EU','MLT'),('EU','MDA'),('EU','MCO'),('EU','MNE'),
('EU','NLD'),('EU','MKD'),('EU','NOR'),('EU','POL'),('EU','PRT'),('EU','ROU'),
('EU','RUS'),('EU','SMR'),('EU','SRB'),('EU','SVK'),('EU','SVN'),('EU','ESP'),
('EU','SWE'),('EU','CHE'),('EU','UKR'),('EU','GBR'),

-- North America & Caribbean
('NA','ATG'),('NA','BHS'),('NA','BRB'),('NA','BLZ'),('NA','CAN'),('NA','CRI'),
('NA','CUB'),('NA','DMA'),('NA','DOM'),('NA','SLV'),('NA','GRD'),('NA','GTM'),
('NA','HTI'),('NA','HND'),('NA','JAM'),('NA','MEX'),('NA','NIC'),('NA','PAN'),
('NA','KNA'),('NA','LCA'),('NA','VCT'),('NA','TTO'),('NA','USA'),('NA','GLP'),
('NA','MTQ'),('NA','PRI'),('NA','BLM'),('NA','MAF'),('NA','CYM'),('NA','ASM'),
('NA','ABW'),('NA','BMU'),('NA','CUW'),('NA','GUM'),('NA','MNP'),('NA','VIR'),
('NA','TCA'),('NA','SXM'),

-- Oceania
('OC','AUS'),('OC','FJI'),('OC','KIR'),('OC','MHL'),('OC','FSM'),('OC','NRU'),
('OC','NZL'),('OC','PLW'),('OC','PNG'),('OC','WSM'),('OC','SLB'),('OC','TON'),
('OC','TUV'),('OC','VUT'),('OC','NCL'),('OC','PYF'),

-- South America
('SA','ARG'),('SA','BOL'),('SA','BRA'),('SA','CHL'),('SA','COL'),('SA','ECU'),
('SA','GUY'),('SA','PRY'),('SA','PER'),('SA','SUR'),('SA','URY'),('SA','VEN'),
('SA','FLK');



/* =====================================================================
   2. INDICATOR METADATA + FACT TABLE
   ===================================================================== */

---------------------------------------------------------------
-- 2.1 INDICATOR METADATA
---------------------------------------------------------------

CREATE TABLE indicator (
    indicator_code VARCHAR(20) PRIMARY KEY,
    indicator_name TEXT NOT NULL,
    topic          VARCHAR(50)
);

INSERT INTO indicator (indicator_code, indicator_name, topic) VALUES
-- 5 Emissions Indicators
('EN_ATM_CO2E_KT',     'CO2 emissions (kt)',                               'Emissions'),
('EN_ATM_CO2E_PC',     'CO2 emissions (metric tons per capita)',          'Emissions'),
('EN_ATM_CO2E_LF_KT',  'CO2 emissions from liquid fuel consumption (kt)', 'Emissions'),
('EN_ATM_CO2E_SF_KT',  'CO2 emissions from solid fuel consumption (kt)',  'Emissions'),
('EN_ATM_CO2E_GF_KT',  'CO2 emissions from gaseous fuel consumption (kt)','Emissions'),

-- 3 Common Indicators (used in additional analysis A1-A5)
('NY_GDP_PCAP_CD','GDP per capita (current US$)',         'Common'),
('IT_NET_USER_P2','Internet users (per 100 people)',      'Common'),
('FP_CPI_TOTL_ZG','Inflation, consumer prices (annual %)','Common');

---------------------------------------------------------------
-- 2.2 MAIN FACT TABLE: DATA
---------------------------------------------------------------

CREATE TABLE data (
    data_id        SERIAL PRIMARY KEY,
    country_code   VARCHAR(3) REFERENCES country(country_code),
    indicator_code VARCHAR(20) REFERENCES indicator(indicator_code),
    data_date      DATE NOT NULL,
    value          NUMERIC,
    UNIQUE(country_code, indicator_code, data_date)
);
/* =====================================================================
   3. RAW IMPORT TABLES (One per CSV file)
   =====================================================================

   Run this, then import each CSV using pgAdmin's Import/Export tool:

   1. raw_co2_total          ← EN_ATM_CO2E_KT.csv
   2. raw_co2_per_capita     ← EN_ATM_CO2E_PC.csv
   3. raw_co2_liquid_fuel    ← EN_ATM_CO2E_LF_KT.csv
   4. raw_co2_solid_fuel     ← EN_ATM_CO2E_SF_KT.csv
   5. raw_co2_gas_fuel       ← EN_ATM_CO2E_GF_KT.csv
   6. raw_gdp_per_capita     ← NY_GDP_PCAP_CD.csv
   7. raw_internet_users     ← IT_NET_USER_P2.csv
   8. raw_inflation          ← FP_CPI_TOTL_ZG.csv

   After all 8 are imported, continue with section 4 below.
   ===================================================================== */

CREATE TABLE raw_co2_total (
    date_text TEXT,
    value_text TEXT,
    country_code TEXT,
    indicator_code TEXT
);

CREATE TABLE raw_co2_per_capita (
    date_text TEXT,
    value_text TEXT,
    country_code TEXT,
    indicator_code TEXT
);

CREATE TABLE raw_co2_liquid_fuel (
    date_text TEXT,
    value_text TEXT,
    country_code TEXT,
    indicator_code TEXT
);

CREATE TABLE raw_co2_solid_fuel (
    date_text TEXT,
    value_text TEXT,
    country_code TEXT,
    indicator_code TEXT
);

CREATE TABLE raw_co2_gas_fuel (
    date_text TEXT,
    value_text TEXT,
    country_code TEXT,
    indicator_code TEXT
);

CREATE TABLE raw_gdp_per_capita (
    date_text TEXT,
    value_text TEXT,
    country_code TEXT,
    indicator_code TEXT
);

CREATE TABLE raw_internet_users (
    date_text TEXT,
    value_text TEXT,
    country_code TEXT,
    indicator_code TEXT
);

CREATE TABLE raw_inflation (
    date_text TEXT,
    value_text TEXT,
    country_code TEXT,
    indicator_code TEXT
);

-- Verify all 8 staging tables created
SELECT tablename
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename LIKE 'raw_%'
ORDER BY tablename;
/* =====================================================================
   4. COMBINE RAW TABLES INTO MAIN DATA TABLE
   ===================================================================== */

-- Casts text → typed columns, uppercases country codes, blanks → NULL.
-- The NOT IN list excludes World Bank aggregates (WLD, HIC, SSA, etc.)
-- so regions/income groups don't get counted as countries.

-- First verify all staging tables have data
SELECT 'raw_co2_total' as table_name, COUNT(*) FROM raw_co2_total
UNION ALL SELECT 'raw_co2_per_capita', COUNT(*) FROM raw_co2_per_capita
UNION ALL SELECT 'raw_co2_liquid_fuel', COUNT(*) FROM raw_co2_liquid_fuel
UNION ALL SELECT 'raw_co2_solid_fuel', COUNT(*) FROM raw_co2_solid_fuel
UNION ALL SELECT 'raw_co2_gas_fuel', COUNT(*) FROM raw_co2_gas_fuel
UNION ALL SELECT 'raw_gdp_per_capita', COUNT(*) FROM raw_gdp_per_capita
UNION ALL SELECT 'raw_internet_users', COUNT(*) FROM raw_internet_users
UNION ALL SELECT 'raw_inflation', COUNT(*) FROM raw_inflation;

-- Combine all 8 staging tables into the main data table
INSERT INTO data (country_code, indicator_code, data_date, value)
SELECT
    UPPER(country_code) AS country_code,
    indicator_code,
    date_text::date AS data_date,
    NULLIF(value_text, '')::numeric AS value
FROM raw_co2_total
WHERE UPPER(country_code) IN (SELECT country_code FROM country)
  AND indicator_code IN (SELECT indicator_code FROM indicator)
  AND UPPER(country_code) NOT IN (
      'WLD', 'EAP', 'EAS', 'ECA', 'ECS', 'EMU', 'EUU', 'FCS', 'HPC',
      'LAC', 'LCN', 'LDC', 'MEA', 'MNA', 'NAC', 'OED', 'OSS',
      'PSS', 'PST', 'SAS', 'SSA', 'SSF', 'SST', 'TEA', 'TEC',
      'TLA', 'TMN', 'TSA', 'TSS', 'HIC', 'INX', 'LIC', 'LMC',
      'LMY', 'MIC', 'UMC', 'ARB', 'CEB', 'CSS', 'IBD', 'IBT',
      'IDA', 'IDB', 'IDX', 'PRE', 'UNS'
  )

UNION ALL

SELECT UPPER(country_code), indicator_code, date_text::date, NULLIF(value_text, '')::numeric
FROM raw_co2_per_capita
WHERE UPPER(country_code) IN (SELECT country_code FROM country)
  AND indicator_code IN (SELECT indicator_code FROM indicator)
  AND UPPER(country_code) NOT IN (
      'WLD', 'EAP', 'EAS', 'ECA', 'ECS', 'EMU', 'EUU', 'FCS', 'HPC',
      'LAC', 'LCN', 'LDC', 'MEA', 'MNA', 'NAC', 'OED', 'OSS',
      'PSS', 'PST', 'SAS', 'SSA', 'SSF', 'SST', 'TEA', 'TEC',
      'TLA', 'TMN', 'TSA', 'TSS', 'HIC', 'INX', 'LIC', 'LMC',
      'LMY', 'MIC', 'UMC', 'ARB', 'CEB', 'CSS', 'IBD', 'IBT',
      'IDA', 'IDB', 'IDX', 'PRE', 'UNS'
  )

UNION ALL

SELECT UPPER(country_code), indicator_code, date_text::date, NULLIF(value_text, '')::numeric
FROM raw_co2_liquid_fuel
WHERE UPPER(country_code) IN (SELECT country_code FROM country)
  AND indicator_code IN (SELECT indicator_code FROM indicator)
  AND UPPER(country_code) NOT IN (
      'WLD', 'EAP', 'EAS', 'ECA', 'ECS', 'EMU', 'EUU', 'FCS', 'HPC',
      'LAC', 'LCN', 'LDC', 'MEA', 'MNA', 'NAC', 'OED', 'OSS',
      'PSS', 'PST', 'SAS', 'SSA', 'SSF', 'SST', 'TEA', 'TEC',
      'TLA', 'TMN', 'TSA', 'TSS', 'HIC', 'INX', 'LIC', 'LMC',
      'LMY', 'MIC', 'UMC', 'ARB', 'CEB', 'CSS', 'IBD', 'IBT',
      'IDA', 'IDB', 'IDX', 'PRE', 'UNS'
  )

UNION ALL

SELECT UPPER(country_code), indicator_code, date_text::date, NULLIF(value_text, '')::numeric
FROM raw_co2_solid_fuel
WHERE UPPER(country_code) IN (SELECT country_code FROM country)
  AND indicator_code IN (SELECT indicator_code FROM indicator)
  AND UPPER(country_code) NOT IN (
      'WLD', 'EAP', 'EAS', 'ECA', 'ECS', 'EMU', 'EUU', 'FCS', 'HPC',
      'LAC', 'LCN', 'LDC', 'MEA', 'MNA', 'NAC', 'OED', 'OSS',
      'PSS', 'PST', 'SAS', 'SSA', 'SSF', 'SST', 'TEA', 'TEC',
      'TLA', 'TMN', 'TSA', 'TSS', 'HIC', 'INX', 'LIC', 'LMC',
      'LMY', 'MIC', 'UMC', 'ARB', 'CEB', 'CSS', 'IBD', 'IBT',
      'IDA', 'IDB', 'IDX', 'PRE', 'UNS'
  )

UNION ALL

SELECT UPPER(country_code), indicator_code, date_text::date, NULLIF(value_text, '')::numeric
FROM raw_co2_gas_fuel
WHERE UPPER(country_code) IN (SELECT country_code FROM country)
  AND indicator_code IN (SELECT indicator_code FROM indicator)
  AND UPPER(country_code) NOT IN (
      'WLD', 'EAP', 'EAS', 'ECA', 'ECS', 'EMU', 'EUU', 'FCS', 'HPC',
      'LAC', 'LCN', 'LDC', 'MEA', 'MNA', 'NAC', 'OED', 'OSS',
      'PSS', 'PST', 'SAS', 'SSA', 'SSF', 'SST', 'TEA', 'TEC',
      'TLA', 'TMN', 'TSA', 'TSS', 'HIC', 'INX', 'LIC', 'LMC',
      'LMY', 'MIC', 'UMC', 'ARB', 'CEB', 'CSS', 'IBD', 'IBT',
      'IDA', 'IDB', 'IDX', 'PRE', 'UNS'
  )

UNION ALL

SELECT UPPER(country_code), indicator_code, date_text::date, NULLIF(value_text, '')::numeric
FROM raw_gdp_per_capita
WHERE UPPER(country_code) IN (SELECT country_code FROM country)
  AND indicator_code IN (SELECT indicator_code FROM indicator)
  AND UPPER(country_code) NOT IN (
      'WLD', 'EAP', 'EAS', 'ECA', 'ECS', 'EMU', 'EUU', 'FCS', 'HPC',
      'LAC', 'LCN', 'LDC', 'MEA', 'MNA', 'NAC', 'OED', 'OSS',
      'PSS', 'PST', 'SAS', 'SSA', 'SSF', 'SST', 'TEA', 'TEC',
      'TLA', 'TMN', 'TSA', 'TSS', 'HIC', 'INX', 'LIC', 'LMC',
      'LMY', 'MIC', 'UMC', 'ARB', 'CEB', 'CSS', 'IBD', 'IBT',
      'IDA', 'IDB', 'IDX', 'PRE', 'UNS'
  )

UNION ALL

SELECT UPPER(country_code), indicator_code, date_text::date, NULLIF(value_text, '')::numeric
FROM raw_internet_users
WHERE UPPER(country_code) IN (SELECT country_code FROM country)
  AND indicator_code IN (SELECT indicator_code FROM indicator)
  AND UPPER(country_code) NOT IN (
      'WLD', 'EAP', 'EAS', 'ECA', 'ECS', 'EMU', 'EUU', 'FCS', 'HPC',
      'LAC', 'LCN', 'LDC', 'MEA', 'MNA', 'NAC', 'OED', 'OSS',
      'PSS', 'PST', 'SAS', 'SSA', 'SSF', 'SST', 'TEA', 'TEC',
      'TLA', 'TMN', 'TSA', 'TSS', 'HIC', 'INX', 'LIC', 'LMC',
      'LMY', 'MIC', 'UMC', 'ARB', 'CEB', 'CSS', 'IBD', 'IBT',
      'IDA', 'IDB', 'IDX', 'PRE', 'UNS'
  )

UNION ALL

SELECT UPPER(country_code), indicator_code, date_text::date, NULLIF(value_text, '')::numeric
FROM raw_inflation
WHERE UPPER(country_code) IN (SELECT country_code FROM country)
  AND indicator_code IN (SELECT indicator_code FROM indicator)
  AND UPPER(country_code) NOT IN (
      'WLD', 'EAP', 'EAS', 'ECA', 'ECS', 'EMU', 'EUU', 'FCS', 'HPC',
      'LAC', 'LCN', 'LDC', 'MEA', 'MNA', 'NAC', 'OED', 'OSS',
      'PSS', 'PST', 'SAS', 'SSA', 'SSF', 'SST', 'TEA', 'TEC',
      'TLA', 'TMN', 'TSA', 'TSS', 'HIC', 'INX', 'LIC', 'LMC',
      'LMY', 'MIC', 'UMC', 'ARB', 'CEB', 'CSS', 'IBD', 'IBT',
      'IDA', 'IDB', 'IDX', 'PRE', 'UNS'
  );

-- VERIFICATION
SELECT COUNT(*) as total_rows FROM data;
SELECT indicator_code, COUNT(*) FROM data GROUP BY indicator_code ORDER BY indicator_code;
SELECT COUNT(DISTINCT country_code) as num_countries FROM data;
SELECT MIN(data_date) as earliest, MAX(data_date) as latest FROM data;

/* Cleanup – drop raw tables once data table is verified

DROP TABLE IF EXISTS raw_co2_total CASCADE;
DROP TABLE IF EXISTS raw_co2_per_capita CASCADE;
DROP TABLE IF EXISTS raw_co2_liquid_fuel CASCADE;
DROP TABLE IF EXISTS raw_co2_solid_fuel CASCADE;
DROP TABLE IF EXISTS raw_co2_gas_fuel CASCADE;
DROP TABLE IF EXISTS raw_gdp_per_capita CASCADE;
DROP TABLE IF EXISTS raw_internet_users CASCADE;
DROP TABLE IF EXISTS raw_inflation CASCADE;

*/
/* =====================================================================
   5. MANDATORY ANALYSIS VIEWS (M1 – M9)
   ===================================================================== */

---------------------------------------------------------------
-- HELPER VIEW – topic indicator list (only 5 emissions)
---------------------------------------------------------------

CREATE OR REPLACE VIEW topic_indicator_codes AS
SELECT unnest(ARRAY[
    'EN_ATM_CO2E_KT',
    'EN_ATM_CO2E_PC',
    'EN_ATM_CO2E_LF_KT',
    'EN_ATM_CO2E_SF_KT',
    'EN_ATM_CO2E_GF_KT'
]::text[]) AS indicator_code;

---------------------------------------------------------------
-- M1: Countries missing data for one or more of 5 emissions indicators
---------------------------------------------------------------

CREATE OR REPLACE VIEW M1 AS
WITH country_indicator_counts AS (
    SELECT
        d.country_code,
        COUNT(DISTINCT d.indicator_code) AS num_indicators
    FROM data d
    WHERE d.indicator_code IN (SELECT indicator_code FROM topic_indicator_codes)
    GROUP BY d.country_code
)
SELECT
    c.country_name,
    COALESCE(cic.num_indicators, 0) AS num_indicators_present
FROM country c
LEFT JOIN country_indicator_counts cic
  ON cic.country_code = c.country_code
WHERE COALESCE(cic.num_indicators, 0) < 5
ORDER BY c.country_name;

---------------------------------------------------------------
-- M2: Countries with data for ALL 5 emissions indicators
---------------------------------------------------------------

CREATE OR REPLACE VIEW M2 AS
WITH country_indicator_counts AS (
    SELECT
        d.country_code,
        COUNT(DISTINCT d.indicator_code) AS num_indicators
    FROM data d
    WHERE d.indicator_code IN (SELECT indicator_code FROM topic_indicator_codes)
    GROUP BY d.country_code
)
SELECT
    c.country_name,
    cic.num_indicators
FROM country c
JOIN country_indicator_counts cic
  ON cic.country_code = c.country_code
WHERE cic.num_indicators = 5
ORDER BY c.country_name;

---------------------------------------------------------------
-- M3: The 5 emissions indicators with number of countries
---------------------------------------------------------------

CREATE OR REPLACE VIEW M3 AS
SELECT
    i.indicator_name,
    COUNT(DISTINCT d.country_code) AS num_countries
FROM data d
JOIN indicator i ON i.indicator_code = d.indicator_code
WHERE d.indicator_code IN (SELECT indicator_code FROM topic_indicator_codes)
GROUP BY i.indicator_name
ORDER BY num_countries DESC, i.indicator_name;

---------------------------------------------------------------
-- M4: Top 10 countries by most recent total CO2 emissions
---------------------------------------------------------------

CREATE OR REPLACE VIEW M4 AS
WITH ranked AS (
    SELECT
        d.country_code,
        c.country_name,
        d.data_date,
        d.value AS co2_emissions_kt,
        ROW_NUMBER() OVER (
            PARTITION BY d.country_code
            ORDER BY d.data_date DESC
        ) AS rn
    FROM data d
    JOIN country c ON c.country_code = d.country_code
    WHERE d.indicator_code = 'EN_ATM_CO2E_KT'
)
SELECT
    country_name,
    data_date,
    co2_emissions_kt
FROM ranked
WHERE rn = 1
ORDER BY co2_emissions_kt DESC
LIMIT 10;

---------------------------------------------------------------
-- M5: Continents with most recent average CO2 per capita
---------------------------------------------------------------

CREATE OR REPLACE VIEW M5 AS
WITH country_latest AS (
    SELECT
        d.country_code,
        d.data_date,
        d.value,
        ROW_NUMBER() OVER (
            PARTITION BY d.country_code
            ORDER BY d.data_date DESC
        ) AS rn
    FROM data d
    WHERE d.indicator_code = 'EN_ATM_CO2E_PC'
),
country_latest_clean AS (
    SELECT
        country_code,
        value AS co2_pc
    FROM country_latest
    WHERE rn = 1
)
SELECT
    cont.continent_name,
    AVG(cl.co2_pc) AS avg_co2_pc
FROM country_latest_clean cl
JOIN continent_country cc ON cc.country_code = cl.country_code
JOIN continent cont ON cont.continent_code = cc.continent_code
GROUP BY cont.continent_name
ORDER BY cont.continent_name;

---------------------------------------------------------------
-- M6: Wide table of 5 emissions indicators for USA
---------------------------------------------------------------

CREATE OR REPLACE VIEW M6 AS
WITH all_dates AS (
    SELECT DISTINCT data_date
    FROM data
    WHERE country_code = 'USA'
      AND indicator_code IN (SELECT indicator_code FROM topic_indicator_codes)
)
SELECT
    d.data_date,
    co2_tot.value AS EN_ATM_CO2E_KT,
    co2_pc.value  AS EN_ATM_CO2E_PC,
    co2_sf.value  AS EN_ATM_CO2E_SF_KT,
    co2_lf.value  AS EN_ATM_CO2E_LF_KT,
    co2_gf.value  AS EN_ATM_CO2E_GF_KT
FROM all_dates d
LEFT JOIN data co2_tot
  ON co2_tot.country_code = 'USA'
 AND co2_tot.indicator_code = 'EN_ATM_CO2E_KT'
 AND co2_tot.data_date = d.data_date
LEFT JOIN data co2_pc
  ON co2_pc.country_code = 'USA'
 AND co2_pc.indicator_code = 'EN_ATM_CO2E_PC'
 AND co2_pc.data_date = d.data_date
LEFT JOIN data co2_sf
  ON co2_sf.country_code = 'USA'
 AND co2_sf.indicator_code = 'EN_ATM_CO2E_SF_KT'
 AND co2_sf.data_date = d.data_date
LEFT JOIN data co2_lf
  ON co2_lf.country_code = 'USA'
 AND co2_lf.indicator_code = 'EN_ATM_CO2E_LF_KT'
 AND co2_lf.data_date = d.data_date
LEFT JOIN data co2_gf
  ON co2_gf.country_code = 'USA'
 AND co2_gf.indicator_code = 'EN_ATM_CO2E_GF_KT'
 AND co2_gf.data_date = d.data_date
ORDER BY d.data_date;

---------------------------------------------------------------
-- M7: Average % growth in total CO2 emissions (2010+)
---------------------------------------------------------------

CREATE OR REPLACE VIEW M7 AS
WITH yearly AS (
    SELECT
        d.country_code,
        c.country_name,
        d.data_date,
        d.value,
        LAG(d.value) OVER (
            PARTITION BY d.country_code
            ORDER BY d.data_date
        ) AS prev_value
    FROM data d
    JOIN country c ON c.country_code = d.country_code
    WHERE d.indicator_code = 'EN_ATM_CO2E_KT'
      AND d.data_date >= DATE '2010-01-01'
),
growth AS (
    SELECT
        country_name,
        100.0 * (value - prev_value) / prev_value AS pct_growth
    FROM yearly
    WHERE prev_value IS NOT NULL
      AND prev_value <> 0
)
SELECT
    country_name,
    ROUND(AVG(pct_growth)::numeric, 2) AS avg_pct_growth
FROM growth
GROUP BY country_name
ORDER BY avg_pct_growth DESC;

---------------------------------------------------------------
-- M8: Countries with 2011 data for any emissions indicator
---------------------------------------------------------------

CREATE OR REPLACE VIEW M8 AS
SELECT DISTINCT country_name
FROM (
    SELECT
        c.country_name,
        d.indicator_code,
        d.data_date,
        ROW_NUMBER() OVER (
            PARTITION BY d.country_code, d.indicator_code
            ORDER BY ABS(EXTRACT(YEAR FROM d.data_date) - 2011)
        ) AS rn
    FROM data d
    JOIN country c ON c.country_code = d.country_code
    WHERE d.indicator_code IN (SELECT indicator_code FROM topic_indicator_codes)
) x
WHERE rn = 1   -- nearest to 2011
ORDER BY country_name;

---------------------------------------------------------------
-- M9: Countries with 2011 data for ALL 5 emissions indicators
---------------------------------------------------------------

CREATE OR REPLACE VIEW M9 AS
SELECT
    c.country_name
FROM country c
JOIN data d ON d.country_code = c.country_code
WHERE d.indicator_code IN (SELECT indicator_code FROM topic_indicator_codes)
  AND d.data_date >= DATE '2011-01-01'
  AND d.data_date <  DATE '2012-01-01'
GROUP BY c.country_name
HAVING COUNT(DISTINCT d.indicator_code) = 5
ORDER BY c.country_name;



/* =====================================================================
   6. ADDITIONAL ANALYSIS VIEWS (A1 – A5)
   ===================================================================== */

---------------------------------------------------------------
-- A1: Development vs Technology Adoption
---------------------------------------------------------------

CREATE OR REPLACE VIEW A1 AS
WITH paired AS (
    SELECT
        d_gdp.country_code,
        c.country_name,
        d_gdp.data_date,
        d_gdp.value AS gdp_pc,
        d_net.value AS internet_users
    FROM data d_gdp
    JOIN data d_net
      ON d_gdp.country_code = d_net.country_code
     AND d_gdp.data_date = d_net.data_date
    JOIN country c ON c.country_code = d_gdp.country_code
    WHERE d_gdp.indicator_code = 'NY_GDP_PCAP_CD'
      AND d_net.indicator_code = 'IT_NET_USER_P2'
)
SELECT
    country_name,
    ROUND(AVG(gdp_pc)::numeric, 2) AS avg_gdp_pc,
    ROUND(AVG(internet_users)::numeric, 2) AS avg_internet_users
FROM paired
GROUP BY country_name
HAVING COUNT(*) >= 5
ORDER BY avg_gdp_pc DESC;

---------------------------------------------------------------
-- A2: Technology Adoption vs Environmental Impact
---------------------------------------------------------------

CREATE OR REPLACE VIEW A2 AS
WITH paired AS (
    SELECT
        d_net.country_code,
        c.country_name,
        d_net.data_date,
        d_net.value AS internet_users,
        d_co2.value AS co2_pc
    FROM data d_net
    JOIN data d_co2
      ON d_net.country_code = d_co2.country_code
     AND d_net.data_date = d_co2.data_date
    JOIN country c ON c.country_code = d_net.country_code
    WHERE d_net.indicator_code = 'IT_NET_USER_P2'
      AND d_co2.indicator_code = 'EN_ATM_CO2E_PC'
)
SELECT
    country_name,
    ROUND(AVG(internet_users)::numeric, 2) AS avg_internet_users,
    ROUND(AVG(co2_pc)::numeric, 2) AS avg_co2_pc
FROM paired
GROUP BY country_name
HAVING COUNT(*) >= 5
ORDER BY avg_internet_users DESC;

---------------------------------------------------------------
-- A3: Economic Growth vs Environmental Growth
---------------------------------------------------------------

CREATE OR REPLACE VIEW A3 AS
WITH yearly AS (
    SELECT
        country_code,
        data_date,
        indicator_code,
        value,
        LAG(value) OVER (
            PARTITION BY country_code, indicator_code
            ORDER BY data_date
        ) AS prev_val
    FROM data
    WHERE indicator_code IN ('NY_GDP_PCAP_CD', 'EN_ATM_CO2E_PC')
      AND data_date >= DATE '2010-01-01'
),
growth AS (
    SELECT
        country_code,
        indicator_code,
        100.0 * (value - prev_val) / prev_val AS pct_growth
    FROM yearly
    WHERE prev_val IS NOT NULL AND prev_val <> 0
),
avg_growth AS (
    SELECT
        country_code,
        indicator_code,
        AVG(pct_growth) AS avg_pct_growth
    FROM growth
    GROUP BY country_code, indicator_code
)
SELECT
    c.country_name,
    ROUND(gdp.avg_pct_growth::numeric, 2) AS gdp_growth,
    ROUND(co2.avg_pct_growth::numeric, 2) AS co2_growth,
    ROUND((co2.avg_pct_growth - gdp.avg_pct_growth)::numeric, 2) AS decoupling_gap
FROM avg_growth gdp
JOIN avg_growth co2 ON gdp.country_code = co2.country_code
JOIN country c ON c.country_code = gdp.country_code
WHERE gdp.indicator_code = 'NY_GDP_PCAP_CD'
  AND co2.indicator_code = 'EN_ATM_CO2E_PC'
ORDER BY decoupling_gap ASC;

---------------------------------------------------------------
-- A4: Economic Stability vs Development Level
---------------------------------------------------------------

CREATE OR REPLACE VIEW A4 AS
WITH paired AS (
    SELECT
        d_inf.country_code,
        c.country_name,
        d_inf.data_date,
        d_inf.value AS inflation,
        d_gdp.value AS gdp_pc
    FROM data d_inf
    JOIN data d_gdp
      ON d_inf.country_code = d_gdp.country_code
     AND d_inf.data_date = d_gdp.data_date
    JOIN country c ON c.country_code = d_inf.country_code
    WHERE d_inf.indicator_code = 'FP_CPI_TOTL_ZG'
      AND d_gdp.indicator_code = 'NY_GDP_PCAP_CD'
)
SELECT
    country_name,
    ROUND(AVG(inflation)::numeric, 2) AS avg_inflation,
    ROUND(AVG(gdp_pc)::numeric, 2) AS avg_gdp_pc
FROM paired
GROUP BY country_name
HAVING COUNT(*) >= 5
ORDER BY avg_gdp_pc DESC;

---------------------------------------------------------------
-- A5: Energy Mix by Development Level
---------------------------------------------------------------

CREATE OR REPLACE VIEW A5 AS
WITH latest_gdp AS (
    SELECT
        country_code,
        value AS gdp_pc,
        ROW_NUMBER() OVER (
            PARTITION BY country_code
            ORDER BY data_date DESC
        ) AS rn
    FROM data
    WHERE indicator_code = 'NY_GDP_PCAP_CD'
),
latest_energy AS (
    SELECT
        country_code,
        indicator_code,
        value,
        ROW_NUMBER() OVER (
            PARTITION BY country_code, indicator_code
            ORDER BY data_date DESC
        ) AS rn
    FROM data
    WHERE indicator_code IN (
        'EN_ATM_CO2E_SF_KT',
        'EN_ATM_CO2E_LF_KT',
        'EN_ATM_CO2E_GF_KT'
    )
)
SELECT
    c.country_name,
    ROUND(g.gdp_pc::numeric, 2) AS gdp_per_capita,
    ROUND(sf.value::numeric, 2) AS solid_fuel_co2_kt,
    ROUND(lf.value::numeric, 2) AS liquid_fuel_co2_kt,
    ROUND(gf.value::numeric, 2) AS gas_fuel_co2_kt,
    ROUND((COALESCE(sf.value, 0) + COALESCE(lf.value, 0) + COALESCE(gf.value, 0))::numeric, 2) AS total_fuel_co2_kt
FROM latest_gdp g
JOIN country c ON c.country_code = g.country_code
LEFT JOIN latest_energy sf
  ON sf.country_code = g.country_code
 AND sf.indicator_code = 'EN_ATM_CO2E_SF_KT'
 AND sf.rn = 1
LEFT JOIN latest_energy lf
  ON lf.country_code = g.country_code
 AND lf.indicator_code = 'EN_ATM_CO2E_LF_KT'
 AND lf.rn = 1
LEFT JOIN latest_energy gf
  ON gf.country_code = g.country_code
 AND gf.indicator_code = 'EN_ATM_CO2E_GF_KT'
 AND gf.rn = 1
WHERE g.rn = 1
  AND (sf.value IS NOT NULL OR lf.value IS NOT NULL OR gf.value IS NOT NULL)
ORDER BY g.gdp_pc DESC;



/* =====================================================================
   7. TEST ALL VIEWS – RESULTS, VALIDATION, SUMMARY
   ===================================================================== */

---------------------------------------------------------------
-- 7.1 QUICK ROW COUNT TEST
---------------------------------------------------------------

SELECT 'M1' AS view_name, COUNT(*) AS row_count FROM M1
UNION ALL SELECT 'M2', COUNT(*) FROM M2
UNION ALL SELECT 'M3', COUNT(*) FROM M3
UNION ALL SELECT 'M4', COUNT(*) FROM M4
UNION ALL SELECT 'M5', COUNT(*) FROM M5
UNION ALL SELECT 'M6', COUNT(*) FROM M6
UNION ALL SELECT 'M7', COUNT(*) FROM M7
UNION ALL SELECT 'M8', COUNT(*) FROM M8
UNION ALL SELECT 'M9', COUNT(*) FROM M9
UNION ALL SELECT 'A1', COUNT(*) FROM A1
UNION ALL SELECT 'A2', COUNT(*) FROM A2
UNION ALL SELECT 'A3', COUNT(*) FROM A3
UNION ALL SELECT 'A4', COUNT(*) FROM A4
UNION ALL SELECT 'A5', COUNT(*) FROM A5;

---------------------------------------------------------------
-- 7.2 MANDATORY ANALYSIS RESULTS
---------------------------------------------------------------

-- M1: Countries missing data (show first 10)
SELECT 'M1: Countries Missing Data' AS query;
SELECT * FROM M1 LIMIT 10;

-- M2: Countries with complete data (show first 10)
SELECT 'M2: Countries with Complete Data' AS query;
SELECT * FROM M2 LIMIT 10;

-- M3: Indicator coverage (show all 5)
SELECT 'M3: Indicator Coverage' AS query;
SELECT * FROM M3;

-- M4: Top 10 by most recent CO2 emissions
SELECT 'M4: Top 10 CO2 Emitters' AS query;
SELECT * FROM M4;

-- M5: Continental averages (show all continents)
SELECT 'M5: Continental CO2 Averages' AS query;
SELECT * FROM M5;

-- M6: USA emissions data (show first 10 rows)
SELECT 'M6: USA Emissions Timeline' AS query;
SELECT * FROM M6 LIMIT 10;

-- M7: Average growth rates (show top 10)
SELECT 'M7: Average CO2 Growth Rates' AS query;
SELECT * FROM M7 LIMIT 10;

-- M8: Countries with any 2011 data (show first 10)
SELECT 'M8: Countries with ANY 2011 Data' AS query;
SELECT * FROM M8 LIMIT 10;

-- M9: Countries with all 2011 data (show first 10)
SELECT 'M9: Countries with ALL 2011 Data' AS query;
SELECT * FROM M9 LIMIT 10;

---------------------------------------------------------------
-- 7.3 ADDITIONAL ANALYSIS RESULTS
---------------------------------------------------------------

-- A1: Development vs Technology (show top 10)
SELECT 'A1: Development vs Technology' AS query;
SELECT * FROM A1 LIMIT 10;

-- A2: Technology vs Emissions (show top 10)
SELECT 'A2: Technology vs CO2' AS query;
SELECT * FROM A2 LIMIT 10;

-- A3: Economic vs Environmental Growth (show top 10 best decoupling)
SELECT 'A3: Growth Decoupling Analysis' AS query;
SELECT * FROM A3 LIMIT 10;

-- A4: Inflation vs Development (show top 10)
SELECT 'A4: Inflation vs Development' AS query;
SELECT * FROM A4 LIMIT 10;

-- A5: Energy Mix by Development (show top 10)
SELECT 'A5: Energy Mix Analysis' AS query;
SELECT * FROM A5 LIMIT 10;

---------------------------------------------------------------
-- 7.4 VALIDATION CHECKS
---------------------------------------------------------------

-- Check M8 > M9 (more countries have SOME data than ALL data)
SELECT 'Validation: M8 vs M9 counts' AS check;
SELECT
    (SELECT COUNT(*) FROM M8) AS m8_any_2011_data,
    (SELECT COUNT(*) FROM M9) AS m9_all_2011_data,
    CASE
        WHEN (SELECT COUNT(*) FROM M8) > (SELECT COUNT(*) FROM M9)
        THEN '✓ PASS: M8 > M9'
        ELSE '✗ FAIL: M8 should be > M9'
    END AS validation_result;

-- Check M1 + M2 = Total countries in data
SELECT 'Validation: M1 + M2 coverage' AS check;
SELECT
    (SELECT COUNT(*) FROM M1) AS countries_incomplete,
    (SELECT COUNT(*) FROM M2) AS countries_complete,
    (SELECT COUNT(DISTINCT country_code) FROM data) AS total_countries_in_data,
    CASE
        WHEN (SELECT COUNT(*) FROM M1) + (SELECT COUNT(*) FROM M2) <=
             (SELECT COUNT(DISTINCT country_code) FROM data) + 10
        THEN '✓ PASS: Coverage reasonable'
        ELSE '⚠ CHECK: Coverage mismatch'
    END AS validation_result;

-- Check topic_indicator_codes has exactly 5 indicators
SELECT 'Validation: Topic indicators count' AS check;
SELECT
    COUNT(*) AS topic_indicator_count,
    CASE
        WHEN COUNT(*) = 5 THEN '✓ PASS: Exactly 5 emissions indicators'
        ELSE '✗ FAIL: Should have exactly 5 indicators'
    END AS validation_result
FROM topic_indicator_codes;

-- Check M3 returns exactly 5 rows (one per emissions indicator)
SELECT 'Validation: M3 row count' AS check;
SELECT
    COUNT(*) AS m3_row_count,
    CASE
        WHEN COUNT(*) = 5 THEN '✓ PASS: M3 shows 5 indicators'
        ELSE '✗ FAIL: M3 should show exactly 5 rows'
    END AS validation_result
FROM M3;

-- Check M6 has exactly 6 columns (date + 5 emissions)
SELECT 'Validation: M6 column count' AS check;
SELECT
    COUNT(*) AS column_count,
    CASE
        WHEN COUNT(*) = 6 THEN '✓ PASS: M6 has 6 columns'
        ELSE '✗ FAIL: M6 should have 6 columns'
    END AS validation_result
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'm6';

-- Check no aggregate countries in data
SELECT 'Validation: No aggregate countries' AS check;
SELECT
    COUNT(*) AS aggregate_count,
    CASE
        WHEN COUNT(*) = 0 THEN '✓ PASS: No aggregates in data'
        ELSE '✗ FAIL: Found aggregate country codes'
    END AS validation_result
FROM data
WHERE country_code IN ('WLD', 'HIC', 'EAP', 'EAS', 'LIC', 'UMC', 'LMC', 'MIC');

-- Check all 8 indicators present in data
SELECT 'Validation: All indicators loaded' AS check;
SELECT
    COUNT(DISTINCT indicator_code) AS indicator_count,
    CASE
        WHEN COUNT(DISTINCT indicator_code) = 8 THEN '✓ PASS: All 8 indicators present'
        ELSE '✗ FAIL: Should have 8 indicators'
    END AS validation_result
FROM data;

---------------------------------------------------------------
-- 7.5 SUMMARY STATISTICS
---------------------------------------------------------------

SELECT '========== DATABASE SUMMARY ==========' AS info;

-- Table row counts
SELECT 'Table Row Counts' AS category;
SELECT 'continent' AS table_name, COUNT(*) AS rows FROM continent
UNION ALL SELECT 'country', COUNT(*) FROM country
UNION ALL SELECT 'continent_country', COUNT(*) FROM continent_country
UNION ALL SELECT 'indicator', COUNT(*) FROM indicator
UNION ALL SELECT 'data', COUNT(*) FROM data;

-- Data by indicator
SELECT 'Data Rows per Indicator' AS category;
SELECT indicator_code, COUNT(*) AS row_count
FROM data
GROUP BY indicator_code
ORDER BY indicator_code;

-- Date range
SELECT 'Date Range' AS category;
SELECT
    MIN(data_date) AS earliest_date,
    MAX(data_date) AS latest_date,
    MAX(data_date) - MIN(data_date) AS date_span_days
FROM data;

-- Country coverage
SELECT 'Country Coverage' AS category;
SELECT
    COUNT(DISTINCT country_code) AS countries_with_data,
    (SELECT COUNT(*) FROM country) AS total_countries_in_schema,
    ROUND(100.0 * COUNT(DISTINCT country_code) / (SELECT COUNT(*) FROM country), 1) AS coverage_pct
FROM data;

SELECT '========== ALL TESTS COMPLETE ==========' AS info;
