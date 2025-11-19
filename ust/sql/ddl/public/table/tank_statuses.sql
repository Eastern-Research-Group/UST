CREATE TABLE public.tank_statuses (
    "tank_status_id" integer  NOT NULL generated always as identity,
    "tank_status" character varying(100)  NOT NULL );

ALTER TABLE public.tank_statuses ADD CONSTRAINT tank_statuses_pkey PRIMARY KEY (tank_status_id);

CREATE UNIQUE INDEX tank_statuses_pkey ON public.tank_statuses USING btree (tank_status_id)

CREATE INDEX tank_statuses_idx ON public.tank_statuses USING btree (tank_status)

CREATE INDEX tank_statuses_desc_idx ON public.tank_statuses USING btree (tank_status)