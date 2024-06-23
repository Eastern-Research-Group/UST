CREATE TABLE public.pipe_tank_top_sump_wall_types (
    pipe_tank_top_sump_wall_type_id integer  NOT NULL generated always as identity,
    pipe_tank_top_sump_wall_type character varying(20)  NOT NULL );

ALTER TABLE public.pipe_tank_top_sump_wall_types ADD CONSTRAINT pipe_tank_top_sump_wall_types_pkey PRIMARY KEY (pipe_tank_top_sump_wall_type_id);

CREATE UNIQUE INDEX pipe_tank_top_sump_wall_types_pkey ON public.pipe_tank_top_sump_wall_types USING btree (pipe_tank_top_sump_wall_type_id)

CREATE INDEX pipe_tank_top_sump_wall_types_idx ON public.pipe_tank_top_sump_wall_types USING btree (pipe_tank_top_sump_wall_type)