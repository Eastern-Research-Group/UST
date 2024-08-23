CREATE TABLE public.performance_measures_release (
    organization_id character varying(10)  NOT NULL ,
    num_cumulative_releases integer  NULL ,
    num_cumulative_initiated_cleanups integer  NULL ,
    num_cumulative_completed_cleanups integer  NULL ,
    num_cleanups_backlog integer  NULL );

ALTER TABLE public.performance_measures_release ADD CONSTRAINT performance_measures_release_pkey PRIMARY KEY (organization_id);

CREATE UNIQUE INDEX performance_measures_release_pkey ON public.performance_measures_release USING btree (organization_id)