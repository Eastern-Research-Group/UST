CREATE TABLE public.piping_styles (
    piping_style_id integer  NOT NULL generated always as identity,
    piping_style character varying(100)  NULL );