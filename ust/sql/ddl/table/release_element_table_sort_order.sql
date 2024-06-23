CREATE TABLE public.release_element_table_sort_order (
    table_name character varying(100)  NOT NULL ,
    sort_order integer  NULL ,
    template_tab_name character varying(100)  NULL );

ALTER TABLE public.release_element_table_sort_order ADD CONSTRAINT release_element_table_sort_order_pkey PRIMARY KEY (table_name);

CREATE UNIQUE INDEX release_element_table_sort_order_pkey ON public.release_element_table_sort_order USING btree (table_name)