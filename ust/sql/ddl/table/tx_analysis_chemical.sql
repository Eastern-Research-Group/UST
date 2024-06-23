CREATE TABLE public.tx_analysis_chemical (
    facility_id character varying(4000)  NULL ,
    chemical_id character varying(4000)  NULL ,
    chemical_name character varying(4000)  NULL ,
    casnumber character varying(4000)  NULL ,
    ehs character varying(4000)  NULL ,
    pure character varying(4000)  NULL ,
    mixture character varying(4000)  NULL ,
    solid character varying(4000)  NULL ,
    liquid character varying(4000)  NULL ,
    gas character varying(4000)  NULL ,
    aveamount character varying(4000)  NULL ,
    aveamountcode character varying(4000)  NULL ,
    maxamount character varying(4000)  NULL ,
    maxamountcode character varying(4000)  NULL ,
    sameaslastyear character varying(4000)  NULL ,
    daysonsite character varying(4000)  NULL ,
    maxamtlargestcontainer character varying(4000)  NULL ,
    belowreportingthresholds character varying(4000)  NULL ,
    confidentialstoragelocs character varying(4000)  NULL ,
    tradesecret character varying(4000)  NULL ,
    file_no character varying  NULL );

CREATE INDEX tac_idx ON public.tx_analysis_chemical USING btree (facility_id)

CREATE INDEX tac_idx2 ON public.tx_analysis_chemical USING btree (chemical_id)

CREATE INDEX tac_idx3 ON public.tx_analysis_chemical USING btree (chemical_name)

CREATE INDEX tac_idx4 ON public.tx_analysis_chemical USING btree (casnumber)

CREATE INDEX tx_analysis_chemical_idx ON public.tx_analysis_chemical USING btree (chemical_id)