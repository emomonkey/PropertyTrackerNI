class CreateAdHistoricCntyvolView < ActiveRecord::Migration
  def up
    self.connection.execute %Q(
      CREATE OR REPLACE VIEW ad_historic_cntyvol_views as
          SELECT county, searchparam, SUM(resultvalue) totalval, row_number() OVER ()   id
       FROM historic_analyses h
       , search_types a, search_params p  WHERE searchtext = 'Volume Summary Property Types'
                                             AND h.search_types_id = a.id AND p.id = h.search_params_id
       GROUP BY county, searchparam)
      end

  def down
    execute "DROP VIEW IF EXISTS ad_historic_cntyvol_views;"
  end
end

