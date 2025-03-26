update ust_element_mapping 
set query_logic = 'When SafeSuction = Yes then Yes, when SafeSuction = No then No, else Unknown'
where ust_element_mapping_id = 2092;

update ust_element_mapping 
set query_logic = 'When AmericanSuction = Yes then Yes, when AmericanSuction = No then No, else Unknown'
where ust_element_mapping_id = 2093;
