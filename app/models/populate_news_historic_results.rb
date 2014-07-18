class PopulateNewsHistoricResults

  def initialize()

  end

  def start()
    calculatemonthavg
    calculatemonthmin
    calculatemonthvol
    volumelowproptype
    soldproptype
  end


  def calculatemonthvol()
    stypetxt = SearchType.find_by_searchtext('Volume Sales')
    @stid = stypetxt.id

    # Calculate month vol for room, propertytype, searchtext, county

    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, ps.propertytype, ps.beds, COUNT(price) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, beds,propertytype, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @stid.to_s
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm AND ps.beds = myear.beds AND ps.propertytype = myear.propertytype AND myear.search_types_id = "
    sSql = sSql + @stid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL "\
           " GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid "

    @vresprop = PropertySiteValue.find_by_sql(sSql)
    @vresprop.each do |phist|
      HistoricAnalysis.create(:year => phist.vyear ,:month => phist.vmonth , :search_types_id => @stid , :search_params_id => phist.spid, :propertytype => phist.propertytype, :beds => phist.beds, :resulttext => phist.vol, :resultvalue => phist.vol)
    end

  rescue StandardError => e
    Rails.logger.debug 'Error running PopulateNewsHistoric.calculatemonthvol ' + e.message


  end

  def soldproptype()
    stypetxt = SearchType.find_by_searchtext('Sold Summary Prop Type')
    stype = stypetxt.id

    sSql = "SELECT MONTH(ps.solddate) as vmonth, YEAR(ps.solddate) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + stype.to_s + " AND propertytype LIKE '%Semi-detached%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.solddate,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + stype.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND ps.propertytype LIKE '%Semi-detached%' AND ps.solddate IS NOT NULL "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "
    vsemi = PropertySiteValue.find_by_sql(sSql)

    vsemi.each do |psemi|
      HistoricAnalysis.create(:year => psemi.vyear ,:month => psemi.vmonth , :search_types_id => stype , :search_params_id => psemi.spid, :propertytype => "Semi-detached", :beds => 0, :resulttext => psemi.vol.to_s , :resultvalue => psemi.vol)
    end

    sSql = "SELECT MONTH(ps.solddate) as vmonth, YEAR(ps.solddate) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + stype.to_s + " AND propertytype LIKE '%Detached%' AND propertytype NOT LIKE '%Semi-detached%' "
    sSql <<  ") myear ON DATE_FORMAT(ps.solddate,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + stype.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND propertytype LIKE '%Detached%' AND ps.solddate IS NOT NULL AND propertytype NOT LIKE '%Semi-detached%' "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "

    vdet = PropertySiteValue.find_by_sql(sSql)

    vdet.each do |pdet|
      HistoricAnalysis.create(:year => pdet.vyear ,:month => pdet.vmonth , :search_types_id => stype , :search_params_id => pdet.spid, :propertytype => 'Detached', :beds => 0, :resulttext => pdet.vol, :resultvalue => pdet.vol)
    end

    sSql = "SELECT MONTH(ps.solddate) as vmonth, YEAR(ps.solddate) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + stype.to_s + " AND propertytype LIKE '%Terrace%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.solddate,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + stype.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND propertytype LIKE '%Terrace%'  AND ps.solddate IS NOT NULL "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "

    vterr = PropertySiteValue.find_by_sql(sSql)

    vterr.each do |pterr|
      HistoricAnalysis.create(:year => pterr.vyear ,:month => pterr.vmonth , :search_types_id => stype , :search_params_id => pterr.spid, :propertytype => 'Terrace', :beds => 0, :resulttext => pterr.vol, :resultvalue => pterr.vol)
    end

    sSql = "SELECT MONTH(ps.solddate) as vmonth, YEAR(ps.solddate) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + stype.to_s + " AND propertytype LIKE '%Townhouse%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.solddate,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + stype.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND propertytype LIKE '%Townhouse%'  AND ps.solddate IS NOT NULL  "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "

    vtown = PropertySiteValue.find_by_sql(sSql)

    vtown.each do |ptown|
      HistoricAnalysis.create(:year => ptown.vyear ,:month => ptown.vmonth , :search_types_id => stype , :search_params_id => ptown.spid, :propertytype => 'Townhouse', :beds => 0, :resulttext => ptown.vol, :resultvalue => ptown.vol)
    end


    sSql = "SELECT MONTH(ps.solddate) as vmonth, YEAR(ps.solddate) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + stype.to_s + " AND propertytype LIKE '%Site%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.solddate,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + stype.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND (propertytype LIKE '%Land%' OR propertytype LIKE '%Site%')  AND ps.solddate IS NOT NULL "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "

    vland = PropertySiteValue.find_by_sql(sSql)


    vland.each do |psite|
      HistoricAnalysis.create(:year => psite.vyear ,:month => psite.vmonth , :search_types_id => stype , :search_params_id => psite.spid, :propertytype => 'Site', :beds => 0, :resulttext => psite.vol, :resultvalue => psite.vol)
    end


    sSql = "SELECT MONTH(ps.solddate) as vmonth, YEAR(ps.solddate) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + stype.to_s + " AND propertytype LIKE '%Cottage%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.solddate,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + stype.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND propertytype LIKE '%Cottage%'  AND ps.solddate IS NOT NULL "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "

    vcottage = PropertySiteValue.find_by_sql(sSql)

    vcottage.each do |pcot|
      HistoricAnalysis.create(:year => pcot.vyear ,:month => pcot.vmonth , :search_types_id => stype , :search_params_id => pcot.spid, :propertytype => 'Cottage', :beds => 0, :resulttext => pcot.vol, :resultvalue => pcot.vol)
    end


    sSql = "SELECT MONTH(ps.solddate) as vmonth, YEAR(ps.solddate) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + stype.to_s + " AND propertytype LIKE '%Apartment%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.solddate,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + stype.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND propertytype LIKE '%Apartment%'  AND ps.solddate IS NOT NULL "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "

    vapt = PropertySiteValue.find_by_sql(sSql)


    vapt.each do |papt|
      HistoricAnalysis.create(:year => papt.vyear ,:month => papt.vmonth , :search_types_id => stype , :search_params_id => papt.spid, :propertytype => 'Apartment', :beds => 0, :resulttext => papt.vol, :resultvalue => papt.vol)
    end
    # soldproptype

  rescue StandardError => e
    Rails.logger.debug 'Error running PopulateNewsHistoric.soldproptype ' + e.message


  end

  def volumelowproptype()
    stypetxt = SearchType.find_by_searchtext('Volume Summary Property Types')
    @stid = stypetxt.id
    #vsemi = PropertySite.where(["propertytype LIKE :type", {:type => 'Semi-detached'}]).select("MONTH(created_at) as vmonth, YEAR(created_at) as vyear, propertytype, ps.beds, COUNT(price) as vol, sp.id as spid")

    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @stid.to_s + " AND propertytype LIKE '%Semi-detached%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + @stid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND propertytype LIKE '%Semi-detached%' "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "
    vsemi = PropertySiteValue.find_by_sql(sSql)


    vsemi.each do |psemi|
      HistoricAnalysis.create(:year => psemi.vyear ,:month => psemi.vmonth , :search_types_id => @stid , :search_params_id => psemi.spid, :propertytype => "Semi-detached", :beds => 0, :resulttext => psemi.vol.to_s , :resultvalue => psemi.vol)
    end


    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @stid.to_s + " AND propertytype LIKE '%Detached%' AND propertytype NOT LIKE '%Semi-detached%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + @stid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND propertytype LIKE '%Detached%' AND propertytype NOT LIKE '%Semi-detached%' "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "

    vdet = PropertySiteValue.find_by_sql(sSql)

    vdet.each do |pdet|
      HistoricAnalysis.create(:year => pdet.vyear ,:month => pdet.vmonth , :search_types_id => @stid , :search_params_id => pdet.spid, :propertytype => 'Detached', :beds => 0, :resulttext => pdet.vol, :resultvalue => pdet.vol)
    end


    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @stid.to_s + " AND propertytype LIKE '%Terrace%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + @stid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND propertytype LIKE '%Terrace%' "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "

    vterr = PropertySiteValue.find_by_sql(sSql)

    vterr.each do |pterr|
      HistoricAnalysis.create(:year => pterr.vyear ,:month => pterr.vmonth , :search_types_id => @stid , :search_params_id => pterr.spid, :propertytype => 'Terrace', :beds => 0, :resulttext => pterr.vol, :resultvalue => pterr.vol)
    end

    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @stid.to_s + " AND propertytype LIKE '%Townhouse%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + @stid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND propertytype LIKE '%Townhouse%' "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "

    vtown = PropertySiteValue.find_by_sql(sSql)

    vtown.each do |ptown|
      HistoricAnalysis.create(:year => ptown.vyear ,:month => ptown.vmonth , :search_types_id => @stid , :search_params_id => ptown.spid, :propertytype => 'Townhouse', :beds => 0, :resulttext => ptown.vol, :resultvalue => ptown.vol)
    end


    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @stid.to_s + " AND propertytype LIKE '%Site%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + @stid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND (propertytype LIKE '%Land%' OR propertytype LIKE '%Site%')"
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "

    vland = PropertySiteValue.find_by_sql(sSql)


    vland.each do |psite|
      HistoricAnalysis.create(:year => psite.vyear ,:month => psite.vmonth , :search_types_id => @stid , :search_params_id => psite.spid, :propertytype => 'Site', :beds => 0, :resulttext => psite.vol, :resultvalue => psite.vol)
    end


    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @stid.to_s + " AND propertytype LIKE '%Cottage%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + @stid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND propertytype LIKE '%Cottage%' "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "

    vcottage = PropertySiteValue.find_by_sql(sSql)

    vcottage.each do |pcot|
      HistoricAnalysis.create(:year => pcot.vyear ,:month => pcot.vmonth , :search_types_id => @stid , :search_params_id => pcot.spid, :propertytype => 'Cottage', :beds => 0, :resulttext => pcot.vol, :resultvalue => pcot.vol)
    end


    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, COUNT(ps.id) as vol, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, LPAD(month,2,0)) yrm, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @stid.to_s + " AND propertytype LIKE '%Apartment%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm  AND myear.search_types_id = "
    sSql = sSql + @stid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext"\
           " AND myear.yrm IS NULL "
    sSql = sSql + " AND propertytype LIKE '%Apartment%' "
    sSql = sSql  +     " GROUP BY vyear,vmonth,  spid "

    vapt = PropertySiteValue.find_by_sql(sSql)


    vapt.each do |papt|
      HistoricAnalysis.create(:year => papt.vyear ,:month => papt.vmonth , :search_types_id => @stid , :search_params_id => papt.spid, :propertytype => 'Apartment', :beds => 0, :resulttext => papt.vol, :resultvalue => papt.vol)
    end



    # Semi-detached
    # Detached
    # Terrace
    # Townhouse
    # Land Site
    # Cottage
  # Apartment
  rescue StandardError => e
    Rails.logger.debug 'Error running PopulateNewsHistoric.volumelowproptype ' + e.message

  end

  def calculatemonthavg()
    @stype = SearchType.find_by_searchtext('Historic Avg')
    @sid = @stype.id
    # Calculate month avg for room, propertytype, searchtext, county

    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, ps.propertytype, ps.beds, AVG(price) as avgprice, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, month) yrm, beds,propertytype, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @sid.to_s + " AND propertytype LIKE '%Semi-detached%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm AND ps.beds = myear.beds AND ps.propertytype = myear.propertytype AND myear.search_types_id = "
    sSql = sSql + @sid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL "\
           " AND ps.propertytype LIKE '%Semi-detached%' GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid "
    @vresprop = PropertySiteValue.find_by_sql(sSql)
    @vresprop.each do |phist|
      HistoricAnalysis.create(:year => phist.vyear ,:month => phist.vmonth , :search_types_id => @sid , :search_params_id => phist.spid, :propertytype => 'Semi-detached', :beds => phist.beds, :resulttext => phist.avgprice, :resultvalue => phist.avgprice)
    end

    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, ps.propertytype, ps.beds, AVG(price) as avgprice, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, month) yrm, beds,propertytype, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @sid.to_s + " AND propertytype LIKE '%Detached%' AND propertytype NOT LIKE '%Semi-detached%' "
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm AND ps.beds = myear.beds AND ps.propertytype = myear.propertytype AND myear.search_types_id = "
    sSql = sSql + @sid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL "\
           " AND ps.propertytype LIKE '%Detached%' AND ps.propertytype NOT LIKE '%Semi-detached%' GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid "
    @vdresprop = PropertySiteValue.find_by_sql(sSql)
    @vdresprop.each do |pdet|
      HistoricAnalysis.create(:year => pdet.vyear ,:month => pdet.vmonth , :search_types_id => @sid , :search_params_id => pdet.spid, :propertytype => 'Detached', :beds => pdet.beds, :resulttext => pdet.avgprice, :resultvalue => pdet.avgprice)
    end

    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, ps.propertytype, ps.beds, AVG(price) as avgprice, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, month) yrm, beds,propertytype, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @sid.to_s + " AND propertytype LIKE '%Terrace%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm AND ps.beds = myear.beds AND ps.propertytype = myear.propertytype AND myear.search_types_id = "
    sSql = sSql + @sid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL "\
           " AND ps.propertytype LIKE '%Terrace%' GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid "
    @vterrprop = PropertySiteValue.find_by_sql(sSql)
    @vterrprop.each do |pterr|
      HistoricAnalysis.create(:year => pterr.vyear ,:month => pterr.vmonth , :search_types_id => @sid , :search_params_id => pterr.spid, :propertytype => 'Terrace', :beds => pterr.beds, :resulttext => pterr.avgprice, :resultvalue => pterr.avgprice)
    end

    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, ps.propertytype, ps.beds, AVG(price) as avgprice, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, month) yrm, beds,propertytype, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @sid.to_s + " AND propertytype LIKE '%Townhouse%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm AND ps.beds = myear.beds AND ps.propertytype = myear.propertytype AND myear.search_types_id = "
    sSql = sSql + @sid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL "\
           " AND ps.propertytype LIKE '%Townhouse%' GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid "
    @vtownprop = PropertySiteValue.find_by_sql(sSql)
    @vtownprop.each do |ptown|
      HistoricAnalysis.create(:year => ptown.vyear ,:month => ptown.vmonth , :search_types_id => @sid , :search_params_id => ptown.spid, :propertytype => 'Townhouse', :beds => ptown.beds, :resulttext => ptown.avgprice, :resultvalue => ptown.avgprice)
    end

    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, ps.propertytype, ps.beds, AVG(price) as avgprice, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, month) yrm, beds,propertytype, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @sid.to_s + " AND propertytype LIKE '%Site%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm AND ps.beds = myear.beds AND ps.propertytype = myear.propertytype AND myear.search_types_id = "
    sSql = sSql + @sid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL "\
           " AND (ps.propertytype LIKE '%Land%' OR ps.propertytype LIKE '%Site%') GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid "


    @vsiteprop = PropertySiteValue.find_by_sql(sSql)
    @vsiteprop.each do |psite|
      HistoricAnalysis.create(:year => psite.vyear ,:month => psite.vmonth , :search_types_id => @sid , :search_params_id => psite.spid, :propertytype => 'Site', :beds => psite.beds, :resulttext => psite.avgprice, :resultvalue => psite.avgprice)
    end

    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, ps.propertytype, ps.beds, AVG(price) as avgprice, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, month) yrm, beds,propertytype, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @sid.to_s + " AND propertytype LIKE '%Cottage%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm AND ps.beds = myear.beds AND ps.propertytype = myear.propertytype AND myear.search_types_id = "
    sSql = sSql + @sid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL "\
           " AND ps.propertytype LIKE '%Cottage%' GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid "
    @vcotprop = PropertySiteValue.find_by_sql(sSql)
    @vcotprop.each do |pcot|
      HistoricAnalysis.create(:year => pcot.vyear ,:month => pcot.vmonth , :search_types_id => @sid , :search_params_id => pcot.spid, :propertytype => 'Townhouse', :beds => pcot.beds, :resulttext => pcot.avgprice, :resultvalue => pcot.avgprice)
    end

    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, ps.propertytype, ps.beds, AVG(price) as avgprice, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, month) yrm, beds,propertytype, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @sid.to_s + " AND propertytype LIKE '%Apartment%'"
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm AND ps.beds = myear.beds AND ps.propertytype = myear.propertytype AND myear.search_types_id = "
    sSql = sSql + @sid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL "\
           " AND ps.propertytype LIKE '%Apartment%' GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid "
    @vaptprop = PropertySiteValue.find_by_sql(sSql)
    @vaptprop.each do |papt|
      HistoricAnalysis.create(:year => papt.vyear ,:month => papt.vmonth , :search_types_id => @sid , :search_params_id => papt.spid, :propertytype => 'Apartment', :beds => papt.beds, :resulttext => papt.avgprice, :resultvalue => papt.avgprice)
    end

      # Semi-detached
      # Detached
      # Terrace
      # Townhouse
      # Land Site
      # Cottage
      # Apartment

    rescue StandardError => e
      Rails.logger.debug 'Error running PopulateNewsHistoric.calculatemonthavg ' + e.message
  end

  def calculatemonthmin()
    @stypemin = SearchType.find_by_searchtext('Historic Min')
    @sminid = @stypemin.id
    # Calculate month min for room, propertytype, searchtext, county
    sSql = "SELECT MONTH(ps.created_at) as vmonth, YEAR(ps.created_at) as vyear, ps.propertytype, ps.beds, MIN(price) as minprice, sp.id as spid  FROM property_sites ps "\
            "LEFT JOIN (SELECT DISTINCT CONCAT(year, month) yrm, beds,propertytype, search_types_id FROM historic_analyses WHERE search_types_id = "
    sSql = sSql + @sminid.to_s
    sSql <<  ") myear ON DATE_FORMAT(ps.created_at,'%Y%m') = "\
           " myear.yrm AND ps.beds = myear.beds AND ps.propertytype = myear.propertytype AND myear.search_types_id = "
    sSql = sSql + @sminid.to_s
    sSql <<  ", property_site_values psv , search_params sp WHERE ps.id = psv.property_site_id AND sp.searchparam = ps.searchtext AND myear.yrm IS NULL "\
           " GROUP BY vyear,vmonth, ps.propertytype, ps.beds, spid "

    @vrespropm = PropertySiteValue.find_by_sql(sSql)
    @vrespropm.each do |phist|
      HistoricAnalysis.create(:year => phist.vyear ,:month => phist.vmonth , :search_types_id => @sminid , :search_params_id => phist.spid, :propertytype => phist.propertytype, :beds => phist.beds, :resulttext => phist.minprice, :resultvalue => phist.minprice)
    end

  rescue StandardError => e
    Rails.logger.debug 'Error running PopulateNewsHistoric.calculatemonthmin ' + e.message
  end


end