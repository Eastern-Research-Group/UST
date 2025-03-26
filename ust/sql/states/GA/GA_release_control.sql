insert into release_control (organization_id, date_received, date_processed, data_source)
values ('GA', '2024-09-13', current_date, 'State submitted excel spreadsheet very close to EPA template format. Needs to be mapped to EPAs business rules.')
returning release_control_id;
