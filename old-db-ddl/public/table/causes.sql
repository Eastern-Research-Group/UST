CREATE TABLE public.causes (
    "cause_id" integer  NOT NULL generated always as identity,
    "cause" character varying(200)  NOT NULL );

ALTER TABLE public.causes ADD CONSTRAINT causes_pkey PRIMARY KEY (cause_id);

CREATE INDEX causes_cause_idx ON public.causes USING btree (cause);

CREATE INDEX causes_idx ON public.causes USING btree (cause);
