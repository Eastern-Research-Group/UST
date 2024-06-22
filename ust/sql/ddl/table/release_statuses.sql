CREATE TABLE public.release_statuses (
    release_status_id integer  NOT NULL generated always as identity,
    release_status character varying(200)  NOT NULL );