CREATE TABLE public.facility_dispenser (
    facility_dispenser_id integer  NOT NULL generated always as identity,
    ust_facility_id integer  NOT NULL ,
    dispenser_id character varying(50)  NOT NULL ,
    dispenser_udc character varying(7)  NULL ,
    dispenser_udc_wall_type_id integer  NULL );

ALTER TABLE public.facility_dispenser ADD CONSTRAINT facility_dispenser_dispwt_fk FOREIGN KEY (dispenser_udc_wall_type_id) REFERENCES dispenser_udc_wall_types(dispenser_udc_wall_type_id);

ALTER TABLE public.facility_dispenser ADD CONSTRAINT facility_dispenser_fac_fk FOREIGN KEY (ust_facility_id) REFERENCES ust_facility(ust_facility_id);

ALTER TABLE public.facility_dispenser ADD CONSTRAINT facility_dispenser_pk PRIMARY KEY (facility_dispenser_id);

CREATE UNIQUE INDEX facility_dispenser_pk ON public.facility_dispenser USING btree (facility_dispenser_id)