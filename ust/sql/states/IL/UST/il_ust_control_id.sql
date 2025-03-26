insert into ust_control (organization_id, date_received, date_processed, data_source)
values ('IL', '2024-10-09', current_date, 'Source Data from an EPA template populated by the state, some mapping done by ERG.')
returning ust_control_id;

update ust_control 
set organization_compartment_flag = 'Y'
where ust_control_id = 27;
