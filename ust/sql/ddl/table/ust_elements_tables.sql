CREATE TABLE public.ust_elements_tables (
    element_table_id integer  NOT NULL generated always as identity,
    element_id integer  NOT NULL ,
    table_name character varying(100)  NOT NULL ,
    sort_order integer  NULL ,
    primary_key character varying(1)  NULL );

ALTER TABLE public.ust_elements_tables ADD CONSTRAINT ust_elements_tables_element_id_fkey FOREIGN KEY (element_id) REFERENCES ust_elements(element_id);

ALTER TABLE public.ust_elements_tables ADD CONSTRAINT ust_elements_tables_pkey PRIMARY KEY (element_table_id);

CREATE UNIQUE INDEX ust_elements_tables_pkey ON public.ust_elements_tables USING btree (element_table_id)

CREATE INDEX ust_elements_tables_element_id_idx ON public.ust_elements_tables USING btree (element_id)