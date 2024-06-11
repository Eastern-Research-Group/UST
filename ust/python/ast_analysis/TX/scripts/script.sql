/*facility tables*/
create table tx_analysis_facility 
(
facility_id VARCHAR(4000),
facilityName VARCHAR(4000), 
streetAddress VARCHAR(4000),
city VARCHAR(4000),
state VARCHAR(4000),
zip VARCHAR(4000),
mailing_street VARCHAR(4000),
mailing_city VARCHAR(4000),
mailing_state VARCHAR(4000),
mailing_zip VARCHAR(4000),
mailing_country VARCHAR(4000),
county VARCHAR(4000),
fireDistrict VARCHAR(4000),
latitude VARCHAR(4000),
longitude VARCHAR(4000),
department VARCHAR(4000),
failedTier2SubmitValidation VARCHAR(4000),
notes VARCHAR(4000),
sitePlanAttached VARCHAR(4000),
siteCoordAbbrevAttached VARCHAR(4000),
dikeDescriptionAttached VARCHAR(4000),
facilityInfoSameAsLastYear VARCHAR(4000),
nameAndTitleOfCertifier VARCHAR(4000),
dateSigned VARCHAR(4000),
feesTotal VARCHAR(4000),
manned VARCHAR(4000),
maxNumOccupants VARCHAR(4000),
subjectToChemAccidentPrevention VARCHAR(4000),
subjectToEmergencyPlanning VARCHAR(4000),
lastModified VARCHAR(4000)
);


create table tx_analysis_fac_contact
(facility_id  VARCHAR(4000),
linkId VARCHAR(4000),
contactid VARCHAR(4000)
);

create table tx_analysis_chemical
(facility_id  VARCHAR(4000),
chemical_id  VARCHAR(4000),
chemical_name VARCHAR(4000),
casNumber VARCHAR(4000),
ehs VARCHAR(4000),
pure VARCHAR(4000),
mixture VARCHAR(4000),
solid VARCHAR(4000),
liquid VARCHAR(4000),
gas VARCHAR(4000),
aveAmount VARCHAR(4000),
aveAmountCode VARCHAR(4000),
maxAmount VARCHAR(4000),
maxAmountCode VARCHAR(4000),
sameAsLastYear VARCHAR(4000),
daysOnSite VARCHAR(4000),
maxAmtLargestContainer  VARCHAR(4000),
belowReportingThresholds VARCHAR(4000),
confidentialStorageLocs VARCHAR(4000),
tradeSecret VARCHAR(4000));

create table tx_analysis_chemical_hazard
(facility_id  VARCHAR(4000),
chemical_id  VARCHAR(4000),
category VARCHAR(4000),
category_value VARCHAR(4000)
);

create table tx_analysis_chemical_storage
(facility_id  VARCHAR(4000),
chemical_id  VARCHAR(4000),
storageLocation_id  VARCHAR(4000),
locationDescription VARCHAR(4000),
storageType VARCHAR(4000),
pressure VARCHAR(4000),
temperature VARCHAR(4000),
amount_unit VARCHAR(4000),
amount VARCHAR(4000)
);

create table tx_analysis_alternative_ids
(facility_id  VARCHAR(4000),
alt_id_value VARCHAR(4000),
alt_id_type VARCHAR(4000),
description VARCHAR(4000))
;



/*facility data*/


CREATE INDEX test_idx
ON tx_tier2_analysis_facility USING BTREE 
    (cast(xpath('/facility', xml_content) as text[])) ;

insert into tx_analysis_facility
SELECT  xpath('/facility/@recordid', subgroup)::text[],
unnest(xpath('/facility/facilityName/text()', subgroup)::text[]),
unnest(xpath('/facility/streetAddress/street/text()', subgroup)::text[]),
unnest(xpath('/facility/streetAddress/city/text()', subgroup)::text[]),
unnest(xpath('/facility/streetAddress/state/text()', subgroup)::text[]),
unnest(xpath('/facility/streetAddress/zipcode/text()', subgroup)::text[]),
unnest(xpath('/facility/mailingAddress/street/text()', subgroup)::text[]),
unnest(xpath('/facility/mailingAddress/city/text()', subgroup)::text[]),
unnest(xpath('/facility/mailingAddress/state/text()', subgroup)::text[]),
unnest(xpath('/facility/mailingAddress/zipcode/text()', subgroup)::text[]),
unnest(xpath('/facility/mailingAddress/country/text()', subgroup)::text[]),
unnest(xpath('/facility/county/text()', subgroup)::text[]),
unnest(xpath('/facility/fireDistrict/text()', subgroup)::text[]),
unnest(xpath('/facility/latLong/latitude/text()', subgroup)::text[]),
unnest(xpath('/facility/latLong/longitude/text()', subgroup)::text[]),
unnest(xpath('/facility/department/text()', subgroup)::text[]),
unnest(xpath('/facility/failedTier2SubmitValidation/text()', subgroup)::text[]),
unnest(xpath('/facility/notes/text()', subgroup)::text[]),
unnest(xpath('/facility/sitePlanAttached/text()', subgroup)::text[]),
unnest(xpath('/facility/siteCoordAbbrevAttached/text()', subgroup)::text[]),
unnest(xpath('/facility/dikeDescriptionAttached/text()', subgroup)::text[]),
unnest(xpath('/facility/facilityInfoSameAsLastYear/text()', subgroup)::text[]),
unnest(xpath('/facility/nameAndTitleOfCertifier/text()', subgroup)::text[]),
unnest(xpath('/facility/dateSigned/text()', subgroup)::text[]),
unnest(xpath('/facility/feesTotal/text()', subgroup)::text[]),
unnest(xpath('/facility/manned/text()', subgroup)::text[]),
unnest(xpath('/facility/maxNumOccupants/text()', subgroup)::text[]),
unnest(xpath('/facility/subjectToChemAccidentPrevention/text()', subgroup)::text[]),
unnest(xpath('/facility/subjectToEmergencyPlanning/text()', subgroup)::text[]),
unnest(xpath('/facility/lastModified/text()', subgroup)::text[])
FROM (
    SELECT
        unnest(xpath('./facilities/facility', oc.xml_content)) AS subgroup
    FROM
        tx_tier2_analysis_facility AS oc
        where rec_no=2 /*cycle through files 1-4 to get all data*/
) AS subgroups;


update tx_analysis_facility
set facilityName  = upper(trim(REPLACE(REPLACE (facilityName, '<![CDATA[', ''),']]>', ''))),
streetAddress  = upper(trim(REPLACE(REPLACE (streetAddress, '<![CDATA[', ''),']]>', ''))),
fireDistrict  = upper(trim(REPLACE(REPLACE (fireDistrict, '<![CDATA[', ''),']]>', ''))),
department  = upper(trim(REPLACE(REPLACE (department, '<![CDATA[', ''),']]>', ''))),
nameAndTitleOfCertifier  = upper(trim(REPLACE(REPLACE (nameAndTitleOfCertifier, '<![CDATA[', ''),']]>', '')));

select count(*) from tx_analysis_facility;

select * from tx_analysis_facility;

insert into tx_analysis_fac_contact
SELECT  xpath('/facility/@recordid', subgroup)::text[],
unnest(xpath('/facility/contactIds/contactId/text()', subgroup)::text[])
FROM (
    SELECT
        unnest(xpath('./facilities/facility', oc.xml_content)) AS subgroup
    FROM
        tx_tier2_analysis_facility AS oc
) AS subgroups;

insert into tx_analysis_chemical
SELECT  xpath('/facility/@recordid', subgroup)::text[],
unnest(xpath('/facility/chemicals/chemical/@recordid', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/chemName/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/casNumber/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/ehs/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/pure/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/mixture/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/solid/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/liquid/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/gas/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/aveAmount/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/aveAmountCode/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/maxAmount/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/maxAmountCode/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/sameAsLastYear/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/daysOnSite/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/maxAmtLargestContainer/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/belowReportingThresholds/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/confidentialStorageLocs/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/tradeSecret/text()', subgroup)::text[])
FROM (
    SELECT
        unnest(xpath('./facilities/facility', oc.xml_content)) AS subgroup
    FROM
        tx_tier2_analysis_facility AS oc
           where rec_no=1
) AS subgroups;


insert into tx_analysis_chemical_hazard
SELECT  xpath('/facility/@recordid', subgroup)::text[],
unnest(xpath('/facility/chemicals/chemical/@recordid', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/hazards/hazard/category/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/hazards/hazard/value/text()', subgroup)::text[])
FROM (
    SELECT
        unnest(xpath('./facilities/facility', oc.xml_content)) AS subgroup
    FROM
        tx_tier2_analysis_facility AS oc
) AS subgroups;

insert into tx_analysis_chemical_storage
SELECT  xpath('/facility/@recordid', subgroup)::text[],
unnest(xpath('/facility/chemicals/chemical/@recordid', subgroup)::text[]),
unnest(xpath('/facility/chemicals/storageLocations/storageLocation/@recordid', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/storageLocations/storageLocation/locationDescription/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/storageLocations/storageLocation/storageType/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/storageLocations/storageLocation/pressure/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/storageLocations/storageLocation/temperature/text()', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/storageLocations/storageLocation/amount/@unit', subgroup)::text[]),
unnest(xpath('/facility/chemicals/chemical/storageLocations/storageLocation/amount/text()', subgroup)::text[])
FROM (
    SELECT
        unnest(xpath('./facilities/facility', oc.xml_content)) AS subgroup
    FROM
        tx_tier2_analysis_facility AS oc
) AS subgroups;

insert into tx_analysis_alternative_ids
SELECT  xpath('/facility/@recordid', subgroup)::text[],
unnest(xpath('/facility/facilityIds/facilityId/id/text()', subgroup)::text[]),
unnest(xpath('/facility/facilityIds/facilityId/@type', subgroup)::text[]),
unnest(xpath('/facility/facilityIds/facilityId/description/text()', subgroup)::text[])
FROM (
    SELECT
        unnest(xpath('./facilities/facility', oc.xml_content)) AS subgroup
    FROM
        tx_tier2_analysis_facility AS oc
) AS subgroups;




/* contact tables */
create table tx_analysis_contact
(
contact_id  VARCHAR(4000),
firstname VARCHAR(4000),
lastname VARCHAR(4000),
title VARCHAR(4000),
email VARCHAR(4000),
mailing_street VARCHAR(4000),
mailing_city VARCHAR(4000),
mailing_state VARCHAR(4000),
mailing_zip VARCHAR(4000),
mailing_country VARCHAR(4000),
parentCompanyDunAndBradstreet VARCHAR(4000),
lastModified VARCHAR(4000)
);


create table tx_analysis_contact_type
(
contact_id  VARCHAR(4000),
contactType  VARCHAR(4000)
);


create table tx_analysis_contact_phone
(
contact_id  VARCHAR(4000),
phoneNumber  VARCHAR(4000),
phoneType VARCHAR(4000)
);



/* load contact data */
delete from tx_tier2_analysis_contact;
delete from tx_analysis_contact_phone;
delete from tx_analysis_contact_type;
delete from tx_analysis_contact;


insert into tx_analysis_contact_phone
SELECT  xpath('/contact/@recordid', subgroup)::text[],
unnest(xpath('/contact/phones/phone/phoneNumber/text()', subgroup)::text[]) AS phoneNumber,
unnest(xpath('/contact/phones/phone/phoneType/text()', subgroup)::text[]) AS phoneType
FROM (
    SELECT
        unnest(xpath('./contacts/contact', oc.xml_content)) AS subgroup
    FROM
        tx_tier2_analysis_contact AS oc
) AS subgroups;

insert into tx_analysis_contact_type
SELECT  xpath('/contact/@recordid', subgroup)::text[],
unnest(xpath('/contact/contactTypes/contactType/text()', subgroup)::text[]) 
FROM (
    SELECT
        unnest(xpath('./contacts/contact', oc.xml_content)) AS subgroup
    FROM
        tx_tier2_analysis_contact AS oc
) AS subgroups;

insert into tx_analysis_contact
SELECT  xpath('/contact/@recordid', subgroup)::text[],
unnest(xpath('/contact/firstName/text()', subgroup)::text[]),
unnest(xpath('/contact/lastName/text()', subgroup)::text[]),
unnest(xpath('/contact/title/text()', subgroup)::text[]),
unnest(xpath('/contact/email/text()', subgroup)::text[]),
unnest(xpath('/contact/mailingAddress/street/text()', subgroup)::text[]),
unnest(xpath('/contact/mailingAddress/city/text()', subgroup)::text[]),
unnest(xpath('/contact/mailingAddress/state/text()', subgroup)::text[]),
unnest(xpath('/contact/mailingAddress/zipcode/text()', subgroup)::text[]),
unnest(xpath('/contact/mailingAddress/country/text()', subgroup)::text[]),
unnest(xpath('/contact/parentCompanyDunAndBradstreet/text()', subgroup)::text[]),
unnest(xpath('/contact/lastModified/text()', subgroup)::text[])
FROM (
    SELECT
        unnest(xpath('./contacts/contact', oc.xml_content)) AS subgroup
    FROM
        tx_tier2_analysis_contact AS oc
) AS subgroups;


update tx_analysis_contact
set firstname  = upper(trim(REPLACE(REPLACE (firstname, '<![CDATA[', ''),']]>', ''))),
lastname  = upper(trim(REPLACE(REPLACE (lastname, '<![CDATA[', ''),']]>', ''))),
title  = upper(trim(REPLACE(REPLACE (title, '<![CDATA[', ''),']]>', ''))),
email  = upper(trim(REPLACE(REPLACE (email, '<![CDATA[', ''),']]>', ''))),
mailing_street  = upper(trim(REPLACE(REPLACE (mailing_street, '<![CDATA[', ''),']]>', ''))),
mailing_city  = upper(trim(REPLACE(REPLACE (mailing_city, '<![CDATA[', ''),']]>', ''))),
mailing_state  = upper(trim(REPLACE(REPLACE (mailing_state, '<![CDATA[', ''),']]>', ''))),
mailing_zip  = upper(trim(REPLACE(REPLACE (mailing_zip, '<![CDATA[', ''),']]>', ''))),
mailing_country  = upper(trim(REPLACE(REPLACE (mailing_country, '<![CDATA[', ''),']]>', '')));

select * from tx_analysis_contact_phone where contact_id='{CTTR2022813311534051}';

select * from tx_analysis_contact_type where contact_id='{CTTR2022813311534051}';

select * from tx_analysis_contact where contact_id='{CTTR2022807311524051}';


select count(*) from tx_analysis_contact_phone ;

select count(*) from tx_analysis_contact_type ;

select count(*) from tx_analysis_contact ;