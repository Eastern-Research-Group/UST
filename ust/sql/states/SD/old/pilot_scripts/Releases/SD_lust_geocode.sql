update public.lust x
set gc_latitude = y.gc_latitude::float, 
	gc_longitude = y.gc_longitude::float, 
	gc_coordinate_source = y.gc_coordinate_source, 
	gc_address_type = y.gc_address_type
from "SD_LUST".sd_lust y  
where x."FacilityID" = y.facilityid and x."LUSTID" = y.lustid  ;


select gc_latitude from  "SD_LUST".sd_lust order by 1 desc;

update "SD_LUST".sd_lust

select count(*) from "SD_LUST".sd_lust
2277


select count(*) from "SD_LUST".sd_lust where gc_latitude is null;

select gc_latitude from "SD_LUST".sd_lust  where gc_latitude not like '%.%'

update "SD_LUST".sd_lust set gc_latitude = null where gc_latitude not like '%.%';



select gc_longitude from "SD_LUST".sd_lust  where gc_longitude not like '%.%'
update "SD_LUST".sd_lust set gc_longitude = null where gc_longitude not like '%.%';

select * from "TX_UST".v_ust_geocode;