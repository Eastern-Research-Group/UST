CREATE TABLE public.ust_facility (
    ust_facility_id integer  NOT NULL generated always as identity,
    facility_id character varying(50)  NOT NULL ,
    facility_name character varying(100)  NULL ,
    owner_type_id integer  NULL ,
    facility_type1 integer  NULL ,
    facility_type2 integer  NULL ,
    facility_address1 character varying(100)  NULL ,
    facility_address2 character varying(100)  NULL ,
    facility_city character varying(100)  NULL ,
    facility_county character varying(100)  NULL ,
    facility_zip_code character varying(10)  NULL ,
    facility_state character varying(2)  NOT NULL ,
    facility_epa_region integer  NULL ,
    facility_tribal_site character varying(3)  NULL ,
    facility_tribe character varying(200)  NULL ,
    facility_latitude double precision  NULL ,
    facility_longitude double precision  NULL ,
    coordinate_source_id integer  NULL ,
    facility_owner_company_name character varying(100)  NULL ,
    facility_operator_company_name character varying(100)  NULL ,
    financial_responsibility_obtained character varying(7)  NULL ,
    financial_responsibility_bond_rating_test character varying(3)  NULL ,
    financial_responsibility_commercial_insurance character varying(3)  NULL ,
    financial_responsibility_guarantee character varying(3)  NULL ,
    financial_responsibility_letter_of_credit character varying(3)  NULL ,
    financial_responsibility_local_government_financial_test character varying(3)  NULL ,
    financial_responsibility_risk_retention_group character varying(3)  NULL ,
    financial_responsibility_self_insurance_financial_test character varying(3)  NULL ,
    financial_responsibility_state_fund character varying(3)  NULL ,
    financial_responsibility_surety_bond character varying(3)  NULL ,
    financial_responsibility_trust_fund character varying(3)  NULL ,
    financial_responsibility_other_method character varying(500)  NULL ,
    ust_reported_release character varying(7)  NULL ,
    associated_ust_release_id character varying(40)  NULL ,
    ust_control_id integer  NULL );

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_facility_type1_fk FOREIGN KEY (facility_type1) REFERENCES facility_types(facility_type_id);

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_facility_type2_fk FOREIGN KEY (facility_type2) REFERENCES facility_types(facility_type_id);

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_owner_type_fk FOREIGN KEY (owner_type_id) REFERENCES owner_types(owner_type_id);

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_coordinate_source_fk FOREIGN KEY (coordinate_source_id) REFERENCES coordinate_sources(coordinate_source_id);

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_state_fk FOREIGN KEY (facility_state) REFERENCES states(state);

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_pkey PRIMARY KEY (ust_facility_id);

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_epa_region_chk CHECK ((facility_epa_region = ANY (ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10])));

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_facility_tribal_site_chk CHECK (((facility_tribal_site)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_financial_responsibility_bond_rating_test_chk CHECK (((financial_responsibility_bond_rating_test)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_financial_responsibility_commercial_insurance_chk CHECK (((financial_responsibility_commercial_insurance)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_financial_responsibility_guarantee_chk CHECK (((financial_responsibility_guarantee)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_financial_responsibility_letter_of_credit_chk CHECK (((financial_responsibility_letter_of_credit)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_financial_responsibility_local_government_financial_te CHECK (((financial_responsibility_local_government_financial_test)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_financial_responsibility_risk_retention_group_chk CHECK (((financial_responsibility_risk_retention_group)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_financial_responsibility_self_insurance_financial_test CHECK (((financial_responsibility_self_insurance_financial_test)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_financial_responsibility_state_fund_chk CHECK (((financial_responsibility_state_fund)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_financial_responsibility_surety_bond_chk CHECK (((financial_responsibility_surety_bond)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_financial_responsibility_trust_fund_chk CHECK (((financial_responsibility_trust_fund)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying])::text[])));

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_ust_reported_release_chk CHECK (((ust_reported_release)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying])::text[])));

ALTER TABLE public.ust_facility ADD CONSTRAINT ust_facility_control_fk FOREIGN KEY (ust_control_id) REFERENCES ust_control(ust_control_id);

ALTER TABLE public.ust_facility ADD CONSTRAINT facility_fr_obtained_chk CHECK (((financial_responsibility_obtained)::text = ANY ((ARRAY['Yes'::character varying, 'No'::character varying, 'Unknown'::character varying, 'N/A'::character varying])::text[])));

CREATE INDEX u_fac_idx ON public.ust_facility USING btree (facility_id)

CREATE UNIQUE INDEX facility_pkey ON public.ust_facility USING btree (ust_facility_id)

CREATE INDEX ust_facility_control_idx ON public.ust_facility USING btree (ust_control_id)

CREATE INDEX ust_facility_associated_ust_release_id_idx ON public.ust_facility USING btree (associated_ust_release_id)

CREATE INDEX ust_facility_coordinate_source_id_idx ON public.ust_facility USING btree (coordinate_source_id)

CREATE INDEX ust_facility_facility_id_idx ON public.ust_facility USING btree (facility_id)

CREATE INDEX ust_facility_owner_type_id_idx ON public.ust_facility USING btree (owner_type_id)

CREATE INDEX ust_facility_ust_control_id_idx ON public.ust_facility USING btree (ust_control_id)

CREATE INDEX ust_facility_ust_facility_id_idx ON public.ust_facility USING btree (ust_facility_id)