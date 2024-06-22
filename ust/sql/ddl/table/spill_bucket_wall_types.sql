CREATE TABLE public.spill_bucket_wall_types (
    spill_bucket_wall_type_id integer  NOT NULL generated always as identity,
    spill_bucket_wall_type character varying(20)  NOT NULL );