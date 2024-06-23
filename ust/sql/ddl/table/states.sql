CREATE TABLE public.states (
    state character varying(2)  NOT NULL );

ALTER TABLE public.states ADD CONSTRAINT states_pkey PRIMARY KEY (state);

ALTER TABLE archive."archive.states" ADD CONSTRAINT states_pkey PRIMARY KEY (state);

CREATE UNIQUE INDEX states_pkey ON public.states USING btree (state)