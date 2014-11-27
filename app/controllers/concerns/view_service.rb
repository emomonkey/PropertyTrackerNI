class ViewService

def CountyPriceStats
  sSql = "SELECT * FROM ae_historic_curravg_view"
  countystat = HistoricAnalysis.find_by_sql [sSql]
end

def CountyStats
  sSql = "SELECT * FROM ac_historic_currvol_view"
  countystat = HistoricAnalysis.find_by_sql [sSql]
end

def fndavgareasldmthyr(varea)
  soldvol = SearchType.find_by_searchtext('Sold Summary Prop Type')
  vpyear = 1.month.ago
  vgraph = GraphData.new

  sSql = " SELECT d.propertytype, d.year, d.month, totalvalue resval FROM   ae_historic_propyear_mview d " \
  " LEFT OUTER JOIN (SELECT propertytype, year, month, SUM(resultvalue) totalvalue FROM historic_analyses, search_params sp WHERE sp.id = search_params_id "\
  " AND search_params_id = #{varea} AND search_types_id = #{soldvol.id} GROUP BY propertytype, year, month ) a "\
  " ON d.propertytype= a.propertytype AND d.year = a.year AND d.month = a.month  ORDER BY propertytype, year,month"



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


  sSql = " SELECT d.propertytype, d.year, d.month, totalvalue resval FROM   ae_historic_propyear_mview d " \
  " LEFT OUTER JOIN (SELECT propertytype, year, month, SUM(resultvalue) totalvalue FROM historic_analyses, search_params sp  WHERE sp.id = search_params_id "\
  " AND search_params_id = #{varea} AND search_types_id = #{stypevol.id} GROUP BY propertytype, year, month ) a "\
  " ON d.propertytype= a.propertytype AND d.year = a.year AND d.month = a.month  ORDER BY propertytype, year,month"


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

#  sSql = "SELECT propertytype, year, month, AVG(resultvalue) resval FROM historic_analyses a,  (SELECT MIN(created_at) startdate FROM historic_analyses WHERE search_types_id= #{svol.id}) c "\
#           ", search_params sp WHERE sp.id = search_params_id AND search_params_id = #{varea} and a.created_at >= (c.startdate + INTERVAL '#{sgap} MONTH') AND search_types_id = #{svol.id}  GROUP BY propertytype, year, month ORDER BY propertytype, year,month"

#  sSql = " SELECT d.propertytype, d.year, d.month, coalesce(totalvalue,0) resval FROM   ae_historic_propyear_mview d " \
  sSql = " SELECT d.propertytype, d.year, d.month, totalvalue resval FROM   ae_historic_propyear_mview d " \
  " LEFT OUTER JOIN (SELECT propertytype, year, month, AVG(resultvalue) totalvalue FROM historic_analyses, search_params sp WHERE sp.id = search_params_id "\
  " AND search_params_id = #{varea} AND search_types_id = #{svol.id} GROUP BY propertytype, year, month ) a "\
  " ON d.propertytype= a.propertytype AND d.year = a.year AND d.month = a.month   ORDER BY propertytype, year,month"


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

    if paramprop.resval.to_i == 0
      arrdata << nil
    else
      arrdata << paramprop.resval.to_i
    end


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


def drawgraphdetail(varea)
  # Price Graph for Town

  prccnty = fndavgareaprcmthyr(varea)
  vAreaRec = SearchParams.find(varea)


  prccntychart =  LazyHighCharts::HighChart.new('graph') do |e|
    e.title(:text => "Average Price PropertyType")
    e.xAxis(:categories => prccnty.category)

    e.chart({:defaultSeriesType=>"column"})
   # e.options[:plotOptions] = { line: { connectNulls: false  }}
    e.legend(:align => 'right', :verticalAlign => 'top', :y => 0, :x => -50, :layout => 'vertical',)

    e.yAxis [
                {:title => {:text => "Price", :margin => 5} }
            ]

    prccnty.series.each_with_index do  |pseries , index |
     # cval =  pseries.map { |i| i.to_i}
      e.series(:name => prccnty.arrseries[index], :yAxis => 0, :data => pseries)
    end
    end



    # Volume for Town Volume Sold
    volareacnty = fndavgareavolmthyr(varea)

    volcntychart =  LazyHighCharts::HighChart.new('graph') do |e|
      e.title(:text => "Volume Sale PropertyType")
      e.xAxis(:categories => volareacnty.category)

      e.legend(:align => 'right', :verticalAlign => 'top', :y => 0, :x => -50, :layout => 'vertical',)

      e.yAxis [
                  {:title => {:text => "Volume", :margin => 5} }
              ]
      e.chart({:defaultSeriesType=>"column"})

      volareacnty.series.each_with_index do  |pseries , index |
     #   cval =  pseries.map { |i| i.to_i}
        e.series(:name => volareacnty.arrseries[index], :yAxis => 0, :data =>pseries)
      end
    end

    # Sold Volumn for Town
    soldcnty = fndavgareasldmthyr(varea)

    sldcntychart =  LazyHighCharts::HighChart.new('graph') do |e|
      e.title(:text => "Volume Sold PropertyType")
      e.xAxis(:categories => soldcnty.category)

      e.legend(:align => 'right', :verticalAlign => 'top', :y => 0, :x => -50, :layout => 'vertical',)

      e.chart({:defaultSeriesType=>"column"})

      e.yAxis [
                  {:title => {:text => "Volume", :margin => 5} }
              ]

      soldcnty.series.each_with_index do  |pseries , index |
      #  cval =  pseries.map { |i| i.nil? i: i.to_i}
        e.series(:name => soldcnty.arrseries[index], :yAxis => 0, :data => pseries)
      end
    end

  return vAreaRec, prccntychart, volcntychart, sldcntychart
end

def generate_vertgraph(graph_title, resultdata, ytitle)
  genchart =  LazyHighCharts::HighChart.new('graph') do |e|
    e.title(:text => graph_title)
    e.xAxis(:categories => resultdata.category)

    e.legend(:align => 'right', :verticalAlign => 'top', :y => 0, :x => -50, :layout => 'vertical',)

    e.yAxis [
                {:title => {:text => ytitle, :margin => 5} }
            ]

    resultdata.series.each_with_index do  |pseries , index |
      cval =  pseries.map { |i| i.to_i}
      e.series(:name => resultdata.arrseries[index], :yAxis => 0, :data =>cval)
    end


  end
  return genchart
rescue StandardError => e
  Rails.logger.debug 'Error running viewservice.generate_vertgraph ' + e.message
end


end