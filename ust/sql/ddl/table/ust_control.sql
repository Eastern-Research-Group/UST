CREATE TABLE public.ust_control (
    ust_control_id integer  NOT NULL generated always as identity,
    organization_id character varying(10)  NULL ,
    date_received date  NULL ,
    date_processed date  NULL ,
    data_source text  NULL ,
    comments text  NULL ,
    organization_compartment_flag character varying(1)  NULL );

ALTER TABLE archive."archive.ust_control" ADD CONSTRAINT ust_control_pkey PRIMARY KEY (control_id);

ALTER TABLE public.ust_control ADD CONSTRAINT ust_control_pkey PRIMARY KEY (ust_control_id);

ALTER TABLE example."example.ust_control" ADD CONSTRAINT ust_control_pkey PRIMARY KEY (ust_control_id);

ALTER TABLE public.ust_control ADD CONSTRAINT ust_control_org_comp_flag_chk CHECK (((organization_compartment_flag)::text = ANY (ARRAY['Y'::text, 'N'::text])));

ALTER TABLE example."example.ust_control" ADD CONSTRAINT ust_control_org_comp_flag_chk CHECK (((organization_compartment_flag)::text = ANY (ARRAY['Y'::text, 'N'::text])));

CREATE UNIQUE INDEX ust_control_pkey ON public.ust_control USING btree (ust_control_id)

CREATE INDEX ust_control_organization_id_idx ON public.ust_control USING btree (organization_id)