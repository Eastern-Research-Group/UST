-- Resolve duplicate facility keys; singleton rows remain unchanged.
-- Text differences verified as whitespace only. Combine non-null fields.
-- Preserve coordinate pairs; prefer nonzero pairs with mapped source.
-- Reapply after generation if custom rules are overwritten.
begin;
set local lock_timeout = '5s';
create or replace view sd_ust.v_ust_facility as
with mapped as (
SELECT DISTINCT a."FacilityNumber"::character varying(50) AS facility_id,
    a."FacilityName"::character varying(100) AS facility_name,
    a."FacilityAddress1Text"::character varying(100) AS facility_address1,
    a."FacilityAddress2Text"::character varying(100) AS facility_address2,
    a."FacilityCity"::character varying(100) AS facility_city,
    a."FacilityCounty"::character varying(100) AS facility_county,
    a."FacilityZipCode"::character varying(10) AS facility_zip_code,
    'SD'::text AS facility_state,
    8 AS facility_epa_region,
    a."FacilityLatitudeValue"::double precision AS facility_latitude,
    a."FacilityLongitudeValue" AS facility_longitude,
    b.coordinate_source_id,
    a."OwnerName"::character varying(100) AS facility_owner_company_name
   FROM sd_ust.tanks a
     LEFT JOIN sd_ust.v_coordinate_source_xwalk b ON a."FacilityMethodDescription" = b.organization_value::text
  WHERE NOT (EXISTS ( SELECT 1
           FROM sd_ust.erg_unregulated_facilities unreg
          WHERE NULLIF(TRIM(BOTH FROM a."FacilityNumber"), ''::text) = unreg.facility_id::text)) AND COALESCE(b.exclude_from_query, 'N'::character varying)::text <> 'Y'::text
), duplicate_ids as (select facility_id from mapped group by facility_id having count(*)>1),
coordinates as (
 select distinct on (m.facility_id) m.facility_id,facility_latitude,facility_longitude,coordinate_source_id
 from mapped m join duplicate_ids d using(facility_id)
 order by m.facility_id,
 (facility_latitude is not null and facility_longitude is not null and (facility_latitude<>0 or facility_longitude<>0)) desc,
 (coordinate_source_id is not null) desc,
 facility_latitude nulls last,facility_longitude nulls last,coordinate_source_id nulls last
)
select m.* from mapped m where not exists(select 1 from duplicate_ids d where d.facility_id=m.facility_id)
union all
select m.facility_id,
min(nullif(trim(m.facility_name), ''))::character varying(100) as facility_name,
min(nullif(trim(m.facility_address1), ''))::character varying(100) as facility_address1,
min(nullif(trim(m.facility_address2), ''))::character varying(100) as facility_address2,
min(nullif(trim(m.facility_city), ''))::character varying(100) as facility_city,
min(nullif(trim(m.facility_county), ''))::character varying(100) as facility_county,
min(nullif(trim(m.facility_zip_code), ''))::character varying(10) as facility_zip_code,
min(nullif(trim(m.facility_state), ''))::text as facility_state,
max(m.facility_epa_region)::integer as facility_epa_region,
max(g.facility_latitude)::double precision as facility_latitude,
max(g.facility_longitude)::double precision as facility_longitude,
max(g.coordinate_source_id)::integer as coordinate_source_id,
min(nullif(trim(m.facility_owner_company_name), ''))::character varying(100) as facility_owner_company_name
from mapped m join coordinates g on g.facility_id=m.facility_id
group by m.facility_id;
commit;
