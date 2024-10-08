-- Mapping update after OUST review ------
----========== For release_status update ==============
update  release_element_value_mapping
set epa_value='Active: general',
Programmer_Comments='remapping from No further action to active general based on OUST comments (tank closure is typically when a LUST starts so this should be active:general or active: site investigation.)'
where release_element_mapping_id=71 and organization_value in ('1 Tank Closure','1a Completed Tank Closure','1b Closure Application Expired','1c Line Closure','1d Completed Line Closure');

update  release_element_value_mapping
set epa_value='Active: stalled',
Programmer_Comments='remapping from No further action to active stalled based on OUST comments (On the face of it an abandoned facility would be one where action is still anticipated - so the most likely EPA value would be Active:stalled)'
where release_element_mapping_id=71 and organization_value='13 Abandoned Facility Project';

update  release_element_value_mapping
set epa_value='Active: post corrective action monitoring',
Programmer_Comments='remapping from No further action to Active: post corrective action monitoring based on OUST comments (should be active: post corrective action monitoring)'
where release_element_mapping_id=71 and organization_value='7 Closure Monitoring';

update  release_element_value_mapping
set epa_value='Other',
Programmer_Comments='remapping from No further action to other based on OUST comments ("other" is not no further action)'
where release_element_mapping_id=71 and organization_value='9 Other';

----========== how_release_detected ======================

update  release_element_value_mapping
set epa_value='At tank removal',
Programmer_Comments='remapping from Inspection to At tank removal based on OUST comments (We need to add Tank Closure to this list.  It is very different than a compliance inspection. Tank removal probably works OK too -in most cases closure will be tank removal and closed in place is programmatically the same but inspection is wrong)'
where release_element_mapping_id=74 and organization_value='1 At Closure';

update  release_element_value_mapping
set epa_value='GW monitoring well',
Programmer_Comments='remapping from other to GW monitoring well based on OUST comments (In most cases on site impact is going to be found by groundwater monitoring)'
where release_element_mapping_id=74 and organization_value in ('3 On-site Impact','3 On-Site Impact');

update  release_element_value_mapping
set epa_value='GW monitoring well',
Programmer_Comments='remapping from Inspection to GW monitoring well based on OUST comments (This should be site assessment/audit.  It is not an inspection.  Agreed - the closest existing option might be groundwater monitoring, but this is definitely not a regulatory inspection)'
where release_element_mapping_id=74 and organization_value='7 Environmental Audit';

update  release_element_value_mapping
set Programmer_Comments='OUST directed us to use ''Other'' per our call on 9/25. '
where release_element_mapping_id=74 and organization_value='2 Release Detection';

----======== Cause ===================

update  release_element_value_mapping
set epa_value='Physical/mechnical damage'
where release_element_mapping_id=76 and organization_value in ('6 Mechanical Failure','Mechanical Failure');

update  release_element_value_mapping
set epa_value='General spill'
where release_element_mapping_id=76 and organization_value ='1 Spill';
