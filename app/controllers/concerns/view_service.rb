class ViewService



def CountyStats

  sSql = "SELECT * FROM ac_historic_currvol_view"

  countystat = HistoricAnalysis.find_by_sql [sSql]


end

def fndavgareasldmthyr(varea)
  soldvol = SearchType.find_by_searchtext('Sold Summary Prop Type')
  sgap = Rails.application.secrets.month_gap;
  vpyear = 1.month.ago
  vgraph = GraphData.new
  vmonth = vpyear.month
  vyear = vpyear.year


  sSql = "SELECT propertytype, year, month, SUM(resultvalue) resval FROM historic_analyses a,  (SELECT MIN(created_at) startdate FROM historic_analyses WHERE search_types_id= #{soldvol.id}) c "\
           ", search_params sp WHERE sp.id = search_params_id AND search_params_id = #{varea} and a.created_at >= (c.startdate + INTERVAL '#{sgap} MONTH') AND search_types_id = #{soldvol.id}  GROUP BY propertytype, year, month ORDER BY propertytype, year,month"

  graphvol = HistoricAnalysis.find_by_sql(sSql)

  arrseries = Array.new
  arrcat = Array.new
  vprev = ""
  bfirst = true
  arrdata = Array.new
  graphvol.each do |paramprop|

    if vprev != paramprop.propertytype and vprev != ""
      arrseries << vprev
      vgraph.addseries(arrdata)
      bfirst = false
      arrdata = Array.new
    end



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

end

def fndavgareavolmthyr(varea)
  stypevol = SearchType.find_by_searchtext('Volume Summary Property Types')
  sgap = Rails.application.secrets.month_gap;
  vpyear = 1.month.ago
  vgraph = GraphData.new
  vmonth = vpyear.month
  vyear = vpyear.year


  sSql = "SELECT propertytype, year, month, SUM(resultvalue) resval FROM historic_analyses a,  (SELECT MIN(created_at) startdate FROM historic_analyses WHERE search_types_id= #{stypevol.id}) c "\
           ", search_params sp WHERE sp.id = search_params_id AND search_params_id = #{varea} and a.created_at >= (c.startdate + INTERVAL '#{sgap} MONTH') AND search_types_id = #{stypevol.id}  GROUP BY propertytype, year, month ORDER BY propertytype, year,month"

  graphvol = HistoricAnalysis.find_by_sql(sSql)

  arrseries = Array.new
  arrcat = Array.new
  vprev = ""
  bfirst = true
  arrdata = Array.new
  graphvol.each do |paramprop|

    if vprev != paramprop.propertytype and vprev != ""
      arrseries << vprev
      vgraph.addseries(arrdata)
      bfirst = false
      arrdata = Array.new
    end

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


end

def fndavgareaprcmthyr(varea)
  svol = SearchType.find_by_searchtext('Historic Avg')
  sgap = Rails.application.secrets.month_gap;

  sSql = "SELECT propertytype, year, month, AVG(resultvalue) resval FROM historic_analyses a,  (SELECT MIN(created_at) startdate FROM historic_analyses WHERE search_types_id= #{svol.id}) c "\
           ", search_params sp WHERE sp.id = search_params_id AND search_params_id = #{varea} and a.created_at >= (c.startdate + INTERVAL '#{sgap} MONTH') AND search_types_id = #{svol.id}  GROUP BY propertytype, year, month ORDER BY propertytype, year,month"


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
  Rails.logger.debug 'Error running viewservice.fndavgareaprcmthyr ' + e.message

end


end