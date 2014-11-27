class CreateAbHistoricCntyView < ActiveRecord::Migration
  def up
    self.connection.execute %Q(
drop view ab_historic_cnty_views;

CREATE OR REPLACE VIEW ab_historic_cnty_views as
  SELECT  cntyvol.COUNTY, cntyvol.YEAR, cntyvol.MONTH, cntyvol.VOLPC, cntyvol.created_at,soldvol.prcsold, prcchg.MONTH_PRICE_DIFF, row_number() OVER ()   id
FROM
  (SELECT vcnty.county, vcnty.year, vcnty.month, ROUND((vcnty.volsum / tvol.volsum) * 100,2) VOLPC, created_at
   FROM
     (SELECT
        COUNTY,
        YEAR,
        MONTH,
        historic_analyses.created_at,
        ROUND(SUM(resultvalue), 2) volsum
      FROM historic_analyses, search_params sp, search_types st
      WHERE search_types_id = st.id AND search_params_id = sp.id
            AND st.searchtext = 'Volume Summary Property Types'
      GROUP BY COUNTY, YEAR, MONTH, historic_analyses.created_at
     ) vcnty,
     (SELECT
        YEAR,
        MONTH,
        ROUND(SUM(resultvalue), 2) volsum
      FROM historic_analyses, search_params sp, search_types st
      WHERE search_types_id = st.id AND search_params_id = sp.id
            AND st.searchtext = 'Volume Summary Property Types'
      GROUP BY YEAR, MONTH
     ) tvol
   WHERE tvol.year = vcnty.year
         AND vcnty.month = tvol.month) cntyvol,
  (SELECT volv.county, volv.year, volv.month, ROUND( (soldval /volsum * 100) ,2) prcsold
   FROM
     (
       SELECT
         COUNTY,
         YEAR,
         MONTH,
         ROUND(SUM(resultvalue), 2) volsum
       FROM historic_analyses, search_params sp, search_types st
       WHERE search_types_id = st.id AND search_params_id = sp.id
             AND st.searchtext = 'Volume Summary Property Types'
       GROUP BY COUNTY, YEAR, MONTH
     ) volv LEFT JOIN
     (
       SELECT
         COUNTY,
         YEAR,
         MONTH,
         ROUND(SUM(resultvalue), 2) soldval
       FROM historic_analyses, search_params sp, search_types st
       WHERE search_types_id = st.id AND search_params_id = sp.id
             AND st.searchtext = 'Sold Summary Prop Type'
       GROUP BY COUNTY, YEAR, MONTH
       ORDER BY COUNTY, YEAR, MONTH DESC
     ) soldv ON soldv.county = volv.county AND soldv.year = volv.year AND soldv.month = volv.month
  ) soldvol,
  (
    SELECT COUNTY, YEAR, MONTH,MONTH_PRICE_DIFF
    FROM (
           SELECT
             COUNTY,
             YEAR,
             MONTH,
             coalesce(round((AVERAGEVAL - LAG(AVERAGEVAL, 1)
             OVER (PARTITION BY county
               ORDER BY year, month)), 2), 0) MONTH_PRICE_DIFF,
             valtime
           FROM (
                  SELECT
                    COUNTY,
                    YEAR,
                    MONTH,
                    ROUND(AVG(resultvalue), 2) AVERAGEVAL,
                    MAX(year || trim(to_char(month, '09')))
                    OVER (PARTITION BY county) valtime

                  FROM historic_analyses, search_params sp
                  WHERE search_types_id = 5 AND search_params_id = sp.id
                  GROUP BY COUNTY, YEAR, MONTH
                  ORDER BY COUNTY, YEAR, MONTH DESC
                ) a
         ) perc
    WHERE valtime = year|| trim(to_char(month,'09'))
  ) prcchg
WHERE soldvol.county = cntyvol.county AND soldvol.year = cntyvol.year
      AND soldvol.month = cntyvol.month AND prcchg.county = cntyvol.county AND prcchg.month = cntyvol.month
      AND prcchg.year = cntyvol.year)
  end

  def down
    execute "DROP VIEW ab_historic_cnty_view"
  end
end

