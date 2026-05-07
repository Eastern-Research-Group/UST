# ERG Peer Review Process 

1. Confirm all three review materials (control summary, QAQC, and populated template) were uploaded to the appropriate state folder in the "02 - Draft Mapped Templates" folder on the EPA SharePoint site at https://usepa.sharepoint.com/:f:/r/sites/USTFinder2ASTSWMO/Shared%20Documents/General/02%20-%20Draft%20Mapped%20Templates?csf=1&web=1&e=UF1ibe. 

2. Open the control summary spreadsheet and make sure each worksheet has been properly populated. The following tabs should exist and have data:
	- XX UST (or Release) Summary
	- XX UST (or Release) Row Count  
	- Performance Measure Comparison
	- Mapped Element Summary 

3. Review the row counts on the XX UST (or Release) Row Count tab to ensure they make sense. For example, for an UST dataset, there should be at least as many Tanks as there are Facilities. If there are fewer Tanks than Facilities, investigate why. For states that report at the compartment level (see the XX UST Summary tab), there should be more Compartments than Tanks; for states that don't report at the compartment level, the number of Tanks and Compartments should be the same. 

4. The Performance Measure comparison may not be accurate for all states - the Performance Measure numbers are submitted by the states by a different process and don't always align with their submitted data - but if the numbers do happen to be within 10% of each other, this is a good indication the data was likely processed correctly. Sometimes the totals are wildly off because we received only a portion of the data included in the performance measures, but individual compartment or release statuses will match up. There is no need to act if these counts don't seem to align, but it's useful to note if they do. 

5. Open the QAQC spreadsheet and make sure each worksheet has been properly populated. The following tabs should exist and have data:
	- Overview
	- Element Mapping

6. Review the Overview tab and ensure the final row, under Bad or Missing Data, says "No bad or missing data".

7. Review the Element Mapping tab to ensure the element mapping looks reasonable. 

8. Open the populated template and make sure each worksheet has been properly populated. 

	In an UST template, the following tabs should exist and have data:
  	- Reference
  	- Facility Types lookup
  	- States lookup
  	- Substances lookup
  	- Element Mapping 
  	- Unmapped Source Elements 
  	- [There will next be individual value mapping tabs that end with the word "Mapping"; these will vary by state depending on the source data]
  	- Facility
  	- Tank 
  	- Tank Substance (should be populated if the source data contains substance data)
  	- Compartment
  	- Compartment Substance (should be populated if the state reports at the compartment level AND their substance data can be tracked to a specific compartment)
  	- Piping (should be populated if the source data contains piping data)
  	- Facility Dispenser (should be populated if the source data contains dispenser data and it can be tracked to a specific facility but not tank or compartment)
  	- Tank Dispenser (should be populated if the source data contains dispenser data and it can be tracked to a specific tank but not compartment)
  	- Compartment Dispenser (should be populated if the source data contains dispenser data and it can be tracked to a specific compartment)

  	In a Releases template, the following tabs should exist and have data: 
  	- Reference 
  	- Facility Types lookup
  	- States lookup
  	- Substances lookup
  	- Sources lookup
  	- Causes lookup
  	- Corrective Actions lookup 
  	- Element Mapping 
  	- Unmapped Source Elements 
  	- [There will next be individual value mapping tabs that end with the word "Mapping"; these will vary by state depending on the source data]
  	- Release 
  	- Substance (should be populated if the source data contains substance data)
  	- Source (should be populated if the source data contains source data)
  	- Cause (should be populated if the source data contains cause data)
  	- Corrective Action Strategy (should be populated if the source data contains corrective action strategy data)

9. Review each of the value mapping tabs and check that the value mappings look reasonable. Check also that there are no aggregated values in the source data (for example, a mapped substance that contains a comma or other delimiter, such as "Gas, Diesel", which may indicate the state entered multiple substances on a single row and the developer failed to properly deaggregate them). 
 	- OUST is providing a lot of value mapping for us ahead of time. The developer should put a programmer comment stating "OUST key vocabulary mapping" on any mapping that is not an exact match to the EPA value and was provided by OUST. Make sure at least some of the value mappings contain this commment. 
 	- The developer may have put a comment of "Please verify" or something similar on some of the mappings that were not provided by OUST and the developer wasn't completely sure of their guess. If you are sure their developer's guess was right OR if you are sure it's wrong and know what the correct mapping would be, make this suggestion to the developer and ask them to change the value. (Be sure to explain your reasoning.)
 	- If you see any suspiciously-mapped values, you can run some queries to verify. There is a special view that contains all previously mapped substances; you can run a query similar to the following, where XXXX is the organization substance value you are questioning or a part of that value: 

 	select * from public.v_mapped_substances 
 	where lower(organization_value) like lower('%XXXX%') 
 	order by 1, 2;

 	For all other mappings, you can use a query similar to the following, where 'epa_column_name' is the ID column of the lookup table (e.g. "owner_type_id")

 	select organization_value, epa_value
	from v_ust_element_mapping (or v_ust_relement_mapping)
	where epa_column_name = 'epa_column_name'
	where lower(organization_value) like lower('%XXXX%') 
	order by 1, 2;

10. Run the peer_review.py script in the util directory of this repo. This script counts the number of rows in the table population views in the state schema and compares them to the number of rows in the EPA data tables in the public schema. If there are discrepancies in row counts, the script will generate a SQL script that you can use to identify which rows were not inserted into the EPA tables, and you can try to figure out why (or you can give this script to the developer and ask them to explain the discrepancy and fix any issues that may have caused it). Note: you can also run the peer review script for states you are processing as an additional QA check! 

11. By default, the peer_review.py script will additionally export a SQL file that contains the DDL for all data population views in the state schema. Open this fle and review the view DDL, checking that the SQL makes sense and that, if it exists, the where clause is logical and consistent with the comments field of the control table. If the views are excluding data in the where clause and you aren't sure why and there is no comment about it in the control table or in other documentation that will be accessible to OUST, ask the developer to update the control table with an explanation. (Where clauses that exclude unregulated facilities using the erg_unregulated_facilities and erg_unregulated_tanks tables do not need an additional explanation/documentation.)
	- As you review the view logic, run queries to view the source data tables as needed to verify the view logic is correctly manipulating the data. 

