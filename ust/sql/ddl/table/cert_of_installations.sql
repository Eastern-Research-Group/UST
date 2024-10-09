CREATE TABLE public.cert_of_installations (
    cert_of_installation_id integer  NOT NULL generated always as identity,
    cert_of_installation character varying(100)  NULL );

ALTER TABLE public.cert_of_installations ADD CONSTRAINT cert_of_installations_pkey1 PRIMARY KEY (cert_of_installation_id);

CREATE UNIQUE INDEX cert_of_installations_pkey1 ON public.cert_of_installations USING btree (cert_of_installation_id)