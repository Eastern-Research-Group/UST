CREATE TABLE public.tank_statuses (
    tank_status_id integer  NOT NULL generated always as identity,
    tank_status character varying(100)  NOT NULL );