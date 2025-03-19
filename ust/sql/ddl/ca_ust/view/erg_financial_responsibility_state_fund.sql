create or replace view "ca_ust"."erg_financial_responsibility_state_fund" as
 SELECT DISTINCT facility."CERS ID" AS facility_id,
        CASE
            WHEN ((facility."State Fund _and _CFO letter" = 'Yes'::text) OR (facility."State Fund _and _CD" = 'Yes'::text)) THEN 'Yes'::text
            WHEN ((facility."State Fund _and _CFO letter" = 'No'::text) OR (facility."State Fund _and _CD" = 'No'::text)) THEN 'No'::text
            ELSE NULL::text
        END AS financial_responsibility_state_fund
   FROM ca_ust.facility;