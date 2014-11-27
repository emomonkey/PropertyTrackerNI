class CountyController < ApplicationController
  before_filter :load_view_service

  def load_view_service(service = ViewService.new)
    @view_service ||= service
  end

  def volumeview
    @arrmstpop = @view_service.CountyStats
    vcntystat = AbHistoricCntyView.all
    @hshcntyst = Hash.new
    @hshcntyst = Hash[vcntystat.map { |fcnty| [fcnty['county'].to_sym, [fcnty['volpc'], fcnty['prcsold'], fcnty['month_price_diff']]] }]
  end

  def pricingview
    @arrmstpop = @view_service.CountyPriceStats
    vcntystat = AbHistoricCntyView.all
    @hshcntyst = Hash.new
    @hshcntyst = Hash[vcntystat.map { |fcnty| [fcnty['county'].to_sym, [fcnty['volpc'], fcnty['prcsold'], fcnty['month_price_diff']]] }]
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
      return_view = @view_service.drawgraphdetail(searchrec.id)
      @vAreaRec = return_view[0]
      @prccntychart = return_view[1]
      @volcntychart = return_view[2]
      @sldcntychart = return_view[3]
      render 'detail'
    end

  end
  end


  def detail
    @search_area_id = params[:searchparam]
    @vAreaRec = SearchParams.find(@search_area_id)
    return_view = @view_service.drawgraphdetail(@search_area_id)
    @vAreaRec = return_view[0]
    @prccntychart = return_view[1]
    @volcntychart = return_view[2]
    @sldcntychart = return_view[3]
  end


end
