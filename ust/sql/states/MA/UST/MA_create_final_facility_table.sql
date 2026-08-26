-- MA final facility table builder
--
-- Purpose:
-- - Build one row per facility_id.
-- - Prefer values from ma_ust."Facility info" when both sources have data.
-- - Backfill from ma_ust.vw_ust_facilities_combined when Facility info is null.
-- - Exclude one-to-many fields: fr_type_name, business_type_name, org_type_name.
-- - Flag where Facility info conflicts with combined view for easy downstream review.

begin;

drop table if exists ma_ust.erg_facility_final;

create table ma_ust.erg_facility_final as
with
facility_info_src as (
    select
        ctid,
        nullif(upper(regexp_replace(trim("Facility ID#"::text), '[^A-Z0-9]', '', 'g')), '') as facility_id,
        nullif(trim("FAC NAME"::text), '') as fac_name,
        nullif(trim("FAC ADD 1"::text), '') as fac_add_1,
        nullif(trim("FAC ADD 2"::text), '') as fac_add_2,
        nullif(trim("FAC CITY"::text), '') as fac_city,
        nullif(trim("FAC STATE"::text), '') as fac_state,
        case
            when nullif(regexp_replace("FAC ZIP"::text, '[^0-9]', '', 'g'), '') is null then null
            when length(regexp_replace("FAC ZIP"::text, '[^0-9]', '', 'g')) >= 9
                then substr(regexp_replace("FAC ZIP"::text, '[^0-9]', '', 'g'), 1, 5)
                    || '-' ||
                    substr(regexp_replace("FAC ZIP"::text, '[^0-9]', '', 'g'), 6, 4)
            else lpad(regexp_replace("FAC ZIP"::text, '[^0-9]', '', 'g'), 5, '0')
        end as fac_zip,
        nullif(trim("FAC PHONE"::text), '') as fac_phone,
        nullif(trim("FAC LONG"::text), '') as fac_long,
        nullif(trim("FAC LAT"::text), '') as fac_lat,
        nullif(trim("FAC TYPE"::text), '') as fac_type,
        nullif(trim("FAC CONTACT"::text), '') as fac_contact,
        nullif(trim("CON ADD 1"::text), '') as con_add_1,
        nullif(trim("CON ADD 2"::text), '') as con_add_2,
        nullif(trim("CON CITY"::text), '') as con_city,
        nullif(trim("CON STATE"::text), '') as con_state,
        case
            when nullif(regexp_replace("CON ZIP"::text, '[^0-9]', '', 'g'), '') is null then null
            when length(regexp_replace("CON ZIP"::text, '[^0-9]', '', 'g')) >= 9
                then substr(regexp_replace("CON ZIP"::text, '[^0-9]', '', 'g'), 1, 5)
                    || '-' ||
                    substr(regexp_replace("CON ZIP"::text, '[^0-9]', '', 'g'), 6, 4)
            else lpad(regexp_replace("CON ZIP"::text, '[^0-9]', '', 'g'), 5, '0')
        end as con_zip,
        nullif(trim("CON PHONE"::text), '') as con_phone,
        nullif(trim("CON EMAIL"::text), '') as con_email,
        nullif(trim("UPDATE"::text), '') as update_text,
        nullif(trim("UPDATE BY"::text), '') as update_by,
        nullif(trim("FAC STATUS"::text), '') as fac_status,
        (
            case when nullif(trim("FAC NAME"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("FAC ADD 1"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("FAC ADD 2"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("FAC CITY"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("FAC STATE"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("FAC ZIP"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("FAC PHONE"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("FAC LONG"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("FAC LAT"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("FAC TYPE"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("FAC CONTACT"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("CON ADD 1"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("CON ADD 2"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("CON CITY"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("CON STATE"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("CON ZIP"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("CON PHONE"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("CON EMAIL"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("UPDATE"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("UPDATE BY"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("FAC STATUS"::text), '') is not null then 1 else 0 end
        ) as non_null_score
    from ma_ust."Facility info"
    where nullif(upper(regexp_replace(trim("Facility ID#"::text), '[^A-Z0-9]', '', 'g')), '') is not null
),
facility_info_one as (
    select *
    from (
        select
            f.*,
            row_number() over (
                partition by f.facility_id
                order by f.non_null_score desc, f.ctid
            ) as rn
        from facility_info_src f
    ) ranked
    where rn = 1
),
combined_src as (
    select
        nullif(upper(regexp_replace(trim("UST Facility ID"::text), '[^A-Z0-9]', '', 'g')), '') as facility_id,
        nullif(trim("Facility Name"::text), '') as facility_name,
        nullif(trim("Facility Address Line 1"::text), '') as facility_address1,
        nullif(trim("Facility City"::text), '') as facility_city,
        case
            when nullif(regexp_replace("Facility Zip"::text, '[^0-9]', '', 'g'), '') is null then null
            when length(regexp_replace("Facility Zip"::text, '[^0-9]', '', 'g')) >= 9
                then substr(regexp_replace("Facility Zip"::text, '[^0-9]', '', 'g'), 1, 5)
                    || '-' ||
                    substr(regexp_replace("Facility Zip"::text, '[^0-9]', '', 'g'), 6, 4)
            else lpad(regexp_replace("Facility Zip"::text, '[^0-9]', '', 'g'), 5, '0')
        end as facility_zip,
        nullif(trim("Owner Name"::text), '') as owner_name,
        nullif(trim("Owner Contact Name"::text), '') as owner_contact_name,
        nullif(trim("Operator Name"::text), '') as operator_name,
        nullif(trim("Operator Contact Name"::text), '') as operator_contact_name,
        nullif(trim(facility_status::text), '') as facility_status,
        (
            case when nullif(trim("Facility Name"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("Facility Address Line 1"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("Facility City"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("Facility Zip"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("Owner Name"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("Owner Contact Name"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("Operator Name"::text), '') is not null then 1 else 0 end +
            case when nullif(trim("Operator Contact Name"::text), '') is not null then 1 else 0 end +
            case when nullif(trim(facility_status::text), '') is not null then 1 else 0 end
        ) as non_null_score
    from ma_ust.vw_ust_facilities_combined
    where nullif(upper(regexp_replace(trim("UST Facility ID"::text), '[^A-Z0-9]', '', 'g')), '') is not null
),
combined_one as (
    select *
    from (
        select
            c.*,
            row_number() over (
                partition by c.facility_id
                order by c.non_null_score desc,
                    case when upper(c.facility_status) = 'OPEN' then 0 else 1 end,
                    c.facility_name,
                    c.facility_address1,
                    c.facility_city,
                    c.facility_zip,
                    c.owner_name,
                    c.owner_contact_name,
                    c.operator_name,
                    c.operator_contact_name,
                    c.facility_status
            ) as rn
        from combined_src c
    ) ranked
    where rn = 1
),
all_ids as (
    select facility_id from facility_info_one
    union
    select facility_id from combined_one
),
resolved as (
    select
        ids.facility_id,
        -- Facility info is authoritative where both sources have values.
        coalesce(fi.fac_name, cv.facility_name) as "FAC NAME",
        coalesce(fi.fac_add_1, cv.facility_address1) as "FAC ADD 1",
        fi.fac_add_2 as "FAC ADD 2",
        coalesce(fi.fac_city, cv.facility_city) as "FAC CITY",
        fi.fac_state as "FAC STATE",
        coalesce(fi.fac_zip, cv.facility_zip) as "FAC ZIP",
        fi.fac_phone as "FAC PHONE",
        fi.fac_long as "FAC LONG",
        fi.fac_lat as "FAC LAT",
        fi.fac_type as "FAC TYPE",
        fi.fac_contact as "FAC CONTACT",
        fi.con_add_1 as "CON ADD 1",
        fi.con_add_2 as "CON ADD 2",
        fi.con_city as "CON CITY",
        fi.con_state as "CON STATE",
        fi.con_zip as "CON ZIP",
        fi.con_phone as "CON PHONE",
        fi.con_email as "CON EMAIL",
        fi.update_text as "UPDATE",
        fi.update_by as "UPDATE BY",
        coalesce(fi.fac_status, cv.facility_status) as "FAC STATUS",

        -- Source coverage flags.
        (fi.facility_id is not null) as in_facility_info,
        (cv.facility_id is not null) as in_combined_view,
        (fi.facility_id is null and cv.facility_id is not null) as combined_only_facility,

        -- Conflict diagnostics on overlapping fields.
        (fi.fac_name is not null and cv.facility_name is not null and fi.fac_name is distinct from cv.facility_name) as conflict_fac_name,
        (fi.fac_add_1 is not null and cv.facility_address1 is not null and fi.fac_add_1 is distinct from cv.facility_address1) as conflict_fac_add_1,
        (fi.fac_city is not null and cv.facility_city is not null and fi.fac_city is distinct from cv.facility_city) as conflict_fac_city,
        (fi.fac_zip is not null and cv.facility_zip is not null and fi.fac_zip is distinct from cv.facility_zip) as conflict_fac_zip,
        (fi.fac_status is not null and cv.facility_status is not null and fi.fac_status is distinct from cv.facility_status) as conflict_fac_status,

        array_remove(array[
            case when fi.fac_name is not null and cv.facility_name is not null and fi.fac_name is distinct from cv.facility_name then 'FAC NAME' end,
            case when fi.fac_add_1 is not null and cv.facility_address1 is not null and fi.fac_add_1 is distinct from cv.facility_address1 then 'FAC ADD 1' end,
            case when fi.fac_city is not null and cv.facility_city is not null and fi.fac_city is distinct from cv.facility_city then 'FAC CITY' end,
            case when fi.fac_zip is not null and cv.facility_zip is not null and fi.fac_zip is distinct from cv.facility_zip then 'FAC ZIP' end,
            case when fi.fac_status is not null and cv.facility_status is not null and fi.fac_status is distinct from cv.facility_status then 'FAC STATUS' end
        ], null) as conflict_fields
    from all_ids ids
    left join facility_info_one fi on fi.facility_id = ids.facility_id
    left join combined_one cv on cv.facility_id = ids.facility_id
)
select
    facility_id as "Facility ID#",
    "FAC NAME",
    "FAC ADD 1",
    "FAC ADD 2",
    "FAC CITY",
    "FAC STATE",
    "FAC ZIP",
    "FAC PHONE",
    "FAC LONG",
    "FAC LAT",
    "FAC TYPE",
    "FAC CONTACT",
    "CON ADD 1",
    "CON ADD 2",
    "CON CITY",
    "CON STATE",
    "CON ZIP",
    "CON PHONE",
    "CON EMAIL",
    "UPDATE",
    "UPDATE BY",
    "FAC STATUS",
    in_facility_info,
    in_combined_view,
    combined_only_facility,
    conflict_fac_name,
    conflict_fac_add_1,
    conflict_fac_city,
    conflict_fac_zip,
    conflict_fac_status,
    (cardinality(conflict_fields) > 0) as has_conflict_with_combined_view,
    conflict_fields
from resolved;

create unique index if not exists ux_erg_facility_final_facility_id
    on ma_ust.erg_facility_final ("Facility ID#");

create index if not exists ix_erg_facility_final_has_conflict
    on ma_ust.erg_facility_final (has_conflict_with_combined_view);

-- Quick QA checks.
select count(*) as total_rows, count(distinct "Facility ID#") as distinct_facility_ids
from ma_ust.erg_facility_final;

select has_conflict_with_combined_view, count(*) as row_count
from ma_ust.erg_facility_final
group by has_conflict_with_combined_view
order by has_conflict_with_combined_view desc;

select *
from ma_ust.erg_facility_final
where has_conflict_with_combined_view
order by "Facility ID#"
limit 100;

-- Choose one after reviewing QA outputs:
-- commit;
-- rollback;
