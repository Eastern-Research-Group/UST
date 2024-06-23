CREATE TABLE public.tx_analysis_chemical_hazard (
    facility_id character varying(4000)  NULL ,
    chemical_id character varying(4000)  NULL ,
    category character varying(4000)  NULL ,
    category_value character varying(4000)  NULL );

CREATE INDEX tx_analysis_chemical_hazard_idx ON public.tx_analysis_chemical_hazard USING btree (chemical_id)