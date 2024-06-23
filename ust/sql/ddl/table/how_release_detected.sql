CREATE TABLE public.how_release_detected (
    how_release_detected_id integer  NOT NULL generated always as identity,
    how_release_detected character varying(200)  NOT NULL );

ALTER TABLE public.how_release_detected ADD CONSTRAINT how_release_detected_pkey PRIMARY KEY (how_release_detected_id);

ALTER TABLE archive."archive.how_release_detected" ADD CONSTRAINT how_release_detected_pkey PRIMARY KEY (how_release_detected);

CREATE INDEX how_release_detected_idx ON public.how_release_detected USING btree (how_release_detected)

CREATE UNIQUE INDEX how_release_detected_pkey ON public.how_release_detected USING btree (how_release_detected_id)