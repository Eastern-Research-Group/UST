CREATE TABLE public.facility_types (
    "facility_type_id" integer  NOT NULL generated always as identity,
    "facility_type" character varying(100)  NOT NULL );

ALTER TABLE public.facility_types ADD CONSTRAINT facility_types_pkey PRIMARY KEY (facility_type_id);

CREATE UNIQUE INDEX facility_types_pkey ON public.facility_types USING btree (facility_type_id)

CREATE INDEX facility_types_idx ON public.facility_types USING btree (facility_type)