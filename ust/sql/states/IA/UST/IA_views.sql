create or replace view ia_ust.v_ust_facility 
as select distinct x."ustID"::text as facility_id,
	x."ustName" as facility_name,
	o.owner_type_id,
	l."loc1Address" as facility_address1,
	l."loc2Address" as facility_address2,
	ci."CityName" as facility_city,
	co."countyName" as facility_county,
	l."locZip" as facility_zip_code,
	s.facility_state,
	l."latitude" as facility_latitude,
	l."longitude" as facility_longitude,
	cs.coordinate_source_id,
	ow."orgname" as facility_owner_company_name,
	op."orgname" as facility_operator_company_name,
	CASE 
		WHEN x."financialCode" is not null THEN 'Yes'  
	END as financial_responsibility_obtained,
	case
		when x."financialCode" = 9.0 then 'Yes'
	end as financial_responsibility_bond_rating_test,
	case
		when x."financialCode" in (15.0,2.0) then 'Yes'
	end as financial_responsibility_commercial_insurance,
	case
		when x."financialCode" = 3.0 then 'Yes'
	end as financial_responsibility_guarantee,
	case
		when x."financialCode" = 5.0 then 'Yes'
	end as financial_responsibility_letter_of_credit,
	case
		when x."financialCode" = 10.0 then 'Yes'
	end as financial_responsibility_local_government_financial_test,
	case
		when x."financialCode" = 1.0 then 'Yes'
	end as financial_responsibility_self_insurance_financial_test,
	case
		when x."financialCode" = 6.0 then 'Yes'
	end as financial_responsibility_state_fund,
	case
		when x."financialCode" = 4.0 then 'Yes'
	end as financial_responsibility_surety_bond,
	case
		when x."financialCode" = 8.0 then 'Yes'
	end as financial_responsibility_trust_fund,
	case
		when x."financialCode" not in (9.0, 15.0, 2.0, 3.0, 5.0, 10.0, 1.0, 6.0, 4.0, 8.0, null) then 'Yes'
	end as financial_responsibility_other_method,
	case
		when lust."lustid" is not null then 'Yes'
	end as ust_reported_release,
	lust."lustid"::text as associated_ust_release_id
from ia_ust.tblustsite x
	left join ia_ust.v_owner_type_xwalk o on x."ownerTypeID"::text = o.organization_value::text
	left join ia_ust.tbllocation l on x."locID"::text = l."locID"::text
	left join ia_ust.tlkcitystandard ci on l."CityID" = ci."CityID"
	left join ia_ust.tlkcounty co on l."countyID" = co."countyID"
	left join ia_ust.v_state_xwalk s on l."locStateCD" = s.organization_value
	left join ia_ust.v_coordinate_source_xwalk cs on l."colMthID"::text = cs.organization_value::text
	left join ia_ust.v_owner_table_name ow on ow."ustid" = x."ustID" and ow.row_num = 1
	left join ia_ust.v_operator_table_name op on op."ustid" = x."ustID" and op.row_num = 1
	left join ia_ust.v_release_table lust on lust."ustid" = x."ustID" and lust.row_num = 1
where s.facility_state = 'IA';

create or replace view ia_ust.v_ust_tank 
as select distinct t."ustID"::text as facility_id,
    t."tankID"::int4 as tank_id,
    case
    	when ts2.tank_status_id is null then 8
    	else ts2.tank_status_id
    end as tank_status_id,
    case
    	when us."statusDescription" like 'non-regulated%' 
    		or us."statusDescription" like '%exempt%'
    		or us."statusDescription" like '%ust distrib%'
    		or us."statusDescription" like '%deleted%'
    		or us."statusDescription" like '%1974%' then 'No'
    	when us."statusDescription" = 'Other' then 'Unknown'
    	else 'Yes'
    end as federally_regulated,
    case
    	when us."statusDescription" like 'Emergency power generator tank%' then 'Yes'
    	else 'No'
    end as emergency_generator,
    case
    	when tankcount."countoftanks" > 1 then 'Yes'
    	else 'No' 
    end as multiple_tanks,
    tankclosuredate."tankDate"::date as tank_closure_date,
    tankinstalldate."tankDate"::date as tank_installation_date,
    case
    	when tc."countofcomps" > 1 then 'Yes'
    	when tc."countofcomps" = 1 then 'No'
    end as compartmentalized_ust,
    tc."countofcomps"::int4 as number_of_compartments,
	md.tank_material_description_id,
	case
		when epic."externalProtectionID" is not null then 'Yes'
	end as tank_corrosion_protection_impressed_current,
	case
		when epil."externalProtectionID" is not null then 'Yes'
	end as tank_corrosion_protection_interior_lining,
	case
		when epo."externalProtectionID" is not null then 'Yes'
	end as tank_corrosion_protection_other,
	coi.cert_of_installation_id,
	case
		when cio."installationID" = 4 then 'Tank and Piping Tested for Leaks During and After Installation'
		when cio."installationID" = 7 then 'Unknown'
	end as cert_of_installation_other
from ia_ust.tbltank t
	left join (select "tankID", count("tankCompartmentID") countofcomps 
		from ia_ust.tbltankcompartment 
		group by "tankID") tc on tc."tankID" = t."tankID"
	left join ia_ust.erg_tank_status ts on t."tankID" = ts."tankID" 
	left join public.tank_statuses ts2 on ts.compartment_status = ts2.tank_status 
	left join ia_ust.v_tank_statuses_table us on us."ustID" = t."ustID" and row_num = 1
	left join (select "ustID", count("tankID") as countoftanks 
		from ia_ust.tbltank 
		group by "ustID"
	) tankcount on t."ustID" = tankcount."ustID"
	left join ia_ust.v_tank_closure_table tankclosuredate on tankclosuredate."tankID" = t."tankID" and tankclosuredate.row_num = 1
	left join ia_ust.v_tank_install_table tankinstalldate on tankinstalldate."tankID" = t."tankID" and tankinstalldate.row_num = 1
	left join ia_ust.tlkmaterialconstruction mc on mc."materialConstructionID" = t."materialConstructionID" 
	left join ia_ust.v_tank_material_description_xwalk md on mc."matConDescription" = md.organization_value
	left join (select distinct on (ep."tankID")
		ep."tankID", ep."externalProtectionID"
		from ia_ust.treltanktoexternalprote ep
		where ep."externalProtectionID" = 4
		order by ep."tankID", ep."lastChanged" desc
	)epic on t."tankID" = epic."tankID"
	left join (select distinct on (ep."tankID")
		ep."tankID", ep."externalProtectionID"
		from ia_ust.treltanktoexternalprote ep
		where ep."externalProtectionID" in (5,6,7,8)
		order by ep."tankID", ep."lastChanged" desc
	)epil on t."tankID" = epil."tankID"
	left join (select distinct on (ep."tankID")
		ep."tankID", ep."externalProtectionID"
		from ia_ust.treltanktoexternalprote ep
		where ep."externalProtectionID" in (9,10)
		order by ep."tankID", ep."lastChanged" desc
	)epo on t."tankID" = epo."tankID"
	left join ia_ust.v_cert_install_table ci on ci."tankID" = t."tankID" and ci.row_num = 1
	left join ia_ust.v_cert_of_installation_xwalk coi on ci."installationID"::text = coi.organization_value
	left join (select distinct on (ci."tankID")
		ci."tankID", ci."installationID"
		from ia_ust.v_cert_install_table ci
		where ci."installationID" in (4,7)
		order by ci."tankID", ci."row_num" 
	) cio on cio."tankID"::text = t."tankID"::text
where t."tankID" is not null;

create or replace view ia_ust.v_ust_tank_substance
as select distinct t."ustID" as facility_id,
	t."tankID" as tank_id,
	case 
		when s.substance_id is null then 47
		else s.substance_id
	end as substance_id
from ia_ust.tbltank t 
	left join ia_ust.tbltankcompartment c on t."tankID" = c."tankID" 
	left join ia_ust.tlkcompcontent cc on c."contentID" = cc."contentID" 
	left join ia_ust.v_substance_xwalk s on cc."contentDescription" = s.organization_value
where t."tankID" is not null;

create or replace view ia_ust.v_ust_compartment
as select distinct t."ustID"::text as facility_id,
	t."tankID"::int4 as tank_id,
	c."tankCompartmentID"::int4 as compartment_id,
	case
		when csx.compartment_status_id is null then 8
		else csx.compartment_status_id
	end as compartment_status_id,
	c."capacity"::int4 as compartment_capacity_gallons,
	case
		when flowshutoff."spillOverfillID" = 2 then 'Yes'
	end as overfill_prevention_flow_shutoff_device,
	case
		when highlevel."spillOverfillID" = 3 then 'Yes'
	end as overfill_prevention_high_level_alarm,
	case
		when overfillother."spillOverfillID" not in (2,3) and overfillother."spillOverfillID" is not null then 'Yes'
	end as overfill_prevention_other,
	case
		when c."catchmentBasin" = 1 or c."catchmentBasinSize" > 0 then 'Yes'
		when c."catchmentBasin" = 0 then 'No'
	end as spill_bucket_installed,
	case
		when c."spillProtection" = 1 then 'No'
		when c."spillProtection" = 0 then 'Yes'
	end as spill_prevention_not_required,
	sb.spill_bucket_wall_type_id,
	case
		when c."InterstitialMonitoring" is not null then 'Yes'
	end as tank_interstitial_monitoring,
	case
		when continuousleak."leakProtectionID" = 11 then 'Yes'
	end as automatic_tank_gauging_continuous_leak_detection,
	case
		when manualgauge."leakProtectionID" = 9 then 'Yes'
	end as tank_manual_tank_gauging,
	case
		when statinventory."leakProtectionID" = 8 then 'Yes'
	end as tank_statistical_inventory_reconciliation,
	case
		when tightnesstest."leakProtectionID" = 7 then 'Yes'
	end as tank_tightness_testing,
	case
		when inventorycont."leakProtectionID" = 12 then 'Yes'
	end as tank_inventory_control,
	case
		when groundwater."leakProtectionID" = 2 then 'Yes'
	end as tank_groundwater_monitoring,
	case
		when vapor."leakProtectionID" = 1 then 'Yes'
	end as tank_vapor_monitoring,
	case
		when releaseother."leakProtectionID" not in (1,2,12,7,8,9,11) and releaseother."leakProtectionID" is not null then 'Yes'
	end as tank_other_release_detection
from ia_ust.tbltankcompartment c 
	left join ia_ust.tbltank t on t."tankID" = c."tankID"
	left join (select "tankCompartmentID", cs."statusDescription", "statusStartDate" 
		from ia_ust.trelcomptostatus tcs 
			inner join ia_ust.tlkcompstatus cs on tcs."compStatusID" = cs."compStatusID" 
		where "statusEndDate" is null
	) sts on sts."tankCompartmentID" = c."tankCompartmentID"
	left join ia_ust.v_compartment_status_xwalk csx on sts."statusDescription" = csx.organization_value 
	left join ( select so."spillOverfillID", so."tankCompartmentID" from ia_ust.trelcomptospilloverfill so
	where so."spillOverfillID" = 2
	) flowshutoff on flowshutoff."tankCompartmentID" = c."tankCompartmentID"
	left join ( select so."spillOverfillID", so."tankCompartmentID" from ia_ust.trelcomptospilloverfill so
	where so."spillOverfillID" = 3
	) highlevel on highlevel."tankCompartmentID" = c."tankCompartmentID"
	left join ( select so."spillOverfillID", so."tankCompartmentID" from ia_ust.trelcomptospilloverfill so
	where so."spillOverfillID" not in (2,3) and so."spillOverfillID" is not null
	) overfillother on overfillother."tankCompartmentID" = c."tankCompartmentID"
	left join ia_ust.v_spill_bucket_wall_type_xwalk sb on c."Wall" = sb.organization_value 
	left join (select cl."leakProtectionID", cl."tankCompartmentID" from ia_ust.trelcomptoleakprotectio cl
	where cl."leakProtectionID" = 11
	) continuousleak on continuousleak."tankCompartmentID" = c."tankCompartmentID"
	left join (select cl."leakProtectionID", cl."tankCompartmentID" from ia_ust.trelcomptoleakprotectio cl
	where cl."leakProtectionID" = 9
	) manualgauge on manualgauge."tankCompartmentID" = c."tankCompartmentID"
	left join (select cl."leakProtectionID", cl."tankCompartmentID" from ia_ust.trelcomptoleakprotectio cl
	where cl."leakProtectionID" = 8
	) statinventory on statinventory."tankCompartmentID" = c."tankCompartmentID"
	left join (select cl."leakProtectionID", cl."tankCompartmentID" from ia_ust.trelcomptoleakprotectio cl
	where cl."leakProtectionID" = 7
	) tightnesstest on tightnesstest."tankCompartmentID" = c."tankCompartmentID"
	left join (select cl."leakProtectionID", cl."tankCompartmentID" from ia_ust.trelcomptoleakprotectio cl
	where cl."leakProtectionID" = 12
	) inventorycont on inventorycont."tankCompartmentID" = c."tankCompartmentID"
	left join (select cl."leakProtectionID", cl."tankCompartmentID" from ia_ust.trelcomptoleakprotectio cl
	where cl."leakProtectionID" = 2
	) groundwater on groundwater."tankCompartmentID" = c."tankCompartmentID"
	left join (select cl."leakProtectionID", cl."tankCompartmentID" from ia_ust.trelcomptoleakprotectio cl
	where cl."leakProtectionID" = 1
	) vapor on vapor."tankCompartmentID" = c."tankCompartmentID"
	left join (select cl."leakProtectionID", cl."tankCompartmentID" from ia_ust.trelcomptoleakprotectio cl
	where cl."leakProtectionID" not in (1,2,12,7,8,9,11) and cl."leakProtectionID" is not null
	) releaseother on releaseother."tankCompartmentID" = c."tankCompartmentID"
where c."tankCompartmentID" is not null;
	
create or replace view ia_ust.v_ust_compartment_substance
as select x."ustID" as facility_id,
	t."tankID" as tank_id,
	c."tankCompartmentID" as compartment_id,
	s.substance_id

from ia_ust.tblustsite x
	left join ia_ust.tbltank t on x."ustID" = t."ustID"
	left join ia_ust.tbltankcompartment c on c."tankID" = t."tankID"
	left join ia_ust.tlkcompcontent cc on c."contentID" = cc."contentID" 
	left join ia_ust.v_substance_xwalk s on cc."contentDescription" = s.organization_value
where c."tankCompartmentID" is not null;

create or replace view ia_ust.v_ust_piping
as select x."ustID" as facility_id,
	t."tankID" as tank_id,
	c."tankCompartmentID" as compartment_id,
	p."pipeID" as piping_id,
	ps.piping_style_id,
	case
		when p."pipingConstID" = 3 then 'Yes'
	end as safe_suction,
	case
		when p."pipingConstID" = 2 then 'Yes'
	end as american_suction,
	case
		when p."pipingConstID" = 4 then 'Yes'
	end as piping_material_frp,
	case
		when p."pipingConstID" = 3 then 'Yes'
	end as piping_material_gal_steel,
	case
		when p."pipingConstID" = 1 then 'Yes'
	end as piping_material_steel,
	case
		when p."pipingConstID" = 11 then 'Yes'
	end as piping_material_flex,
	case
		when p."pipeID" is null then 'Yes'
	end as piping_material_no_piping,
	case
		when p."pipingConstID" not in (1,3,4,11,null) then 'Yes'
	end piping_material_other,
	case
		when ld."pipeLeakDetectionID" in (1,2) then 'Yes'
	end as piping_line_leak_detector,
	case
		when ld."pipeLeakDetectionID" = 9 then 'Yes'
	end as piping_groundwater_monitoring,
	case
		when ld."pipeLeakDetectionID" = 8 then 'Yes'
	end as piping_vapor_monitoring,
	case
		when ld."pipeLeakDetectionID" = 4 then 'Yes'
	end as piping_statistical_inventory_reconciliation,
	case
		when ld."pipeLeakDetectionID" not in (1,2,4,9,8, null) then 'Yes'
	end as piping_release_detection_other,
	p."TransitionSumpPresent" as pipe_tank_top_sump
from ia_ust.tblustsite x
	left join ia_ust.tbltank t on x."ustID" = t."ustID" 
	left join ia_ust.tbltankcompartment c on c."tankID" = t."tankID" 
	left join ia_ust.tblpipe p on p."tankCompartmentID" = c."tankCompartmentID"
	left join ia_ust.v_piping_style_xwalk ps on p."pipeTypeID"::text = ps.organization_value::text
	left join ia_ust.trelpipetoleakdetection ld on ld."pipeID"::text = p."pipeID"::text
where p."pipeID" is not null;
	
create or replace view ia_ust.v_ust_facility_dispenser
as select x."ustID" as facility_id,
	d."DispenserID" as dispenser_id,
	case
		when d."UDCPresent" = 1 then 'Yes'
		when d."UDCPresent" = 0 then 'No'
	end as dispenser_udc,
	case
		when d."DoubleWall" = 1 then 'Double'
		when d."DoubleWall" = 0 then 'Single'
	end as dispenser_udc_wall_type
	
from ia_ust.tblustsite x
	left join ia_ust.tbldispensers d on x."ustID" = d."UstID"
where d."DispenserID" is not null;
	
	
	
	