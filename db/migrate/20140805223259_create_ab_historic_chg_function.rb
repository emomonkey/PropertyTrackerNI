class CreateAbHistoricChgFunction < ActiveRecord::Migration
  def up
    execute <<-SPROC
CREATE OR REPLACE FUNCTION ab_historic_chg() RETURNS VOID AS $$

Declare stype integer;

BEGIN
SELECT id INTO stype FROM search_types WHERE searchtext = 'Highest Price Increase in Cnty';

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
SELECT ps.vmonth, ps.vyear, stype, ps.spid , ps.price  - allvals.avgprice,   ps.beds ,'Semi-detached' ,   ps.price  - allvals.avgprice,
to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')
FROM (SELECT to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') created_at, 'Semi-detached' as propertytype, beds, AVG(psv.price) price,
        EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, sp.id as spid,
        EXTRACT(MONTH FROM ps.created_at - INTERVAL '1 MONTH') as prvmonth, EXTRACT(YEAR FROM ps.created_at - INTERVAL '1 MONTH') as prvyear
      FROM property_sites ps, property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id
      AND sp.searchparam = ps.searchtext AND ps.propertytype LIKE '%Semi-detached%'
      GROUP BY to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy'), vyear,vmonth, ps.propertytype, ps.beds, spid, prvyear, prvmonth) ps
  LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id
             FROM historic_analyses WHERE search_types_id = stype AND propertytype LIKE '%Semi-detached%') myear
    ON ps.vyear || trim(to_char(ps.vmonth,'09')) =  myear.yrm AND ps.beds = myear.beds ,
  (SELECT EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, 'Semi-detached' as propertytype, ps.beds,
          AVG(price) as avgprice, sp.id as spid FROM property_sites ps , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND propertytype LIKE '%Semi-detached%'
  GROUP BY vyear,vmonth, propertytype, ps.beds, spid ) allvals
 WHERE  myear.yrm IS NULL AND ps.beds = allvals.beds AND ps.spid = allvals.spid
         AND   ps.prvmonth =  allvals.vmonth
        AND ps.prvyear = allvals.vyear;

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
SELECT ps.vmonth, ps.vyear, stype, ps.spid , ps.price  - allvals.avgprice,   ps.beds ,'Detached' ,   ps.price  - allvals.avgprice,
to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')
FROM (SELECT to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') created_at, 'Detached' as propertytype, beds, AVG(psv.price) price,
        EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, sp.id as spid,
        EXTRACT(MONTH FROM ps.created_at - INTERVAL '1 MONTH') as prvmonth, EXTRACT(YEAR FROM ps.created_at - INTERVAL '1 MONTH') as prvyear
      FROM property_sites ps, property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id
      AND sp.searchparam = ps.searchtext AND ps.propertytype LIKE '%Detached%' AND ps.propertytype NOT LIKE '%Semi-detached%'
      GROUP BY to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy'), vyear,vmonth, ps.propertytype, ps.beds, spid, prvyear, prvmonth) ps
  LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id
             FROM historic_analyses WHERE search_types_id = stype AND propertytype LIKE '%Detached%') myear
    ON ps.vyear || trim(to_char(ps.vmonth,'09')) =  myear.yrm AND ps.beds = myear.beds ,
  (SELECT EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, 'Detached' as propertytype, ps.beds,
          AVG(price) as avgprice, sp.id as spid FROM property_sites ps , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND propertytype LIKE '%Detached%' AND ps.propertytype NOT LIKE '%Semi-detached%'
  GROUP BY vyear,vmonth, propertytype, ps.beds, spid ) allvals
 WHERE  myear.yrm IS NULL AND ps.beds = allvals.beds AND ps.spid = allvals.spid
         AND   ps.prvmonth =  allvals.vmonth
        AND ps.prvyear = allvals.vyear;

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
SELECT ps.vmonth, ps.vyear, stype, ps.spid , ps.price  - allvals.avgprice,   ps.beds ,'Terrace' ,   ps.price  - allvals.avgprice,
to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')
FROM (SELECT  to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') created_at,'Terrace' as propertytype, beds, AVG(psv.price) price,
        EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, sp.id as spid,
        EXTRACT(MONTH FROM ps.created_at - INTERVAL '1 MONTH') as prvmonth, EXTRACT(YEAR FROM ps.created_at - INTERVAL '1 MONTH') as prvyear
      FROM property_sites ps, property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id
      AND sp.searchparam = ps.searchtext AND ps.propertytype LIKE '%Terrace%'
      GROUP BY to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy'), vyear,vmonth, ps.propertytype, ps.beds, spid, prvyear, prvmonth) ps
  LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id
             FROM historic_analyses WHERE search_types_id = stype AND propertytype LIKE '%Terrace%') myear
    ON ps.vyear || trim(to_char(ps.vmonth,'09')) =  myear.yrm AND ps.beds = myear.beds ,
  (SELECT EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, 'Terrace' as propertytype, ps.beds,
          AVG(price) as avgprice, sp.id as spid FROM property_sites ps , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND propertytype LIKE '%Terrace%'
  GROUP BY vyear,vmonth, propertytype, ps.beds, spid ) allvals
 WHERE  myear.yrm IS NULL AND ps.beds = allvals.beds AND ps.spid = allvals.spid
         AND   ps.prvmonth =  allvals.vmonth
        AND ps.prvyear = allvals.vyear;

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
SELECT ps.vmonth, ps.vyear, stype, ps.spid , ps.price  - allvals.avgprice,   ps.beds ,'Townhouse' ,   ps.price  - allvals.avgprice,
to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')
FROM (SELECT  to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') created_at,'Townhouse' as propertytype, beds, AVG(psv.price) price,
        EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, sp.id as spid,
        EXTRACT(MONTH FROM ps.created_at - INTERVAL '1 MONTH') as prvmonth, EXTRACT(YEAR FROM ps.created_at - INTERVAL '1 MONTH') as prvyear
      FROM property_sites ps, property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id
      AND sp.searchparam = ps.searchtext AND ps.propertytype LIKE '%Townhouse%'
      GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid, prvyear, prvmonth) ps
  LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id
             FROM historic_analyses WHERE search_types_id = stype AND propertytype LIKE '%Townhouse%') myear
    ON ps.vyear || trim(to_char(ps.vmonth,'09')) =  myear.yrm AND ps.beds = myear.beds ,
  (SELECT EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, 'Townhouse' as propertytype, ps.beds,
          AVG(price) as avgprice, sp.id as spid FROM property_sites ps , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND propertytype LIKE '%Townhouse%'
  GROUP BY to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy'), vyear,vmonth, propertytype, ps.beds, spid ) allvals
 WHERE  myear.yrm IS NULL AND ps.beds = allvals.beds AND ps.spid = allvals.spid
         AND   ps.prvmonth =  allvals.vmonth
        AND ps.prvyear = allvals.vyear;

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
SELECT ps.vmonth, ps.vyear, stype, ps.spid , ps.price  - allvals.avgprice,   ps.beds ,'Site' ,   ps.price  - allvals.avgprice,
to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')
FROM (SELECT  to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') created_at,'Site' as propertytype, beds, AVG(psv.price) price,
              EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, sp.id as spid,
              EXTRACT(MONTH FROM ps.created_at - INTERVAL '1 MONTH') as prvmonth, EXTRACT(YEAR FROM ps.created_at - INTERVAL '1 MONTH') as prvyear
      FROM property_sites ps, property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id
                        AND sp.searchparam = ps.searchtext AND (ps.propertytype LIKE '%Site%' OR ps.propertytype LIKE '%Land%')
      GROUP BY to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy'),vyear,vmonth, ps.propertytype, ps.beds, spid, prvyear, prvmonth) ps
  LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id
             FROM historic_analyses WHERE search_types_id = stype AND propertytype LIKE '%Site%') myear
    ON ps.vyear || trim(to_char(ps.vmonth,'09')) =  myear.yrm AND ps.beds = myear.beds ,
  (SELECT EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, 'Site' as propertytype, ps.beds,
          AVG(price) as avgprice, sp.id as spid FROM property_sites ps , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext
         AND (ps.propertytype LIKE '%Site%' or  ps.propertytype LIKE '%Land%')
   GROUP BY vyear,vmonth, propertytype, ps.beds, spid ) allvals
WHERE  myear.yrm IS NULL AND ps.beds = allvals.beds AND ps.spid = allvals.spid
       AND   ps.prvmonth =  allvals.vmonth
       AND ps.prvyear = allvals.vyear;

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
SELECT ps.vmonth, ps.vyear, stype, ps.spid , ps.price  - allvals.avgprice,   ps.beds ,'Cottage' ,   ps.price  - allvals.avgprice,
to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')
FROM (SELECT  to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') created_at,'Cottage' as propertytype, beds, AVG(psv.price) price,
        EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, sp.id as spid,
        EXTRACT(MONTH FROM ps.created_at - INTERVAL '1 MONTH') as prvmonth, EXTRACT(YEAR FROM ps.created_at - INTERVAL '1 MONTH') as prvyear
      FROM property_sites ps, property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id
      AND sp.searchparam = ps.searchtext AND ps.propertytype LIKE '%Cottage%' AND ps.propertytype NOT LIKE '%Semi-Detached%'
      GROUP BY to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy'), vyear,vmonth, ps.propertytype, ps.beds, spid, prvyear, prvmonth) ps
  LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id
             FROM historic_analyses WHERE search_types_id = stype AND propertytype LIKE '%Cottage%') myear
    ON ps.vyear || trim(to_char(ps.vmonth,'09')) =  myear.yrm AND ps.beds = myear.beds ,
  (SELECT EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, 'Cottage' as propertytype, ps.beds,
          AVG(price) as avgprice, sp.id as spid FROM property_sites ps , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND propertytype LIKE '%Cottage%' AND ps.propertytype NOT LIKE '%Semi-Detached%'
  GROUP BY vyear,vmonth, propertytype, ps.beds, spid ) allvals
 WHERE  myear.yrm IS NULL AND ps.beds = allvals.beds AND ps.spid = allvals.spid
         AND   ps.prvmonth =  allvals.vmonth
        AND ps.prvyear = allvals.vyear;


INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
SELECT ps.vmonth, ps.vyear, stype, ps.spid , ps.price  - allvals.avgprice,   ps.beds ,'Apartment' ,   ps.price  - allvals.avgprice,
to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')
FROM (SELECT to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') created_at, 'Apartment' as propertytype, beds, AVG(psv.price) price,
        EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, sp.id as spid,
        EXTRACT(MONTH FROM ps.created_at - INTERVAL '1 MONTH') as prvmonth, EXTRACT(YEAR FROM ps.created_at - INTERVAL '1 MONTH') as prvyear
      FROM property_sites ps, property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id
      AND sp.searchparam = ps.searchtext AND ps.propertytype LIKE '%Apartment%'
      GROUP BY to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy'), vyear,vmonth, ps.propertytype, ps.beds, spid, prvyear, prvmonth) ps
  LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, beds,propertytype, search_types_id
             FROM historic_analyses WHERE search_types_id = stype AND propertytype LIKE '%Apartment%') myear
    ON ps.vyear || trim(to_char(ps.vmonth,'09')) =  myear.yrm AND ps.beds = myear.beds ,
  (SELECT EXTRACT(MONTH FROM ps.created_at) as vmonth, EXTRACT(YEAR FROM ps.created_at) as vyear, 'Apartment' as propertytype, ps.beds,
          AVG(price) as avgprice, sp.id as spid FROM property_sites ps , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND propertytype LIKE '%Apartment%'
  GROUP BY vyear,vmonth, propertytype, ps.beds, spid ) allvals
 WHERE  myear.yrm IS NULL AND ps.beds = allvals.beds AND ps.spid = allvals.spid
         AND   ps.prvmonth =  allvals.vmonth
        AND ps.prvyear = allvals.vyear;

END;

$$ LANGUAGE 'plpgsql';
    SPROC
  end

  def down
    execute "DROP FUNCTION IF EXISTS ab_historic_chg()"
  end
end

