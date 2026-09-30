CREATE TABLE public.state_hazardous_substances (
    "state" character varying(2)  NOT NULL ,
    "casno" character varying(40)  NOT NULL );

ALTER TABLE public.state_hazardous_substances ADD CONSTRAINT state_hazardous_substances_pk PRIMARY KEY (state, casno);
