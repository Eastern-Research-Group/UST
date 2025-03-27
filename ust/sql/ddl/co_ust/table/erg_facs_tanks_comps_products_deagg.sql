CREATE TABLE co_ust.erg_facs_tanks_comps_products_deagg (
    "Products" text  NOT NULL );

ALTER TABLE co_ust."co_ust.erg_facs_tanks_comps_products_deagg" ADD CONSTRAINT erg_facs_tanks_comps_products_deagg_pkey PRIMARY KEY ("Products");

CREATE UNIQUE INDEX erg_facs_tanks_comps_products_deagg_pkey ON co_ust.erg_facs_tanks_comps_products_deagg USING btree ("Products")