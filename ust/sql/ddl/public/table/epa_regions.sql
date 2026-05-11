CREATE TABLE public.epa_regions (
    "organization_id" character varying(2)  NOT NULL ,
    "epa_region" integer  NOT NULL );

ALTER TABLE public.epa_regions ADD CONSTRAINT epa_regions_pkey PRIMARY KEY (organization_id);

CREATE UNIQUE INDEX epa_regions_pkey ON public.epa_regions USING btree (organization_id)