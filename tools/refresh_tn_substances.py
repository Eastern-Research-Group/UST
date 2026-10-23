"""Atomically refresh only substance tables for TN UST control 35."""

from ust.python.util import utils


def main():
    conn = utils.connect_db()
    conn.autocommit = False
    try:
        with conn:
            with conn.cursor() as cur:
                cur.execute("SET LOCAL statement_timeout='5min'")
                cur.execute("SET LOCAL lock_timeout='10s'")
                cur.execute('LOCK TABLE public.ust_facility, public.ust_tank, public.ust_compartment, public.ust_piping IN SHARE MODE')
                cur.execute('LOCK TABLE public.ust_tank_substance, public.ust_compartment_substance IN SHARE ROW EXCLUSIVE MODE')
                cur.execute('CREATE TEMP TABLE tn_tanks ON COMMIT DROP AS SELECT t.ust_tank_id,f.facility_id,t.tank_id FROM public.ust_tank t JOIN public.ust_facility f USING(ust_facility_id) WHERE f.ust_control_id=35')
                cur.execute('CREATE UNIQUE INDEX ON tn_tanks(ust_tank_id)')
                cur.execute('ANALYZE tn_tanks')
                cur.execute('CREATE TEMP TABLE tn_compartments ON COMMIT DROP AS SELECT c.* FROM public.ust_compartment c JOIN tn_tanks t USING(ust_tank_id)')

                def protected():
                    queries = {
                        'facilities': 'SELECT * FROM public.ust_facility WHERE ust_control_id=35',
                        'tanks': 'SELECT t.* FROM public.ust_tank t JOIN tn_tanks k USING(ust_tank_id)',
                        'compartments': 'SELECT c.* FROM public.ust_compartment c JOIN tn_tanks k USING(ust_tank_id)',
                        'piping': 'SELECT p.* FROM public.ust_piping p JOIN tn_compartments c USING(ust_compartment_id)',
                        'other_tank_substances': 'SELECT s.* FROM public.ust_tank_substance s WHERE NOT EXISTS (SELECT 1 FROM tn_tanks t WHERE t.ust_tank_id=s.ust_tank_id)',
                        'other_compartment_substances': 'SELECT s.* FROM public.ust_compartment_substance s WHERE NOT EXISTS (SELECT 1 FROM tn_compartments c WHERE c.ust_compartment_id=s.ust_compartment_id)',
                    }
                    result = {}
                    for name, query in queries.items():
                        cur.execute("SELECT count(*),md5(string_agg(row_to_json(x)::text,'' ORDER BY row_to_json(x)::text)) FROM (" + query + ') x')
                        result[name] = cur.fetchone()
                    return result

                before = protected()
                print('Protected row counts:', {k: v[0] for k, v in before.items()}, flush=True)
                for table in ('tank', 'compartment'):
                    cur.execute(f'CREATE TEMP TABLE source_{table} ON COMMIT DROP AS SELECT * FROM tn_ust.v_ust_{table}_substance')
                    cur.execute(f'ANALYZE source_{table}')
                cur.execute('CREATE TEMP TABLE new_tank ON COMMIT DROP AS SELECT DISTINCT t.ust_tank_id,s.substance_id FROM source_tank s JOIN tn_tanks t USING(facility_id,tank_id)')
                cur.execute('CREATE UNIQUE INDEX ON new_tank(ust_tank_id,substance_id)')
                cur.execute('CREATE TEMP TABLE new_compartment ON COMMIT DROP AS SELECT DISTINCT c.ust_compartment_id,t.ust_tank_id,s.substance_id FROM source_compartment s JOIN tn_tanks t USING(facility_id,tank_id) JOIN tn_compartments c ON c.ust_tank_id=t.ust_tank_id AND c.compartment_id=s.compartment_id')
                cur.execute('SELECT count(*) FROM new_compartment c WHERE NOT EXISTS (SELECT 1 FROM new_tank t WHERE t.ust_tank_id=c.ust_tank_id AND t.substance_id=c.substance_id)')
                if cur.fetchone()[0]:
                    raise RuntimeError('Compartment substances lack matching tank substances')
                cur.execute('SELECT (SELECT count(*) FROM new_tank),(SELECT count(*) FROM new_compartment)')
                expected = cur.fetchone()
                if not all(expected):
                    raise RuntimeError('Empty replacement data')
                print('Replacement counts:', expected, flush=True)
                cur.execute('DELETE FROM public.ust_compartment_substance s USING tn_compartments c WHERE s.ust_compartment_id=c.ust_compartment_id')
                print('Deleted compartment substances:', cur.rowcount, flush=True)
                cur.execute('DELETE FROM public.ust_tank_substance s USING tn_tanks t WHERE s.ust_tank_id=t.ust_tank_id')
                print('Deleted tank substances:', cur.rowcount, flush=True)
                cur.execute('INSERT INTO public.ust_tank_substance(ust_tank_id,substance_id) SELECT ust_tank_id,substance_id FROM new_tank')
                if cur.rowcount != expected[0]:
                    raise RuntimeError('Tank insert count mismatch')
                cur.execute('INSERT INTO public.ust_compartment_substance(ust_compartment_id,ust_tank_substance_id) SELECT c.ust_compartment_id,t.ust_tank_substance_id FROM new_compartment c JOIN public.ust_tank_substance t USING(ust_tank_id,substance_id)')
                if cur.rowcount != expected[1]:
                    raise RuntimeError('Compartment insert count mismatch')
                if protected() != before:
                    raise RuntimeError('Protected data changed; rolling back')
                print('Verified parent/piping rows and other datasets unchanged.', flush=True)
        print('Committed TN control 35 substance refresh.', flush=True)
    finally:
        conn.close()


if __name__ == '__main__':
    main()
