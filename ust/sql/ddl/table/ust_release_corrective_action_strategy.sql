CREATE TABLE public.ust_release_corrective_action_strategy (
    ust_release_corrective_action_strategy_id integer  NOT NULL generated always as identity,
    ust_release_id integer  NOT NULL ,
    corrective_action_strategy_id integer  NOT NULL ,
    corrective_action_strategy_start_date date  NULL );