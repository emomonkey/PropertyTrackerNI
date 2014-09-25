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

  def priceview


  end

  def volumegraph
  end

  def pricevolume
    vcreatedat = HistoricAnalysis.maximum(:created_at)

    vyear =  vcreatedat.strftime("%Y")
    vmonth = vcreatedat.strftime("%m")
    vqdat = Date.strptime("01/" + vmonth + "/" + vyear, '%d/%m/%Y')

    stype = SearchType.find_by_searchtext('Monthly Volume Summary Property Types')
    vcnty = 'Co.' + params[:county]

 #   @vhistvol = AdHistoricCntyvolView.where("county = ? and year = ?  and month = ?", vcnty, vyear, vmonth).paginate(:page => params[:page], per_page: 20)
    @vhistvol = HistoricAnalysis.search_county(params[:county]).where("search_types_id = ? and historic_analyses.created_at = ?" , stype.id, vqdat).paginate(:page => params[:page], per_page: 20).order("resultvalue DESC")
    @county = vcnty
 #    @vhistvol = HistoricAnalysis.search_county(params[:county]).paginate(:page => params[:page], per_page: 20).order("resultvalue DESC")

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
