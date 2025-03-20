insert into release_control (organization_id, date_received, date_processed, data_source, comments)
values ('DC', '2024-12-19', current_date, 'UST Finder Excel at this url: https://ust-doee.dc.gov/pages/PublicReports.aspx', 'DC only reports a single substance per release, see notes from 12/19/2024')
returning release_control_id;


insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','facility_id','release','Facility ID',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','release_id','release','LUSTID',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','federally_reportable_release','release','Federally Reportable Release',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','site_name','release','Site Name',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','site_address','release','Site Address',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','site_city','release','Site City',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','zipcode','release','Zipcode',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','state','release','State',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','epa_region','release','EPARegion',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','facility_type_id','release','Facility Type',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','latitude','release','Latitude',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','longitude','release','Longitude',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','coordinate_source_id','release','Coordinate Source',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','release_status_id','release','LUSTStatus',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','reported_date','release','Reported Date',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','nfa_date','release','NFADate',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','media_impacted_soil','release','Media Impacted Soil',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','media_impacted_groundwater','release','Media Impacted Groundwater',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','media_impacted_surface_water','release','Media Impacted Surface Water',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release_substance','substance_id','release','Substance Released1',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release_substance','quantity_released','release','Quantity Released1',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release_substance','unit','release','Unit1',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release_source','source_id','release','Source Of Release1',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release_cause','cause_id','release','Cause Of Release1',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release_corrective_action_strategy','corrective_action_strategy_id','release','Corrective Action Strategy1',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release_corrective_action_strategy','corrective_action_strategy_start_date','release','Corrective Action Strategy1Start Date',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (18,'ust_release','military_dod_site','release','Military Do DSite',null);



