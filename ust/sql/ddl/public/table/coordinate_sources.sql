CREATE TABLE public.coordinate_sources (
    "coordinate_source_id" integer  NOT NULL generated always as identity,
    "coordinate_source" character varying(100)  NOT NULL );

ALTER TABLE public.coordinate_sources ADD CONSTRAINT coordinate_sources_pkey PRIMARY KEY (coordinate_source_id);

CREATE UNIQUE INDEX coordinate_sources_pkey ON public.coordinate_sources USING btree (coordinate_source_id)

CREATE INDEX coordinate_sources_idx ON public.coordinate_sources USING btree (coordinate_source)