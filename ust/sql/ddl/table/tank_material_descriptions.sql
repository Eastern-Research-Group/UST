CREATE TABLE public.tank_material_descriptions (
    tank_material_description_id integer  NOT NULL generated always as identity,
    tank_material_description character varying(100)  NOT NULL );