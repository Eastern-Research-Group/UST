CREATE TABLE public.generated_table_sort_order (
    table_name character varying(100)  NOT NULL ,
    sort_order integer  NULL );

ALTER TABLE public.generated_table_sort_order ADD CONSTRAINT generated_table_sort_order_pkey PRIMARY KEY (table_name);

CREATE UNIQUE INDEX generated_table_sort_order_pkey ON public.generated_table_sort_order USING btree (table_name)