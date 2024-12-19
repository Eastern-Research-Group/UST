CREATE TABLE public.release_element_allowed_values (
    column_name character varying(100)  NOT NULL ,
    allowed_value character varying(1000)  NOT NULL ,
    sort_order integer  NULL );

ALTER TABLE public.release_element_allowed_values ADD CONSTRAINT release_element_allowed_values_pk PRIMARY KEY (column_name, allowed_value);

CREATE UNIQUE INDEX release_element_allowed_values_pk ON public.release_element_allowed_values USING btree (column_name, allowed_value)