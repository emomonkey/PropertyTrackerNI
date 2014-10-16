class CreateAdHistoricCntyvolFunction < ActiveRecord::Migration
  def up
    self.connection.execute %Q(
     create or replace function ad_historic_cntyvol_function(varea varchar)
  returns table (county varchar, searchparam varchar, totalval bigint, id bigint)
as
  $func$
      BEGIN
      RETURN QUERY
          SELECT p.county, p.searchparam, SUM(resultvalue) totalval, row_number() OVER ()   id
           FROM historic_analyses h
           , search_types a, search_params p
           WHERE searchtext = 'Volume Summary Property Types'
           AND h.search_types_id = a.id AND p.id = h.search_params_id
           AND p.county = varea
          GROUP BY p.county, p.searchparam;
      END
      $func$ LANGUAGE plpgsql;

      )
  end

  def down
    execute "DROP FUNCTION IF EXISTS create_ad_historic_cntyvol_function;"
  end
end

