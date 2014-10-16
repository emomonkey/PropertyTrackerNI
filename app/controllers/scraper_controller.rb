class ScraperController < ApplicationController
  before_filter :load_graphing_service


  def load_graphing_service(service = GraphingService.new)
    @graphing_service ||= service
  end




  def search
   # psitev = PropertySite.create(:title => "Test Withdrawn", :status => "Sale Agreed", :beds => 0)



#    vh.areahighestincprice

    nosearch = SearchParams.count;

    # 25 is the number of sidekiq workers
    batchsize = 5000;
    isize = 1;
    begin
      SearchParams.find_each(start:isize, batch_size: batchsize) do |params|
        pdate = params['searchdate']
   #   @pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', params.searchparam)
        if pdate == nil or (pdate.year != Time.now.year and pdate.mon != Time.now.month)
        @pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', "Waringstown")
      @pnewscrawl.findresult
         end
      end
      isize = isize + batchsize
    end while isize < nosearch


  end


  def resultarea

    @styp = SearchType.find_by_searchtext("Volume Sales")
    HistoricAnalysis.find_by_search_types_id(@styp.id)

    #  Barchart Propertytype Price Sale
    #  Barchart Propertytype Price Sold

    # Total Sold This Year
    # Total Sale This Year

    # LineChart Increase

    #Properties Biggest Decrease
    #Properties Biggest Increase
    #Properties Just Sold
    #Properties Just Added

    # subscribe news letter

  end

  def resultcounty
    # For Each County List Top Areas Price
    # For Each County List Areas Most Sold and Added
    # BarChart of Each Property Type Volume County

    # Linechart increase property price over time

    # Areas Most Activity Sale  Top 20
    # Areas Mostly Activity Sold Top 20
    # Areas increase barchart Top 20

    # Area with Biggest Price Increase
    # Areas with Biggest Price Decrease

  end


  def aboutus

  end


  def result

   volcnty = @graphing_service.fndavgprcmthyr

   volmthcty = @graphing_service.fndvolmthyr

   vcreatedat = HistoricAnalysis.maximum(:created_at)
   smxdt = vcreatedat.strftime('%Y%m')

   @mostsalescnty = @graphing_service.fndvolbycnt(smxdt)
   @mostpricecnty = @graphing_service.fndavgprice(smxdt)

   @cntychart =  LazyHighCharts::HighChart.new('graph') do |e|
     e.title(:text => "Average Price PropertyType")
     e.xAxis(:categories => volcnty.category)

     e.legend(:align => 'right', :verticalAlign => 'top', :y => 0, :x => -50, :layout => 'vertical',)

     e.yAxis [
                 {:title => {:text => "Price", :margin => 5} }
             ]

     volcnty.series.each_with_index do  |pseries , index |
       cval =  pseries.map { |i| i.to_i}
       e.series(:name => volcnty.arrseries[index], :yAxis => 0, :data =>cval)
     end

     e.chart({:defaultSeriesType=>"line", :marginbottom=>0, :height => 150})
   end

    volall = @graphing_service.fndvolcntysimple

    @chart =  LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Volume Sales by PropertyType the past Year")
      f.xAxis(:categories => volall.category)
      #f.series(:name => "Sales", :data => volall.series[0])
      volall.series.each_with_index do  |pseries , index |
        cval =  pseries.map { |i| i.to_i}
        f.series(:name => volall.arrseries[index], :yAxis => 0, :data =>cval)
      end

      f.yAxis [
                  {:title => {:text => "Volume ", :margin => 5} }
              ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.chart({:defaultSeriesType=>"column", :marginbottom=>0, :height => 150})


    end

   volmthcty = @graphing_service.fndvolmthyr
   @volchart =  LazyHighCharts::HighChart.new('graph') do |e|
     e.title(:text => "Volume on Sale Over the Year")
     e.xAxis(:categories => volmthcty.category)

     e.legend(:align => 'right', :verticalAlign => 'top', :y => 0, :x => -50, :layout => 'vertical',)

     e.yAxis [
                 {:title => {:text => "Volume", :margin => 5} }
             ]

     volmthcty.series.each_with_index do  |pseries , index |
       cval =  pseries.map { |i| i.to_i}
       e.series(:name => volcnty.arrseries[index], :yAxis => 0, :data =>cval)
     end

     e.chart({:defaultSeriesType=>"line", :marginbottom=>0, :height => 150})
   end

  # HighChart Pie Sold Volume County
  # Recently Sold By County

  # PieChart  Created Country

  # HighChart Price PropertyType
  # Top Price Property Type

  # County
  # Latest Sold
  # Latest Up Market
  # Price Property Type Area

  # Price Increase

   # Properties- Biggest Price Increase


  end
end
