CREATE TABLE public.tank_material_descriptions (
    tank_material_description_id integer  NOT NULL generated always as identity,
    tank_material_description character varying(100)  NOT NULL );

ALTER TABLE public.tank_material_descriptions ADD CONSTRAINT tank_material_descriptions_pkey PRIMARY KEY (tank_material_description_id);

CREATE UNIQUE INDEX tank_material_descriptions_pkey ON public.tank_material_descriptions USING btree (tank_material_description_id)

CREATE INDEX tank_material_descriptions_idx ON public.tank_material_descriptions USING btree (tank_material_description)