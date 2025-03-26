insert into release_control (organization_id, date_received, date_processed, data_source)
values ('HI', '2024-07-22', current_date, 'State submitted an Excel spreadsheet very close to EPA template format; will require specific value mapping. Contains additional data not in template.')
returning release_control_id;



