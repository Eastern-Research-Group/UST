create or replace view "ia_ust"."v_ust_facility" as
 SELECT DISTINCT (x."ustID")::text AS facility_id,
    x."ustName" AS facility_name,
    o.owner_type_id,
    l."loc1Address" AS facility_address1,
    l."loc2Address" AS facility_address2,
    ci."CityName" AS facility_city,
    co."countyName" AS facility_county,
    l."locZip" AS facility_zip_code,
    s.facility_state,
    l.latitude AS facility_latitude,
    l.longitude AS facility_longitude,
    cs.coordinate_source_id,
    ow.orgname AS facility_owner_company_name,
    op.orgname AS facility_operator_company_name,
        CASE
            WHEN (x."financialCode" IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_obtained,
        CASE
            WHEN (x."financialCode" = (9.0)::double precision) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_bond_rating_test,
        CASE
            WHEN (x."financialCode" = ANY (ARRAY[(15.0)::double precision, (2.0)::double precision])) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_commercial_insurance,
        CASE
            WHEN (x."financialCode" = (3.0)::double precision) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_guarantee,
        CASE
            WHEN (x."financialCode" = (5.0)::double precision) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_letter_of_credit,
        CASE
            WHEN (x."financialCode" = (10.0)::double precision) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_local_government_financial_test,
        CASE
            WHEN (x."financialCode" = (1.0)::double precision) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_self_insurance_financial_test,
        CASE
            WHEN (x."financialCode" = (6.0)::double precision) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_state_fund,
        CASE
            WHEN (x."financialCode" = (4.0)::double precision) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_surety_bond,
        CASE
            WHEN (x."financialCode" = (8.0)::double precision) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_trust_fund,
        CASE
            WHEN (x."financialCode" <> ALL (ARRAY[(9.0)::double precision, (15.0)::double precision, (2.0)::double precision, (3.0)::double precision, (5.0)::double precision, (10.0)::double precision, (1.0)::double precision, (6.0)::double precision, (4.0)::double precision, (8.0)::double precision, NULL::double precision])) THEN 'Yes'::text
            ELSE NULL::text
        END AS financial_responsibility_other_method,
        CASE
            WHEN (lust.lustid IS NOT NULL) THEN 'Yes'::text
            ELSE NULL::text
        END AS ust_reported_release,
    (lust.lustid)::text AS associated_ust_release_id
   FROM (((((((((ia_ust.tblustsite x
     LEFT JOIN ia_ust.v_owner_type_xwalk o ON (((x."ownerTypeID")::text = (o.organization_value)::text)))
     LEFT JOIN ia_ust.tbllocation l ON (((x."locID")::text = (l."locID")::text)))
     LEFT JOIN ia_ust.tlkcitystandard ci ON ((l."CityID" = (ci."CityID")::double precision)))
     LEFT JOIN ia_ust.tlkcounty co ON ((l."countyID" = (co."countyID")::double precision)))
     LEFT JOIN ia_ust.v_state_xwalk s ON ((l."locStateCD" = (s.organization_value)::text)))
     LEFT JOIN ia_ust.v_coordinate_source_xwalk cs ON (((l."colMthID")::text = (cs.organization_value)::text)))
     LEFT JOIN ia_ust.v_owner_table_name ow ON (((ow.ustid = x."ustID") AND (ow.row_num = 1))))
     LEFT JOIN ia_ust.v_operator_table_name op ON (((op.ustid = x."ustID") AND (op.row_num = 1))))
     LEFT JOIN ia_ust.v_release_table lust ON (((lust.ustid = x."ustID") AND (lust.row_num = 1))))
  WHERE ((s.facility_state)::text = 'IA'::text);