CREATE TABLE public.owner_types (
    owner_type_id integer  NOT NULL generated always as identity,
    owner_type character varying(100)  NOT NULL );

ALTER TABLE public.owner_types ADD CONSTRAINT owner_types_pkey PRIMARY KEY (owner_type_id);

CREATE UNIQUE INDEX owner_types_pkey ON public.owner_types USING btree (owner_type_id)

CREATE INDEX owner_types_idx ON public.owner_types USING btree (owner_type)