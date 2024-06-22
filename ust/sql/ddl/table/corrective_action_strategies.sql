CREATE TABLE public.corrective_action_strategies (
    corrective_action_strategy_id integer  NOT NULL generated always as identity,
    corrective_action_strategy character varying(200)  NOT NULL );