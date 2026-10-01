CREATE OR REPLACE FUNCTION public.get_dependent_objects(p_object_name character varying)
 RETURNS TABLE(object_name regclass)
 LANGUAGE plpgsql
AS $function$
begin 
	return query 
	SELECT distinct v.oid::regclass
	FROM pg_depend AS d      -- objects that depend on the table
	   JOIN pg_rewrite AS r  -- rules depending on the table
	      ON r.oid = d.objid
	   JOIN pg_class AS v    -- views for the rules
	      ON v.oid = r.ev_class
	WHERE v.relkind in ('r', 'v')    
	  -- dependency must be a rule depending on a relation
	  AND d.classid = 'pg_rewrite'::regclass
	  AND d.refclassid = 'pg_class'::regclass
	  AND d.deptype = 'n'    -- normal dependency;
	 and d.refobjid = p_object_name::regclass;
end;
$function$;

