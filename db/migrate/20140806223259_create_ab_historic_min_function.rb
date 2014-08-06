class CreateAbHistoricMinFunction < ActiveRecord::Migration
  def up
    execute <<-SPROC
CREATE OR REPLACE FUNCTION ab_historic_min() RETURNS VOID AS $$

Declare stype integer;

BEGIN
SELECT id INTO stype FROM search_types WHERE searchtext = 'Historic Min';

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
SELECT EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, stype,sp.id as spid,MIN(price), ps.beds , ps.propertytype,
       MIN(price) as minprice, now() FROM property_sites ps LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm,
       beds,propertytype, search_types_id FROM historic_analyses WHERE search_types_id = stype
       ) myear ON TO_CHAR(ps.created_at,'YYYYMM') = myear.yrm AND ps.beds = myear.beds AND ps.propertytype = myear.propertytype
      AND myear.search_types_id = stype , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id
      AND trim(ps.propertytype) <> ''
      AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid;



END;

$$ LANGUAGE 'plpgsql';
    SPROC
  end

  def down
    execute "DROP FUNCTION IF EXISTS ab_historic_min()"
  end
end

