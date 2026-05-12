CREATE TABLE public.piping_wall_types (
    "piping_wall_type_id" integer  NOT NULL generated always as identity,
    "piping_wall_type" character varying(20)  NOT NULL );

ALTER TABLE public.piping_wall_types ADD CONSTRAINT piping_wall_types_pkey PRIMARY KEY (piping_wall_type_id);

CREATE UNIQUE INDEX piping_wall_types_pkey ON public.piping_wall_types USING btree (piping_wall_type_id)

CREATE INDEX piping_wall_types_idx ON public.piping_wall_types USING btree (piping_wall_type)

CREATE INDEX piping_wall_types_desc_idx ON public.piping_wall_types USING btree (piping_wall_type)