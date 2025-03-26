select distinct facility_id, tank_id 
 from 
 (select ts.facility_id, tank_id 
 from me_ust.v_ust_tank_substance ts join public.substances s on ts.substance_id = s.substance_id 
 join (select distinct facility_id from 
 (select facility_id, facility_type1 as facility_type_id from me_ust.v_ust_facility ) x 
 where facility_type_id <> 2) f on ts.facility_id = f.facility_id
 where s.substance like 'Heating%'
 union all 
 select x.facility_id, tank_id 
 from (select facility_id, tank_id, sum(compartment_capacity_gallons) as tank_capacity_gallons 
 from me_ust.v_ust_compartment group by facility_id, tank_id) x 
 join (select distinct facility_id from 
 (select facility_id, facility_type1 as facility_type_id from me_ust.v_ust_facility ) x 
 where facility_type_id in (1,12)) f on x.facility_id = f.facility_id 
 where tank_capacity_gallons <1100) a
 order by 1, 2;

select distinct epa_column_name, organization_table_name, organization_column_name, sort_order
from v_ust_element_mapping a join ust_elements_tables b on a.epa_table_name = b.table_name 
     join ust_elements c on b.element_id = c.element_id and a.epa_column_name = c.database_column_name 
where ust_control_id = 31 and epa_table_name = 'ust_' 
order by sort_order;

insert into public.ust_element_mapping (ust_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (31,'ust_piping','piping_id','erg_piping_id','piping_id',null,null);

select
	concat(v_ust_tank_substance.facility_id, '-', v_ust_tank_substance.tank_id ) as id,
    array_agg(DISTINCT "substance_id") as discrepancies
FROM
    me_ust.v_ust_tank_substance
GROUP BY
    id 
HAVING
    COUNT(DISTINCT "substance_id") > 1
order by id;

select * from me_ust.v_ust_tank_substance
where facility_id = '400'

select * from ust_element_mapping
where public.ust_element_mapping.ust_control_id = 31;


update ust_element_mapping
set organization_comments = 'Using the coordinates of the tank with the most recent status date would be fine. The date is changed whenever a tank goes from Active to out of service, etc. If the dates are all the same then the first pair in the list for a facility would also suffice.'
, programmer_comments = 'Coordinates were given to us at the tank level, rather than the facility level. See organization comments for state''s response on how to deal with it.'
, query_logic = 'WITH latest_tank_status AS (
         SELECT (tanks."REGISTRATION NUMBER")::text AS facility_id,
            tanks."TANK STATUS DATE",
            tanks."LATITUDE",
            tanks."LONGITUDE",
            row_number() OVER (PARTITION BY (tanks."REGISTRATION NUMBER")::text ORDER BY tanks."TANK STATUS DATE" DESC, tanks."LATITUDE" desc nulls last) AS row_num
           FROM me_ust.tanks
        )'
where ust_element_mapping_id in (2550, 2551);

select * from ust_element_value_mapping
where ust_element_mapping_id = 2568;

select id_column_name, database_lookup_table
from ust_element_lookup_tables order by 1;

select table_name, column_name
from information_schema.columns 
where table_schema = 'ia_ust' 
and lower(column_name) like lower('%tank%')
order by 1, 2;



update ust_element_value_mapping
set epa_value = 'Hazardous substance'
where ust_element_value_mapping_id = 2149;