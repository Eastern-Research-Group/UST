CREATE TABLE public.cui_exclusions (
    "stopword" character varying(100)  NOT NULL ,
    "maybe_flag" character varying(1)  NULL );

ALTER TABLE public.cui_exclusions ADD CONSTRAINT cui_exclusions_pkey PRIMARY KEY (stopword);

CREATE UNIQUE INDEX cui_exclusions_pkey ON public.cui_exclusions USING btree (stopword)