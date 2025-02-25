CREATE TABLE public.dispenser_udc_wall_types (
    "dispenser_udc_wall_type_id" integer  NOT NULL generated always as identity,
    "dispenser_udc_wall_type" character varying(20)  NOT NULL );

ALTER TABLE public.dispenser_udc_wall_types ADD CONSTRAINT dispenser_udc_wall_types_pkey PRIMARY KEY (dispenser_udc_wall_type_id);

CREATE UNIQUE INDEX dispenser_udc_wall_types_pkey ON public.dispenser_udc_wall_types USING btree (dispenser_udc_wall_type_id)

CREATE INDEX dispenser_udc_wall_types_idx ON public.dispenser_udc_wall_types USING btree (dispenser_udc_wall_type)