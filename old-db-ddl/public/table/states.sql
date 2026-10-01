CREATE TABLE public.states (
    "state" character varying(2)  NOT NULL ,
    "facility_state" character varying(2)  NULL );

ALTER TABLE public.states ADD CONSTRAINT states_pkey PRIMARY KEY (state);
