CREATE TABLE public.release_control (
    release_control_id integer  NOT NULL generated always as identity,
    organization_id character varying(10)  NULL ,
    date_received date  NULL ,
    date_processed date  NULL ,
    data_source text  NULL ,
    comments text  NULL );

ALTER TABLE public.release_control ADD CONSTRAINT release_control_pkey PRIMARY KEY (release_control_id);

CREATE UNIQUE INDEX release_control_pkey ON public.release_control USING btree (release_control_id)

CREATE INDEX release_control_organization_id_idx ON public.release_control USING btree (organization_id)