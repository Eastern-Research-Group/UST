CREATE TABLE public.causes (
    "cause_id" integer  NOT NULL generated always as identity,
    "cause" character varying(200)  NOT NULL );

ALTER TABLE ca_release."ca_release.causes" ADD CONSTRAINT causes_pkey PRIMARY KEY (state_value);

ALTER TABLE public.causes ADD CONSTRAINT causes_pkey PRIMARY KEY (cause_id);

CREATE INDEX causes_idx ON public.causes USING btree (cause)

CREATE UNIQUE INDEX causes_pkey ON public.causes USING btree (cause_id)

CREATE INDEX causes_cause_idx ON public.causes USING btree (cause)