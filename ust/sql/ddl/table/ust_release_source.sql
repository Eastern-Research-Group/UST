CREATE TABLE public.ust_release_source (
    ust_release_source_id integer  NOT NULL generated always as identity,
    ust_release_id integer  NOT NULL ,
    source_id integer  NOT NULL ,
    source_comment character varying(4000)  NULL );

ALTER TABLE public.ust_release_source ADD CONSTRAINT ust_release_source_pkey PRIMARY KEY (ust_release_source_id);

ALTER TABLE public.ust_release_source ADD CONSTRAINT release_source_fk FOREIGN KEY (source_id) REFERENCES sources(source_id);

ALTER TABLE public.ust_release_source ADD CONSTRAINT release_source_release_fk FOREIGN KEY (ust_release_id) REFERENCES ust_release(ust_release_id);

CREATE UNIQUE INDEX ust_release_source_pkey ON public.ust_release_source USING btree (ust_release_source_id)

CREATE INDEX ust_release_source_ust_release_id_idx ON public.ust_release_source USING btree (ust_release_id)