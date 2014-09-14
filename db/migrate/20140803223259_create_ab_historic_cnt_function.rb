class CreateAbHistoricCntFunction < ActiveRecord::Migration
  def up
    execute <<-SPROC
CREATE OR REPLACE FUNCTION ab_historic_cnt() RETURNS VOID AS $$
Declare stype integer;
BEGIN
SELECT id INTO stype FROM search_types WHERE searchtext = 'Volume Summary Property Types';


INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, sp.id as spid,COUNT(ps.id), ps.beds,
    'Semi-detached' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types' AND h.search_types_id =  a.id AND propertytype LIKE '%Semi-detached%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm AND ps.beds = myear.beds
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND ps.propertytype LIKE '%Semi-detached%'
  GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid;

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, sp.id as spid,COUNT(ps.id), ps.beds,
         'Detached' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types' AND h.search_types_id =  a.id AND propertytype LIKE '%Detached%' AND propertytype NOT LIKE '%Semi-detached%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm AND ps.beds = myear.beds
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND ps.propertytype LIKE '%Detached%' AND ps.propertytype NOT LIKE '%Semi-detached%'
  GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid;

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, sp.id as spid,COUNT(ps.id), ps.beds,
         'Terrace' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types' AND h.search_types_id =  a.id AND propertytype LIKE '%Terrace%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm AND ps.beds = myear.beds
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND ps.propertytype LIKE '%Terrace%'
  GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid;



INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, sp.id as spid,COUNT(ps.id), ps.beds,
         'Townhouse' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types' AND h.search_types_id =  a.id AND propertytype LIKE '%Townhouse%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm AND ps.beds = myear.beds
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND ps.propertytype LIKE '%Townhouse%'
  GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid;

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, sp.id as spid,COUNT(ps.id), ps.beds,
         'Site' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types' AND h.search_types_id =  a.id AND propertytype LIKE '%Site%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm AND ps.beds = myear.beds
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL and (ps.propertytype LIKE '%Land%' OR ps.propertytype LIKE '%Site%')
GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid;


INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, sp.id as spid,COUNT(ps.id), ps.beds,
         'Cottage' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types' AND h.search_types_id =  a.id AND propertytype LIKE '%Cottage%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm AND ps.beds = myear.beds
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND ps.propertytype LIKE '%Cottage%' AND ps.propertytype NOT LIKE '%Semi-Detached%'
  GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid;

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, sp.id as spid,COUNT(ps.id), ps.beds,
         'Apartment' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types' AND h.search_types_id =  a.id AND propertytype LIKE '%Apartment%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm AND ps.beds = myear.beds
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND ps.propertytype LIKE '%Apartment%'
  GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid;

 END;
$$ LANGUAGE 'plpgsql';
    SPROC
  end

  def down
    execute "DROP FUNCTION IF EXISTS ab_historic_cnt()"
  end
end

