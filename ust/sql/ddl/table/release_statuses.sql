CREATE TABLE public.release_statuses (
    release_status_id integer  NOT NULL generated always as identity,
    release_status character varying(200)  NOT NULL );

ALTER TABLE public.release_statuses ADD CONSTRAINT ust_release_statuses_pkey PRIMARY KEY (release_status_id);

CREATE UNIQUE INDEX ust_release_statuses_pkey ON public.release_statuses USING btree (release_status_id)