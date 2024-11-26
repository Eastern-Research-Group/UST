-- ust_release
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','facility_id','release','FacilityID',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','release_id','release','LUSTID',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','federally_reportable_release','release','FederallyReportableRelease',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','site_name','release','SiteName',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','site_address','release','SiteAddress',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','site_address2','release','SiteAddress2',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','site_city','release','SiteCity',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','zipcode','release','Zipcode',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','county','release','County',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','state','release','State',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','epa_region','release','SiteName',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','facility_type_id','release','FacilityType',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','latitude','release','Latitude',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','longitude','release','Longitude',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','coordinate_source_id','release','HorizontalCollectionMethodName',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','release_status_id','release','LUSTLatestStatus','Please verify this is correct (could also use LUSTStatus)');

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','reported_date','release','ReportedDate','Please verify this is the correct mapping');

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','nfa_date','release','DataCollectionDate','Please verify (could also be ReportedDate)');

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','how_release_detected_id','release','HowReleaseDetected',null);

insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release','closed_with_contamination','release','ClosedWithContamination',null);

-- ust_release_cause
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release_cause','cause_id','release','CauseOfRelease1',null);

-- ust_release_corrective_action_strategy
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release_corrective_action_strategy','corrective_action_strategy_id','release','CorrectiveActionStrategy1',null);

-- ust_release_source
insert into public.release_element_mapping (release_control_id, epa_table_name, epa_column_name, organization_table_name, organization_column_name, programmer_comments) 
values (14,'ust_release_source','source_id','release','SourceOfRelease1',null);

--ust_release_substance
-- Waiting on response from OUST