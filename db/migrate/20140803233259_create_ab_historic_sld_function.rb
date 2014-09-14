class CreateAbHistoricSldFunction < ActiveRecord::Migration
  def up
    execute <<-SPROC
CREATE OR REPLACE FUNCTION ab_historic_sld() RETURNS VOID AS $$
  DECLARE stype integer;
  BEGIN

  SELECT id INTO stype FROM search_types WHERE searchtext = 'Sold Summary Prop Type';

  INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
    SELECT EXTRACT(MONTH FROM ps.solddate) as vmonth, EXTRACT(YEAR FROM ps.solddate) as vyear, stype, sp.id as spid ,COUNT(ps.id) as vol,0,'Semi-detached',COUNT(ps.id),
to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')   FROM property_sites ps
            LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Sold Summary Prop Type' AND h.search_types_id =  a.id  AND propertytype LIKE '%Semi-detached%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL
   AND lower(ps.propertytype) LIKE '%semi-detached%' AND ps.solddate IS NOT NULL
   GROUP BY vyear,vmonth,  spid, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') ;



INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
    SELECT EXTRACT(MONTH FROM ps.solddate) as vmonth, EXTRACT(YEAR FROM ps.solddate) as vyear, stype, sp.id as spid ,COUNT(ps.id) as vol,0,'Detached',COUNT(ps.id),
   to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps
            LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Sold Summary Prop Type' AND h.search_types_id =  a.id  AND propertytype LIKE '%Detached%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL
   AND lower(ps.propertytype) LIKE '%detached%' AND lower(ps.propertytype) NOT LIKE '%semi-detached%' AND ps.solddate IS NOT NULL
   GROUP BY vyear,vmonth,  spid, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') ;

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
    SELECT EXTRACT(MONTH FROM ps.solddate) as vmonth, EXTRACT(YEAR FROM ps.solddate) as vyear, stype, sp.id as spid ,COUNT(ps.id) as vol,0,'Terrace',COUNT(ps.id),
  to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps
            LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Sold Summary Prop Type' AND h.search_types_id =  a.id  AND propertytype LIKE '%Terrace%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL
   AND ps.propertytype LIKE '%Terrace%' AND ps.solddate IS NOT NULL
   GROUP BY vyear,vmonth,  spid, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') ;

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
    SELECT EXTRACT(MONTH FROM ps.solddate) as vmonth, EXTRACT(YEAR FROM ps.solddate) as vyear, stype, sp.id as spid ,COUNT(ps.id) as vol,0,'Townhouse',COUNT(ps.id),
   to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps
            LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Sold Summary Prop Type' AND h.search_types_id =  a.id  AND propertytype LIKE '%Townhouse%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL
   AND ps.propertytype LIKE '%Townhouse%' AND ps.solddate IS NOT NULL
   GROUP BY vyear,vmonth,  spid, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') ;


INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
    SELECT EXTRACT(MONTH FROM ps.solddate) as vmonth, EXTRACT(YEAR FROM ps.solddate) as vyear, stype, sp.id as spid ,COUNT(ps.id) as vol,0,'Site',COUNT(ps.id),
    to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps
            LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Sold Summary Prop Type' AND h.search_types_id =  a.id  AND propertytype LIKE '%Site%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL
   and (ps.propertytype LIKE '%Land%' OR ps.propertytype LIKE '%Site%') AND ps.solddate IS NOT NULL
   GROUP BY vyear,vmonth,  spid, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') ;

INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
    SELECT EXTRACT(MONTH FROM ps.solddate) as vmonth, EXTRACT(YEAR FROM ps.solddate) as vyear, stype, sp.id as spid ,COUNT(ps.id) as vol,0,'Cottage',COUNT(ps.id),
    to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') FROM property_sites ps
            LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Sold Summary Prop Type' AND h.search_types_id =  a.id  AND propertytype LIKE '%Cottage%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL
   AND ps.propertytype LIKE '%Cottage%' AND ps.propertytype NOT LIKE '%Semi-Detached%' AND ps.solddate IS NOT NULL
   GROUP BY vyear,vmonth,  spid, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') ;


INSERT INTO historic_analyses( month, year, search_types_id, search_params_id, resulttext, beds, propertytype, resultvalue, created_at)
    SELECT EXTRACT(MONTH FROM ps.solddate) as vmonth, EXTRACT(YEAR FROM ps.solddate) as vyear, stype, sp.id as spid ,COUNT(ps.id) as vol,0,'Apartment',COUNT(ps.id),
    to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy')  FROM property_sites ps
            LEFT JOIN (SELECT DISTINCT year || trim(to_char(month,'09')) yrm, search_types_id FROM historic_analyses h, search_types a
    WHERE searchtext = 'Sold Summary Prop Type' AND h.search_types_id =  a.id  AND propertytype LIKE '%Apartment%'
    ) myear ON TO_CHAR(ps.created_at,'YYYYmm') =  myear.yrm , property_site_values psv , search_params sp
   WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL
   AND ps.propertytype LIKE '%Apartment%' AND ps.solddate IS NOT NULL
   GROUP BY vyear,vmonth,  spid, to_date('01/' || EXTRACT (MONTH FROM ps.created_at) || '/' || EXTRACT (YEAR FROM ps.created_at),'dd/mm/yyyy') ;
 END;
$$ LANGUAGE 'plpgsql';
    SPROC
  end

  def down
    execute "DROP FUNCTION IF EXISTS ab_historic_sld()"
  end
end

