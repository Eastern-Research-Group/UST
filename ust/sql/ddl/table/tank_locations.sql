CREATE TABLE public.tank_locations (
    tank_location_id integer  NOT NULL generated always as identity,
    tank_location character varying(100)  NOT NULL );