CREATE TABLE public.spill_bucket_wall_types (
    "spill_bucket_wall_type_id" integer  NOT NULL generated always as identity,
    "spill_bucket_wall_type" character varying(20)  NOT NULL );

ALTER TABLE public.spill_bucket_wall_types ADD CONSTRAINT spill_bucket_wall_types_pkey PRIMARY KEY (spill_bucket_wall_type_id);

CREATE UNIQUE INDEX spill_bucket_wall_types_pkey ON public.spill_bucket_wall_types USING btree (spill_bucket_wall_type_id)

CREATE INDEX spill_bucket_wall_types_idx ON public.spill_bucket_wall_types USING btree (spill_bucket_wall_type)

CREATE INDEX spill_bucket_wall_types_desc_idx ON public.spill_bucket_wall_types USING btree (spill_bucket_wall_type)