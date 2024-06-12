
select distinct "Subpart" from bstank order by 1;


select * from bstank where "Subpart" = 2;



easting_column  = "EASTING";
northing_column = "NORTHING";
datum_column    = "HDATUMNAME";
utm_zone_column = "UTM_ZONE";


select distinct "SiteID", "UTMX" as "EASTING", "UTMY" as "NORTHING", 'NAD83' as "HDATUMNAME", '18N' as "UTM_ZONE"
into utm_conversion
from bsfoil order by 1;

select * from utm_conversion order by 1;

select * from bsfoil where "SiteID" = 2;

select 'null as "' || element_name || '",' as element_name from ust_elements order by element_position;

select distinct matname from bsmat;

select distinct "Type" from bsequip b order by 1;

select * from bsequip b 

select * from bsaffil b ;


select distinct "AffiliationType"  from bsaffil b order by 1;
Emergency Contact
Facility Operator
Facility Owner
Mail Contact

select distinct "SiteStatusName" from bsfoil b order by 1;
Active
Administratively Closed
Inactive
Pending - Registration
Unregistered
Unregulated/Closed

select distinct "SiteType" from bsfoil order by 1;

select * from bsfoil;

select * from ust_element_db_mapping order by 1 desc;

insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NY','2023-02-14', 'FacilityType1', 'bsfoil', 'SiteType');

select * from public.ust_element_value_mappings;

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Airport/Airline/Air Taxi', 'Aviation/airport (non-rental car)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Apartment Building/Office Building', 'Residential');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Auto Service/Repair (No Gasoline Sales)', 'Auto dealership/auto maintenance & repair');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Cemeteries/Memorials', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Chemical Distributor', 'Bulk plant storage/petroleum distributor');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Chemical Manufacturing', 'Industrial');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Farm', 'Agricultural/farm');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Hospital/Nursing Home/Health Care', 'Hospital (or other medical)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Manufacturing (Other than Chemical)/Processing', 'Commercial ');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Marina', 'Marina');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Municipality (Incl. Waste Water Treatment Plants, Utilities, Swimming Pools, etc.)', 'Utility');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Nuclear Power Plant', 'Industrial');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Other', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Other Wholesale/Retail Sales', 'Wholesale');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Private Residence', 'Residential');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Railroad', 'Railroad');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Religious Building (Church, Synagogue, Mosque, Temple, etc.)', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Retail Gasoline Sales', 'Retail fuel sales (non-marina)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'School', 'School');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Storage Terminal/Petroleum Distributor', 'Bulk plant storage/petroleum distributor');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Swimming Pools (Other than Municipal)', 'Commercial ');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Trucking/Transportation/Fleet Operation', 'Trucking/transport/fleet operation');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Unknown', 'Unknown');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Utility (Other than Municipal)', 'Utility');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (61, 'Vessel/Barge', 'Industrial');

select *  from bsaffil  order by 1;

insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NY','2023-02-14', 'TankStatus', 'bstank', 'TankStatus');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, programmer_comments) values (62, '1', 'Currently in use','In Service');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, programmer_comments) values (62, '2', 'Temporarily out of service','Temporarily Out of Service');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, programmer_comments) values (62, '3', 'Closed (removed from ground)','Closed - Removed');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, programmer_comments) values (62, '4', 'Closed (in place)','Closed -In Place');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, programmer_comments) values (62, '5', 'Other','Tank Converted to Non-Regulated Use');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, programmer_comments) values (62, '6', 'Closed (general)','Closed Prior to 03/1991');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, programmer_comments) values (62, '7', 'Closed (general)','Administratively Closed');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, programmer_comments) values (62, '8', 'Other','Unregistered');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, programmer_comments) values (62, '9', 'Other','Inactive Site (Active Tank)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value, programmer_comments) values (62, 'A', 'Other','Inactive Site (T.O.S. Tank)');

select * from ust_element_value_mappings where element_db_mapping_id = 62 order by state_value;

delete from  public.ust_element_value_mappings
where element_db_mapping_id = 62 and state_value = '5';
update public.ust_element_value_mappings
set epa_value = 'Temporarily out of service'
where id = 313;
update public.ust_element_value_mappings
set epa_value = 'Currently in use'
where id = 312;


insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'BallFloatValve', 'bsequip', 'CodeName', 'Type = "Overfill"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'FlowShutoffDevice', 'bsequip', 'CodeName', 'Type = "Overfill"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'HighLevelAlarm', 'bsequip', 'CodeName', 'Type = "Overfill"');


insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (64, 'Float Vent Valve', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (65, 'Automatic Shut-Off', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (66, 'High Level Alarm', 'Yes');


insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'PipingCorrosionProtectionSacrificialAnodes', 'bsequip', 'CodeName', 'Type = "Pipe External Protection"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'PipingCorrosionProtectionAnodesInstalledOrRetrofitted', 'bsequip', 'CodeName', 'Type = "Pipe External Protection"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'PipingCorrosionProtectionImpressedCurrent', 'bsequip', 'CodeName', 'Type = "Pipe External Protection"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'PipingCorrosionProtectionImpressedCurrentInstalledOrRetrofitted', 'bsequip', 'CodeName', 'Type = "Pipe External Protection"');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (67, 'Original Sacrificial Anode', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (67, 'Retrofitted Sacrificial Anode', 'Yes');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (68, 'Original Sacrificial Anode', 'Installed');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (68, 'Retrofitted Sacrificial Anode', 'Retrofitted');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (69, 'Original Impressed Current', 'Yes');insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (69, 'Retrofitted Impressed Current', 'Yes');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (70, 'Original Impressed Current', 'Installed');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (70, 'Retrofitted Impressed Current', 'Retrofitted');


insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'PipingCorrosionProtectionExternalCoating', 'bsequip', 'CodeName', 'Type = "Pipe External Protection"');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (71, 'Fiberglass', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (71, 'Jacketed', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (71, 'Painted/Asphalt Coating', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (71, 'Urethane', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) 
values (71, 'Wrapped', 'Yes');


insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'PipingMaterialDescription', 'bsequip', 'CodeName', 'Type = "Pipe Type"');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'Concrete', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'Copper', 'Copper');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'Equivalent Technology', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'Fiberglass Coated Steel', 'Steel');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'Fiberglass Reinforced Plastic (FRP)', 'Fiberglass reinforced plastic');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'Flexible Piping', 'Flex piping');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'Galvanized Steel', 'Galvanized steel');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'No Piping', 'No piping');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'Other', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'Plastic', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'Stainless Steel Alloy', 'Stainless steel');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'Steel Encased in Concrete', 'Steel');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (72, 'Steel/Carbon Steel/Iron', 'Steel');

select * from ust_element_value_mappings where element_db_mapping_id = 72;

update ust_element_value_mappings set epa_value = 'Fiberglass reinforced plastic' where id = 340;

insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'InterstitialMonitoringContinualElectric', 'bsequip', 'CodeName', 'Type = "Piping Leak Detection"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'InterstitialMonitoringManual', 'bsequip', 'CodeName', 'Type = "Piping Leak Detection"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'GroundwaterMonitoring', 'bsequip', 'CodeName', 'Type = "Piping Leak Detection"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'StatisticalInventoryReconciliation', 'bsequip', 'CodeName', 'Type = "Piping Leak Detection"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'VaporMonitoring', 'bsequip', 'CodeName', 'Type = "Piping Leak Detection"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'HighPressure', 'bsequip', 'CodeName', 'Type = "Piping Leak Detection"');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (74, 'Interstitial - Electronic Monitoring', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (75, 'Interstitial - Manual Monitoring', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (76, 'Groundwater Well', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (77, 'Statistical Inventory Reconciliation (SIR)', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (78, 'Vapor Well', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (79, 'Pressurized Piping Leak Detector', 'Yes');


insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'PipeSecondaryContainment', 'bsequip', 'CodeName', 'Type = "Piping  Secondary Containment"');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Diking (AG only)', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Double-Walled (AG only)', 'Double walled');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Double walled UG', 'Double walled');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Flexible Internal Liner (Bladder)', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Impervious Underlayment ', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Modified Double-Walled (Aboveground)', 'Double walled');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'None', 'N/A');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Other', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Remote Impounding Area', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Synthetic Liner', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Trench Liner', 'Trench liner');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Vault (with Access)', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Vault (without Access)', 'Other');

insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'SpillBucketInstalled', 'bsequip', 'CodeName', 'Type = "Spill Prevention"');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (81, 'Catch Basin', 'Yes');

insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'TankCorrosionProtectionImpressedCurrent', 'bsequip', 'CodeName', 'Type = "Tank External Protection"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'TankCorrosionProtectionImpressedCurrentInstalledOrRetrofitted', 'bsequip', 'CodeName', 'Type = "Tank External Protection"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'TankCorrosionProtectionInteriorLining', 'bsequip', 'CodeName', 'Type = "Tank External Protection"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'TankCorrosionProtectionOther', 'bsequip', 'CodeName', 'Type = "Tank External Protection"');
insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'TankCorrosionProtectionCathodicNotRequired', 'bsequip', 'CodeName', 'Type = "Tank External Protection"');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (82, 'Original Impressed Current', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (82, 'Retrofitted Impressed Current', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (83, 'Original Impressed Current', 'Installed');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (83, 'Retrofitted Impressed Current', 'Retrofitted');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (84, 'Jacketed', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (84, 'Painted/Asphalt Coating', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (84, 'Urethane', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (85, 'Other', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (86, 'None', 'Yes');

insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'AutomaticTankGauging', 'bsequip', 'CodeName', 'Type = "Tank Leak Detection"');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (87, 'In-Tank System (ATG)', 'Yes');

insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'ExcavationLiner', 'bsequip', 'CodeName', 'Type = "Tank Secondary Containment"');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (88, 'Excavation Liner', 'Yes');

insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'TankWallType', 'bsequip', 'CodeName', 'Type = "Tank Secondary Containment"');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (89, 'Double-Walled (Underground)', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (89, 'Double-Walled (AG only)', 'Yes');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (89, 'Modified Double-Walled (Aboveground)', 'Yes');

insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'MaterialDescription', 'bsequip', 'CodeName', 'Type = "Tank Internal Protection"');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (91, 'Epoxy Liner', 'Epoxy coated steel');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (91, 'Fiberglass Liner (FRP)', 'Fiberglass reinforced plastic');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (91, 'Glass Liner', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (91, 'None', '');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (91, 'Other', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (91, 'Rubber Liner', 'Other');


insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name)
values ('NY','2023-02-14', 'TankSubstanceStored', 'bsmat', 'matname');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, '#2 fuel oil (on-site consumption)', 'Heating oil/fuel oil 2');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, '#2 fuel oil (resale/redistribute)', 'Heating oil/fuel oil 2');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, '#4 fuel oil (on-site consumption)', 'Heating oil/fuel oil 4');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, '#4 fuel oil (resale/redistribute)', 'Heating oil/fuel oil 4');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, '#5 fuel oil (on-site consumption)', 'Heating oil/fuel oil 5');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, '#6 fuel oil (on-site consumption)', 'Heating/fuel oil # unknown');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, '#6 fuel oil (resale/redistribute)', 'Heating/fuel oil # unknown');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'aviation gasoline', 'Aviation gasoline');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'Biodiesel (E-Gen)', 'Diesel fuel (b-unknown)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'biodiesel (motor fuel)', 'Diesel fuel (b-unknown)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'biofuel oil (on-site consumption)', '');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'clarified oil (on-site consumption)', 'Used oil/waste oil');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'clarified oil (resale/redistribute)', 'Used oil/waste oil');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'crude oil', 'Petroleum product');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'crude oil fractions', 'Petroleum product');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'cutting oil', 'Petroleum product');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'diesel', 'Diesel fuel (b-unknown)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'Diesel (E-Gen)', 'Diesel fuel (b-unknown)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'form oil', 'Petroleum product');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'gasoline', 'Gasoline (unknown type)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'gasoline/ethanol', 'Gasoline/ethanol blends E16-E50');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'gear/spindle oil', 'Lube/motor oil (new)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'hydraulic oil', 'Lube/motor oil (new)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'insulating oil', 'Lube/motor oil (new)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'jet fuel', 'Unknown aviation gas or jet fuel');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'kerosene [#1 fuel oil] (on-site consumption)', 'Kerosene');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'kerosene [#1 fuel oil] (resale/redistribute)', 'Kerosene');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'lube oil', 'Lube/motor oil (new)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'mineral oil', 'Petroleum product');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'motor oil', 'Lube/motor oil (new)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'naphtha', 'Solvent');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'other', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'petroleum grease', 'Petroleum product');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'transmission fluid', 'Petroleum product');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'turbine oil', 'Lube/motor oil (new)');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'used oil (heating, on-site consumption)', 'Used oil/waste oil');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'waste oil/used oil', 'Used oil/waste oil');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'white/mineral spirits', 'Solvent');


select * from ust_element_value_mappings where element_db_mapping_id = 90 order by state_value;

update ust_element_value_mappings set state_value = 'Other' where id = 399;
update ust_element_value_mappings set state_value = 'Other' where id in (401,402,403);
update ust_element_value_mappings set state_value = 'Gasoline/ethanol blends E16-E50' where id =  411;
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'invalid material - please fix', 'Unknown');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'asphalt', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (90, 'asphaltic emulsions', 'Other');




select * from ust_element_db_mapping where state = 'NY' order by 1 desc;

select * from ust_element_value_mappings order by 1 desc;
	

select distinct "Type", "CodeName" from bsequip order by 1, 2;


select distinct "CodeName" from bsequip b where "Type" = 'Tank Internal Protection' order by 1;



select * from bsequip b where "Type" = 'Tank Internal Protection' order by 1;

select * from bsmat;

select distinct matname from bsmat order by 1;

select distinct "TankType" from bstank;


-------------------------------------------------------------------------------------------------------------------------------

select * from bsequip a
where "Type" = 'Piping Secondary Containment' 
and "CodeName" in ('Diking (AG only)','Double-Walled (AG only)','Modified Double-Walled (Aboveground)')
and exists (select 1 from bstank b 
			where a."ï»¿siteid" = b."ï»¿SiteID" and a."TankID" = b."TankID" 
			and "Subpart" <> 2);
	419309	230754
419309	230751
419309	230757
419309	230752
419309	230755

3



	select * from bstank where 	"ï»¿SiteID" = 465097 and "TankID" = 244335

select * from bstank where "ï»¿SiteID" in (374288,55490,55576)

select "ï»¿SiteID", "TankLoc", "TankID"
from bstank 
where "Subpart" = 2
and "ï»¿SiteID" in (44)
order by 1, 3;
5
5
5
5
5

4
4
4
4

select * from bsequip where "ï»¿siteid" = 11 and "Type" = 'Piping Secondary Containment' 

select * from public.v_ust_element_mapping where element_name = 'PipeSecondaryContainment'

11	703	5	E04	Double walled UG	Piping Secondary Containment
11	51088	6	E04	Double walled UG	Piping Secondary Containment


select distinct "CodeName" from bsequip b where "Type" = 'Piping Secondary Containment' order by 1;
Diking (AG only)
Double-Walled (AG only)
Double walled UG
Flexible Internal Liner (Bladder)
Impervious Underlayment 
Modified Double-Walled (Aboveground)
None
Other
Remote Impounding Area
Synthetic Liner
Trench Liner
Vault (with Access)
Vault (without Access)

select * from public.ust_element_db_mapping where element_name = 'PipeSecondaryContainment'

select * from ust_element_value_mappings where element_db_mapping_id = 80 order by 1;

insert into public.ust_element_db_mapping (state, mapping_date, element_name, state_table_name, state_column_name, programmer_comments)
values ('NY','2023-02-14', 'PipeSecondaryContainment', 'bsequip', 'CodeName', 'Type = "Piping  Secondary Containment"');

insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Diking (AG only)', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Double-Walled (AG only)', 'Double walled');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Double walled UG', 'Double walled');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Flexible Internal Liner (Bladder)', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Impervious Underlayment ', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Modified Double-Walled (Aboveground)', 'Double walled');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'None', 'N/A');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Other', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Remote Impounding Area', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Synthetic Liner', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Trench Liner', 'Trench liner');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Vault (with Access)', 'Other');
insert into public.ust_element_value_mappings (element_db_mapping_id, state_value, epa_value) values (80, 'Vault (without Access)', 'Other');

delete from ust_element_value_mappings where id in (350,351,355);

select "ï»¿siteid", "TankID", "CodeName", "Type"
from bsequip
where "ï»¿siteid" = 11 order by 2;

select * from v_ust_element_mapping where state = 'NY' and element_name = 'PipeSecondaryContainment'

				(select distinct "ï»¿siteid", "TankID", epa_value 
				from bsequip x join v_ust_element_mapping y on x."CodeName" = y.state_value 
				where y.state = 'NY' and y.element_name = 'PipeSecondaryContainment' and "Type" = 'Piping Secondary Containment'
				and "ï»¿siteid" = 11) psc
		on t."ï»¿SiteID" = psc."ï»¿siteid" and t."TankID" = psc."TankID"	
		
		select distinct "Type" from bsequip order by 1;
	
	select distinct "CodeName" from bsequip where "Type" = 'Tank Secondary Containment' order by 1;
