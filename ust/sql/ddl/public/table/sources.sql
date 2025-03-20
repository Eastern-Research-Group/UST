CREATE TABLE public.sources (
    "source_id" integer  NOT NULL generated always as identity,
    "source" character varying(200)  NOT NULL );

ALTER TABLE ca_release."ca_release.sources" ADD CONSTRAINT sources_pkey PRIMARY KEY (state_value);

ALTER TABLE public.sources ADD CONSTRAINT sources_pkey PRIMARY KEY (source_id);

CREATE INDEX sources_idx ON public.sources USING btree (source)

CREATE UNIQUE INDEX sources_pkey ON public.sources USING btree (source_id)