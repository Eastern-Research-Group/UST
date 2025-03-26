insert into release_control (organization_id, date_received, date_processed, data_source)
values ('IA', '2024-03-01', current_date, 'Notes')
returning release_control_id;
