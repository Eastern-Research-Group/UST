


/*********** v_ust_facility ***********/


--View definition for md_ust.v_ust_facility:
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."LocName")::character varying(100) AS facility_name,
    (x."LocStr")::character varying(100) AS facility_address1,
    (x."City")::character varying(100) AS facility_city,
    (x."County")::character varying(100) AS facility_county,
    (x."ZIP")::character varying(10) AS facility_zip_code,
    (mo."Name")::character varying(100) AS facility_owner_company_name,
        CASE
            WHEN (x."Finance" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_obtained,
        CASE
            WHEN (x."LocGovBondRating" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_bond_rating_test,
        CASE
            WHEN (x."Insurance" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_commercial_insurance,
        CASE
            WHEN (x."Guarantee" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_guarantee,
        CASE
            WHEN (x."LtrCredit" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_letter_of_credit,
        CASE
            WHEN (x."LocGovFinancialTest" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_local_government_financial_test,
        CASE
            WHEN (x."RiskRetention" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_risk_retention_group,
        CASE
            WHEN (x."SelfInsurance" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_self_insurance_financial_test,
        CASE
            WHEN (x."StateFunds" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_state_fund,
        CASE
            WHEN (x."SuretyBond" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_surety_bond,
        CASE
            WHEN (x."StandByTrustFund" IS TRUE) THEN 'Yes'::text
            ELSE 'No'::text
        END AS financial_responsibility_trust_fund,
    (x."FinanceOther")::character varying(500) AS financial_responsibility_other_method,
        CASE
            WHEN (rl.ust_facility_id IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS ust_reported_release,
    (md_ust.get_latest_release_id((rl.ust_facility_id)::character varying))::character varying(40) AS associated_ust_release_id,
    'MD'::text AS facility_state,
    3 AS facility_epa_region,
    ft.facility_type_id AS facility_type1
   FROM ((((md_ust.md_facility_combined x
     LEFT JOIN md_ust.md_supp_tank_data z ON ((x."FacilityID" = z."FacilityID")))
     LEFT JOIN md_ust.v_facility_type_xwalk ft ON ((z."FacilityDesc" = (ft.organization_value)::text)))
     LEFT JOIN md_ust.md_owner mo ON ((x."OwnerID" = mo."OwnerID")))
     LEFT JOIN md_ust.md_release_linkages rl ON ((((x."FacilityID")::character varying)::text = ((rl.ust_facility_id)::character varying)::text)))
  WHERE (NOT (((x."FacilityID")::character varying(50))::text IN ( SELECT erg_unregulated_facilities.facility_id
           FROM md_ust.erg_unregulated_facilities)));;




/*********** v_ust_tank ***********/


--View definition for md_ust.v_ust_tank:
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    (x."TankID")::integer AS tank_id,
    vtsx.tank_status_id,
        CASE
            WHEN (x."TankMatDesc" = 'Airport Hydrant System'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS airport_hydrant_system,
    (x."DateClosed")::date AS tank_closure_date,
    (x."DateInstalled")::date AS tank_installation_date,
        CASE
            WHEN (md_ust.get_compartment_data(x."FacilityID", x."TankID") = 1) THEN 'No'::text
            ELSE 'Yes'::text
        END AS compartmentalized_ust,
    (md_ust.get_compartment_data(x."FacilityID", x."TankID"))::integer AS number_of_compartments,
    vtmdx.tank_material_description_id,
    vtscx.tank_secondary_containment_id,
        CASE
            WHEN (x."TankMatDesc" ~~ '%Impressed Current%'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS tank_corrosion_protection_impressed_current,
        CASE
            WHEN (x."TankMatDesc" ~~ '%Lined Interior%'::text) THEN 'Yes'::text
            ELSE 'No'::text
        END AS tank_corrosion_protection_interior_lining,
        CASE
            WHEN (x."TankMatDesc" = ANY (ARRAY['Cathodically Protected Steel (Supplemental Anodes Added)'::text, 'Cathodically Protected Steel (Coating w/CP - Galvanic)'::text])) THEN 'Yes'::text
            ELSE 'No'::text
        END AS tank_corrosion_protection_sacrificial_anode
   FROM (((md_ust.md_tanks_combined x
     LEFT JOIN md_ust.v_tank_status_xwalk vtsx ON (((vtsx.organization_value)::text = x."TankStatusDesc")))
     LEFT JOIN md_ust.v_tank_material_description_xwalk vtmdx ON (((vtmdx.organization_value)::text = x."TankMatDesc")))
     LEFT JOIN md_ust.v_tank_secondary_containment_xwalk vtscx ON (((vtscx.organization_value)::text = x."TankModsDesc")))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM md_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));;




/*********** v_ust_tank_substance ***********/


--View definition for md_ust.v_ust_tank_substance:
 SELECT DISTINCT (x."FacilityID")::character varying(50) AS facility_id,
    x."TankID" AS tank_id,
    sx.substance_id
   FROM (md_ust.md_tanks_combined x
     JOIN md_ust.v_substance_xwalk sx ON ((x."SubstanceDesc" = (sx.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM md_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));;




/*********** v_ust_compartment ***********/


--View definition for md_ust.v_ust_compartment:
 SELECT DISTINCT c.facility_id,
    c.tank_id,
    c.compartment_id,
    (x."tblCompartment_Compartment")::character varying(50) AS compartment_name,
    ts.compartment_status_id,
    (x."Gallons")::integer AS compartment_capacity_gallons
   FROM ((md_ust.md_tanks_combined x
     JOIN md_ust.erg_compartment_id c ON (((((x."FacilityID")::character varying)::text = (c.facility_id)::text) AND ((x."TankID")::integer = c.tank_id) AND ((c.compartment_name)::text = x."tblCompartment_Compartment"))))
     LEFT JOIN md_ust.v_compartment_status_xwalk ts ON ((x."TankStatusDesc" = (ts.organization_value)::text)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM md_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));;




/*********** v_ust_compartment_substance ***********/


--View definition for md_ust.v_ust_compartment_substance:
 SELECT DISTINCT c.facility_id,
    c.tank_id,
    sx.substance_id,
    c.compartment_id
   FROM ((md_ust.md_tanks_combined x
     JOIN md_ust.v_substance_xwalk sx ON ((x."SubstanceDesc" = (sx.organization_value)::text)))
     JOIN md_ust.erg_compartment_id c ON (((((x."FacilityID")::character varying)::text = (c.facility_id)::text) AND ((x."TankID")::integer = c.tank_id) AND ((c.compartment_name)::text = x."tblCompartment_Compartment"))))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM md_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));;




/*********** v_ust_piping ***********/


--View definition for md_ust.v_ust_piping:
 SELECT DISTINCT (c.piping_id)::character varying(50) AS piping_id,
    c.facility_id,
    c.tank_id,
    c.compartment_id,
        CASE x."PipeMatDesc"
            WHEN 'Fiberglass Reinforced Plastic'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_frp,
        CASE
            WHEN (x."PipeMatDesc" = ANY (ARRAY['Galvanized Steel'::text, 'Bare or Galvanized Steel'::text])) THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_gal_steel,
        CASE x."PipeMatDesc"
            WHEN 'Steel-slvd. in PVC, FRP or Plastic'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_steel,
        CASE
            WHEN (x."PipeMatDesc" = ANY (ARRAY['Copper (cathodically protected)'::text, 'Copper'::text, 'Copper sleeved in plastic'::text])) THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_copper,
        CASE x."PipeMatDesc"
            WHEN 'Flexible Plastic'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_flex,
        CASE x."PipeMatDesc"
            WHEN 'No Piping'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_no_piping,
        CASE x."PipeMatDesc"
            WHEN 'Other'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_other,
        CASE x."PipeMatDesc"
            WHEN 'Unknown'::text THEN 'Yes'::text
            ELSE 'No'::text
        END AS piping_material_unknown
   FROM (md_ust.md_tanks_combined x
     JOIN md_ust.erg_piping_id c ON ((((x."FacilityID")::integer = (c.facility_id)::integer) AND ((x."TankID")::integer = c.tank_id) AND (x."tblCompartment_Compartment" = (c.compartment_name)::text))))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM md_ust.erg_unregulated_tanks unreg
          WHERE ((((x."FacilityID")::character varying(50))::text = (unreg.facility_id)::text) AND ((x."TankID")::integer = unreg.tank_id)))));;

