CREATE TABLE public.ust_facility_geocode (
    "id" integer  NOT NULL generated always as identity,
    "ust_facility_id" integer  NOT NULL ,
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

ALTER TABLE public.ust_facility_geocode ADD CONSTRAINT ust_facility_geocode_facid_fk FOREIGN KEY (ust_facility_id) REFERENCES ust_facility(ust_facility_id);

ALTER TABLE public.ust_facility_geocode ADD CONSTRAINT ust_facility_geocode_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX ust_facility_geocode_facid_idx ON public.ust_facility_geocode USING btree (ust_facility_id);
