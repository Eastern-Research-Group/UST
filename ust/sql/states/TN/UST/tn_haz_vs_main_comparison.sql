-- Row-by-row comparison of the EPA Region 4 hazardous substance UST data (tn_ust.haz_tanks /
-- tn_ust.haz_compartments) against the TN state dataset (tn_ust.tn_facilities /
-- tn_ust.tn_compartments / tn_ust.facilities_gis).
--
-- Produces one row per haz tank/compartment record for client review. The suggested_id_xwalk CTE
-- holds ERG's proposed manual matches for haz Location IDs that do not resolve to a state
-- FACILITY_ID_UST; those require client confirmation.

with suggested_id_xwalk ("haz_id_stripped", "suggested_facility_id", "suggested_basis") as (
    values
        ('22630',     5950272, 'Name and address match Costco Gasoline (Loc. No. 1686), 100 A Legacy Pointe Blvd, Mt. Juliet 37122. Haz ID appears to be incorrect.'),
        ('5-830374',  5830374, 'Name and address match Costco Gasoline (Loc. No. 1659), 1105 Forest Retreat Rd, Hendersonville 37075. Haz ID appears to contain a stray hyphen.')
),

haz as (
    select
        t."Location ID"                                                                as haz_location_id,
        nullif(btrim(regexp_replace(t."Location ID", '^\s*TNHS[-\s]*', '')), '')       as haz_id_stripped,
        btrim(t."Facility Name")                                                       as haz_facility_name,
        btrim(t."Tank Name")                                                           as haz_tank_name,
        nullif(regexp_replace(btrim(t."Tank Name"), '^(Tank|UST)\s+', '', 'i'), '')    as haz_tank_number_derived,
        btrim(c."Compartment Name")                                                    as haz_compartment_name,
        btrim(t."Street Address")                                                      as haz_street_address,
        btrim(t."City")                                                                as haz_city,
        t."Zip"::text                                                                  as haz_zip,
        t."Latitude"                                                                   as haz_latitude,
        t."Longitude"                                                                  as haz_longitude,
        t."Tank Capacity"                                                              as haz_tank_capacity,
        c."Compartment Capacity"                                                       as haz_compartment_capacity,
        btrim(t."Substance Description")                                               as haz_substance,
        btrim(t."Tank Status Description")                                             as haz_tank_status,
        btrim(c."Compartment Status Description")                                      as haz_compartment_status,
        t."Federally Regulated Tank"                                                   as haz_federally_regulated,
        c."Overfill Installed"                                                         as haz_overfill_installed,
        c."Spill Installed"                                                            as haz_spill_installed,
        btrim(t."Date Installed")                                                      as haz_date_installed
    from tn_ust.haz_tanks t
    left join tn_ust.haz_compartments c
           on c."Location ID" = t."Location ID"
          and btrim(c."Tank Name") = btrim(t."Tank Name")
),

resolved as (
    select
        h.*,
        f_direct."FACILITY_ID_UST"                                                     as direct_facility_id,
        x."suggested_facility_id",
        x."suggested_basis",
        coalesce(f_direct."FACILITY_ID_UST", x."suggested_facility_id")                as main_facility_id
    from haz h
    left join tn_ust.tn_facilities f_direct
           on f_direct."FACILITY_ID_UST"::text = h.haz_id_stripped
    left join suggested_id_xwalk x
           on x."haz_id_stripped" = h.haz_id_stripped
          and f_direct."FACILITY_ID_UST" is null
),

main_compartments as (
    select
        c."Facility Id Ust"                                                            as facility_id,
        c."Tank Number"                                                                as tank_number,
        count(*)                                                                       as main_compartment_count,
        string_agg(distinct c."Tank Id"::text, '; ' order by c."Tank Id"::text)         as main_tank_ids,
        string_agg(c."Compartment Id"::text, '; ' order by c."Compartment Id"::text)    as main_compartment_ids,
        string_agg(distinct coalesce(c."Compartment Letter", ''), '; ')                 as main_compartment_letters,
        string_agg(distinct c."Compartment Capacity"::text, '; ')                       as main_compartment_capacity,
        sum(c."Compartment Capacity")                                                   as main_tank_capacity_total,
        string_agg(distinct c."Product", '; ')                                          as main_product,
        string_agg(distinct c."Status", '; ')                                           as main_status,
        string_agg(distinct c."Overfill Prevention", '; ')                              as main_overfill_prevention,
        string_agg(distinct c."Spill Prevention", '; ')                                 as main_spill_prevention,
        string_agg(distinct c."Date Tank Installed", '; ')                              as main_date_tank_installed
    from tn_ust.tn_compartments c
    group by c."Facility Id Ust", c."Tank Number"
)

select
    -- ---------- haz source record ----------
    r.haz_location_id,
    r.haz_id_stripped,
    r.haz_facility_name,
    r.haz_tank_name,
    r.haz_compartment_name,

    -- ---------- facility-level match ----------
    case
        when r.direct_facility_id is not null and r.haz_location_id = r.haz_id_stripped
            then 'Matched - haz Location ID already equals state FACILITY_ID_UST'
        when r.direct_facility_id is not null
            then 'Matched - after stripping TNHS prefix'
        when r."suggested_facility_id" is not null
            then 'Suggested match - CLIENT CONFIRMATION NEEDED (haz Location ID does not resolve)'
        else 'No match found - may be a facility absent from the state dataset'
    end                                                                                as facility_match_status,
    case
        when r.direct_facility_id is not null and r.haz_location_id = r.haz_id_stripped
            then 'haz."Location ID"::bigint = tn_facilities."FACILITY_ID_UST"'
        when r.direct_facility_id is not null
            then 'regexp_replace(haz."Location ID", ''^\s*TNHS[-\s]*'', '''')::bigint = tn_facilities."FACILITY_ID_UST"'
        when r."suggested_facility_id" is not null
            then 'Manual crosswalk on facility name + street address (haz ID is not a valid FACILITY_ID_UST)'
        else 'None available'
    end                                                                                as facility_match_method,
    r."suggested_basis"                                                                as suggested_match_basis,
    r.main_facility_id,

    -- ---------- facility attribute comparison ----------
    r.haz_facility_name                                                                as haz_facility_name_value,
    f."FACILITY_NAME"                                                                  as main_facility_name,
    case when f."FACILITY_ID_UST" is null then null
         when upper(btrim(coalesce(r.haz_facility_name, ''))) is distinct from upper(btrim(coalesce(f."FACILITY_NAME", ''))) then 'DIFFERS'
         else 'same' end                                                               as facility_name_comparison,

    r.haz_street_address,
    f."FACILITY_ADDRESS1"                                                              as main_street_address,
    case when f."FACILITY_ID_UST" is null then null
         when upper(btrim(coalesce(r.haz_street_address, ''))) is distinct from upper(btrim(coalesce(f."FACILITY_ADDRESS1", ''))) then 'DIFFERS'
         else 'same' end                                                               as street_address_comparison,

    r.haz_city,
    f."FACILITY_CITY"                                                                  as main_city,
    case when f."FACILITY_ID_UST" is null then null
         when upper(btrim(coalesce(r.haz_city, ''))) is distinct from upper(btrim(coalesce(f."FACILITY_CITY", ''))) then 'DIFFERS'
         else 'same' end                                                               as city_comparison,

    r.haz_zip,
    f."FACILITY_ZIP"                                                                   as main_zip,
    case when f."FACILITY_ID_UST" is null then null
         when btrim(coalesce(r.haz_zip, '')) is distinct from left(btrim(coalesce(f."FACILITY_ZIP", '')), 5) then 'DIFFERS'
         else 'same' end                                                               as zip_comparison,

    r.haz_latitude,
    g."LATITUDE"                                                                       as main_latitude,
    r.haz_longitude,
    g."LONGITUDE"                                                                      as main_longitude,
    case when g."FACILITY_ID" is null then null
         when round(r.haz_latitude::numeric, 4) is distinct from round(g."LATITUDE"::numeric, 4)
           or round(r.haz_longitude::numeric, 4) is distinct from round(g."LONGITUDE"::numeric, 4) then 'DIFFERS'
         else 'same' end                                                               as coordinate_comparison,
    case when g."FACILITY_ID" is null then null
         else round((abs(r.haz_latitude - g."LATITUDE") + abs(r.haz_longitude - g."LONGITUDE"))::numeric, 6) end
                                                                                       as coordinate_abs_difference,

    -- ---------- tank / compartment match ----------
    'Strip leading "Tank "/"UST " from haz."Tank Name" -> tn_compartments."Tank Number" (within the matched facility). haz."Compartment Name" is descriptive text, not a key; tn_compartments has surrogate keys "Tank Id" and "Compartment Id".'
                                                                                       as tank_match_method,
    r.haz_tank_number_derived,
    case
        when r.main_facility_id is null then 'No facility match - tank cannot be evaluated'
        when mc.tank_number is null then 'Facility matched but NO TANK with this number in the state dataset'
        when r.haz_tank_capacity is not distinct from mc.main_tank_capacity_total then 'Tank number matched and capacity agrees - likely the same physical tank'
        else 'Tank number matched but CAPACITY DISAGREES - may be a different physical tank sharing a tank number'
    end                                                                                as tank_match_status,
    mc.main_tank_ids,
    mc.tank_number                                                                     as main_tank_number,
    mc.main_compartment_ids,
    mc.main_compartment_letters,
    mc.main_compartment_count,

    -- ---------- tank / compartment attribute comparison ----------
    r.haz_tank_capacity,
    r.haz_compartment_capacity,
    mc.main_compartment_capacity,
    mc.main_tank_capacity_total,
    case when mc.tank_number is null then null
         when r.haz_tank_capacity is distinct from mc.main_tank_capacity_total then 'DIFFERS'
         else 'same' end                                                               as capacity_comparison,

    r.haz_substance,
    mc.main_product,
    case when mc.tank_number is null then null
         when upper(btrim(coalesce(r.haz_substance, ''))) is distinct from upper(btrim(coalesce(mc.main_product, ''))) then 'DIFFERS'
         else 'same' end                                                               as substance_comparison,

    r.haz_tank_status,
    r.haz_compartment_status,
    mc.main_status,
    case when mc.tank_number is null then null
         when upper(btrim(coalesce(r.haz_compartment_status, ''))) is distinct from upper(btrim(coalesce(mc.main_status, ''))) then 'DIFFERS'
         else 'same' end                                                               as status_comparison,

    r.haz_overfill_installed::text                                                     as haz_overfill_installed,
    mc.main_overfill_prevention,
    r.haz_spill_installed,
    mc.main_spill_prevention,
    r.haz_date_installed,
    mc.main_date_tank_installed,
    r.haz_federally_regulated::text                                                    as haz_federally_regulated,

    -- ---------- reviewer guidance ----------
    case
        when r.main_facility_id is null
            then 'No state facility identified. Confirm whether this is a facility the state does not track, or whether the haz Location ID is incorrect.'
        when r."suggested_facility_id" is not null
            then 'Confirm the proposed facility ID before merging. Haz Location ID is not a valid state FACILITY_ID_UST.'
        when mc.tank_number is null
            then 'Facility exists in the state data but this tank number does not. Confirm whether this is an additional tank to append or a tank-numbering difference.'
        when r.haz_tank_capacity is distinct from mc.main_tank_capacity_total
            then 'Tank numbers collide but capacities differ substantially. Confirm whether the haz record describes a separate hazardous-substance tank rather than the state tank with the same number.'
        else 'Tank number and capacity agree. Confirm which source is authoritative for any attribute flagged DIFFERS.'
    end                                                                                as review_note

from resolved r
left join tn_ust.tn_facilities f on f."FACILITY_ID_UST" = r.main_facility_id
left join tn_ust.facilities_gis g on g."FACILITY_ID" = r.main_facility_id
left join main_compartments mc
       on mc.facility_id = r.main_facility_id
      and mc.tank_number::text = r.haz_tank_number_derived
order by r.haz_facility_name, r.haz_tank_name;
