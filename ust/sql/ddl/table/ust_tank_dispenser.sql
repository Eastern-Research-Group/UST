CREATE TABLE public.ust_tank_dispenser (
    tank_dispenser_id integer  NOT NULL generated always as identity,
    ust_tank_id integer  NOT NULL ,
    dispenser_id character varying(50)  NOT NULL ,
    dispenser_udc character varying(7)  NULL ,
    dispenser_udc_wall_type_id integer  NULL ,
    dispenser_comment character varying(4000)  NULL );

ALTER TABLE public.ust_tank_dispenser ADD CONSTRAINT tank_dispenser_tank_fk FOREIGN KEY (ust_tank_id) REFERENCES ust_tank(ust_tank_id);

ALTER TABLE public.ust_tank_dispenser ADD CONSTRAINT tank_dispenser_dispwt_fk FOREIGN KEY (dispenser_udc_wall_type_id) REFERENCES dispenser_udc_wall_types(dispenser_udc_wall_type_id);

ALTER TABLE public.ust_compartment_dispenser ADD CONSTRAINT tank_dispenser_dispwt_fk FOREIGN KEY (dispenser_udc_wall_type_id) REFERENCES dispenser_udc_wall_types(dispenser_udc_wall_type_id);

ALTER TABLE public.ust_tank_dispenser ADD CONSTRAINT tank_dispenser_pk PRIMARY KEY (tank_dispenser_id);

ALTER TABLE public.ust_tank_dispenser ADD CONSTRAINT ust_tank_dispenser_unique UNIQUE (ust_tank_id, dispenser_id);

CREATE UNIQUE INDEX tank_dispenser_pk ON public.ust_tank_dispenser USING btree (tank_dispenser_id)

CREATE UNIQUE INDEX ust_tank_dispenser_unique ON public.ust_tank_dispenser USING btree (ust_tank_id, dispenser_id)