CREATE TABLE public.ust_release_corrective_action_strategy (
    "ust_release_corrective_action_strategy_id" integer  NOT NULL generated always as identity,
    "ust_release_id" integer  NOT NULL ,
    "corrective_action_strategy_id" integer  NOT NULL ,
    "corrective_action_strategy_start_date" date  NULL ,
    "corrective_action_strategy_comment" character varying(4000)  NULL );

ALTER TABLE public.ust_release_corrective_action_strategy ADD CONSTRAINT ust_release_corrective_action_strategy_pkey PRIMARY KEY (ust_release_corrective_action_strategy_id);

ALTER TABLE public.ust_release_corrective_action_strategy ADD CONSTRAINT release_corrective_action_fk FOREIGN KEY (corrective_action_strategy_id) REFERENCES corrective_action_strategies(corrective_action_strategy_id);

ALTER TABLE public.ust_release_corrective_action_strategy ADD CONSTRAINT release_corrective_action_release_fk FOREIGN KEY (ust_release_id) REFERENCES ust_release(ust_release_id);

ALTER TABLE public.ust_release_corrective_action_strategy ADD CONSTRAINT ust_release_corrective_action_strategy_unique UNIQUE (ust_release_id, corrective_action_strategy_id);

CREATE UNIQUE INDEX ust_release_corrective_action_strategy_pkey ON public.ust_release_corrective_action_strategy USING btree (ust_release_corrective_action_strategy_id)

CREATE INDEX ust_release_corrective_action_strategy_ust_release_id_idx ON public.ust_release_corrective_action_strategy USING btree (ust_release_id)

CREATE UNIQUE INDEX ust_release_corrective_action_strategy_unique ON public.ust_release_corrective_action_strategy USING btree (ust_release_id, corrective_action_strategy_id)