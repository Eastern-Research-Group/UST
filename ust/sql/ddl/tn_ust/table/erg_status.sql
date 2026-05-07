CREATE TABLE tn_ust.erg_status (
    "Facility Id Ust" bigint  NULL ,
    "Tank Id" bigint  NULL ,
    "Tank Number" bigint  NULL ,
    "Compartment Id" bigint  NULL ,
    "Compartment Letter" text  NULL ,
    "status_combined" text  NULL ,
    "order_by" integer  NULL );

CREATE INDEX es_idx1 ON tn_ust.erg_status USING btree ("Tank Id", "Facility Id Ust", order_by)