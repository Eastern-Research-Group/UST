CREATE TABLE public.ust_release_cause (
    ust_release_cause_id integer  NOT NULL generated always as identity,
    ust_release_id integer  NOT NULL ,
    cause_id integer  NOT NULL ,
    cause_comment character varying(4000)  NULL );

ALTER TABLE public.ust_release_cause ADD CONSTRAINT ust_release_cause_pkey PRIMARY KEY (ust_release_cause_id);

ALTER TABLE public.ust_release_cause ADD CONSTRAINT release_cause_fk FOREIGN KEY (cause_id) REFERENCES causes(cause_id);

ALTER TABLE public.ust_release_cause ADD CONSTRAINT release_cause_release_fk FOREIGN KEY (ust_release_id) REFERENCES ust_release(ust_release_id);

CREATE UNIQUE INDEX ust_release_cause_pkey ON public.ust_release_cause USING btree (ust_release_cause_id)

CREATE INDEX ust_release_cause_ust_release_id_idx ON public.ust_release_cause USING btree (ust_release_id)