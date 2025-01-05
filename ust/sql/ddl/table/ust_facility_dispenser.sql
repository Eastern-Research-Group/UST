CREATE TABLE public.ust_facility_dispenser (
    facility_dispenser_id integer  NOT NULL generated always as identity,
    ust_facility_id integer  NOT NULL ,
    dispenser_id character varying(50)  NOT NULL ,
    dispenser_udc character varying(7)  NULL ,
    dispenser_udc_wall_type_id integer  NULL ,
    dispenser_comment character varying(4000)  NULL );

ALTER TABLE public.ust_facility_dispenser ADD CONSTRAINT facility_dispenser_fac_fk FOREIGN KEY (ust_facility_id) REFERENCES ust_facility(ust_facility_id);

ALTER TABLE public.ust_facility_dispenser ADD CONSTRAINT facility_dispenser_pk PRIMARY KEY (facility_dispenser_id);

ALTER TABLE public.ust_facility_dispenser ADD CONSTRAINT facility_dispenser_dispwt_fk FOREIGN KEY (dispenser_udc_wall_type_id) REFERENCES dispenser_udc_wall_types(dispenser_udc_wall_type_id);

ALTER TABLE public.ust_facility_dispenser ADD CONSTRAINT ust_facility_dispenser_unique UNIQUE (ust_facility_id, dispenser_id);

CREATE UNIQUE INDEX facility_dispenser_pk ON public.ust_facility_dispenser USING btree (facility_dispenser_id)

CREATE UNIQUE INDEX ust_facility_dispenser_unique ON public.ust_facility_dispenser USING btree (ust_facility_id, dispenser_id)