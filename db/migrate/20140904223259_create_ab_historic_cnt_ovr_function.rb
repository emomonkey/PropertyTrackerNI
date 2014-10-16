class CreateAbHistoricCntOvrFunction < ActiveRecord::Migration
  def up
    execute <<-SPROC
CREATE OR REPLACE FUNCTION ab_historic_cnt_ovr() RETURNS VOID AS $$
Declare stype integer;
BEGIN
SELECT id INTO stype FROM search_types WHERE searchtext = 'Volume Summary Property Types Overall';


INSERT INTO historic_analyses( month, year, search_types_id, resulttext,propertytype, resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype,COUNT(ps.id),
    'Semi-detached' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types Overall' AND h.search_types_id =  a.id AND propertytype LIKE '%Semi-detached%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND lower(ps.propertytype) LIKE '%semi-detached%'
  GROUP BY vyear,vmonth;

INSERT INTO historic_analyses( month, year, search_types_id, resulttext, propertytype,resultvalue, created_At)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, COUNT(ps.id),
         'Detached' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm,  search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types Overall' AND h.search_types_id =  a.id AND lower(propertytype) LIKE '%detached%' AND lower(propertytype) NOT LIKE '%semi-detached%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
 , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                     AND myear.yrm IS NULL AND lower(ps.propertytype) LIKE '%detached%' AND lower(ps.propertytype) NOT LIKE '%semi-detached%'
  GROUP BY vyear,vmonth;

INSERT INTO historic_analyses( month, year, search_types_id, resulttext, propertytype,resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, COUNT(ps.id),
         'Terrace' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types Overall' AND h.search_types_id =  a.id AND propertytype LIKE '%Terrace%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND lower(ps.propertytype) LIKE '%terrace%'
  GROUP BY vyear,vmonth;



INSERT INTO historic_analyses( month, year, search_types_id, resulttext, propertytype,resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype,COUNT(ps.id),
         'Townhouse' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm,  search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types Overall' AND h.search_types_id =  a.id AND propertytype LIKE '%Townhouse%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND lower(ps.propertytype) LIKE '%townhouse%'
  GROUP BY vyear,vmonth;

INSERT INTO historic_analyses( month, year, search_types_id, resulttext, propertytype, resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype,COUNT(ps.id),
         'Site' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types Overall' AND h.search_types_id =  a.id AND propertytype LIKE '%Site%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL and (ps.propertytype LIKE '%Land%' OR ps.propertytype LIKE '%Site%')
GROUP BY vyear,vmonth;


INSERT INTO historic_analyses( month, year, search_types_id, resulttext, propertytype, resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, COUNT(ps.id),
         'Cottage' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm,  search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types Overall' AND h.search_types_id =  a.id AND propertytype LIKE '%Cottage%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND lower(ps.propertytype) LIKE '%cottage%' AND ps.propertytype NOT LIKE '%Semi-Detached%'
  GROUP BY vyear,vmonth;

INSERT INTO historic_analyses( month, year, search_types_id,  resulttext, propertytype, resultvalue, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype,COUNT(ps.id),
         'Apartment' as propertytype, COUNT(ps.id), to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Volume Summary Property Types Overall' AND h.search_types_id =  a.id AND propertytype LIKE '%Apartment%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND lower(ps.propertytype) LIKE '%apartment%'
  GROUP BY vyear,vmonth;

 END;
$$ LANGUAGE 'plpgsql';

    SPROC
  end

  def down
    execute "DROP FUNCTION IF EXISTS ab_historic_cnt_ovr()"
  end
end

