CREATE TABLE public.ust_elements (
    "element_id" integer  NOT NULL generated always as identity,
    "element_name" character varying(200)  NOT NULL ,
    "element_description" character varying(4000)  NULL ,
    "displayed_in_ustfinder" character varying(1)  NULL ,
    "element_type" character varying(20)  NULL ,
    "element_size" integer  NULL ,
    "required" character varying(20)  NULL ,
    "allowed_values" character varying(1)  NULL ,
    "lookup_table" character varying(50)  NULL ,
    "business_rule" character varying(4000)  NULL ,
    "notes" character varying(4000)  NULL ,
    "database_column_name" character varying(100)  NULL ,
    "database_lookup_table" character varying(100)  NULL ,
    "database_lookup_column" character varying(100)  NULL ,
    "generic_template" character varying(1)  NULL ,
    "in_use" character varying(1)  NULL );

ALTER TABLE public.ust_elements ADD CONSTRAINT ust_elements_pkey1 PRIMARY KEY (element_id);

CREATE UNIQUE INDEX ust_elements_pkey1 ON public.ust_elements USING btree (element_id)

CREATE INDEX ust_elements_dbcn_idx ON public.ust_elements USING btree (database_column_name)

CREATE INDEX ust_elements_lut_idx ON public.ust_elements USING btree (database_lookup_table)

CREATE INDEX ust_elements_dblcn_idx ON public.ust_elements USING btree (database_lookup_column)

CREATE INDEX ust_elements_element_id_idx ON public.ust_elements USING btree (element_id)