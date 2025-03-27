CREATE TABLE public.tank_locations (
    "tank_location_id" integer  NOT NULL generated always as identity,
    "tank_location" character varying(100)  NOT NULL );

ALTER TABLE public.tank_locations ADD CONSTRAINT tank_locations_pkey PRIMARY KEY (tank_location_id);

CREATE UNIQUE INDEX tank_locations_pkey ON public.tank_locations USING btree (tank_location_id)

CREATE INDEX tank_locations_idx ON public.tank_locations USING btree (tank_location)

CREATE INDEX tank_locations_desc_idx ON public.tank_locations USING btree (tank_location)