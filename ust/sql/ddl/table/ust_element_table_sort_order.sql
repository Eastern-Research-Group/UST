CREATE TABLE public.ust_element_table_sort_order (
    table_name character varying(100)  NOT NULL ,
    sort_order integer  NULL ,
    template_tab_name character varying(100)  NULL ,
    db_lookup character varying(1)  NULL );

ALTER TABLE public.ust_element_table_sort_order ADD CONSTRAINT ust_element_table_sort_order_pkey PRIMARY KEY (table_name);

CREATE UNIQUE INDEX ust_element_table_sort_order_pkey ON public.ust_element_table_sort_order USING btree (table_name)