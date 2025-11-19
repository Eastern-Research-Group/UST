CREATE TABLE public.compartment_statuses (
    "compartment_status_id" integer  NOT NULL generated always as identity,
    "compartment_status" character varying(100)  NULL ,
    "status_hierarchy" integer  NULL ,
    "status_comment" character varying(4000)  NULL );

ALTER TABLE public.compartment_statuses ADD CONSTRAINT compartment_statuses_pkey PRIMARY KEY (compartment_status_id);

CREATE UNIQUE INDEX compartment_statuses_pkey ON public.compartment_statuses USING btree (compartment_status_id)

CREATE INDEX compartment_statuses_idx ON public.compartment_statuses USING btree (compartment_status)

CREATE INDEX compartment_statuses_desc_idx ON public.compartment_statuses USING btree (compartment_status)