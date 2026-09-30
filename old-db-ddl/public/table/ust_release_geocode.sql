CREATE TABLE public.ust_release_geocode (
    "id" integer  NOT NULL generated always as identity,
    "ust_release_id" integer  NOT NULL ,
    "status" character varying(1)  NULL ,
    "score" double precision  NULL ,
    "match_type" character varying(1)  NULL ,
    "rank" double precision  NULL ,
    "street_address" character varying(200)  NULL ,
    "city" character varying(100)  NULL ,
    "subregion" character varying(100)  NULL ,
    "region_abbreviation" character varying(2)  NULL ,
    "zip_code" integer  NULL ,
    "zip_extension" integer  NULL ,
    "country" character varying(50)  NULL ,
    "latitude" double precision  NULL ,
    "longitude" double precision  NULL );

ALTER TABLE public.ust_release_geocode ADD CONSTRAINT ust_release_geocode_pkey PRIMARY KEY (id);

ALTER TABLE public.ust_release_geocode ADD CONSTRAINT ust_release_geocode_rid_fk FOREIGN KEY (ust_release_id) REFERENCES ust_release(ust_release_id);

CREATE UNIQUE INDEX ust_release_geocode_rid_idx ON public.ust_release_geocode USING btree (ust_release_id);
