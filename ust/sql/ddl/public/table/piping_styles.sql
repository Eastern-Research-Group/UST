CREATE TABLE public.piping_styles (
    "piping_style_id" integer  NOT NULL generated always as identity,
    "piping_style" character varying(100)  NULL );

ALTER TABLE public.piping_styles ADD CONSTRAINT piping_styles_pkey PRIMARY KEY (piping_style_id);

CREATE UNIQUE INDEX piping_styles_pkey ON public.piping_styles USING btree (piping_style_id)

CREATE INDEX piping_styles_idx ON public.piping_styles USING btree (piping_style)