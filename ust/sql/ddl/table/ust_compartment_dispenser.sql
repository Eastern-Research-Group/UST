CREATE TABLE public.ust_compartment_dispenser (
    compartment_dispenser_id integer  NOT NULL generated always as identity,
    ust_compartment_id integer  NOT NULL ,
    dispenser_id character varying(50)  NOT NULL ,
    dispenser_udc character varying(7)  NULL ,
    dispenser_udc_wall_type_id integer  NULL ,
    dispenser_comment character varying(4000)  NULL );

ALTER TABLE public.ust_compartment_dispenser ADD CONSTRAINT compartment_dispenser_pk PRIMARY KEY (compartment_dispenser_id);

ALTER TABLE public.ust_compartment_dispenser ADD CONSTRAINT ust_compartment_dispenser_unique UNIQUE (ust_compartment_id, dispenser_id);

ALTER TABLE public.ust_compartment_dispenser ADD CONSTRAINT compartment_dispenser_tank_fk FOREIGN KEY (ust_compartment_id) REFERENCES ust_compartment(ust_compartment_id);

ALTER TABLE public.ust_tank_dispenser ADD CONSTRAINT tank_dispenser_dispwt_fk FOREIGN KEY (dispenser_udc_wall_type_id) REFERENCES dispenser_udc_wall_types(dispenser_udc_wall_type_id);

ALTER TABLE public.ust_compartment_dispenser ADD CONSTRAINT tank_dispenser_dispwt_fk FOREIGN KEY (dispenser_udc_wall_type_id) REFERENCES dispenser_udc_wall_types(dispenser_udc_wall_type_id);

CREATE UNIQUE INDEX compartment_dispenser_pk ON public.ust_compartment_dispenser USING btree (compartment_dispenser_id)

CREATE UNIQUE INDEX ust_compartment_dispenser_unique ON public.ust_compartment_dispenser USING btree (ust_compartment_id, dispenser_id)