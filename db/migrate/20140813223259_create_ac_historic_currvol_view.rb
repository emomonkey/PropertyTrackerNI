class CreateAcHistoricCurrvolView < ActiveRecord::Migration
  def up
    self.connection.execute %Q(
      CREATE OR REPLACE VIEW ac_historic_currvol_view as
        SELECT a.searchparam antrim, b.searchparam armagh, c.searchparam down, d.searchparam fermanagh, e.searchparam tyrone, f.searchparam lderry
FROM
(
SELECT county, year, month, searchparam, SUM(resultvalue) totalval FROM historic_analyses h
  , search_types a, search_params p  WHERE searchtext = 'Volume Summary Property Types'
                                           AND p.id = h.search_params_id AND county = 'Co.Antrim'
GROUP BY county,year, month, searchparam ORDER BY county, year desc, month desc,totalval desc LIMIT 1
) a,
(SELECT county, year, month, searchparam, SUM(resultvalue) totalval FROM historic_analyses h
      , search_types a, search_params p  WHERE searchtext = 'Volume Summary Property Types'
        AND p.id = h.search_params_id AND county = 'Co.Armagh'
GROUP BY county,year, month, searchparam ORDER BY county, year desc, month desc,totalval desc LIMIT 1)b,
  (SELECT county, year, month, searchparam, SUM(resultvalue) totalval FROM historic_analyses h
    , search_types a, search_params p  WHERE searchtext = 'Volume Summary Property Types'
                                             AND p.id = h.search_params_id AND county = 'Co.Down'
  GROUP BY county,year, month, searchparam ORDER BY county, year desc, month desc,totalval desc LIMIT 1)c,
  (SELECT county, year, month, searchparam, SUM(resultvalue) totalval FROM historic_analyses h
    , search_types a, search_params p  WHERE searchtext = 'Volume Summary Property Types'
                                             AND p.id = h.search_params_id AND county = 'Co.Fermanagh'
  GROUP BY county,year, month, searchparam ORDER BY county, year desc, month desc,totalval desc LIMIT 1)d,
  (SELECT county, year, month, searchparam, SUM(resultvalue) totalval FROM historic_analyses h
    , search_types a, search_params p  WHERE searchtext = 'Volume Summary Property Types'
                                             AND p.id = h.search_params_id AND county = 'Co.Tyrone'
  GROUP BY county,year, month, searchparam ORDER BY county, year desc, month desc,totalval desc LIMIT 1)e,
  (SELECT county, year, month, searchparam, SUM(resultvalue) totalval FROM historic_analyses h
    , search_types a, search_params p  WHERE searchtext = 'Volume Summary Property Types'
                                             AND p.id = h.search_params_id AND county = 'Co.Londonderry'
  GROUP BY county,year, month, searchparam ORDER BY county, year desc, month desc,totalval desc LIMIT 1)f;
)

  end

  def down
    execute "DROP VIEW IF EXISTS ac_historic_currvol_view "
  end
end

