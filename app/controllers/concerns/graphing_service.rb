class GraphingService

  def fndavgprcmthyr()
    svol = SearchType.find_by_searchtext('Historic Avg Overall')
    sgap = Rails.application.secrets.month_gap;

    sSql = "SELECT propertytype, year, month, AVG(resultvalue) resval FROM historic_analyses a,  (SELECT MIN(created_at) startdate FROM historic_analyses WHERE search_types_id= #{svol.id}) c "\
           " WHERE  a.created_at >= (c.startdate + INTERVAL '#{sgap} MONTH') AND search_types_id = #{svol.id}  GROUP BY propertytype, year, month ORDER BY propertytype, year,month"


    prptyvol  = HistoricAnalysis.find_by_sql(sSql)
    vgraph = GraphData.new
    arrcat = Array.new

    arrseries = Array.new

    vprev = ""
    bfirst = true
    arrdata = Array.new
    prptyvol.each do |paramprop|

      if vprev != paramprop.propertytype and vprev != ""
        arrseries << vprev
        vgraph.addseries(arrdata)
        bfirst = false
        arrdata = Array.new
      end

  #  if bfirst
  #      arrcat  <<  "%d%02d" % [paramprop.year, paramprop.month]
  #    end

      unless arrcat.include?("%d%02d" % [paramprop.year, paramprop.month])
        arrcat  <<  "%d%02d" % [paramprop.year, paramprop.month]
      end


      arrdata << paramprop.resval

      vprev = paramprop.propertytype
    end
    arrseries << vprev
    vgraph.arrseries = arrseries
    vgraph.addseries(arrdata)
    vgraph.category = arrcat
    return vgraph

  rescue StandardError => e
    Rails.logger.debug 'Error running graphingservice.fndavgprcmthyr ' + e.message

  end





  def fndavgprice(vym)
    savgprice_type = SearchType.find_by_searchtext('Historic Avg')

    sSql = "SELECT searchparam, county, round(avg(resultvalue)) as resultvalue FROM search_params a, historic_analyses h WHERE "\
           "search_params_id = a.id AND search_types_id = #{savgprice_type.id} AND TO_CHAR(h.created_at,'YYYYMM') = '#{vym}' GROUP BY  searchparam, county ORDER BY AVG(resultvalue) DESC LIMIT 10"

    savgprice  = HistoricAnalysis.find_by_sql(sSql)
    return savgprice

  rescue StandardError => e
    Rails.logger.debug 'Error running graphingservice.fndsoldbycnt ' + e.message
  end

  def fndvolbycnt(vym)
    svol = SearchType.find_by_searchtext('Volume Summary Property Types')

    sSql = "SELECT searchparam, county, sum(resultvalue) FROM search_params a, historic_analyses h WHERE "\
           "search_params_id = a.id AND search_types_id = #{svol.id} AND TO_CHAR(h.created_at,'YYYYMM') = '#{vym}' GROUP BY  searchparam, county ORDER BY SUM(resultvalue) DESC LIMIT 10"

    cntyvol  = HistoricAnalysis.find_by_sql(sSql)
    return cntyvol
  rescue StandardError => e
    Rails.logger.debug 'Error running graphingservice.fndvolbycnt ' + e.message
  end



  def fndvolcntysimple()
    stypevol = SearchType.find_by_searchtext('Volume Summary Property Types Overall')
    vpyear = 1.month.ago

    vmonth = vpyear.month
    vyear = vpyear.year

    graphvol  = HistoricAnalysis.select("propertytype ,sum(resultvalue) as vol").where(" search_types_id = ?  and month = ? and year = ?", stypevol.id, vmonth, vyear).group(" propertytype")


    vgraph = GraphData.new
    arrcat = Array.new
    arrdata = Array.new
    arrsold = Array.new
    soldvol = SearchType.find_by_searchtext('Sold Summary Prop Type')

    @soldgraph  = HistoricAnalysis.select("propertytype ,sum(resultvalue) as vol").where(" search_types_id = ?  and month = ? and year = ?", soldvol.id, vmonth, vyear).group(" propertytype")


    graphvol.each do |gdata|
      vsold = @soldgraph.find_by propertytype: gdata.propertytype

      if vsold.nil?
        arrsold << 0
      else
        arrsold << vsold.vol
      end

      arrcat << "%s" % [gdata.propertytype]
      arrdata << gdata.vol
    end

    vgraph.category = arrcat

    vgraph.addseries(arrdata)
    vgraph.addseries(arrsold)
    vgraph.arrseries = ['On Sale', 'Sold/Sale Agreed']


    return vgraph


  end



  # FindVolCol Volume Sales PropertyType Past Year
  def fndvolall()
    @stypetxt = SearchType.find_by_searchtext('Volume Sales')

    vpyear = 12.month.ago
    graphvol = HistoricAnalysis.select("propertytype ,count(id) as vol").where(" search_types_id = ?  and created_at > ?", @stypetxt.id, 12.months.ago).group(" propertytype")

    arrcat = Array.new
    arrdata = Array.new

    graphvol.each do |gdata|
      arrcat << "%s" % [gdata.propertytype]
      arrdata << gdata.vol
    end

    return {:categories =>  arrcat, :data => arrdata}
  end




end