-- ust_release

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','facility_id','release','FacilityID',null, null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','release_id','release','LUSTID',null, null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','site_name','release','SiteName',null,null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','site_address','release','SiteAddress',null, null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','site_city','release','SiteCity',null, null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','zipcode','release','Zipcode',null, null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','county','release','County',null, null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','state','release','State',null,null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','epa_region','release','EPARegion',null,null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','facility_type_id','release','FacilityType',null, null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','latitude','release','Latitude',null, null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','longitude','release','Longitude',null, null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','release_status_id','release','LUSTStatus',null, null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','reported_date','release','ReportedDate',null, null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','nfa_date','release','NFADate',null, null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments, query_logic) 
values (15,'ust_release','military_dod_site','release','MilitaryDoDSite',null, null);

-- update query_logic

update release_element_mapping 
set query_logic = 'when MilitaryDoDSite = YES then Yes
when MilitaryDoDSite = NO then No
else null'
where release_element_mapping_id = 427;
