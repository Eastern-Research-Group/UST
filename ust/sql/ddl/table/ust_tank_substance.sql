CREATE TABLE public.ust_tank_substance (
    ust_tank_substance_id integer  NOT NULL generated always as identity,
    ust_tank_id integer  NOT NULL ,
    substance_id integer  NOT NULL ,
    substance_casno character varying(12)  NULL );

ALTER TABLE public.ust_tank_substance ADD CONSTRAINT ust_tank_substance_pkey PRIMARY KEY (ust_tank_substance_id);

ALTER TABLE public.ust_tank_substance ADD CONSTRAINT ust_tank_substance_sub_fk FOREIGN KEY (substance_id) REFERENCES substances(substance_id);

ALTER TABLE public.ust_tank_substance ADD CONSTRAINT ust_tank_substance_tankid_fk FOREIGN KEY (ust_tank_id) REFERENCES ust_tank(ust_tank_id);

CREATE UNIQUE INDEX ust_tank_substance_pkey ON public.ust_tank_substance USING btree (ust_tank_substance_id)

CREATE INDEX ust_tank_substance_sub_idx ON public.ust_tank_substance USING btree (substance_id)

CREATE INDEX ust_tank_substance_tankid_idx ON public.ust_tank_substance USING btree (ust_tank_id)

CREATE INDEX ust_tank_substance_casno_idx ON public.ust_tank_substance USING btree (substance_casno)