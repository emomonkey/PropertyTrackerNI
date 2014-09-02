class CreateAbHistoricCntSumFunction < ActiveRecord::Migration
  def up
    execute <<-SPROC
CREATE OR REPLACE FUNCTION ab_historic_cnt_sum() RETURNS VOID AS $$
Declare stype integer;
BEGIN
SELECT id INTO stype FROM search_types WHERE searchtext = 'Volume County Summary Property Types';


INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext,  resultvalue, created_at)
 SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, stype,
  sp.id as spid,  count(ps.id), count(ps.id),now() FROM property_sites ps LEFT JOIN
  (SELECT DISTINCT year || trim(to_char(month,'09')) yrm,  search_types_id
   FROM historic_analyses h, search_types a
   WHERE searchtext = 'Volume County Summary Property Types' AND h.search_types_id =  a.id
  ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
   ,search_params sp WHERE sp.searchparam = ps.searchtext
                                                      AND myear.yrm IS NULL and sp.searchparam = 'Waringstown'
group by vmonth, vyear, spid, now();

END;

$$ LANGUAGE 'plpgsql';
    SPROC
  end

  def down
    execute "DROP FUNCTION IF EXISTS ab_historic_cnt_sum()"
  end
end