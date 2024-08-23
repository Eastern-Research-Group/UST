CREATE TABLE public.performance_measures_ust (
    organization_id character varying(10)  NOT NULL ,
    num_active_petroleum_ust integer  NULL ,
    num_closed_petroleum_ust integer  NULL ,
    num_active_hazmat_ust integer  NULL ,
    num_closed_hazmat_ust integer  NULL ,
    total_active_ust integer  NULL ,
    total_closed_ust integer  NULL ,
    total_ust integer  NULL );

ALTER TABLE public.performance_measures_ust ADD CONSTRAINT performance_measures_ust_pkey PRIMARY KEY (organization_id);

CREATE UNIQUE INDEX performance_measures_ust_pkey ON public.performance_measures_ust USING btree (organization_id)