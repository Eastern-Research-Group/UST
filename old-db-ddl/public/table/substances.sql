CREATE TABLE public.substances (
    "substance_id" integer  NOT NULL generated always as identity,
    "substance" character varying(200)  NOT NULL ,
    "substance_group" character varying(30)  NOT NULL ,
    "federally_regulated" character varying(1)  NULL ,
    "hazardous_substance" character varying(1)  NULL ,
    "inactive_flag" character varying(1)  NULL ,
    "ust_flag" character varying(1)  NULL ,
    "release_flag" character varying(1)  NULL ,
    "notes" character varying(4000)  NULL );

ALTER TABLE public.substances ADD CONSTRAINT substances_pkey PRIMARY KEY (substance_id);

CREATE INDEX substances_desc_idx ON public.substances USING btree (substance);

CREATE INDEX substances_idx ON public.substances USING btree (substance);
