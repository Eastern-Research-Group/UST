CREATE TABLE public.ust_compartment_substance (
    ust_compartment_substance_id integer  NOT NULL generated always as identity,
    ust_tank_substance_id integer  NOT NULL ,
    ust_compartment_id integer  NOT NULL ,
    substance_comment character varying(4000)  NULL );

ALTER TABLE public.ust_compartment_substance ADD CONSTRAINT ust_compartment_substance_compd_fk FOREIGN KEY (ust_compartment_id) REFERENCES ust_compartment(ust_compartment_id);

ALTER TABLE public.ust_compartment_substance ADD CONSTRAINT ust_compartment_substance_pkey PRIMARY KEY (ust_compartment_substance_id);

ALTER TABLE public.ust_compartment_substance ADD CONSTRAINT ust_compartment_substance_ts_fk FOREIGN KEY (ust_tank_substance_id) REFERENCES ust_tank_substance(ust_tank_substance_id);

CREATE UNIQUE INDEX ust_compartment_substance_pkey ON public.ust_compartment_substance USING btree (ust_compartment_substance_id)

CREATE INDEX ust_compartment_substance_ts_idx ON public.ust_compartment_substance USING btree (ust_tank_substance_id)

CREATE INDEX ust_compartment_substance_compid_idx ON public.ust_compartment_substance USING btree (ust_compartment_id)