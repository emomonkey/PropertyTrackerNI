 class CreateAbHistoricAvgSumFunction < ActiveRecord::Migration
    def up
      execute <<-SPROC
CREATE OR REPLACE FUNCTION ab_historic_avg_sum() RETURNS VOID AS $$

Declare stype integer;

BEGIN


                SELECT id INTO stype FROM search_types WHERE searchtext = 'Historic Avg County Summary';

                INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, resultvalue, created_at)
                  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, sp.id as spid,AVG(price),
                                 AVG(price) as avgprice, now() FROM property_sites ps LEFT JOIN
                                (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds, search_types_id FROM historic_analyses h, search_types a
                                WHERE searchtext = 'Historic Avg County Summary' AND h.search_types_id =  a.id
                                ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
                                , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext  AND myear.yrm IS NULL
                  GROUP BY vyear,vmonth, spid;

END;

$$ LANGUAGE 'plpgsql';
      SPROC
    end

    def down
      execute "DROP FUNCTION IF EXISTS ab_historic_avg_sum()"
    end
  end



