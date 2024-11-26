update release_element_mapping 
set query_logic = 'Set All values to yes: per comment'
where release_element_mapping_id = 390;

update release_element_mapping 
set query_logic = 'when ClosedWithContamination is null then null
when ClosedWithContamination is ` then null
else Yes',
programmer_comments = 'Please Verify: Mapped all null or "`" values to No, everything else to Yes.'
where release_element_mapping_id = 411;

