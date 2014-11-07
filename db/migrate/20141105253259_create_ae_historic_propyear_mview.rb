class CreateAeHistoricPropyearMview < ActiveRecord::Migration
  def up
    self.connection.execute %Q(
      CREATE MATERIALIZED VIEW ae_historic_propyear_mview as
        SELECT DISTINCT b.propertytype,a.year,a.month
        FROM (SELECT DISTINCT year, month from historic_analyses) a,
        (SELECT DISTINCT propertytype from historic_analyses a, search_types b
        where search_types_id=b.id AND searchtext='Historic Avg') b
        ORDER BY b.propertytype, a.year, a.month;
        )

  end

  def down
    execute "DROP VIEW IF EXISTS ae_historic_propyear_mview "
  end
end

