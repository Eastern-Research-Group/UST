create or replace view hi_ust.v_ust_facility as
	with release_id as (
		select l."FacilityId" as facility_id,
			l."AltEventId",
			l."Date reported",
			l."LUSTLatestStatusDate",
			row_number() over (
				partition by l."FacilityId"
				order by l."Date reported" desc, 
				l."LUSTLatestStatusDate" desc,
				l."AltEventId" desc
				nulls last
			) as row_num
		from hi_ust."tblLUSTSite" l
	),
	owner_type as (
		select ca."FacilityID" as facility_id,
			ca."EndDate",
			ca."StartDate",
			ca."Owner Type:",
			row_number() over(
				partition by ca."FacilityID"
				order by ca."EndDate" desc,
				ca."StartDate" desc,
				ca."Owner Type:" desc
				nulls last
			) as row_num
		from hi_ust."tblContactAffiliation" ca
	),
	financial_responsibility AS (
    SELECT 
        fr."FacilityID",
        MAX(CASE WHEN fr."FRType" IN ('commercial insurance', 'Insurance', 'nsurance') THEN 'Yes' END) AS financial_responsibility_commercial_insurance,
        MAX(CASE WHEN fr."FRType" = 'Guarantee' THEN 'Yes' END) AS financial_responsibility_guarantee,
        MAX(CASE WHEN fr."FRType" = 'Letter of Credit' THEN 'Yes' END) AS financial_responsibility_letter_of_credit,
        MAX(CASE WHEN fr."FRType" LIKE 'Local Gov_t Bond Rating' THEN 'Yes' END) AS financial_responsibility_local_government_financial_test,
        MAX(CASE WHEN fr."FRType" = 'Risk Retention Group' THEN 'Yes' END) AS financial_responsibility_risk_retention_group,
        MAX(CASE WHEN fr."FRType" = 'Self Insured' THEN 'Yes' END) AS financial_responsibility_self_insurance_financial_test,
        MAX(CASE WHEN fr."FRType" = 'State Fund' THEN 'Yes' END) AS financial_responsibility_state_fund,
        MAX(CASE WHEN fr."FRType" = 'Surety Bond' THEN 'Yes' END) AS financial_responsibility_surety_bond,
        MAX(CASE WHEN fr."FRType" = 'Trust Fund' THEN 'Yes' END) AS financial_responsibility_trust_fund,
        MAX(CASE WHEN fr."FRType" = 'Other' THEN 'Yes' END) AS financial_responsibility_other_method
    FROM hi_ust."tblFacilityFR" fr
    GROUP BY fr."FacilityID"
)
	select distinct
	x."FacilityID"::text as facility_id,
	x."Facility Name" as facility_name,
	ot.owner_type_id,
	ft.facility_type_id as facility_type1,
	case
		when x."FacilityID" = '9101061' then 'Honolulu International Airport 200 Rodgers Blvd'
		else x."Street Address"
	end as facility_address1,
	case
		when z."City" = 'ZipCode Unknown' then null
		else z."City"
	end as facility_city,
	case
		when z."City" = 'Zipcode Unknown' then null
		else z."County"
	end as facility_county,
	case
		when z."ZIP Code" = '99999' then null
		else z."ZIP Code"
	end as facility_zip_code,
	case
		when s.facility_state is null then 'HI'
		else s.facility_state
	end as facility_state,
	x."LatitudeMeasure" as facility_latitude,
	x."LongitudeMeasure" as facility_longitude, 
	cs.coordinate_source_id,
	co."OrganizationFormalName" as facility_owner_company_name,
	CASE
        WHEN fr_agg.financial_responsibility_commercial_insurance IS NOT NULL OR
             fr_agg.financial_responsibility_guarantee IS NOT NULL OR
             fr_agg.financial_responsibility_letter_of_credit IS NOT NULL OR
             fr_agg.financial_responsibility_local_government_financial_test IS NOT NULL OR
             fr_agg.financial_responsibility_risk_retention_group IS NOT NULL OR
             fr_agg.financial_responsibility_self_insurance_financial_test IS NOT NULL OR
             fr_agg.financial_responsibility_state_fund IS NOT NULL OR
             fr_agg.financial_responsibility_surety_bond IS NOT NULL OR
             fr_agg.financial_responsibility_trust_fund IS NOT NULL OR
             fr_agg.financial_responsibility_other_method IS NOT NULL 
        THEN 'Yes'
    END AS financial_responsibility_obtained,
    fr_agg.financial_responsibility_commercial_insurance,
    fr_agg.financial_responsibility_guarantee,
    fr_agg.financial_responsibility_letter_of_credit,
    fr_agg.financial_responsibility_local_government_financial_test,
    fr_agg.financial_responsibility_risk_retention_group,
    fr_agg.financial_responsibility_self_insurance_financial_test,
    fr_agg.financial_responsibility_state_fund,
    fr_agg.financial_responsibility_surety_bond,
    fr_agg.financial_responsibility_trust_fund,
    fr_agg.financial_responsibility_other_method,
	case
		when r."AltEventId" is not null then 'Yes'
	end as ust_reported_release,
	r."AltEventId" as associated_ust_release_id
from hi_ust."tblFacility" x
	join owner_type o on x."FacilityID" = o.facility_id and o.row_num = 1
	left join hi_ust.v_owner_type_xwalk ot on o."Owner Type:" = ot.organization_value
	left join hi_ust.v_facility_type_xwalk ft on x."Facility Description" = ft.organization_value
	left join hi_ust."tlkpZIP" z on x."ZIP Linkage" = z."ZIP ID"
	left join hi_ust.v_state_xwalk s on z."State" = s.organization_value
	left join hi_ust."tblContactOrganization" co on x."Owner ID" = co."OwnerId"
	LEFT JOIN financial_responsibility fr_agg ON x."FacilityID" = fr_agg."FacilityID"
	join release_id r on x."FacilityID" = r.facility_id and r.row_num = 1
	left join hi_ust.v_coordinate_source_xwalk cs on x."HorizontalCollectionMethodName" = cs.organization_value;

create or replace view hi_ust.v_ust_tank as 
select distinct 
	x."FacilityID"::text as facility_id,
	x."TankID"::int4 as tank_id,
	x."AltTankID" as tank_name,
	ts.tank_status_id,
	case
		when x."Exempt" = true then 'No'
		when x."Exempt" = false then 'Yes'
	end as federally_regulated,
	case
		when x."EmergGenSoleUse" = true then 'Yes'
		when x."EmergGenSoleUse" = false then 'No'
	end as emergency_generator,
	case
		when multi_tank_count > 1 then 'Yes'
		else 'No'
	end as multiple_tanks,
	x."DateClosed"::date as tank_closure_date,
	x."InstalledDate"::date as tank_installation_date, 
	case
		when x."Compartment" = true then 'Yes'
		when x."Compartment" = false then 'No'
	end as compartmentalized_ust,
	tm.tank_material_description_id,
	case
		when x."TankCorrosionProtectionSacrificialAnodes" = false then 'No'
		when x."TankCorrosionProtectionSacrificialAnodes" = true then 'Yes'
	end as tank_corrosion_protection_sacrificial_anode,
	case
		when x."TankCorrosionProtectionImpressedCurrent" = false then 'No'
		when x."TankCorrosionProtectionImpressedCurrent" = true then 'Yes'
	end as tank_corrosion_protection_impressed_current,
	case
		when x."TankCorrosionProtectionNonCorrodible" = false then 'No'
		when x."TankCorrosionProtectionNonCorrodible" = true then 'Yes'
	end as tank_corrosion_protection_cathodic_not_required,
	case
		when x."TankCorrosionProtectionInteriorLining" = false then 'No'
		when x."TankCorrosionProtectionInteriorLining" = true then 'Yes'
	end as tank_corrosion_protection_interior_lining, 
	sc.tank_secondary_containment_id
from hi_ust."tblTank" x
	left join hi_ust.v_tank_status_xwalk ts on x."TankStatusDesc" = ts.organization_value
	left join ( select "FacilityID", count("TankID") as multi_tank_count
		from hi_ust."tblTank"
		group by "FacilityID"
	) mt on x."FacilityID" = mt."FacilityID"
	left join hi_ust.v_tank_material_description_xwalk tm on x."TankMatDesc" = tm.organization_value
	left join hi_ust.v_tank_secondary_containment_xwalk sc on x."TankModsDesc" = sc.organization_value;

create or replace view hi_ust.v_ust_tank_substance as
select distinct 
	x."FacilityID"::text as facility_id,
	x."TankID"::int4 as tank_id,
	x."AltTankID" as tank_name,
	case
		when s.substance_id is null then 47
		else s.substance_id
	end as substance_id
from hi_ust."tblTank" x
	left join v_substance_xwalk s on x."SubstanceDesc" = s.organization_value;

create or replace view hi_ust.v_ust_compartment as
select distinct
	x."FacilityID"::text as facility_id,
	x."TankID"::int4 as tank_id,
	c.compartment_id,
	cs.compartment_status_id,
	x."TankCapacity"::int4 as compartment_capacity_gallons,
	case
		when x."OverfillBallFloat" = false then 'No'
		when x."OverfillBallFloat" = true then 'Yes'
	end as overfill_prevention_ball_float_valve,
	case
		when x."OverfillFlapper" = false then 'No'
		when x."OverfillFlapper" = true then 'Yes'
	end as overfill_prevention_flow_shutoff_device,
	case
		when x."OverfillAlarm" = false then 'No'
		when x."OverfillAlarm" = true then 'Yes'
	end as overfill_prevention_high_level_alarm,
	case
		when x."SpillInstalled" = false then 'No'
		when x."SpillInstalled" = true then 'Yes'
	end as spill_bucket_installed,
	case
		when x."TankInterstitialDblWalled" = false then 'No'
		when x."TankInterstitialDblWalled" = true then 'Yes'
	end as tank_interstitial_monitoring,
	case
		when x."TankATG" = false then 'No'
		when x."TankATG" = true then 'Yes'
	end as tank_automatic_tank_gauging_release_detection,
	case
		when x."TankManualGauge" = false then 'No'
		when x."TankManualGauge" = true then 'Yes'
	end as tank_manual_tank_gauging,
	case
		when x."TankSIR" = false then 'No'
		when x."TankSIR" = true then 'Yes'
	end as tank_statistical_inventory_reconciliation,
	case
		when x."TankTightness" = false then 'No'
		when x."TankTightness" = true then 'Yes'
	end as tank_tightness_testing,
	case
		when x."TankInventoryControl" = false then 'No'
		when x."TankInventoryControl" = true then 'Yes'
	end as tank_inventory_control,
	case
		when x."TankGWMonitor" = false then 'No'
		when x."TankGWMonitor" = true then 'Yes'
	end as tank_groundwater_monitoring,
	case
		when x."TankVaporMonitor" = false then 'No'
		when x."TankVaporMonitor" = true then 'Yes'
	end as tank_vapor_monitoring,
	case
		when x."TankLDOther" = false then 'No'
		when x."TankLDOther" = true then 'Yes'
	end as tank_other_release_detection	
from hi_ust."tblTank" x
	join hi_ust.erg_compartment_id c on x."FacilityID"::text = c.facility_id::text and x."TankID"::text = c.tank_id::text and x."AltTankID"::text = c.tank_name::text
	left join hi_ust.v_compartment_status_xwalk cs on x."TankStatusDesc" = cs.organization_value;

create or replace view hi_ust.v_ust_piping as 
select distinct
	x."FacilityID"::text as facility_id,
	x."TankID"::int4 as tank_id,
	c.compartment_id,
	p.piping_id::text,
	ps.piping_style_id,
	case
		when x."PipeTypeDesc" = 'Safe Suction' then 'Yes'
	end as safe_suction,
	case
		when x."PipeTypeDesc" = 'U.S. Suction' then 'Yes'
	end as american_suction,
	pwt.piping_wall_type_id,
	case
		WHEN x."PipeMatDesc" = 'Fiberglass Reinforced Plastic'::text THEN 'Yes'::text
        WHEN x."PipeMatDesc" IS NULL THEN NULL::text
	end as piping_material_frp,
	case
		WHEN x."PipeMatDesc" = 'GALVANIZED STEEL'::text THEN 'Yes'::text
        WHEN x."PipeMatDesc" = 'Galvanized Steel'::text THEN 'Yes'::text
        WHEN x."PipeMatDesc" IS NULL THEN NULL::text
	end as piping_material_gal_steel,
	case
		WHEN x."PipeMatDesc" = 'BARE STEEL'::text THEN 'Yes'::text
        WHEN x."PipeMatDesc" = 'Bare Steel'::text THEN 'Yes'::text
        WHEN x."PipeMatDesc" IS NULL THEN NULL::text
	end as piping_material_steel,
	case
		WHEN x."PipeMatDesc" = 'Copper'::text THEN 'Yes'::text
        WHEN x."PipeMatDesc" IS NULL THEN NULL::text
	end as piping_material_copper,
	case
		WHEN x."PipeMatDesc" = 'Flexible Plastic'::text THEN 'Yes'::text
        WHEN x."PipeMatDesc" IS NULL THEN NULL::text
	end as piping_material_flex,
	case
		WHEN x."PipeMatDesc" = 'No Piping'::text THEN 'Yes'::text
        WHEN x."PipeMatDesc" IS NULL THEN NULL::text
	end as piping_material_no_piping,
	case
		WHEN x."PipeMatDesc" = 'Other'::text THEN 'Yes'::text
        WHEN x."PipeMatDesc" IS NULL THEN NULL::text
	end as piping_material_other,
	case
		WHEN x."PipeMatDesc" = 'Unknown'::text THEN 'Yes'::text
        WHEN x."PipeMatDesc" = 'UNKNOWN'::text THEN 'Yes'::text
        WHEN x."PipeMatDesc" IS NULL THEN NULL::text
	end as piping_material_unknown,
	case
		when x."PipeCorrosionProtectionSacrificialAnodes" = false then 'No'
		when x."PipeCorrosionProtectionSacrificialAnodes" = true then 'Yes'
	end as piping_corrosion_protection_sacrificial_anode,
	case
		when x."PipeCorrosionProtectionImpressedCurrent" = false then 'No'
		when x."PipeCorrosionProtectionImpressedCurrent" = true then 'Yes'
	end as piping_corrosion_protection_impressed_current,
	case
		when x."PipeCorrosionProtectionNonCorrodible" = false then 'No'
		when x."PipeCorrosionProtectionNonCorrodible" = true then 'Yes'
	end as piping_corrosion_protection_cathodic_not_required,
	case
		when x."PipeAutoLineLeakDetection" = false then 'No'
		when x."PipeAutoLineLeakDetection" = true then 'Yes'
	end as piping_line_leak_detector,
	case
		when x."PipeGWMonitoring" = false then 'No'
		when x."PipeGWMonitoring" = true then 'Yes'
	end as piping_groundwater_monitoring,
	case
		when x."PipeVaporMonitoring" = false then 'No'
		when x."PipeVaporMonitoring" = true then 'Yes'
	end as piping_vapor_monitoring,
	case
		when x."PipeInterstitialDblWalled" = false then 'No'
		when x."PipeInterstitialDblWalled" = true then 'Yes'
	end as piping_interstitial_monitoring,
	case
		when x."PipeSIR" = false then 'No'
		when x."PipeSIR" = true then 'Yes'
	end as piping_statistical_inventory_reconciliation,
	case
		when x."PipeLDOther" = false then 'No'
		when x."PipeLDOther" = true then 'Yes'
	end as piping_release_detection_other
from hi_ust."tblTank" x
	join hi_ust.erg_compartment_id c on x."FacilityID"::text = c.facility_id::text and x."TankID"::text = c.tank_id::text and x."AltTankID"::text = c.tank_name::text
	join hi_ust.erg_piping_id p on x."FacilityID"::text = c.facility_id::text and x."TankID"::text = c.tank_id::text and x."AltTankID"::text = c.tank_name::text and c.compartment_id::text = p.compartment_id::text
	left join hi_ust.v_piping_style_xwalk ps on x."PipeTypeDesc" = ps.organization_value
	left join hi_ust.v_piping_wall_type_xwalk pwt on x."PipeModDesc" = pwt.organization_value;
