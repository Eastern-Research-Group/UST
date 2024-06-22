CREATE TABLE public.piping_wall_types (
    piping_wall_type_id integer  NOT NULL generated always as identity,
    piping_wall_type character varying(20)  NOT NULL );