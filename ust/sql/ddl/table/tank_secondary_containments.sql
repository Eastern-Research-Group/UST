CREATE TABLE public.tank_secondary_containments (
    tank_secondary_containment_id integer  NOT NULL generated always as identity,
    tank_secondary_containment character varying(100)  NULL );

ALTER TABLE public.tank_secondary_containments ADD CONSTRAINT tank_secondary_containments_pkey PRIMARY KEY (tank_secondary_containment_id);

CREATE UNIQUE INDEX tank_secondary_containments_pkey ON public.tank_secondary_containments USING btree (tank_secondary_containment_id)

CREATE INDEX tank_secondary_containments_idx ON public.tank_secondary_containments USING btree (tank_secondary_containment)