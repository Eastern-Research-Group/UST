CREATE TABLE public.tank_secondary_containments (
    tank_secondary_containment_id integer  NOT NULL generated always as identity,
    tank_secondary_containment character varying(100)  NULL );