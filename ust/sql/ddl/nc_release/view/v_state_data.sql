create or replace view "nc_release"."v_state_data" as
 SELECT DISTINCT y."IncidentNumber",
    x."USTNum",
    y."IncidentName",
    y."FacilID",
    y."Address",
    y."CityTown",
    y."State",
    y."County",
    y."ZipCode",
    y."LatDec",
    y."LongDec",
    y."HCS_Res",
    y."HCS_Ref",
    y."Reliability",
    y."DateReported",
    y."CloseOut",
    y."Sources",
    y."Causes",
    y."InterCons",
    y."Comm",
    y.reg,
    y."LUSTStatus",
    y."MTBE",
    y."ReleaseCode",
    y."RBCA_GW",
    y."PETOPT",
    y."HowReleaseDetected",
    y."CauseOfRelease",
    y."RemediationStrategy",
    y."OwnershipType",
    y."RSource",
    y."Substance",
    y."Plume",
    y."RCause",
    y."LURFiled",
    y."EPA Status"
   FROM ((( SELECT a."USTNum",
            max(b.sort_order) AS sort_order
           FROM (nc_release."LUST_Data_050523" a
             JOIN nc_release.status_order b ON ((a."EPA Status" = b."EPA Status")))
          GROUP BY a."USTNum") x
     JOIN nc_release."LUST_Data_050523" y ON ((x."USTNum" = y."USTNum")))
     JOIN nc_release.status_order z ON ((x.sort_order = z.sort_order)));