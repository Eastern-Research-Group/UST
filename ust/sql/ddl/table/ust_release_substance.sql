CREATE TABLE public.ust_release_substance (
    ust_release_substance_id integer  NOT NULL generated always as identity,
    ust_release_id integer  NOT NULL ,
    substance_id integer  NOT NULL ,
    quantity_released double precision  NULL ,
    unit character varying(20)  NULL ,
    substance_comment character varying(4000)  NULL );

ALTER TABLE public.ust_release_substance ADD CONSTRAINT release_release_fk FOREIGN KEY (ust_release_id) REFERENCES ust_release(ust_release_id);

ALTER TABLE public.ust_release_substance ADD CONSTRAINT release_substance_fk FOREIGN KEY (substance_id) REFERENCES substances(substance_id);

ALTER TABLE public.ust_release_substance ADD CONSTRAINT ust_release_substance_pkey PRIMARY KEY (ust_release_substance_id);

CREATE UNIQUE INDEX ust_release_substance_pkey ON public.ust_release_substance USING btree (ust_release_substance_id)

CREATE INDEX ust_release_substance_ust_release_id_idx ON public.ust_release_substance USING btree (ust_release_id)