CREATE TABLE public.corrective_action_strategies (
    "corrective_action_strategy_id" integer  NOT NULL generated always as identity,
    "corrective_action_strategy" character varying(200)  NOT NULL ,
    "inactive_flag" character varying(1)  NULL ,
    "notes" character varying(4000)  NULL );

ALTER TABLE public.corrective_action_strategies ADD CONSTRAINT corrective_action_strategies_pkey PRIMARY KEY (corrective_action_strategy_id);

CREATE INDEX corrective_action_strategies_idx ON public.corrective_action_strategies USING btree (corrective_action_strategy);
