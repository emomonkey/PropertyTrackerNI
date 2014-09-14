class CreateAbHistoricAvgFunction < ActiveRecord::Migration
  def up
    execute <<-SPROC
CREATE OR REPLACE FUNCTION ab_historic_avg ()
  RETURNS void
AS
$BODY$
  Declare stype integer;

BEGIN
SELECT id INTO stype FROM search_types WHERE searchtext = 'Historic Avg';


INSERT INTO historic_analyses( month, year, search_types_id,  resulttext, propertytype, resultvalue, search_params_id,created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype,
    AVG(price),
    'Semi-detached', AVG(price) as avgprice,sp.id, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Historic Avg' AND h.search_types_id =  a.id AND lower(propertytype) LIKE '%semi-detached%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND lower(ps.propertytype) LIKE '%semi-detached%'
  GROUP BY vyear,vmonth, sp.id;


INSERT INTO historic_analyses( month, year, search_types_id,  resulttext, propertytype, resultvalue, search_params_id, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype,AVG(price),
         'Detached' as propertytype, AVG(price) as avgprice,sp.id, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Historic Avg' AND h.search_types_id =  a.id AND propertytype LIKE '%Detached%' AND propertytype NOT LIKE '%Semi-detached%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND lower(ps.propertytype) LIKE '%detached%' AND lower(ps.propertytype)
  NOT LIKE '%semi-detached%'
  GROUP BY vyear,vmonth,sp.id;

INSERT INTO historic_analyses( month, year, search_types_id, resulttext, propertytype, resultvalue, search_params_id, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype,AVG(price),
         'Terrace' as propertytype, AVG(price) as avgprice,sp.id, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')   FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm,propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Historic Avg' AND h.search_types_id =  a.id AND propertytype LIKE '%Terrace%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND lower(ps.propertytype) LIKE '%terrace%'
  GROUP BY vyear,vmonth,sp.id;



INSERT INTO historic_analyses( month, year, search_types_id, resulttext, propertytype, resultvalue, search_params_id, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, AVG(price),
         'Townhouse' as propertytype, AVG(price) as avgprice,sp.id, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')   FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Historic Avg' AND h.search_types_id =  a.id AND propertytype LIKE '%Townhouse%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND lower(ps.propertytype) LIKE '%townhouse%'
  GROUP BY vyear,vmonth,sp.id;

INSERT INTO historic_analyses( month, year, search_types_id, resulttext,propertytype, resultvalue, search_params_id, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype,AVG(price),
         'Site' as propertytype, AVG(price) as avgprice,sp.id, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')   FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Historic Avg' AND h.search_types_id =  a.id AND propertytype LIKE '%Site%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL and (ps.propertytype LIKE '%Land%' OR ps.propertytype LIKE '%Site%')
GROUP BY vyear,vmonth,sp.id;


INSERT INTO historic_analyses( month, year, search_types_id,  resulttext, propertytype, resultvalue, search_params_id, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype,AVG(price),
         'Cottage' as propertytype, AVG(price) as avgprice, sp.id, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Historic Avg' AND h.search_types_id =  a.id AND propertytype LIKE '%Cottage%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND lower(ps.propertytype) LIKE '%cottage%'
                                                        AND ps.propertytype NOT LIKE '%semi-detached%'
  GROUP BY vyear,vmonth,sp.id;

INSERT INTO historic_analyses( month, year, search_types_id,  resulttext, propertytype, resultvalue, search_params_id, created_at)
  SELECT EXTRACT (MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear,stype, AVG(price),
         'Apartment' as propertytype, AVG(price) as avgprice, sp.id, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps LEFT JOIN
    (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, propertytype, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Historic Avg' AND h.search_types_id =  a.id AND propertytype LIKE '%Apartment%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm
    , property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
                                                        AND myear.yrm IS NULL AND lower(ps.propertytype) LIKE '%apartment%'
  GROUP BY vyear,vmonth,sp.id;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;





    SPROC
  end

  def down
    execute "DROP FUNCTION IF EXISTS ab_historic_avg()"
  end
end

