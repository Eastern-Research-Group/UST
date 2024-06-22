CREATE TABLE public.ust_release_cause (
    ust_release_cause_id integer  NOT NULL generated always as identity,
    ust_release_id integer  NOT NULL ,
    cause_id integer  NOT NULL );