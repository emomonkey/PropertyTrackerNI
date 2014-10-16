class CountyController < ApplicationController
  before_filter :load_view_service



  def load_view_service(service = ViewService.new)
    @view_service ||= service
  end


  def volumeview

    @arrmstpop = @view_service.CountyStats
    #continue.maximum(:resultvalue, :group => :county)

    vcntystat = AbHistoricCntyView.all
    @hshcntyst = Hash.new
    @hshcntyst = Hash[vcntystat.map { |fcnty| [fcnty['county'].to_sym, [fcnty['volpc'], fcnty['prcsold'], fcnty['month_price_diff']]] }]

  end

  def pricingview
    @arrmstpop = @view_service.CountyPriceStats
    #continue.maximum(:resultvalue, :group => :county)

    vcntystat = AbHistoricCntyView.all
    @hshcntyst = Hash.new
    @hshcntyst = Hash[vcntystat.map { |fcnty| [fcnty['county'].to_sym, [fcnty['volpc'], fcnty['prcsold'], fcnty['month_price_diff']]] }]


  end

  def volumegraph
  end

  def pricingvolume
    vcreatedat = HistoricAnalysis.maximum(:created_at)

    vyear =  vcreatedat.strftime("%Y")
    vmonth = vcreatedat.strftime("%m")
    vqdat = Date.strptime("01/" + vmonth + "/" + vyear, '%d/%m/%Y')

    stype = SearchType.find_by_searchtext('Monthly Average Summary Property Types')
    vcnty = 'Co.' + params[:county]

    @vhistvol = HistoricAnalysis.search_county(params[:county]).where("search_types_id = ? and historic_analyses.created_at = ?" , stype.id, vqdat).order("resultvalue DESC").paginate(:page => params[:page],:per_page=>15)

    @county = vcnty

  end


  def pricevolume
    vcreatedat = HistoricAnalysis.maximum(:created_at)

    vyear =  vcreatedat.strftime("%Y")
    vmonth = vcreatedat.strftime("%m")
    vqdat = Date.strptime("01/" + vmonth + "/" + vyear, '%d/%m/%Y')

    stype = SearchType.find_by_searchtext('Monthly Volume Summary Property Types')
    vcnty = 'Co.' + params[:county]

    @vhistvol = HistoricAnalysis.search_county(params[:county]).where("search_types_id = ? and historic_analyses.created_at = ?" , stype.id, vqdat).paginate(:page => params[:page], per_page: 15).order("resultvalue DESC")
    @county = vcnty

  end


  def drawgraphdetail(varea)
    # Price Graph for Town

    prccnty = @view_service.fndavgareaprcmthyr(varea)
    @vAreaRec = SearchParams.find(varea)


    @prccntychart =  LazyHighCharts::HighChart.new('graph') do |e|
      e.title(:text => "Average Price PropertyType")
      e.xAxis(:categories => prccnty.category)

      e.legend(:align => 'right', :verticalAlign => 'top', :y => 0, :x => -50, :layout => 'vertical',)

      e.yAxis [
                  {:title => {:text => "Price", :margin => 5} }
              ]

      prccnty.series.each_with_index do  |pseries , index |
        cval =  pseries.map { |i| i.to_i}
        e.series(:name => prccnty.arrseries[index], :yAxis => 0, :data =>cval)
      end




      # Volume for Town Volume Sold
      volareacnty = @view_service.fndavgareavolmthyr(varea)

      @volcntychart =  LazyHighCharts::HighChart.new('graph') do |e|
        e.title(:text => "Volume Sale PropertyType")
        e.xAxis(:categories => volareacnty.category)

        e.legend(:align => 'right', :verticalAlign => 'top', :y => 0, :x => -50, :layout => 'vertical',)

        e.yAxis [
                    {:title => {:text => "Volume", :margin => 5} }
                ]

        volareacnty.series.each_with_index do  |pseries , index |
          cval =  pseries.map { |i| i.to_i}
          e.series(:name => volareacnty.arrseries[index], :yAxis => 0, :data =>cval)
        end
      end

      # Sold Volumn for Town
      soldcnty = @view_service.fndavgareasldmthyr(varea)

      @sldcntychart =  LazyHighCharts::HighChart.new('graph') do |e|
        e.title(:text => "Volume Sold PropertyType")
        e.xAxis(:categories => soldcnty.category)

        e.legend(:align => 'right', :verticalAlign => 'top', :y => 0, :x => -50, :layout => 'vertical',)

        e.yAxis [
                    {:title => {:text => "Volume", :margin => 5} }
                ]

        soldcnty.series.each_with_index do  |pseries , index |
          cval =  pseries.map { |i| i.to_i}
          e.series(:name => soldcnty.arrseries[index], :yAxis => 0, :data =>cval)
        end
      end

    end
  end



  def searcharea
    varea = params[:txtsearch]

      if !varea.nil?
      searchrec = SearchParams.where("lower(searchparam)=lower(?)", varea).first

      if searchrec.nil?
        # notfound
        flash[:notice] = "Area not found. If you want it added please use the contact us page."
        render 'scraper/search'
      else
        # Run Logic to see if area can be found
        drawgraphdetail(searchrec.id)
        render 'detail'
      end

    end

  end

  def detail
    @varea = params[:searchparam]

    # Price Graph for Town

    prccnty = @view_service.fndavgareaprcmthyr(@varea)
    @vAreaRec = SearchParams.find(@varea)


    @prccntychart =  LazyHighCharts::HighChart.new('graph') do |e|
      e.title(:text => "Average Price PropertyType")
      e.xAxis(:categories => prccnty.category)

      e.legend(:align => 'right', :verticalAlign => 'top', :y => 0, :x => -50, :layout => 'vertical',)

      e.yAxis [
                  {:title => {:text => "Price", :margin => 5} }
              ]

      prccnty.series.each_with_index do  |pseries , index |
        cval =  pseries.map { |i| i.to_i}
        e.series(:name => prccnty.arrseries[index], :yAxis => 0, :data =>cval)
      end




    # Volume for Town Volume Sold
      volareacnty = @view_service.fndavgareavolmthyr(@varea)

      @volcntychart =  LazyHighCharts::HighChart.new('graph') do |e|
        e.title(:text => "Volume Sale PropertyType")
        e.xAxis(:categories => volareacnty.category)

        e.legend(:align => 'right', :verticalAlign => 'top', :y => 0, :x => -50, :layout => 'vertical',)

        e.yAxis [
                    {:title => {:text => "Volume", :margin => 5} }
                ]

        volareacnty.series.each_with_index do  |pseries , index |
          cval =  pseries.map { |i| i.to_i}
          e.series(:name => volareacnty.arrseries[index], :yAxis => 0, :data =>cval)
        end
      end

    # Sold Volumn for Town
      soldcnty = @view_service.fndavgareasldmthyr(@varea)

      @sldcntychart =  LazyHighCharts::HighChart.new('graph') do |e|
        e.title(:text => "Volume Sold PropertyType")
        e.xAxis(:categories => soldcnty.category)

        e.legend(:align => 'right', :verticalAlign => 'top', :y => 0, :x => -50, :layout => 'vertical',)

        e.yAxis [
                    {:title => {:text => "Volume", :margin => 5} }
                ]

        soldcnty.series.each_with_index do  |pseries , index |
          cval =  pseries.map { |i| i.to_i}
          e.series(:name => soldcnty.arrseries[index], :yAxis => 0, :data =>cval)
        end
      end

  end

  end



end
