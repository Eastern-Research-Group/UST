CREATE TABLE public.release_discovered (
    "release_discovered_id" integer  NOT NULL generated always as identity,
    "release_discovered" character varying(100)  NULL );

ALTER TABLE public.release_discovered ADD CONSTRAINT release_discovered_pkey PRIMARY KEY (release_discovered_id);
