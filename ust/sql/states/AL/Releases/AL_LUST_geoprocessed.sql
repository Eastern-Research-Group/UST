select * from information_schema.tables where table_schema = 'AL_LUST';

select 'alter table ' || table_name || ' alter column "' || column_name || '" type text;'
from information_schema.columns where table_name = 'al_lust_to_geogprocess'
order by ordinal_position ;

alter table al_lust_to_geogprocess alter column "column1" type text;
alter table al_lust_to_geogprocess alter column "Unnamed: 0.1" type text;
alter table al_lust_to_geogprocess alter column "Unnamed: 0" type text;
alter table al_lust_to_geogprocess alter column "facilityid" type text;
alter table al_lust_to_geogprocess alter column "tankidassociatedwithrelease" type text;
alter table al_lust_to_geogprocess alter column "lustid" type text;
alter table al_lust_to_geogprocess alter column "federallyreportablerelease" type text;
alter table al_lust_to_geogprocess alter column "sitename" type text;
alter table al_lust_to_geogprocess alter column "siteaddress" type text;
alter table al_lust_to_geogprocess alter column "siteaddress2" type text;
alter table al_lust_to_geogprocess alter column "sitecity" type text;
alter table al_lust_to_geogprocess alter column "zipcode" type text;
alter table al_lust_to_geogprocess alter column "county" type text;
alter table al_lust_to_geogprocess alter column "state" type text;
alter table al_lust_to_geogprocess alter column "eparegion" type text;
alter table al_lust_to_geogprocess alter column "facilitytype" type text;
alter table al_lust_to_geogprocess alter column "tribalsite" type text;
alter table al_lust_to_geogprocess alter column "tribe" type text;
alter table al_lust_to_geogprocess alter column "latitude" type text;
alter table al_lust_to_geogprocess alter column "longitude" type text;
alter table al_lust_to_geogprocess alter column "coordinatesource" type text;
alter table al_lust_to_geogprocess alter column "luststatus" type text;
alter table al_lust_to_geogprocess alter column "reporteddate" type text;
alter table al_lust_to_geogprocess alter column "nfadate" type text;
alter table al_lust_to_geogprocess alter column "mediaimpactedsoil" type text;
alter table al_lust_to_geogprocess alter column "mediaimpactedgroundwater" type text;
alter table al_lust_to_geogprocess alter column "mediaimpactedsurfacewater" type text;
alter table al_lust_to_geogprocess alter column "substancereleased1" type text;
alter table al_lust_to_geogprocess alter column "quantityreleased1" type text;
alter table al_lust_to_geogprocess alter column "unit1" type text;
alter table al_lust_to_geogprocess alter column "substancereleased2" type text;
alter table al_lust_to_geogprocess alter column "quantityreleased2" type text;
alter table al_lust_to_geogprocess alter column "unit2" type text;
alter table al_lust_to_geogprocess alter column "substancereleased3" type text;
alter table al_lust_to_geogprocess alter column "quantityreleased3" type text;
alter table al_lust_to_geogprocess alter column "unit3" type text;
alter table al_lust_to_geogprocess alter column "substancereleased4" type text;
alter table al_lust_to_geogprocess alter column "quantityreleased4" type text;
alter table al_lust_to_geogprocess alter column "unit4" type text;
alter table al_lust_to_geogprocess alter column "substancereleased5" type text;
alter table al_lust_to_geogprocess alter column "quantityreleased5" type text;
alter table al_lust_to_geogprocess alter column "unit5" type text;
alter table al_lust_to_geogprocess alter column "sourceofrelease1" type text;
alter table al_lust_to_geogprocess alter column "causeofrelease1" type text;
alter table al_lust_to_geogprocess alter column "sourceofrelease2" type text;
alter table al_lust_to_geogprocess alter column "causeofrelease2" type text;
alter table al_lust_to_geogprocess alter column "sourceofrelease3" type text;
alter table al_lust_to_geogprocess alter column "causeofrelease3" type text;
alter table al_lust_to_geogprocess alter column "howreleasedetected" type text;
alter table al_lust_to_geogprocess alter column "correctiveactionstrategy1" type text;
alter table al_lust_to_geogprocess alter column "correctiveactionstrategy1startdate" type text;
alter table al_lust_to_geogprocess alter column "correctiveactionstrategy2" type text;
alter table al_lust_to_geogprocess alter column "correctiveactionstrategy2startdate" type text;
alter table al_lust_to_geogprocess alter column "correctiveactionstrategy3" type text;
alter table al_lust_to_geogprocess alter column "correctiveactionstrategy3startdate" type text;
alter table al_lust_to_geogprocess alter column "closedwithcontamination" type text;
alter table al_lust_to_geogprocess alter column "nofurtheractionletterurl" type text;
alter table al_lust_to_geogprocess alter column "militarydodsite" type text;
alter table al_lust_to_geogprocess alter column "globalid" type text;
alter table al_lust_to_geogprocess alter column "gc_coordinate_source" type text;
alter table al_lust_to_geogprocess alter column "gc_status" type text;
alter table al_lust_to_geogprocess alter column "gc_score" type text;
alter table al_lust_to_geogprocess alter column "gc_latitude" type text;
alter table al_lust_to_geogprocess alter column "gc_longitude" type text;
alter table al_lust_to_geogprocess alter column "gc_address_type" type text;
alter table al_lust_to_geogprocess alter column "gc_match_address" type text;
alter table al_lust_to_geogprocess alter column "gc_street_address" type text;
alter table al_lust_to_geogprocess alter column "gc_city" type text;
alter table al_lust_to_geogprocess alter column "gc_state" type text;
alter table al_lust_to_geogprocess alter column "gc_zip" type text;
alter table al_lust_to_geogprocess alter column "gc_zip4" type text;
alter table al_lust_to_geogprocess alter column "gc_country" type text;
alter table al_lust_to_geogprocess alter column "gc_outside_state" type text;




4)	In the UST files, when gc_latitude and gc_longitude are not null, move their values to the latitude and longitude columns.
5)	In the UST files, move gc_coordinate_source to the right of FacilityLongitude.
6)	In the UST files, move gc_address_type to the right of gc_coordinate_source.
7)	In the UST files, remove globalid column and all other “gc_XXX” columns.



select * from information_schema.tables;

update public.lust x 
set gc_latitude = y.gc_latitude::float, 
	gc_longitude = y.gc_longitude::float, 
	gc_coordinate_source = y.gc_coordinate_source, 
	gc_address_type = y.gc_address_type
from "AL_LUST".al_lust_to_geogprocess y
where x."FacilityID" = y.facilityid and x."LUSTID" = y.lustid
and x.state = 'AL' and x.control_id = (select max(control_id) from public.lust_control where state = 'AL');


select * from information_schema.tables 
		         where table_schema ='AL_LUST' and table_type = 'BASE TABLE'
		         and lower(table_name) like '%geo%'


select count(*) from "AL_LUST".al_lust_to_geogprocess
5395

select count(*) from public.lust x
where x.state = 'AL' and x.control_id = (select max(control_id) from public.lust_control where state = 'AL');
5395



select * from "AL_LUST".v_lust_geocode order by "FacilityID", "LUSTID";



